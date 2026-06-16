# Magic Eraser — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Magic Eraser. For end-user documentation, see [README.md](https://github.com/Gogo1951/Magic-Eraser/blob/main/README.md).

## File Map

```text
Magic-Eraser/
├── .github/
│   └── workflows/
│       └── package.yml         CurseForge release + library vendoring.
├── .pkgmeta                    Externals and ignore list.
├── .gitignore
├── LICENSE                     MIT.
├── MagicEraser.toc             Single TOC; dual interface (11508 Classic Era, 20505 TBC).
├── README.md                   Player-facing documentation.
├── README-Technical.md         This document.
├── CHANGELOG.md
├── Data/
│   ├── Data.lua                Locale init, identity, version, links, color palette, ns.OPTIONS_REGISTRY, class reagent exclusions, deletion priority. No logic beyond GetLocale/GetVersion.
│   ├── Default-Settings.lua    ns.DEFAULT_CONFIGURATION — account and per-character defaults.
│   ├── Quest-Items.lua         ns.AllowedDeleteQuestItems: itemId → { questId, ... } release map.
│   ├── Consumables.lua         ns.AllowedDeleteConsumables: itemId → true, vendor-trash consumables.
│   └── Equipment.lua           ns.AllowedDeleteEquipment: itemId → true, vendor-quality whites.
├── Features/
│   ├── Core.lua                Central event dispatcher, saved-variable lifecycle, scan/evaluate/rank/erase pipeline, scan cache, ignore list.
│   ├── Utilities.lua           Derived COLORS table + ns.GetColor, ns.BrandPrefix, currency/number formatting, ns:IsQuestCompleted.
│   ├── Announcements.lua       ns:PrintMessage — player-only branded print.
│   ├── Auto-Vend.lua           Merchant auto-sell (scan-then-process queue). Owns ns:OnMerchantShow / ns:OnMerchantClosed.
│   ├── Diagnostics.lua         Diagnostic Tools: report builders, event log, API/event probes, taint log. Runtime-only, never persisted, strings never localized.
│   └── Minimap-Button.lua      LDB data object, tooltip composition, click handlers, ns:RefreshDisplay.
├── Includes/
│   ├── Libraries/              Vendored: LibStub, CallbackHandler-1.0, AceLocale-3.0, AceGUI-3.0, AceConfig-3.0 (Registry/Cmd/Dialog), LibDataBroker-1.1, LibDBIcon-1.0.
│   └── Images/
│       └── Magic-Eraser.tga    Default minimap icon.
├── Locales/
│   ├── enUS.lua                Source of truth; the only NewLocale with the default-fallback flag.
│   └── deDE · esES · esMX · frFR · itIT · koKR · ptBR · ruRU · zhCN · zhTW
└── Options/
    ├── Options-Utilities.lua   Shared ns.Options* widget constructors.
    ├── Options-General.lua     ns.BuildGeneralOptions — root panel.
    ├── Options-Diagnostics.lua ns.BuildDiagnosticsOptions — Diagnostic Tools panel.
    └── Options.lua             Registration only: RegisterOptionsTable + AddToBlizOptions.
```

## Architecture

### Event Loop

Every event routes through a single frame in `Core.lua`. `ns.EVENT_NAMES` is the one source of truth: the dispatcher registers each name in it, and `EVENT_HANDLERS` maps each name to an `ns:OnXxx` method resolved *by name at fire time* — so feature files that load after Core supply their own handlers (`Auto-Vend.lua` defines `ns:OnMerchantShow` / `ns:OnMerchantClosed`). Add an event to `ns.EVENT_NAMES` and it is registered, dispatched, and covered by the Diagnostic Tools panel with no second list to maintain.

| Event | Handler | Purpose |
|-------|---------|---------|
| `PLAYER_LOGIN` | `ns:OnPlayerLogin` | Saved-variable init, LibDBIcon registration, welcome print. |
| `PLAYER_LEVEL_UP` | `ns:OnPlayerLevelUp` | Consumable eligibility is level-gated, so a ding can newly qualify outgrown food — re-scan. |
| `BAG_UPDATE_DELAYED` | `ns:OnBagUpdateDelayed` | Re-scan + refresh the minimap candidate. |
| `QUEST_TURNED_IN` | `ns:OnQuestTurnedIn` | Quest-item-ready chat alert. |
| `MERCHANT_SHOW` / `MERCHANT_CLOSED` | `ns:OnMerchantShow` / `ns:OnMerchantClosed` | Start/stop Auto-Vend. |

`BAG_UPDATE_DELAYED` is debounced with a 0.1s `C_Timer.After` behind the `updatePending` flag, so a burst of updates from looting or a vendor turn-in coalesces into one rescan. `QUEST_TURNED_IN` work is delayed 1.0s to give the server time to flag the quest complete before `IsQuestFlaggedCompleted` is read.

The dispatcher taps the diagnostics event log *before* calling the handler, behind a single boolean check (`ns.diagnostics.logging`) so it costs nothing when logging is off. Because every event passes through this one point, the event log is complete — a feature that created its own event frame would bypass the tap and go unlogged.

### Combat Lockdown

`RunEraser` checks `InCombatLockdown()` at entry and bails with `L["COMBAT_LOCKOUT"]`. There is no deferred replay — the player clicks again after combat. Auto-Vend never runs in combat because merchant frames cannot open in combat.

### Scan → Evaluate → Rank → Erase

The pipeline lives in `Core.lua`:

1. **Scan** — `FindItemToDelete` walks bags 0–4 via `C_Container.GetContainerItemInfo`, skipping items on the per-character ignore list and in the class reagent exclusions.
2. **Evaluate** — `GetItemDeleteReason` returns `"quest"`, `"consumable"`, `"equipment"`, `"gray"`, or `nil` from the three databases plus a rarity-0 / positive-sell-price gray fallback. Quest items must additionally pass `IsQuestCompleted`; consumables must be at least 10 levels below the player.
3. **Rank** — `isBetterDeletionCandidate` ranks by total stack value first; ties break by `ns.DeletePriority` (`quest=1`, `gray=2`, `consumable=3`, `equipment=3`).
4. **Erase** — `RunEraser` performs `PickupContainerItem` → `GetCursorInfo` verification → `DeleteCursorItem`, plays a sound, prints the result, invalidates the cache, and refreshes the display after 0.2s.

### Item Data Caching

`GetItemInfo` returns `nil` on a cold cache. `FindItemToDelete` (Core) and `ScanAndVend` (Auto-Vend) detect this, call `C_Item.RequestLoadItemDataByID`, and schedule a bounded retry capped at `MAX_SCAN_RETRIES` (5) so an item whose data never resolves cannot loop forever. Core's `ScheduleScanRetry` allows one pending retry (`retryPending`) and uses an `inScanRetry` flag so the attempt counter resets only on a genuinely fresh scan trigger — every fresh trigger flows through `InvalidateCache`, which resets the counter unless a retry is in progress. Auto-Vend resets its counter on `MERCHANT_SHOW`.

The eraser also keeps a short-lived candidate cache (`cachedItem` + `isCacheValid`) invalidated on bag update, level-up, ignore-list change, deletion, and quest turn-in.

### Colors

The raw hex palette is data (`ns.PALETTE` in `Data/Data.lua`); the derived escape strings (`COLORS`) and the accessor (`ns.GetColor`) are logic (`Features/Utilities.lua`). `COLORS` is file-local — consumers never read it directly. Each consuming file aliases the accessor once (`local GetColor = ns.GetColor`) and calls `GetColor("KEY")`. Keys: `TITLE`, `INFO`, `BODY`, `TEXT`, `ON`, `OFF`, `SEPARATOR`, `MUTED`.

## Eraser Pipeline

The four-category logic in `GetItemDeleteReason` is an ordered fall-through, so an item appearing in two databases is classified by the first match:

```lua
if questItemDatabase[itemId] then        -- a completed quest releases it
elseif consumableDatabase[itemId] then   -- outgrown by 10+ levels
elseif equipmentDatabase[itemId] then    -- curated vendor-white
elseif rarity == 0 and sellPrice > 0     -- generic gray fallback
```

Quest data is `itemId → { questId, ... }`; an item is erasable if **any** listed quest is flagged complete, which handles a single drop tied to multiple quests across a chain. There is no "Are you sure?" dialog — `DeleteCursorItem` deletes outright; the safety model is the hand-curated lists, and the player opts in per click. Auto-Vend reuses the same evaluation, so any change to the categories applies to both deletion and vending.

## Auto-Vend

Auto-Vend is a separate, opt-in feature (`MagicEraserCharDB.autoVendEnabled`) in `Auto-Vend.lua`. It uses a two-stage scan-then-process pattern rather than selling inside the scan:

1. `ScanAndVend` walks bags, applies the same ignore-list and class-reagent filters as the eraser, and queues every item with a positive `sellPrice` and a non-nil `GetItemDeleteReason`.
2. `ProcessSellQueue` advances one item per 0.25s tick (`C_Timer.After`) and re-reads the slot before selling, because bag positions shift after a sale. The 0.25s spacing is deliberate — tighter spacing makes the merchant frame drop sales silently.

Items with `sellPrice == 0` (most quest items) are filtered at scan time — they cannot be vendored, so the eraser handles them instead. `MERCHANT_CLOSED` flips `isSelling` false and the next tick wipes the queue.

## Quest-Item Alerts

`ns:OnQuestTurnedIn` waits 1.0s, then walks bags and prints `L["QUEST_ITEM_READY"]` for each held item whose newly-completed quest matches one of its tracked ids. This is purely a UX nudge — the eraser's own evaluation already classifies the same items.

## Minimap Button

`Minimap-Button.lua` builds an LDB data object whose icon mirrors the current erase candidate. Click handlers: left = `RunEraser`, right = toggle the current candidate on the ignore list, middle = clear the ignore list, shift + right = toggle Auto-Vend. `ns:RefreshDisplay` invalidates the cache, recomputes the candidate, repoints the icon, and re-renders the tooltip if the button currently owns it.

## Diagnostic Tools

`Features/Diagnostics.lua` plus `Options/Options-Diagnostics.lua` provide a gated panel at **Options > AddOns > Magic Eraser > Diagnostic Tools** for bug reports — environment probing and state capture, not unit tests. State lives in `ns.diagnostics` (`{ enabled, logging, log }`), never in SavedVariables, so it defaults off and resets every session. Sections:

- **Event Registration** — every `ns.EVENT_NAMES` entry tested for `C_EventUtils.IsEventValid` and a register/unregister round-trip.
- **API Endpoints** — `ns.DIAGNOSTIC_API_CHECKS`, kept one-to-one with the APIs the add-on actually calls; existence/shape checks only.
- **Event Log** — the dispatcher tap, capped ring buffer; `ns.DIAGNOSTIC_EVENT_EXCLUDE` drops firehose events.
- **Eraser / Display Context** — the live candidate, database sizes, player level/class, screen size, and minimap placement.
- **Saved Variables** — both tables dumped; the ignore list is summarized by count.
- **Library Versions** and **Taint Log** — the taint CVar is the only thing the panel ever writes.

All diagnostics strings are plain English in the diagnostics files (never localized). The panel is registered last so it sits at the bottom of the settings tree.

## Saved Variables

- **`MagicEraserDB`** (account-wide):
    - `minimap` — table passed to `LibDBIcon:Register` for button placement.
    - `showWelcome` — boolean, default `true`.
- **`MagicEraserCharDB`** (per-character):
    - `ignoreList` — `itemId → true` map; items added via right-click on the minimap button.
    - `autoVendEnabled` — boolean, default `false`.

Defaults live in `ns.DEFAULT_CONFIGURATION` (`Data/Default-Settings.lua`) and are applied by `ApplyDefaults` in `ns:OnPlayerLogin` — a recursive additive merge that seeds a fresh table per scope for table-valued defaults (`minimap`, `ignoreList`) rather than aliasing the shared default.

### Migration Chain

- **`autoVendEnabled` (account → per-character)** — earlier versions stored `autoVendEnabled` on `MagicEraserDB`. On `PLAYER_LOGIN` the per-character field inherits the legacy account value when it is nil, then the legacy field is cleared. Only the first character to log in after the upgrade inherits it; later characters fall back to the default.

> `ApplyDefaults` runs *after* the migration; only fills nil fields; never overrides explicit user values.

## Adding a New Trash Item

- **Consumable** — append `[itemId] = true` to `Data/Consumables.lua` with a name comment. Eligibility is gated by required-level vs player-level (10+ delta).
- **Equipment** — append `[itemId] = true` to `Data/Equipment.lua` with a name comment. White vendor trash, no level gate.
- **Quest item** — append `[itemId] = { questId, ... }` to `Data/Quest-Items.lua`. List every quest that releases the item; the eraser fires when any of them is complete.
- **Class reagent exclusion** — add to `ns.ClassReagentExclusions[CLASS_TOKEN]` in `Data/Data.lua`. Excluded items are never erased or vendored, regardless of database membership.

Keep entries alphabetized by the trailing name comment so diffs stay readable. Per the style guide, arrays over 20 entries are appended to, never reformatted or reproduced wholesale, and each table carries a `-- TODO: Add SQL Query` marker until its originating Mangos query is filled in.

## Adding a New Locale

Copy `Locales/enUS.lua` to `Locales/<locale>.lua`. Drop the `true` argument from `NewLocale("MagicEraser", "<locale>", true)` — that flag marks the default fallback, and only `enUS.lua` should set it. Translate every string. Add the file to `MagicEraser.toc` immediately after `Locales/enUS.lua`.

`esES.lua` and `esMX.lua` are separate standalone files, each with its own `NewLocale` call, like every other locale. Only `enUS.lua` is edited when strings change; the rest are translated separately, so a renamed key leaves harmless orphans in the other files until the next translation pass.

## Common Pitfalls

- **Cursor latency between pickup and delete**: `PickupContainerItem` is asynchronous. `RunEraser` verifies `GetCursorInfo` holds the expected `itemId` before `DeleteCursorItem`, printing `L["CURSOR_TOO_FAST"]` and clearing the cursor on a mismatch — a click-spam guard, not a real error.
- **Stale `GetItemInfo` on first scan**: cold-cache nils are handled by `RequestLoadItemDataByID` plus the bounded retry. Don't add eager fallbacks like hyperlink parsing — let the API resolve.
- **`BAG_UPDATE_DELAYED` fires per bag**: coalesce with the 0.1s `updatePending` guard already in `ns:OnBagUpdateDelayed`; don't refresh straight from the handler.
- **Consumable eligibility is level-dependent**: `GetItemDeleteReason` reads `UnitLevel`, so the candidate must refresh on `PLAYER_LEVEL_UP` — a bag update is not guaranteed to fire after a ding.
- **Bypassing the dispatcher**: register events only by adding to `ns.EVENT_NAMES` plus an `ns:OnXxx` handler. A feature that creates its own event frame escapes the diagnostics event-log tap and goes unlogged.
- **Auto-Vend and `sellPrice == 0`**: filtered at scan time. Quest items aren't vendorable, so the eraser keeps them rather than the vendor swallowing them.

## Contributing

Issues and PRs go on [GitHub](https://github.com/Gogo1951/Magic-Eraser/issues). Discussion happens on [Discord](https://discord.gg/eh8hKq992Q).

Bug reports should include game version (Classic Era 1.15.x or TBC 2.5.x), locale, class + level, reproduction steps, and the relevant chat output. The Diagnostic Tools panel produces a copy-paste-ready report for exactly this.

PR guidelines:

- **One concern per PR.** A locale addition, a database expansion, and a logic change are three PRs.
- **Match existing style** — 80-character section dividers, the `ns` namespace, `L["UPPER_SNAKE_CASE"]` for all user-facing strings, and the shared `ns.Options*` / `ns.GetColor` helpers.
- **New saved-variable fields** seed defaults through `ns.DEFAULT_CONFIGURATION` + the `ApplyDefaults` merge; never overwrite user values.
- **Database edits** keep the column-header comment and the SQL/`TODO` marker; don't reformat existing rows.
- **Update this document** when the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X" or "I fixed Y" — frame the change by who it helps and why.

    **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

    **Example:** *As a player grinding mobs without looting, I wanted the minimap candidate to stay correct after I level up so the lowest-value food shows immediately. This change registers `PLAYER_LEVEL_UP` and re-scans on the ding instead of waiting for the next bag update.*

    The User Story makes review faster and gives future maintainers context the diff alone won't carry.
