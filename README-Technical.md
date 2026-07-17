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
├── MagicEraser.toc             Single TOC; dual interface (11508 Classic Era, 20506 TBC Anniversary).
├── README.md                   Player-facing documentation.
├── README-Technical.md         This document.
├── Data/
│   ├── Data.lua                Locale init, identity, ns.Links, ns.OPTIONS_REGISTRY, color palette, class reagent exclusions, deletion priority. No logic beyond GetLocale.
│   ├── Default-Settings.lua    ns.DATABASE_DEFAULTS — the AceDB defaults table (global + profile scopes).
│   ├── Quest-Items.lua         ns.AllowedDeleteQuestItems: itemId → { questId, ... }.
│   ├── Consumables.lua         ns.AllowedDeleteConsumables: itemId → true, outgrown food/drink.
│   └── Equipment.lua           ns.AllowedDeleteEquipment: itemId → true, vendor-quality whites.
├── Features/
│   ├── Core.lua                Event dispatcher, saved-variable lifecycle + migrations, ignore list.
│   ├── Utilities.lua           Derived COLORS table + ns.GetColor, ns.BrandPrefix, currency/number formatting, ns:IsQuestCompleted.
│   ├── Announcements.lua       ns:PrintMessage — player-only branded print.
│   ├── Eraser.lua              Scan cache + bounded retry, ns:GetItemDeleteReason, ranking, the safety popup, ns:PerformErase / ns:RunEraser, ns:GetReclaimSummary.
│   ├── Bag-Warnings.lua        Free-slot counting, ns:IsBagWindowOpen gate, ns:CheckBagsFullNudge, ns:OnMailClosed, ns:SeedBagSpaceBaseline (login baseline).
│   ├── Auto-Vend.lua           Merchant auto-sell (scan → queue → process, multi-pass). Owns ns:OnMerchantShow / ns:OnMerchantClosed / ns:OnCombatEnded.
│   ├── Item-Tooltips.lua       ns.SetupTooltipHooks — appends the will-erase / protected line to bag-item tooltips.
│   ├── Diagnostics.lua         Diagnostic Tools: report builders, event log, API/event probes, taint log. Runtime-only, never persisted, strings never localized.
│   └── Minimap-Button.lua      LDB data object, tooltip composition, click handlers, ns:RefreshDisplay.
├── Includes/
│   ├── Libraries/              Vendored: LibStub, CallbackHandler-1.0, AceLocale-3.0, AceDB-3.0, AceGUI-3.0, AceConfig-3.0 (Registry/Cmd/Dialog), AceDBOptions-3.0, LibDataBroker-1.1, LibDBIcon-1.0.
│   └── Images/
│       └── Magic-Eraser.tga    Default minimap icon.
├── Locales/
│   ├── enUS.lua                Source of truth; the only NewLocale with the default-fallback flag.
│   └── deDE · esES · esMX · frFR · itIT · koKR · ptBR · ruRU · zhCN · zhTW
└── Options/
    ├── Options-Utilities.lua   Shared ns.Options* widget constructors.
    ├── Options-General.lua     ns.BuildGeneralOptions — root panel.
    ├── Options-Profiles.lua    ns.BuildProfilesOptions — stock AceDBOptions-3.0 table, unmodified.
    ├── Options-Diagnostics.lua ns.BuildDiagnosticsOptions — Diagnostic Tools panel.
    └── Options.lua             Panel registration (RegisterOptionsTable + AddToBlizOptions) and the /eraser slash command.
```

## Architecture

### Event Loop

Every event routes through a single frame in `Core.lua`. `ns.EVENT_NAMES` is the one source of truth: the dispatcher registers each name in it, and `EVENT_HANDLERS` maps each name to an `ns:OnXxx` method resolved *by name at fire time* — so feature files that load after Core supply their own handlers (`Auto-Vend.lua` defines `ns:OnMerchantShow` / `ns:OnMerchantClosed` / `ns:OnCombatEnded`). Add an event to `ns.EVENT_NAMES` and it is registered, dispatched, and covered by the Diagnostic Tools panel with no second list to maintain.

| Event | Handler | Purpose |
|-------|---------|---------|
| `PLAYER_LOGIN` | `ns:OnPlayerLogin` | AceDB init, migrations, LibDBIcon registration, welcome print, tooltip-hook install. |
| `PLAYER_LEVEL_UP` | `ns:OnPlayerLevelUp` | Consumable eligibility is level-gated, so a ding can newly qualify outgrown food — re-scan. |
| `BAG_UPDATE_DELAYED` | `ns:OnBagUpdateDelayed` | Debounced re-scan + minimap refresh + bag-space check. |
| `QUEST_TURNED_IN` | `ns:OnQuestTurnedIn` | Quest-item-ready chat alert. |
| `MERCHANT_SHOW` / `MERCHANT_CLOSED` | `ns:OnMerchantShow` / `ns:OnMerchantClosed` | Start Auto-Vend / flush summary + re-check bag space. |
| `MAIL_CLOSED` | `ns:OnMailClosed` | Re-check bag space once mail looting settles. |
| `PLAYER_REGEN_ENABLED` | `ns:OnCombatEnded` | Resume a vend pass deferred because it began in combat. |

`BAG_UPDATE_DELAYED` is debounced with a 0.1s `C_Timer.After` behind the `updatePending` flag, so a burst from looting or a vendor turn-in coalesces into one rescan. `QUEST_TURNED_IN` work is delayed 1.0s to give the server time to flag the quest complete before `IsQuestFlaggedCompleted` is read.

The dispatcher taps the diagnostics event log *before* calling the handler, behind a single boolean check (`ns.diagnostics.logging`) so it costs nothing when logging is off. Because every event passes through this one point, the event log is complete — a feature that created its own event frame would bypass the tap and go unlogged.

### Combat Lockdown

`RunEraser` and `PerformErase` check `InCombatLockdown()` at entry and bail with `L["COMBAT_LOCKOUT"]` (`DeleteCursorItem` and `PickupContainerItem` are protected). There is no deferred replay — the player clicks again after combat. `PerformErase` re-guards on entry because a safety confirmation dialog can span the moment combat begins.

Auto-Vend faces combat differently: a merchant frame can be open while in combat, and `UseContainerItem` is protected, so calling it under lockdown throws `ADDON_ACTION_FORBIDDEN`. Auto-Vend guards in two places — `ns:OnMerchantShow` (opened in combat) and each `ProcessSellQueue` tick (combat started mid-queue) — and on either it stops, sets `vendPending`, and announces the deferral once via `PrintVendMessage`. `ns:OnCombatEnded` (`PLAYER_REGEN_ENABLED`) then re-scans from scratch and resumes if the merchant is still open, since slots may have shifted during combat. `MERCHANT_CLOSED` clears `vendPending`.

### Scan → Evaluate → Rank → Erase

The pipeline lives in `Eraser.lua`:

1. **Scan** — `FindItemToDelete` walks bags 0–4 via `C_Container.GetContainerItemInfo`, skipping items on the per-character ignore list and in the class reagent exclusions.
2. **Evaluate** — `GetItemDeleteReason` returns `"quest"`, `"consumable"`, `"equipment"`, `"gray"`, or `nil`. Quest items must additionally pass `IsQuestCompleted`; consumables must be at least 10 levels below the player.
3. **Rank** — `isBetterDeletionCandidate` ranks by total stack value first; ties break by `ns.DeletePriority` (`quest=1`, `gray=2`, `consumable=3`, `equipment=3`), so the cheapest item wins and a completed quest item breaks a value tie.
4. **Erase** — `RunEraser` (optionally behind a safety confirmation) calls `PerformErase`: `PickupContainerItem` → `GetCursorInfo` verification → `DeleteCursorItem`, plays a sound, prints the result, invalidates the cache, and refreshes the display after 0.2s.

The same single scan populates the tooltip's Clutter Report totals (`cachedReclaimSlots/Items/Value`) as a side effect, read back via `ns:GetReclaimSummary`.

### Item Data Caching

`GetItemInfo` returns `nil` on a cold cache. `FindItemToDelete` (Eraser) and `ScanAndVend` (Auto-Vend) detect this, call `C_Item.RequestLoadItemDataByID`, and schedule a bounded retry capped at `MAX_SCAN_RETRIES` (5) so an item whose data never resolves cannot loop forever. Eraser's `ScheduleScanRetry` allows one pending retry (`retryPending`) and uses an `inScanRetry` flag so the attempt counter resets only on a genuinely fresh scan trigger — every fresh trigger flows through `InvalidateCache`, which resets the counter unless a retry is in progress. Auto-Vend resets its counter on `MERCHANT_SHOW`.

The eraser also keeps a short-lived candidate cache (`cachedItem` + `isCacheValid`) invalidated on bag update, level-up, ignore-list change, deletion, and quest turn-in.

### Per-Character State Inside a Shared Profile

The ignore list is the one per-character setting, but it lives inside the AceDB **profile** rather than a character scope. `profile.ignoreLists` is a table keyed by `ns.db.keys.char` (`"Name - Realm"`); `ns:GetIgnoreList` lazily creates the bucket for the current character on first use. This keeps every toon's list disjoint (distinct char keys never collide) while letting a single shared "Default" profile hold them all — so switching profiles swaps the entire set of per-toon lists at once, and a "Farming" profile can carry its own. Everything else is account-wide under `global`, untouched by profile switches. Registered `OnProfileChanged` / `OnProfileCopied` callbacks re-scan immediately so the candidate reflects the newly active list.

### Colors

The raw hex palette is data (`ns.PALETTE` in `Data/Data.lua`); the derived escape strings (`COLORS`) and the accessor (`ns.GetColor`) are logic (`Features/Utilities.lua`). `COLORS` is file-local — consumers never read it directly. Each consuming file aliases the accessor once (`local GetColor = ns.GetColor`) and calls `GetColor("KEY")`. Keys: `TITLE`, `INFO`, `BODY`, `TEXT`, `ON`, `OFF`, `SEPARATOR`, `MUTED`. Color constants carry no `|cff` prefix — it is prepended once in Utilities, and `|r` is appended at each call site.

## Eraser Categories

`GetItemDeleteReason` is an ordered fall-through, so an item appearing in two databases is classified by the first match:

```lua
if questItemDatabase[itemId] then        -- a completed quest releases it
elseif consumableDatabase[itemId] then   -- outgrown by 10+ levels
elseif equipmentDatabase[itemId] then    -- curated vendor-white
elseif rarity == 0 and sellPrice > 0     -- generic gray fallback
```

Quest data is `itemId → { questId, ... }`; an item is erasable if **any** listed quest is flagged complete, which handles one drop tied to multiple quests across a chain. Auto-Vend reuses the exact same evaluation, so any change to the categories applies to both deletion and vending.

## Safety Confirmations

Erasing is normally a single click with no prompt — the safety model is the hand-curated databases. When the player opts in (**Eraser Confirmations**, off by default), `ns:NeedsSafetyConfirm` maps the candidate's delete reason to its per-reason toggle through `SAFETY_REASON_KEYS` (`quest→safetyQuest`, `consumable→safetyConsumable`, `equipment→safetyWhite`, `gray→safetyGray`). When both the master toggle and the matching per-reason toggle are on, `RunEraser` shows the `MAGICERASER_CONFIRM_ERASE` static popup instead of erasing directly. The candidate is passed as the dialog's `data` so each showing acts on the exact item the player saw, and `PerformErase` re-validates the slot (cursor item id must match) before deleting — a slot that shifted while the dialog was open aborts rather than deleting the wrong item. `preferredIndex = 3` avoids tainting the shared dialog stack.

## Auto-Vend

Auto-Vend is a separate, opt-in feature (`ns.db.global.autoVendEnabled`) in `Auto-Vend.lua`, using a two-stage scan-then-process pattern rather than selling inside the scan:

1. `ScanAndVend` walks bags, applies the same ignore-list and class-reagent filters as the eraser, and queues every item with a positive `sellPrice` and a non-nil `GetItemDeleteReason`. The queue is then sorted by total stack value ascending, so the cheapest items sell first.
2. `ProcessSellQueue` advances one item per 0.1s tick and re-reads the slot before selling, because bag positions shift after a sale.

**Multi-pass re-sell.** The server silently drops some `UseContainerItem` sells when many arrive in quick succession, leaving one or two flagged items behind on large batches. After a pass finishes, Auto-Vend re-scans and runs another pass (up to `MAX_VEND_PASSES` = 4), rebuilding the queue from live bag state so only items that did not actually sell get re-queued. The cap prevents a flagged-but-unsellable item from looping forever.

**Message modes.** All Auto-Vend chat routes through the file-local `PrintVendMessage`, a no-op unless `ns.db.global.autoVendMessagesEnabled` is set. With messages on, the **Verbose/Summary** dropdown (`autoVendSummaryEnabled`) chooses between a per-item `L["SOLD_ITEM"]` line as each sale lands (Verbose) and a single `L["SOLD_SUMMARY"]` line flushed on `MERCHANT_CLOSED` (Summary). Per-visit totals (`summaryCount` / `summaryValue`) accrue for every newly announced sale regardless of the current mode, so flipping the dropdown mid-visit still produces a correct closing line. `announcedSales`, keyed `"bag:slot:itemId"`, dedups the per-item line so a retry pass that re-sells a silently-dropped slot only announces it once; it is wiped per visit in `StartVending`, not per pass.

Items with `sellPrice == 0` (most quest items) are filtered at scan time — they cannot be vendored, so the eraser handles them instead.

## Item Tooltip Warnings

`Features/Item-Tooltips.lua` appends a single branded line to a carried-bag item's tooltip: a red will-erase warning (`L["TOOLTIP_WILL_ERASE"]`) when Magic Eraser would erase it, or a green protection notice (`L["TOOLTIP_IGNORED"]`) when the Ignore List is shielding it. The verdict comes from the very rules the eraser's scan uses (`ns:IsIgnored`, class-reagent exclusions, `ns:GetItemDeleteReason`), so the line appears only when the item truly would be erased — level gate and quest-completion check included. Purely read-only; gated on `tooltipWarningEnabled`.

There are two hook paths because the tooltip API differs across the flavors we target, and only one is ever active (the line is never doubled):

- **Modern** clients expose `TooltipDataProcessor`; the post-call fires for every item tooltip, so `IsCarriedBagSlot` filters to owners whose `GetBagID()` (or `ContainerFrame` parent id) is in `0..NUM_BAG_SLOTS`.
- **Older** clients get a `hooksecurefunc` on `GameTooltip:SetBagItem`, already bag-scoped by its arguments.

Hooks install from `ns:OnPlayerLogin` via `C_Timer.After(0, ns.SetupTooltipHooks)`, not at file load, so ours wraps the **outermost** layer other add-ons installed. A heavy tooltip add-on like TSM that clears and re-fills the tooltip in its own `OnTooltipSetItem` would otherwise wipe our line; landing last, we survive its rebuild (and on the `SetBagItem` path we re-`Show()` so the frame grows to include the added line).

## Bag-Space Warnings

Lives in `Features/Bag-Warnings.lua`. An opt-in countdown (`bagsFullNudgeEnabled`, off by default) that warns as free slots drop to or below `bagsFullThreshold`. It never deletes and does not care whether anything is erasable — it is purely a free-space alert. `CountFreeSlots` sums only general bags, excluding specialty bags (quiver/soul/profession) since ordinary loot can't go there. `lastNudgeFree` dedups so the same count is never printed twice in a row, and resets once free climbs back above the threshold so re-entering the warning zone warns again.

Warnings are suppressed while a merchant or mailbox window is open (`IsBagWindowOpen`, checked live rather than via a tracked flag), because those visits churn bags hardest and any count would be stale the moment the window closes. `OnMerchantClosed` and `OnMailClosed` re-check once on close so the warning reflects where the bags actually landed. The baseline is seeded at login by `ns:SeedBagSpaceBaseline` (called from Core's `OnPlayerLogin`) so the login-time `BAG_UPDATE_DELAYED` burst — the client populating bags on load — is treated as already known and doesn't warn about space you arrived with.

## Quest-Item Alerts

`ns:OnQuestTurnedIn` waits 1.0s, then walks bags and prints `L["QUEST_ITEM_READY"]` once per held item whose newly-completed quest matches one of its tracked ids. Purely a UX nudge — the eraser's own evaluation already classifies the same items.

## Minimap Button & Display

`Minimap-Button.lua` builds an LDB data object (registered with LibDBIcon) whose icon mirrors the current erase candidate, falling back to `ns.DefaultIcon` when bags are clean. Click handlers:

| Click | Action |
|-------|--------|
| Left | `RunEraser` — erase the lowest-value candidate. |
| Right | Toggle the current candidate on the ignore list. |
| Middle | Clear the ignore list. |
| Shift + Right | Toggle Auto-Vend. |
| Shift + Middle | Open the options panel. |

`RefreshTooltip` composes the whole tooltip — Clutter Report (or a clean-bags congratulations), the lowest-value item with click hints, Auto-Vend status, the per-character ignore list (item names resolved lazily, `LOADING_ITEM` shown for cold ones), and the options keybind. `ns:RefreshDisplay` invalidates the cache, recomputes the candidate, repoints the icon, and re-renders the tooltip if the button currently owns it.

## Diagnostic Tools

`Features/Diagnostics.lua` plus `Options/Options-Diagnostics.lua` provide a gated panel at **Options > AddOns > Magic Eraser > Diagnostic Tools** for bug reports — environment probing and state capture, not unit tests. State lives in `ns.diagnostics` (`{ enabled, logging, log }`), a plain namespace table that is never a SavedVariable, so it defaults off and resets every session. Every report builds only on a button press, never on load or panel open. Sections:

- **Event Log** — the dispatcher tap, a 500-entry ring buffer capping 8 args × 255 bytes each, pipes escaped so item links paste as plain text. `ns.DIAGNOSTIC_EVENT_EXCLUDE` is deliberately empty (the log only ever sees events the add-on registers).
- **Event Registration** — every `ns.EVENT_NAMES` entry tested for `C_EventUtils.IsEventValid` and a register/unregister round-trip on a probe frame.
- **API Endpoints** — `ns.DIAGNOSTIC_API_CHECKS`, kept one-to-one with the APIs the add-on calls or guards; existence/shape checks only.
- **Eraser / Display Context** — the live candidate, database sizes, player level/class, ignore-list count, screen size, UI scale, and minimap placement.
- **Saved Variables** — `MagicEraserDB` dumped; each profile's `ignoreLists` is replaced with a per-character count summary rather than every itemId.
- **Library Versions** and **Taint Log** — the `taintLog` CVar is the only state the panel ever writes (see WRITING USER CVARS).

All diagnostics strings are plain English in the diagnostics files, never localized (developer-facing, zero player value). The panel is registered last so it sits at the bottom of the settings tree.

## Options & Profiles

`ns:RegisterOptionsPanels` (called from `OnPlayerLogin`, once `ns.db` exists) registers three AceConfig tables from `ns.OPTIONS_REGISTRY` and nests them under Magic Eraser in Blizzard options, in order: **General** (root) → **Profiles** → **Diagnostic Tools**. Panel content lives in the per-panel builder files; `Options.lua` is registration only. Widget constructors (`ns.OptionsHeader/Desc/Spacer/SubHeader`) are shared from `Options-Utilities.lua`. The **Profiles** panel is the stock `AceDBOptions-3.0` table returned unmodified.

`/eraser` opens the options panel. Registration is in `Options.lua` (`SLASH_MAGICERASER1` + `SlashCmdList.MAGICERASER`); the handler `ns:OpenOptionsPanel` walks a three-tier fallback so it works across client versions: `Settings.OpenToCategory` (modern), then `InterfaceOptionsFrame_OpenToCategory` called twice (legacy quirk — first call scrolls the tree, second opens the panel), then `AceConfigDialog:Open`. The category is looked up by `ns.AddonTitle`, the same name passed to `AddToBlizOptions`, so registration and lookup stay in sync.

## Saved Variables

Magic Eraser uses **AceDB-3.0**. There is one managed table, `MagicEraserDB`, initialized in `ns:OnPlayerLogin` with `LibStub("AceDB-3.0"):New("MagicEraserDB", ns.DATABASE_DEFAULTS, true)`:

- **`global`** (account-wide) — every setting: `showWelcome`, `tooltipWarningEnabled`, `autoVendEnabled`, `autoVendMessagesEnabled`, `autoVendSummaryEnabled`, `bagsFullNudgeEnabled`, `bagsFullThreshold`, `safetyEnabled`, `safetyQuest`, `safetyConsumable`, `safetyWhite`, `safetyGray`, and `minimap` (the LibDBIcon placement table). Migration markers `autoVendSummaryMigrated` and `deleteMacroCleanupDone` also live here.
- **`profile`** — only `ignoreLists`, a table keyed by character (`"Name - Realm"`); see *Per-Character State Inside a Shared Profile*.

`## SavedVariablesPerCharacter: MagicEraserCharDB` is still declared in the TOC, but only as a legacy migration source — it is read once and cleared. The declaration is scheduled for removal after 2026-10-08 (see the MIGRATION comment in the TOC).

Defaults come from `ns.DATABASE_DEFAULTS` and are applied lazily by AceDB-3.0 via metatables — nothing is copied into the saved table, and explicit user values (including `false`) are never overridden.

There is no refill-on-empty logic: the curated item databases (`AllowedDeleteQuestItems`, `AllowedDeleteConsumables`, `AllowedDeleteEquipment`) are static Lua tables shipped in `Data/`, not saved variables, so they can never be emptied at runtime.

### Migration Chain

All migrations run once in `ns:OnPlayerLogin`, guarded so they self-disable and are safe across every character:

1. **Pre-AceDB adoption** *(remove after 2026-10-08)* — the pre-AceDB build kept two raw tables: account-wide `MagicEraserDB` (`showWelcome`, `minimap`, and on the oldest builds an account-level `autoVendEnabled`) and per-character `MagicEraserCharDB` (`autoVendEnabled`, `autoVendMessagesEnabled`, `ignoreList`). These are captured *before* AceDB adopts `MagicEraserDB`, folded into `global`, then the legacy keys are cleared. `autoVendEnabled` prefers the per-character value, falling back to the old account-level one.
2. **Profile → global rehome** *(remove after 2026-10-11)* — the first AceDB build kept settings on one shared "Default" profile; a non-nil raw read for any settings key means the user set it, so it is moved up to `global` and cleared from the profile. Idempotent across toons.
3. **Ignore-list flat reset** *(remove after 2026-10-11)* — those first AceDB builds also merged every toon's ignore list into a flat `profile.ignoreList`. That pollution can't be unmerged, so its mere presence zeroes every per-character bucket and deletes the flat list. Self-disabling once the flat list is gone.
4. **Per-toon ignore seed** *(remove after 2026-10-11)* — this toon's bucket is seeded once, from its *own* pre-AceDB `MagicEraserCharDB.ignoreList` only, never the shared pool. A toon with no legacy list starts empty.
5. **Auto-Vend message reset** *(remove after 2026-10-11)* — the Verbose/Summary rollout forces Auto-Vend messages on once for everyone via the `autoVendSummaryMigrated` marker, which has no default entry so AceDB never strips it and the reset cannot re-fire.
6. **Stray macro cleanup** *(remove after 2026-10-11)* — the removed Delete Macro feature left an account-wide `- Eraser` macro; it is deleted once, combat-guarded (`DeleteMacro` is protected), and marked done only after a real pass.

**Reset Profile.** `Reset Profile` in the AceDBOptions panel resets only the profile scope, which now holds just the ignore lists — so `ns:OnDatabaseReset` is hooked to the `OnProfileReset` callback to also restore every `global` setting to its default and re-show the minimap button, making the button behave like a full reset.

## Adding a New Trash Item

- **Consumable** — append `[itemId] = true` to `Data/Consumables.lua` with a name comment. Eligibility is gated by required-level vs player-level (10+ delta).
- **Equipment** — append `[itemId] = true` to `Data/Equipment.lua` with a name comment. White vendor trash, no level gate.
- **Quest item** — append `[itemId] = { questId, ... }` to `Data/Quest-Items.lua`. List every quest that releases the item; the eraser fires when any of them is complete.
- **Class reagent exclusion** — add to `ns.ClassReagentExclusions[CLASS_TOKEN]` in `Data/Data.lua`. Excluded items are never erased or vendored, regardless of database membership.

Keep entries alphabetized by the trailing name comment so diffs stay readable. Per the style guide, these tables are appended to, never reformatted or reproduced wholesale, and each carries a `-- TODO: Add SQL Query` marker until its originating query is filled in — leave that marker in place.

## Adding a New Event

1. Add the event name to `ns.EVENT_NAMES` in `Features/Core.lua`.
2. Add a `EVENT_NAME = "OnXxx"` entry to `EVENT_HANDLERS` in the same file.
3. Define `ns:OnXxx(...)` in whichever feature file owns it (Core, or a feature file loaded after Core — it is resolved by name at fire time).

That is the whole registration. The dispatcher, and the Diagnostic Tools event log and Event Registration probe, all read `ns.EVENT_NAMES`, so they pick the event up automatically with no second list to update. Never create a separate event frame — it would escape the diagnostics tap.

## Localization

WoW ships a fixed locale set, and every supported locale file already exists in `Locales/`, so localization here is **maintenance, not expansion** — there is no "add a new locale" step.

- **Structure** — each `Locales/<locale>.lua` registers through `LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "<locale>")`. `enUS.lua` is the source of truth and the only file that passes the `true` default-fallback flag; every string originates there.
- **Keeping locales in sync** — every non-English file carries a translation of the same key set, and AceLocale falls back to English via `__index` for anything missing at runtime. Translating each `enUS.lua` key into every locale and keeping the files aligned is the job of the Localization pass; don't hand-edit the other locales during ordinary work. A renamed key leaves harmless orphans in the translated files until that pass runs.
- **Placeholders** — `%s`/`%d` count, type, and order must match `enUS` per key in every locale, or the string crashes at runtime. This is the highest-value invariant when editing strings.
- **Spanish** — `esES.lua` and `esMX.lua` are two separate, self-contained files; identical strings in both is correct and expected.
- **Locale overflow** — German is the usual canary for length. Watch it wherever a translated string sits in a width-constrained slot — the minimap tooltip's double-lines and the options-panel toggle labels — since Magic Eraser generates no macros, the 255-character macro limit does not apply here.

## Common Pitfalls

- **Cursor latency between pickup and delete**: `PickupContainerItem` is asynchronous. `PerformErase` verifies `GetCursorInfo` holds the expected `itemId` before `DeleteCursorItem`, printing `L["CURSOR_TOO_FAST"]` and clearing the cursor on a mismatch — a click-spam guard, not a real error.
- **Stale `GetItemInfo` on first scan**: cold-cache nils are handled by `RequestLoadItemDataByID` plus the bounded retry. Don't add eager fallbacks like hyperlink parsing — let the API resolve.
- **`BAG_UPDATE_DELAYED` fires repeatedly**: coalesce with the 0.1s `updatePending` guard already in `ns:OnBagUpdateDelayed`; don't refresh straight from the handler.
- **Consumable eligibility is level-dependent**: `GetItemDeleteReason` reads `UnitLevel`, so the candidate must refresh on `PLAYER_LEVEL_UP` — a bag update is not guaranteed after a ding.
- **Bypassing the dispatcher**: register events only by adding to `ns.EVENT_NAMES` plus an `ns:OnXxx` handler. A feature that creates its own event frame escapes the diagnostics event-log tap and goes unlogged.
- **Auto-Vend and `sellPrice == 0`**: filtered at scan time. Quest items aren't vendorable, so the eraser keeps them rather than the vendor swallowing them.
- **New Auto-Vend chat must use `PrintVendMessage`**: calling `ns:PrintMessage` directly from the vend path ignores the **Enable Auto-Vend Messages** toggle. Route every Auto-Vend line through the `PrintVendMessage` guard in `Auto-Vend.lua`.
- **Settings are `global`, ignore lists are `profile`**: new user settings go in `ns.db.global` (account-wide) via a `ns.DATABASE_DEFAULTS.global` default; only the per-character ignore lists belong in `profile`. Putting a setting in `profile` silently makes it per-profile and breaks `Reset Profile` expectations.
- **Server silently drops bulk sells**: don't assume one `ScanAndVend` pass clears the bags. The multi-pass loop (`MAX_VEND_PASSES`) exists because `UseContainerItem` sells are dropped under load; keep the re-scan-between-passes structure.

## Contributing

Issues and PRs go on [GitHub](https://github.com/Gogo1951/Magic-Eraser/issues). Discussion happens on [Discord](https://discord.gg/eh8hKq992Q).

Bug reports should include game version (Classic Era 1.15.x or TBC Anniversary 2.5.x), locale, class + level, reproduction steps, and the relevant chat output. The Diagnostic Tools panel produces a copy-paste-ready report for exactly this.

PR guidelines:

- **One concern per PR.** A locale update, a database expansion, and a logic change are three PRs.
- **Match existing style** — 80-character section dividers, the `ns` namespace, `L["UPPER_SNAKE_CASE"]` for all user-facing strings, and the shared `ns.Options*` / `ns.GetColor` helpers.
- **New saved-variable fields** seed defaults through `ns.DATABASE_DEFAULTS` and rely on AceDB's metatable application; never hand-merge or overwrite user values.
- **Database edits** keep the column-header comment and the `TODO` marker; don't reformat existing rows.
- **Migration discipline** — migrations are one-time, guarded, and dated in `ns:OnPlayerLogin`; don't remove one before its noted date.
- **Update this document** when the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X" or "I fixed Y" — frame the change by who it helps and why.

    **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

    **Example:** *As a player grinding mobs without looting, I wanted the minimap candidate to stay correct after I level up so the lowest-value food shows immediately. This change registers `PLAYER_LEVEL_UP` and re-scans on the ding instead of waiting for the next bag update.*

    The User Story makes review faster and gives future maintainers context the diff alone won't carry.
