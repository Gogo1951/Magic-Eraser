# Magic Eraser — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Magic Eraser. For end-user documentation, see [README.md](https://github.com/Gogo1951/Magic-Eraser/blob/main/README.md).

## File Map

```
Magic-Eraser/
├── .github/
│   └── workflows/
│       └── package.yml         CurseForge release + library vendoring.
├── .pkgmeta                    Externals and ignore list.
├── .gitignore
├── MagicEraser.toc             Single-version TOC.
├── Core.lua                    Addon state, event loop, scan/evaluate/erase pipeline.
├── Auto-Vend.lua               Merchant-window auto-sell feature. MERCHANT_SHOW gate, sell queue.
├── Minimap-Button.lua          LDB data object, tooltip composition, click handlers.
├── Options.lua                 AceConfig options table, registration, OpenOptions helper.
├── Database/
│   ├── General.lua             Locale init, identity, version, links, colors, class reagent exclusions, deletion priority.
│   ├── Quest-Items.lua         itemId → list of completed-quest-IDs that release the item.
│   ├── Consumables.lua         itemId → true map of vendor-trash consumables.
│   └── Equipment.lua           itemId → true map of vendor-quality whites.
├── Includes/                   Vendored libraries: LibStub, CallbackHandler-1.0, AceLocale-3.0, AceGUI-3.0, AceConfig-3.0, LibDataBroker-1.1, LibDBIcon-1.0.
├── Locales/
│   ├── enUS.lua                Source of truth. Other locales fall back via AceLocale __index.
│   ├── deDE.lua
│   ├── esES.lua                Registers both esES and esMX from a shared `strings` table.
│   ├── frFR.lua
│   ├── itIT.lua
│   ├── koKR.lua
│   ├── ptBR.lua
│   ├── ruRU.lua
│   ├── zhCN.lua
│   └── zhTW.lua
├── LICENSE                     MIT.
├── Magic-Eraser.tga            Default minimap button icon.
├── README.md                   Player-facing documentation.
└── README-Technical.md         This document.
```

## Architecture

### Event Loop

Two event frames split the workload:

- **Core.lua** listens for `PLAYER_LOGIN` (saved-variable init, LibDBIcon registration, welcome print), `BAG_UPDATE_DELAYED` (rescan + minimap icon refresh), and `QUEST_TURNED_IN` (quest-item-ready chat alert).
- **Auto-Vend.lua** listens for `MERCHANT_SHOW` and `MERCHANT_CLOSED`. Its scan is gated by the `MagicEraserCharDB.autoVendEnabled` toggle.

`BAG_UPDATE_DELAYED` is debounced with a 0.1s `C_Timer.After` (the `updatePending` flag) so a burst of updates from looting or vendor turn-in coalesces into one rescan. `QUEST_TURNED_IN` is delayed 1.0s to give the server time to mark the quest complete before we read `IsQuestFlaggedCompleted`.

### Combat Lockdown

`RunEraser` checks `InCombatLockdown()` at entry and bails with a localized chat message. There is no deferred replay — the player just clicks again after combat. Container slot manipulation is protected from a tainted execution path because the player click reaches the LDB handler before any UI lockdown applies.

### Scan / Evaluate / Erase Pipeline

The addon's main pipeline lives in `Core.lua`:

1. **Scan** — `FindItemToDelete` walks bags 0–4, reading each slot via `C_Container.GetContainerItemInfo` (with a fallback to the legacy global). Each slot is filtered against the per-character Ignore List and the class reagent exclusions.
2. **Evaluate** — `GetItemDeleteReason` returns one of `"quest"`, `"consumable"`, `"equipment"`, `"gray"`, or `nil` based on the database lookups in `ns.AllowedDeleteQuestItems`, `ns.AllowedDeleteConsumables`, `ns.AllowedDeleteEquipment`, and the rarity/sellPrice fallback for grays. Quest items must additionally pass `IsQuestCompleted`. Consumables must be at least 10 levels below the player.
3. **Rank** — `isBetterDeletionCandidate` ranks every flagged item by total stack value first; ties break by `ns.DeletePriority` (quest=1, gray=2, consumable=3, equipment=3).
4. **Erase** — `RunEraser` performs `PickupContainerItem` → cursor verification → `DeleteCursorItem`. The cursor verification (`GetCursorInfo` returns the expected itemId) is critical — see Common Pitfalls.

After a successful erase, the cache is invalidated and a 0.2s `C_Timer.After` triggers a tooltip/icon refresh.

### Item Data Caching

`GetItemInfo` returns `nil` on a cold cache miss. Both `FindItemToDelete` (Core) and `ScanAndVend` (Auto-Vend) detect this with an `isDataMissing` flag, call `C_Item.RequestLoadItemDataByID` for each missing item, and schedule a retry — 1.0s for the eraser scan, 0.5s for the auto-vend scan. The eraser also has its own short-lived cache (`cachedItem` + `isCacheValid`) that is invalidated on every bag update, ignore-list change, deletion, and quest turn-in.

## Eraser Pipeline (Deep Dive)

The four-category logic in `GetItemDeleteReason` is intentionally ordered:

```lua
if questItemDatabase[itemId] then
    -- Quest items must have a completed quest in their associated list.
elseif consumableDatabase[itemId] then
    -- Outgrown by 10+ levels.
elseif equipmentDatabase[itemId] then
    -- Always erasable when in the curated list.
elseif rarity == 0 and (sellPrice or 0) > 0 then
    -- Generic gray fallback.
end
```

The fall-through structure means an item appearing in two databases (rare, but possible after edits) is classified by the first matching category. Quest items take precedence, then consumables, then equipment. Gray-trash classification is the catch-all and only applies when none of the curated databases match.

`Quest-Items.lua` stores the data as `itemId → { questId, ... }`. An item is erasable if **any** of the listed quest IDs is flagged completed. This handles the case where a single drop is tied to multiple quests across the chain.

The `QUEST_TURNED_IN` handler walks bags after a 1s delay and prints `L["QUEST_ITEM_READY"]` for each held item whose newly-completed quest matches one of its tracked quest IDs. This is purely a UX nudge — the eraser's evaluation already handles the same logic.

## Auto-Vend (Deep Dive)

Auto-Vend is a separate event-driven feature in `Auto-Vend.lua` that runs at merchant windows when `MagicEraserCharDB.autoVendEnabled` is true.

It uses a two-stage scan-then-process pattern instead of selling directly inside the scan:

1. `ScanAndVend` walks bags 0–4, applies the same ignore-list and class-reagent filters as the eraser, and pushes every item with a positive `sellPrice` and a non-nil `GetItemDeleteReason` onto `sellQueue`.
2. `ProcessSellQueue` advances the index every 0.25s (`C_Timer.After`) and calls `C_Container.UseContainerItem`. Each tick re-reads the slot via `GetContainerItemInfo` to confirm the item is still there before selling — bag positions can shift after a sale.

The 0.25s tick is deliberately conservative. Tighter spacing causes the merchant frame to drop sales silently. `MERCHANT_CLOSED` flips `isSelling` to false and the next tick wipes the queue and exits.

Items with `sellPrice == 0` (which would otherwise be erasable, like quest items) are filtered out at scan time — they can't be sold to a vendor.

## Saved Variables

- **`MagicEraserDB`** (account-wide):
    - `minimap` — table passed to `LibDBIcon:Register` for button placement.
    - `showWelcome` — boolean, default `true`. Toggled from the options panel.
- **`MagicEraserCharDB`** (per-character):
    - `ignoreList` — `itemId → true` map. Items added via right-click on the minimap button.
    - `autoVendEnabled` — boolean, default `false`. Toggled via shift+right-click on the minimap button or the options panel.

Initialization happens at `PLAYER_LOGIN` in `Core.lua`. The pattern is `if db.field == nil then db.field = default end` — never overwrite existing values.

### Migration Chain

- **`autoVendEnabled` legacy cleanup** (current release) — earlier versions stored `autoVendEnabled` on `MagicEraserDB` (account-wide). On `PLAYER_LOGIN`, if the legacy field is non-nil it is set to `nil` to clear the account-wide value. The per-character field is then seeded from the default. The cleanup block can be removed in a future release after users have had time to update.

`EnsureDefaults`-style initialization runs *after* the migration and only fills nil fields; explicit user values are never overridden.

## Adding a New Locale

Copy `Locales/enUS.lua` to `Locales/<locale>.lua`. Drop the `true` argument from the `NewLocale("MagicEraser", "<locale>", true)` call — the `true` flag marks the file as the default fallback, and only `enUS.lua` should set it. Translate every string. Add the file to `MagicEraser.toc` immediately after `Locales/enUS.lua`.

For Spanish, follow the existing `Locales/esES.lua` pattern: build the translations into a shared local `strings` table, then register both `esES` and `esMX` from that table. The standard `if not L then return end` guard would bail before the second `NewLocale` call when the file is loaded by an esMX client.

## Adding a New Trash Item

- **Quest item** — append to `Database/Quest-Items.lua` as `[itemId] = { questId, ... }`. List every quest that releases the item; the eraser fires when any of them is completed.
- **Consumable** — append to `Database/Consumables.lua` as `[itemId] = true,` with a comment naming the item. Eligibility is gated by required-level vs player-level (10+ delta).
- **Equipment** — append to `Database/Equipment.lua` as `[itemId] = true,` with a comment naming the item. White-quality vendor trash with no required-level gate.
- **Class reagent exclusion** — add to `ns.ClassReagentExclusions[CLASS_TOKEN]` in `Database/General.lua`. Items in this map are never considered for either erasure or auto-vend, regardless of whether they appear in the trash databases.

Keep entries alphabetized by item name (the trailing comment is the sort key) so future diffs stay readable. Per the style guide, large arrays (>20 entries) are not reformatted or reproduced when editing — append, don't rewrite.

## Common Pitfalls

- **Editing items in combat** — `DeleteCursorItem` and `UseContainerItem` work in combat for non-equipment items, but the safer pattern is to bail entirely. `RunEraser` checks `InCombatLockdown()` first and prints `L["COMBAT_LOCKOUT"]`. Auto-Vend doesn't run in combat because merchant frames can't be opened in combat.
- **Cursor latency between Pickup and Delete** — `PickupContainerItem` is asynchronous. `RunEraser` verifies the cursor holds the expected `itemId` via `GetCursorInfo` before calling `DeleteCursorItem`. If the cursor doesn't match, the addon prints `L["CURSOR_TOO_FAST"]` and clears the cursor — a click-spam guard, not a real error.
- **Stale `GetItemInfo`** — first-scan after login returns `nil` for items not yet in the client cache. Both scan paths call `C_Item.RequestLoadItemDataByID` for any missing item and reschedule via `C_Timer.After`. Don't add eager fallbacks (e.g., parsing the hyperlink) — let the API resolve.
- **`BAG_UPDATE_DELAYED` fires per-bag during a multi-bag operation** — coalesce with the 0.1s `updatePending` guard already in place. Don't call `RefreshDisplay` directly from the event.
- **Quest items mid-quest** — only the *completed* state matters. Pre-turn-in items don't appear as candidates because `IsQuestCompleted` returns false. Don't try to second-guess this with quest-progress checks.
- **Auto-Vend selling items with `sellPrice == 0`** — filtered at scan time. Quest items would otherwise be erasable but aren't sellable; the filter keeps them in your bags so the eraser can handle them later.
- **Welcome message shows literal `@project-version@`** — the CurseForge packager substitutes the token at build time. Local dev installs see the unsubstituted string in `L["CHAT_LOADED"]`. The runtime `ns.Version` is computed separately via `GetVersion()` and correctly falls back to `"Dev"`.
- **`AceConfig-3.0.lua` requires `AceConfigCmd-3.0`** — the meta-package's first lines call `LibStub("AceConfigCmd-3.0")` without the silent flag. This addon does not bundle `AceConfigCmd-3.0` (no slash commands), and relies on another enabled addon having loaded it. If the options panel ever fails to register, add `Includes/AceConfig-3.0/AceConfigCmd-3.0/AceConfigCmd-3.0.lua` back to the TOC and the `.pkgmeta` will re-fetch the folder on the next packager run.
- **`esMX` clients and `if not L then return end`** — would short-circuit before the second `NewLocale` call. `Locales/esES.lua` builds a shared `strings` table and registers both locales from it. Don't refactor.

## Contributing

Issues and PRs go on [GitHub](https://github.com/Gogo1951/Magic-Eraser). Bug reports should include game version (Classic Era 1.15.x or BC Anniversary 2.5.x), locale, class + level, and reproduction steps. Chat output from the relevant action is helpful.

PR guidelines:

- One concern per PR. A locale addition, a database expansion, and a logic change are three PRs.
- Match existing code style (80-character section dividers, `ns` namespace, `L["UPPER_SNAKE_CASE"]` for all user-facing strings).
- New saved-variable fields seed defaults at `PLAYER_LOGIN` with the `if db.field == nil then db.field = default end` pattern. Never overwrite user values.
- If you change `Database/Quest-Items.lua`, `Database/Consumables.lua`, or `Database/Equipment.lua`, prepend the originating SQL query as a comment so the file remains regenerable.
- Update this document when the architecture or file map changes.

Discussion happens on [Discord](https://discord.gg/eh8hKq992Q).
