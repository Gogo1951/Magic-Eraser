# Magic Eraser — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Magic Eraser. For end-user documentation, see [README.md](https://github.com/Gogo1951/Magic-Eraser/blob/main/README.md).

## File Map

```text
Magic-Eraser/
├── .github/
│   └── workflows/
│       └── package.yml         CurseForge + Wago release; vendors the libraries.
├── .pkgmeta                    Externals and ignore list.
├── LICENSE                     MIT.
├── MagicEraser.toc             Single TOC; dual-flavor Interface line (Classic Era 11509 + TBC Anniversary 20506).
├── README.md                   Player-facing documentation.
├── README-Technical.md         This document.
├── README-Testing.md           Manual test plan, run on both flavors before a release is tagged.
├── Data/
│   ├── Data.lua                Locale handle, identity, ns.Links, ns.OPTIONS_REGISTRY, ns.IGNORE_SCOPE_GLOBAL, ns.PALETTE + ns.CurrencyColors, class reagent exclusions, ns.DeletePriority. No logic beyond GetLocale.
│   ├── Default-Settings.lua    ns.DATABASE_DEFAULTS — the AceDB defaults table (global + profile scopes).
│   ├── Quest-Items.lua         ns.AllowedDeleteQuestItems: itemId → { questId, ... }.
│   ├── Consumables.lua         ns.AllowedDeleteConsumables: itemId → true, outgrown food/drink.
│   └── Equipment.lua           ns.AllowedDeleteEquipment: itemId → true, vendor-quality whites.
├── Features/
│   ├── Core.lua                ns.Version, ns.EVENT_NAMES, the one event frame and its dispatcher, AceDB init + every migration, the profile-callback hooks.
│   ├── Utilities.lua           Derived COLORS table + ns.GetColor, ns:FormatCommaNumber / ns:FormatCurrency, ns:CountFreeBagSlots.
│   ├── Announcements.lua       ns.BrandPrefix and ns:PrintMessage — player-only branded print.
│   ├── Ignore-List.lua         Both lists: ns:GetIgnoreList / ns:GetGlobalIgnoreList, ns:IsIgnored, ns:ToggleIgnore, ns:ClearIgnoreList, plus the per-scope reads and writes the Ignore List panel uses (ns:GetIgnoreListForScope, ns:SetIgnoredInScope).
│   ├── Eraser.lua              Scan cache + bounded retry, ns:IsQuestCompleted, ns:GetItemDeleteReason, ranking, the safety popup, ns:PerformErase / ns:RunEraser, ns:GetReclaimSummary, ns:OnQuestTurnedIn.
│   ├── Bag-Warnings.lua        The ns:IsBagWindowOpen gate, ns:CheckBagsFullNudge, ns:SeedBagSpaceBaseline, ns:OnEnteringWorld, ns:OnMailClosed.
│   ├── Bank-Retrieval.lua      Pulls flagged items out of the bank within a free-slot budget, with confirmed-move accounting. Owns ns:OnBankOpened / ns:OnBankClosed.
│   ├── Auto-Vend.lua           Merchant auto-sell (scan → queue → sell → confirm, multi-pass). Owns ns:OnMerchantShow / ns:OnMerchantClosed / ns:OnCombatEnded.
│   ├── Item-Tooltips.lua       ns.SetupTooltipHooks — appends the will-erase / protected line to bag-item tooltips.
│   ├── Diagnostics.lua         Diagnostic Tools: report builders, event log, API/event probes, taint log. Runtime-only, never persisted, strings never localized.
│   └── Minimap-Button.lua      LDB data object, tooltip composition, click handlers, ns:RefreshDisplay.
├── Includes/
│   ├── Images/
│   │   └── Magic-Eraser.tga    The TOC's IconTexture — the add-on list icon. The minimap button's own fallback is ns.DefaultIcon, a stock game texture.
│   └── Libraries/              Vendored: LibStub, CallbackHandler-1.0, AceLocale-3.0, AceDB-3.0, AceGUI-3.0, AceConfig-3.0 (Registry/Cmd/Dialog), AceDBOptions-3.0, LibDataBroker-1.1, LibDBIcon-1.0.
├── Locales/
│   ├── enUS.lua                Source of truth; the only NewLocale with the default-fallback flag.
│   └── deDE · esES · esMX · frFR · itIT · koKR · ptBR · ruRU · zhCN · zhTW
└── Options/
    ├── Options-Utilities.lua   Shared ns.Options* widget constructors, plus ns.WarmItemCache.
    ├── Options-General.lua     ns.BuildGeneralOptions — root panel.
    ├── Options-Ignore-List.lua ns.BuildIgnoreListOptions — one tree node per ignore list on the account.
    ├── Options-Profiles.lua    ns.BuildProfilesOptions — the stock AceDBOptions-3.0 table, returned unmodified.
    ├── Options-Diagnostics.lua ns.BuildDiagnosticsOptions — Diagnostic Tools panel.
    └── Options.lua             Panel registration, ns:OpenOptionsPanel, and the /eraser slash command.
```

There are no deprecated or dead files. Everything in `Features/` and `Options/` is loaded by the TOC and reachable at runtime. The one legacy artifact is a TOC line, not a file: `## SavedVariablesPerCharacter: MagicEraserCharDB`, kept only as a migration source (see *Saved Variables*).

## Architecture

### Event Loop

Every event routes through a single frame in `Core.lua`. `ns.EVENT_NAMES` is the one source of truth: the dispatcher registers each name in it, and `EVENT_HANDLERS` maps each name to an `ns:OnXxx` method resolved *by name at fire time* — so feature files that load after Core supply their own handlers (`Auto-Vend.lua` defines `ns:OnMerchantShow` / `ns:OnMerchantClosed` / `ns:OnCombatEnded`, `Bag-Warnings.lua` defines `ns:OnEnteringWorld` / `ns:OnMailClosed`, `Bank-Retrieval.lua` defines `ns:OnBankOpened` / `ns:OnBankClosed`, and `Eraser.lua` defines `ns:OnQuestTurnedIn`). Add an event to `ns.EVENT_NAMES` and it is registered, dispatched, and covered by the Diagnostic Tools panel with no second list to maintain.

| Event | Handler | Purpose |
|-------|---------|---------|
| `PLAYER_LOGIN` | `ns:OnPlayerLogin` | AceDB init, migrations, options registration, profile callbacks, LibDBIcon registration, welcome print, bag-space baseline, tooltip-hook install. |
| `PLAYER_ENTERING_WORLD` | `ns:OnEnteringWorld` | Holds bag-space warnings briefly while the client repopulates containers after a loading screen. |
| `PLAYER_LEVEL_UP` | `ns:OnPlayerLevelUp` | Consumable eligibility is level-gated, so a ding can newly qualify outgrown food — re-scan. |
| `BAG_UPDATE_DELAYED` | `ns:OnBagUpdateDelayed` | Debounced re-scan + minimap refresh + bag-space check. |
| `QUEST_TURNED_IN` | `ns:OnQuestTurnedIn` | Quest-item-ready chat alert. |
| `MERCHANT_SHOW` / `MERCHANT_CLOSED` | `ns:OnMerchantShow` / `ns:OnMerchantClosed` | Start Auto-Vend / final sale confirmation, summary flush, re-check bag space. |
| `MAIL_CLOSED` | `ns:OnMailClosed` | Re-check bag space once mail looting settles. |
| `BANKFRAME_OPENED` / `BANKFRAME_CLOSED` | `ns:OnBankOpened` / `ns:OnBankClosed` | Start a bank-retrieval pass / end it, print its summary, re-check bag space. |
| `PLAYER_REGEN_ENABLED` | `ns:OnCombatEnded` | Resume a vend pass deferred because it began in combat. |

`BAG_UPDATE_DELAYED` is debounced with a 0.1s `C_Timer.After` behind the `updatePending` flag, so a burst from looting or a vendor turn-in coalesces into one rescan. `QUEST_TURNED_IN` work is delayed 1.0s to give the server time to flag the quest complete before `IsQuestFlaggedCompleted` is read.

The dispatcher taps the diagnostics event log *before* calling the handler, behind a single boolean check (`ns.diagnostics.logging`) so it costs nothing when logging is off. Because every event passes through this one point, the event log is complete — a feature that created its own event frame would bypass the tap and go unlogged.

### Combat Lockdown

`RunEraser` and `PerformErase` check `InCombatLockdown()` at entry and bail with `L["COMBAT_LOCKOUT"]` (`DeleteCursorItem` and `PickupContainerItem` are protected). There is no deferred replay — the player clicks again after combat. `PerformErase` re-guards on entry because a safety confirmation dialog can span the moment combat begins.

The two automatic features face combat differently, and the difference is the window they run behind:

- **Auto-Vend defers and resumes.** A merchant frame can be open while in combat, and `UseContainerItem` is protected, so calling it under lockdown throws `ADDON_ACTION_FORBIDDEN`. Auto-Vend guards in two places — `ns:OnMerchantShow` (opened in combat) and each `ProcessSellQueue` tick (combat started mid-queue) — and on either it stops, sets `vendPending`, and announces the deferral once via `PrintVendMessage`. `ns:OnCombatEnded` then re-scans from scratch and resumes if the merchant is still open, since slots may have shifted during combat. `MERCHANT_CLOSED` clears `vendPending`.
- **Bank Retrieval ends outright.** The bank window does not survive combat, so there is nothing to come back to. `StartPass` and every `ProcessMoveQueue` tick check `InCombatLockdown()` or a closed `BankFrame` and call `FinishPass` — no pending flag, no `PLAYER_REGEN_ENABLED` resume. Reopening the bank starts a fresh pass.

### Scan → Evaluate → Rank → Erase

The pipeline lives in `Eraser.lua`:

1. **Scan** — `FindItemToDelete` walks bags 0–4 via `C_Container.GetContainerItemInfo`, skipping items on either ignore list and in the class reagent exclusions.
2. **Evaluate** — `GetItemDeleteReason` returns `"quest"`, `"consumable"`, `"equipment"`, `"gray"`, or `nil`. Quest items must additionally pass `IsQuestCompleted`; consumables must be at least 10 levels below the player.
3. **Rank** — `isBetterDeletionCandidate` ranks by total stack value first; ties break by `ns.DeletePriority` (`quest=1`, `gray=2`, `consumable=3`, `equipment=3`), so the cheapest item wins and a completed quest item breaks a value tie.
4. **Erase** — `RunEraser` (optionally behind a safety confirmation) calls `PerformErase`: `PickupContainerItem` → `GetCursorInfo` verification → `DeleteCursorItem`, plays a sound, prints the result, invalidates the cache, and refreshes the display after 0.2s.

The same single scan populates the tooltip's Clutter Report totals (`cachedReclaimSlots/Items/Value`) as a side effect, read back via `ns:GetReclaimSummary`.

`ns:GetItemDeleteReason` is the shared predicate: Auto-Vend, Bank Retrieval, and the item tooltip all call it, so a category change lands everywhere at once and nothing can classify an item differently from the eraser.

### Item Data Caching

`GetItemInfo` returns `nil` on a cold cache. All three scanners — `FindItemToDelete` (Eraser), `ScanAndVend` (Auto-Vend), and `ScanBank` (Bank Retrieval) — detect this, call `C_Item.RequestLoadItemDataByID`, and schedule a bounded retry capped at `MAX_SCAN_RETRIES` (5 in each file) so an item whose data never resolves cannot loop forever. Eraser's `ScheduleScanRetry` allows one pending retry (`retryPending`) and uses an `inScanRetry` flag so the attempt counter resets only on a genuinely fresh scan trigger — every fresh trigger flows through `InvalidateCache`, which resets the counter unless a retry is in progress. Auto-Vend resets its counter on `MERCHANT_SHOW`, Bank Retrieval on `BANKFRAME_OPENED`.

The eraser also keeps a short-lived candidate cache (`cachedItem` + `isCacheValid`) invalidated on bag update, level-up, ignore-list change, profile switch, deletion, quest turn-in, and a completed retrieval pass.

Options panels that list item ids have a fourth path: `ns.WarmItemCache` in `Options/Options-Utilities.lua`. A panel renders cold rows as `L["LOADING_ITEM"]` and hands the cold ids over; the helper requests each one, then polls (`WARM_RETRY_SECONDS` 0.5, `WARM_MAX_ATTEMPTS` 10) and fires `NotifyChange` only when the cold count actually drops, so every repaint means a row really changed. One chain per registry name at a time, guarded by `warmingPending`, since the repaint re-enters the function with the still-cold ids.

### Per-Character Profiles

`Core.lua` creates the database **without** AceDB's shared-Default flag (`AceDB:New("MagicEraserDB", ns.DATABASE_DEFAULTS)`), so every character lands on its own `"Name - Realm"` profile. That profile holds exactly one thing — the character's ignore list, as a flat `profile.ignoreList` — which makes the per-character list per-character for free, with no keying inside a shared profile.

Everything else lives in `global`: account-wide, identical on every character, and untouched by profile switches. That split is deliberate. Settings should not vary per character, but a character's ignore list should, and expressing "per character" as an actual AceDB profile means the stock Profiles panel behaves normally: the picker shows the real character, and Copy From / switching move one character's list rather than swapping a whole hidden set at once.

Two consequences worth knowing:

- Because `global` is outside the profile scope, `Reset Profile` alone would clear only the ignore list. `ns:OnDatabaseReset` is hooked to the `OnProfileReset` callback so it also restores every scalar `global` setting to its default and re-shows the minimap button, making that button behave like a full reset of the add-on for the current character. The minimap *position* is deliberately left alone — a saved position is not a "setting" a reset should move.
- The erase candidate is computed from the active profile's ignore list, so `OnProfileChanged` and `OnProfileCopied` are hooked to `ns:OnProfileSwitched`, which just re-runs `ns:RefreshDisplay`.

### Colors

The raw hex palette is data (`ns.PALETTE` in `Data/Data.lua`); the derived escape strings (`COLORS`) and the accessor (`ns.GetColor`) are logic (`Features/Utilities.lua`), built by iterating the palette so a new key needs no second edit. `COLORS` is file-local — consumers never read it directly; each consuming file aliases the accessor once (`local GetColor = ns.GetColor`) and calls `GetColor("KEY")`. Keys: `TITLE`, `INFO`, `BODY`, `HELP`, `TEXT`, `ON`, `OFF`, `SEPARATOR`, `MUTED`. `BODY` is white for descriptions and body text; `HELP` is the silver split-off for helper text and pro tips, used by the developer-facing Diagnostic Tools panel. Color constants carry no `|cff` prefix — it is prepended once in Utilities, and `|r` is appended at each call site. `ns.CurrencyColors` (gold/silver/copper) sits beside the palette in `Data.lua` and is consumed only by `ns:FormatCurrency`.

## Eraser Categories

`GetItemDeleteReason` is an ordered fall-through, so an item appearing in two databases is classified by the first match:

```lua
if questItemDatabase[itemId] then        -- a completed quest releases it
elseif consumableDatabase[itemId] then   -- outgrown by 10+ levels
elseif equipmentDatabase[itemId] then    -- curated vendor-white
elseif rarity == 0 and sellPrice > 0     -- generic gray fallback
```

Quest data is `itemId → { questId, ... }`; an item is erasable if **any** listed quest is flagged complete, which handles one drop tied to multiple quests across a chain. Because the quest branch is checked first, a gray-quality quest item is protected until its quest is done rather than being swept up by the gray fallback.

## Safety Confirmations

Erasing is normally a single click with no prompt — the safety model is the hand-curated databases. When the player opts in (**Eraser Confirmations**, off by default), `ns:NeedsSafetyConfirm` maps the candidate's delete reason to its per-reason toggle through `SAFETY_REASON_KEYS` (`quest→safetyQuest`, `consumable→safetyConsumable`, `equipment→safetyWhite`, `gray→safetyGray`). When both the master toggle and the matching per-reason toggle are on, `RunEraser` shows the `MAGICERASER_CONFIRM_ERASE` static popup instead of erasing directly. The candidate is passed as the dialog's `data` so each showing acts on the exact item the player saw, and `PerformErase` re-validates the slot (cursor item id must match) before deleting — a slot that shifted while the dialog was open aborts rather than deleting the wrong item. `preferredIndex = 3` avoids tainting the shared dialog stack.

## Auto-Vend

Auto-Vend lives in `Auto-Vend.lua` and uses a scan-then-process pattern rather than selling inside the scan:

1. `ScanAndVend` walks bags, applies the same ignore-list and class-reagent filters as the eraser, and queues every item with a positive `sellPrice` and a non-nil `GetItemDeleteReason`. The queue is sorted by total stack value ascending, so the cheapest items sell first.
2. `ProcessSellQueue` advances one item per 0.1s tick and re-reads the slot before selling, because bag positions shift after a sale.

**Sales are announced only once confirmed.** `UseContainerItem` is optimistic: a merchant that cannot complete a transaction — a "dead" corpse vendor that still opens a merchant frame — accepts the call silently and sells nothing. Announcing at send time would report phantom sales, so `ProcessSellQueue` records each attempt in `pendingSales` and announces nothing. `ConfirmSales` then counts a sale only when the slot no longer holds the attempted item; anything still sitting in its slot did not sell and stays pending for a later pass. Confirmation runs at the top of each `ScanAndVend` re-scan (0.3s after a pass, long enough for the sell round-trip) and once more `CLOSE_CONFIRM_SECONDS` (0.4s) after `MERCHANT_CLOSED`, deferred so the last sells have time to leave their slots. That deferred flush carries a `visitGeneration` check so it drops out if a new merchant visit has already begun. `announcedSales`, keyed `"bag:slot:itemId"`, keeps a retried slot from being announced twice; it is wiped per visit in `StartVending`, not per pass.

**Multi-pass re-sell.** The server silently drops some `UseContainerItem` sells when many arrive in quick succession, leaving one or two flagged items behind on large batches. After a pass finishes, Auto-Vend re-scans and runs another pass (up to `MAX_VEND_PASSES` = 4), rebuilding the queue from live bag state so only items that did not actually sell get re-queued. The cap prevents a flagged-but-unsellable item from looping forever.

**Message modes.** All Auto-Vend chat routes through the file-local `PrintVendMessage`, a no-op unless `ns.db.global.autoVendMessagesEnabled` is set. With messages on, the **Line Item / Summary Only** dropdown (`autoVendSummaryEnabled`) chooses whether a per-item `L["SOLD_ITEM"]` line prints as each sale is confirmed; the closing `L["SOLD_SUMMARY"]` line prints in both modes on the deferred `MERCHANT_CLOSED` flush. Per-visit totals accrue for every newly confirmed sale regardless of the current mode, so flipping the dropdown mid-visit still produces a correct closing line.

Items with `sellPrice == 0` (most quest items) are filtered at scan time — they cannot be vendored, so the eraser handles them instead.

## Bank Retrieval

`Bank-Retrieval.lua` runs one pass per `BANKFRAME_OPENED`, pulling flagged items out of the bank so the eraser can act on them. `BANK_CONTAINERS` is built once at load from `BANK_CONTAINER` plus the purchasable bank bags (`NUM_BAG_SLOTS + 1` through `+ NUM_BANKBAGSLOTS`), with the same numeric fallbacks Bag-Warnings uses so a missing global can never quietly scan nothing. Neither flavor has a reagent bank, so nothing else is scanned.

The pass waits `BANK_SETTLE_SECONDS` (0.5s) before its first scan, because the bank containers read empty for a moment after the frame opens. `ScanBank` then applies exactly the eraser's predicate over those containers, and `ProcessMoveQueue` moves one item per `MOVE_INTERVAL_SECONDS` (0.1s) tick — the same pacing as Auto-Vend, and for the same reason.

**The budget is the free-slot count minus the player's own threshold.** `GetMoveBudget` returns `ns:CountFreeBagSlots() - bagsFullThreshold`, so retrieval stops short of triggering the bag-space warning it would otherwise cause. A `nil` free count (containers not ready) yields no budget and the pass simply does not run.

**Sorted most-valuable-first**, the opposite of Auto-Vend's ascending sell order. Auto-Vend has the whole merchant visit to work through its queue, so it starts with the cheapest clutter; this pass is capped by however many bag slots happen to be free, so when the budget runs out mid-queue what stays in the bank should be the gold that mattered least.

**Confirmed-move accounting.** `UseContainerItem` can be dropped by the server here too, so `pendingMove` holds the last attempted move and `ConfirmPendingMove` counts it only once the bank slot no longer holds that item. The queue-exhausted branch schedules one extra tick so the final move of a pass gets the same chance. A pass cut short by combat or the window closing therefore leaves its last move uncounted rather than claiming one it could not verify.

**`passGeneration` guards the timer chains.** It is bumped on every `BANKFRAME_OPENED`, and every timer this file schedules carries the generation it was created under and drops out if a newer pass has begun. `isRetrieving` alone would not catch a close-and-reopen inside the settle window: the second open sets that flag back to true and the first pass's stale timer would sail straight through.

`FinishPass` is the single exit, however the pass ended. It prints `L["BANK_RETRIEVED"]` only when something was confirmed moved, then resets the totals and drops any unconfirmed move — so the second call (the pass finishing, then `BANKFRAME_CLOSED` arriving) stays silent and nothing leaks into the next pass.

## Ignore Lists

There are two lists and protection is **additive**: `ns:IsIgnored` answers true if either one holds the item, and neither can override the other.

- **Per-character** — `ns.db.profile.ignoreList`, the one profile-scoped setting (see *Per-Character Profiles*).
- **Account-wide** — `ns.db.global.ignoreList`, its mirror in the global scope, protecting an item on every character.

The minimap button's right-click (toggle) and middle-click (clear) act on the **current character's list only**, which is exactly what the minimap tooltip's Ignore List section shows — so both keep meaning what the player just read. The account-wide list is edited from the Ignore List panel.

`ns:GetIgnoreListForScope(scopeKey, createIfMissing)` is the panel's single accessor. The current profile resolves through `ns.db.profile` rather than the raw saved table, so an edit lands on the very list the eraser reads and applies live. Every *other* profile is read straight out of `ns.db.sv.profiles`, because AceDB only materializes the profile you are on — and it strips default-valued tables at logout, so a character who never added an entry has no stored `ignoreList` and one who never changed a setting has no stored profile at all. A read returns `nil` in those cases; a write passes `createIfMissing` and builds what it needs on the spot.

**Promote, not copy.** The panel's per-character rows carry a Global button that only ever issues the account-wide add; `ns:SetIgnoredInScope` then calls `ClearFromAllProfiles`, dropping the item from every character's list. Protection only widens doing it this way, because the global list already covers everyone it just left, and the item ends up living in exactly one place instead of cluttering panes with rows that can no longer change any outcome. Removing from the account-wide list deliberately does *not* put the item back on anyone: there is no record of who held it.

`ns.IGNORE_SCOPE_GLOBAL` is the literal `"**global**"`. Every other scope key is an AceDB profile name (`"Name - Realm"`, never localized), so the account-wide list needs a key no profile can collide with — the asterisks are something the profile picker's name box would never produce.

## Item Tooltip Warnings

`Features/Item-Tooltips.lua` appends a single branded line to a carried-bag item's tooltip: a red will-erase warning (`L["TOOLTIP_WILL_ERASE"]`) when Magic Eraser would erase it, or a white protection notice (`L["TOOLTIP_IGNORED"]`) when an ignore list is shielding it. Protection wins over any erase verdict. The rest of the verdict comes from the very rules the eraser's scan uses (class-reagent exclusions, `ns:GetItemDeleteReason`), so the line appears only when the item truly would be erased — level gate and quest-completion check included. Purely read-only; gated on `tooltipWarningEnabled`.

There are two hook paths because the tooltip API differs across the flavors we target, and only one is ever active (the line is never doubled):

- **Modern** clients expose `TooltipDataProcessor`; the post-call fires for every item tooltip, so `IsCarriedBagSlot` filters to owners whose `GetBagID()` (or `ContainerFrame` parent id) is in `0..NUM_BAG_SLOTS`.
- **Older** clients get a `hooksecurefunc` on `GameTooltip:SetBagItem`, already bag-scoped by its arguments — bank bags (5..11) fall outside the range check, so no owner sniffing is needed.

The choice is made by feature detection, never by flavor, so a client that gains the API needs no code change. Hooks install from `ns:OnPlayerLogin` via `C_Timer.After(0, ns.SetupTooltipHooks)`, not at file load, so ours wraps the **outermost** layer other add-ons installed. A heavy tooltip add-on like TSM that clears and re-fills the tooltip in its own `OnTooltipSetItem` would otherwise wipe our line; landing last, we survive its rebuild. Running outermost also means the tooltip has already been sized, so the `SetBagItem` path re-`Show()`s when it added a line, letting the frame grow to include it.

## Bag-Space Warnings

Lives in `Features/Bag-Warnings.lua`. An opt-in countdown (`bagsFullNudgeEnabled`, off by default) that warns as free slots drop to or below `bagsFullThreshold`. It never deletes and does not care whether anything is erasable — it is purely a free-space alert.

The count comes from `ns:CountFreeBagSlots` in `Features/Utilities.lua`, which is shared with Bank Retrieval's budget and lives there rather than in either consumer. It sums only general-purpose bags, excluding specialty bags (quiver/soul/profession) since ordinary loot can't go there, and it returns `nil`, never `0`, when no container has answered yet. Summing `(bagFree or 0)` across bags cannot tell "the API has no data yet" apart from "zero free slots," so mid-loading-screen every container reads nil, the total collapses to 0, and the add-on cries "bags full" at a player with a half-empty inventory. Reporting "unknown" lets the caller skip instead. Readiness is judged from the data itself — the backpack always has slots and always answers once the inventory is loaded, so a zero slot total, or no bag answering at all, means nothing is loaded yet.

A `BAG_SETTLE_SECONDS` (2s) hold refreshed on every `PLAYER_ENTERING_WORLD` is the secondary guard, keeping the check idle while the client repopulates containers. `lastNudgeFree` dedups so the same count is never printed twice in a row, and resets once free climbs back above the threshold so re-entering the warning zone warns again. The baseline is seeded at login by `ns:SeedBagSpaceBaseline` so the login-time `BAG_UPDATE_DELAYED` burst is treated as already known.

Warnings are suppressed while a merchant, mailbox, **or bank** window is open (`ns:IsBagWindowOpen`, checked live rather than via a tracked flag so a missed SHOW event can't strand it), because those visits churn bags hardest. Each of the three close handlers re-checks once: `ns:OnMailClosed`, Auto-Vend's deferred merchant flush, and `ns:OnBankClosed`.

## Quest-Item Alerts

`ns:OnQuestTurnedIn` waits 1.0s, then walks bags and prints `L["QUEST_ITEM_READY"]` once per held item whose newly-completed quest matches one of its tracked ids. Purely a UX nudge — the eraser's own evaluation already classifies the same items.

## Minimap Button & Display

`Minimap-Button.lua` builds an LDB data object (registered with LibDBIcon) whose icon mirrors the current erase candidate, falling back to `ns.DefaultIcon` when bags are clean. Click handlers:

| Click | Action |
|-------|--------|
| Left | `RunEraser` — erase the lowest-value candidate. |
| Right | Toggle the current candidate on this character's ignore list. |
| Middle | Clear this character's ignore list. |
| Shift + Right | Toggle Auto-Vend. |
| Shift + Middle | Open the options panel. |

`RefreshTooltip` composes the whole tooltip in a fixed order — the lowest-value item with click hints, Auto-Vend status, the Clutter Report, then the ignore list, then the options keybind. The list is last of the content sections because it is the only one whose length varies with how much the player has protected, so everything above it holds a fixed position no matter how long the list grows. Item names in it resolve lazily, with `L["LOADING_ITEM"]` shown for cold ones. `ns:RefreshDisplay` invalidates the cache, recomputes the candidate, repoints the icon, and re-renders the tooltip if the button currently owns it.

## Diagnostic Tools

`Features/Diagnostics.lua` plus `Options/Options-Diagnostics.lua` provide a gated panel at **Options > AddOns > Magic Eraser > Diagnostic Tools** for bug reports — environment probing and state capture, not unit tests. State lives in `ns.diagnostics` (`{ enabled, logging, log }`, plus the last-built report string per section), a plain namespace table that is never a SavedVariable, so it defaults off and resets every session. A single runtime toggle gates the panel: when off, only the warning text and the enable toggle render and everything below is hidden rather than grayed. Every report builds only on a button press, never on load or panel open. Sections:

- **Event Log** — the dispatcher tap, a 500-entry ring buffer capping 8 args × 255 bytes each, pipes escaped *after* the length cut so item links paste as plain text and a cut can never leave a dangling pipe. `ns.DIAGNOSTIC_EVENT_EXCLUDE` is deliberately empty (the log only ever sees events the add-on registers).
- **Event Registration** — every `ns.EVENT_NAMES` entry tested for `C_EventUtils.IsEventValid` and a register/unregister round-trip on a probe frame with no handler attached.
- **API Endpoints** — `ns.DIAGNOSTIC_API_CHECKS`, kept one-to-one with the APIs the add-on calls or guards; existence/shape checks only. `C_AddOns.GetAddOnMetadata` and the legacy global are both listed, because the legacy one ships on Era and is gone on TBC.
- **Eraser Context** — player level/class, the Auto-Vend and Bank Retrieval toggles, both ignore-list counts, database sizes, class-reagent count, and the live candidate.
- **Display Context** — screen size, UI scale, and the minimap button's saved placement; answers "the button is gone / off-screen."
- **Other Add-ons** — every installed add-on with version and loadable state.
- **Saved Variables** — `MagicEraserDB` dumped, with any `ignoreList` replaced by a count summary rather than every itemId.
- **Library Versions**, **Taint Log**, and **External Tools**. The `taintLog` CVar is the only state the panel ever writes; External Tools is text only, pointing at BugSack/`/console scriptErrors 1` and `/etrace` rather than reimplementing them.

All diagnostics strings live in `ns.DiagnosticsStrings` as plain English and are never localized (developer-facing, zero player value). The one exception is `ns.AddonTitle`, which is identity, not a diagnostics string. The panel is registered last so it sits at the bottom of the settings tree.

## Options & Profiles

`ns:RegisterOptionsPanels` (called from `OnPlayerLogin`, once `ns.db` exists — the Ignore List and Profiles builders both need the database) registers four AceConfig tables from `ns.OPTIONS_REGISTRY` and nests them under Magic Eraser in Blizzard options, in order: **General** (root) → **Ignore List** → **Profiles** → **Diagnostic Tools**. Each child passes `ns.AddonTitle` as its third `AddToBlizOptions` argument. Panel content lives in the per-panel builder files; `Options.lua` is registration only. Widget constructors (`ns.OptionsHeader/Desc/Spacer/SubHeader`) are shared from `Options-Utilities.lua`. The **Profiles** panel is the stock `AceDBOptions-3.0` table returned unmodified.

The Ignore List panel is registered as the **builder function itself**, not a built table: its rows are the ignore lists, so AceConfig re-invokes it on every open and every `NotifyChange` and the panel can never render a stale list. It uses `childGroups = "tree"`, keyed by scope rather than by position — the tree remembers the selected node by its arg key, so a key that moved when a profile appeared or dropped out would silently reselect a different character. Character scopes with nothing ignored are left out of the tree entirely, except the one being played, whose list has to stay reachable to put a first item in it. There is no drop target, deliberately: the game closes the bags when the options interface opens, so typing an id or shift-clicking a link into the add box is the only path that can actually work.

`/eraser` opens the options panel. Registration is in `Options.lua` (`SLASH_MAGICERASER1` + `SlashCmdList.MAGICERASER`). `AddToBlizOptions` returns `(frame, categoryID)` and **both are captured** at the root panel's registration; `ns:OpenOptionsPanel` then routes `Settings.OpenToCategory(<captured categoryID>)` first, falls back to `InterfaceOptionsFrame_OpenToCategory(<captured frame>)` called twice, and reaches `AceConfigDialog:Open` only as a last resort. Never look the category up by display name: AceConfigDialog only aliases the category ID to the panel's name on clients lacking `C_SettingsUtil.OpenSettingsPanel`, so a name lookup returns `nil` on TBC Anniversary and the panel opens as a floating standalone window instead of docking into Blizzard's settings.

## Saved Variables

Magic Eraser uses **AceDB-3.0** with one managed table, `MagicEraserDB`, initialized in `ns:OnPlayerLogin`. `AceDB:New` deliberately omits the shared-Default third argument, so each character gets its own `"Name - Realm"` profile (see *Per-Character Profiles*).

- **`global`** (account-wide) — every user setting, the account-wide `ignoreList`, the LibDBIcon placement table, and the one-time migration markers.
- **`profile`** (per character) — only `ignoreList`, that character's flat set of protected item ids.

`## SavedVariablesPerCharacter: MagicEraserCharDB` is still declared in the TOC, but only as a legacy migration source — it is read once and cleared. The declaration is scheduled for removal after 2026-08-21 (see the MIGRATION comment in the TOC).

### Migration Chain

All migrations run once in `ns:OnPlayerLogin`, guarded so they self-disable and are safe across every character.

1. **Pre-AceDB adoption** *(remove after 2026-08-21)* — captures the raw pre-AceDB `MagicEraserDB` and per-character `MagicEraserCharDB` before AceDB adopts the table, folds the settings into `global`, then clears the legacy keys. Each legacy value is read only inside its table guard, so a fresh install leaves every capture `nil` rather than `false` — a `false` would overwrite a correct `true` default.
2. **Profile → global rehome** *(remove after 2026-08-21)* — the first AceDB build kept settings on one shared profile; a non-nil raw read for any settings key means the user set it, so it moves up to `global` and is cleared from the profile. Idempotent across characters.
3. **Shared profile → per-character profiles** *(remove after 2026-08-21)* — moves this character onto its own `"Name - Realm"` profile, carrying its list out of the old shared `Default.ignoreLists` keyed table into a flat `profile.ignoreList`, then drops the obsolete keyed table. A non-empty flat `ignoreList` still sitting on the old `Default` marks a first-AceDB profile whose merged buckets are unreliable; those are discarded and the character re-seeds from its own pre-AceDB list instead.
4. **Auto-Vend message reset** *(remove after 2026-08-21)* — the Line Item/Summary Only rollout forces Auto-Vend messages on once for everyone via the `autoVendSummaryMigrated` marker, which has no default entry so AceDB never strips it and the reset cannot re-fire.
5. **Stray macro cleanup** *(remove after 2026-08-21)* — the removed Delete Macro feature left an account-wide `- Eraser` macro; it is deleted once, combat-guarded (`DeleteMacro` is protected), and marked done only after a real pass, so a login-in-combat retries next time.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied lazily by AceDB-3.0 via metatables — nothing is copied into the saved table, and explicit user values (including `false`) are never overridden.

There is no refill-on-empty logic, and nothing needs one: the curated item databases (`AllowedDeleteQuestItems`, `AllowedDeleteConsumables`, `AllowedDeleteEquipment`) are static Lua tables shipped in `Data/`, not saved variables, so they can never be emptied at runtime. The two saved lists that *can* be emptied are the ignore lists, where empty is exactly what the player asked for.

## Adding a New Trash Item

1. **Consumable** — append `[itemId] = true` to `Data/Consumables.lua` with a name comment. Eligibility is gated by required-level vs player-level (10+ delta).
2. **Equipment** — append `[itemId] = true` to `Data/Equipment.lua` with a name comment. White vendor trash, no level gate.
3. **Quest item** — append `[itemId] = { questId, ... }` to `Data/Quest-Items.lua`. List every quest that releases the item; the eraser fires when any of them is complete.
4. **Class reagent exclusion** — add to `ns.ClassReagentExclusions[CLASS_TOKEN]` in `Data/Data.lua`. Excluded items are never erased, vendored, or retrieved from the bank, regardless of database membership.

Keep entries alphabetized by the trailing name comment so diffs stay readable. Per the style guide, these tables are appended to, never reformatted or reproduced wholesale, and each carries a `-- TODO: Add SQL Query` marker until its originating query is filled in — leave that marker in place.

## Adding a New Event

1. Add the event name to `ns.EVENT_NAMES` in `Features/Core.lua`.
2. Add an `EVENT_NAME = "OnXxx"` entry to `EVENT_HANDLERS` in the same file.
3. Define `ns:OnXxx(...)` in whichever feature file owns it (Core, or a feature file loaded after Core — it is resolved by name at fire time).

That is the whole registration. The dispatcher, and the Diagnostic Tools event log and Event Registration probe, all read `ns.EVENT_NAMES`, so they pick the event up automatically with no second list to update. Never create a separate event frame — it would escape the diagnostics tap.

## Adding a New Setting

1. Add the key and its default to `ns.DATABASE_DEFAULTS.global` in `Data/Default-Settings.lua`. Settings are account-wide; only the per-character ignore list belongs in `profile`.
2. Add the widget to `ns.BuildGeneralOptions` in `Options/Options-General.lua`, reading and writing `ns.db.global.<key>` directly — AceDB's metatable supplies the default, so there is nothing to initialize.
3. Add the label strings to `Locales/enUS.lua`; the Localization pass carries them into the other ten locales.
4. If the setting gates chat output, route that output through the feature's existing print wrapper rather than calling `ns:PrintMessage` directly.

A new setting needs no migration. One is needed only when an *existing* key changes meaning or home; those go in `ns:OnPlayerLogin`, guarded by a marker with no default entry (so AceDB never strips it) and dated in a `MIGRATION` comment.

Magic Eraser writes no macros and sends no chat, so neither the 255-character macro limit nor the 255-byte chat-line limit constrains any of this — every player-visible string is a local `print` or an options-panel label. The practical ceiling is visual: a translated label has to fit its widget.

## Localization

WoW ships a fixed locale set, and every supported locale file already exists in `Locales/`, so localization here is **maintenance, not expansion** — there is no "add a new locale" step.

- **Structure** — each `Locales/<locale>.lua` registers through `LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "<locale>")`. `enUS.lua` is the source of truth and the only file that passes the `true` default-fallback flag; every string originates there.
- **Keeping locales in sync** — every non-English file carries a translation of the same key set, and AceLocale falls back to English via `__index` for anything missing at runtime. Translating each `enUS.lua` key into every locale and keeping the files aligned is the job of the Localization pass; don't hand-edit the other locales during ordinary work. A renamed key leaves harmless orphans in the translated files until that pass runs.
- **Placeholders** — `%s`/`%d` count, type, and order must match `enUS` per key in every locale, or the string crashes at runtime. This is the highest-value invariant when editing strings. The multi-placeholder lines are the ones to watch: `SOLD_SUMMARY`, `BANK_RETRIEVED`, `ERASED_ITEM_WITH_VALUE`, and `ERASED_ITEM_FROM_QUEST`.
- **Spanish** — `esES.lua` and `esMX.lua` are two separate, self-contained files; identical strings in both is correct and expected.
- **Not localized** — `ns.DiagnosticsStrings` (developer-facing), AceConfig registry names in `ns.OPTIONS_REGISTRY`, `ns.IGNORE_SCOPE_GLOBAL`, and AceDB profile names, which are `"Name - Realm"` character keys.
- **Locale overflow** — Magic Eraser writes no macros and sends no chat, so neither the 255-character macro limit nor the 255-byte chat-line limit applies here; all player output is a local `print`. The practical constraint is visual: watch translated strings in width-constrained slots, chiefly the minimap tooltip's double-lines and the options-panel toggle labels.

## Common Pitfalls

- **Announcing a sale or a bank move before it is confirmed**: `UseContainerItem` succeeds silently against a merchant that cannot actually buy, and the server can drop the call outright. Record the attempt (`pendingSales` / `pendingMove`) and count it only once the item has left its slot.
- **Cursor latency between pickup and delete**: `PickupContainerItem` is asynchronous. `PerformErase` verifies `GetCursorInfo` holds the expected `itemId` before `DeleteCursorItem`, printing `L["CURSOR_TOO_FAST"]` and clearing the cursor on a mismatch.
- **Treating "no container data" as "no free slots"**: mid-loading-screen every bag reads nil, so `(bagFree or 0)` sums to a false "bags full." `ns:CountFreeBagSlots` returns nil for unknown and callers skip — including Bank Retrieval, where a nil count must mean "no budget," not "no free slots."
- **Stale `GetItemInfo` on first scan**: cold-cache nils are handled by `RequestLoadItemDataByID` plus the bounded retry. Don't add eager fallbacks like hyperlink parsing — let the API resolve.
- **`BAG_UPDATE_DELAYED` fires repeatedly**: coalesce with the 0.1s `updatePending` guard already in `ns:OnBagUpdateDelayed`; don't refresh straight from the handler.
- **Consumable eligibility is level-dependent**: `GetItemDeleteReason` reads `UnitLevel`, so the candidate must refresh on `PLAYER_LEVEL_UP` — a bag update is not guaranteed after a ding.
- **A reopened window restarting a timer chain**: Bank Retrieval's `isRetrieving` flag alone cannot stop a stale chain, because reopening sets it back to true. Any new timed pass needs a generation counter checked inside every timer, as `passGeneration` does.
- **Opening the options panel by name**: `Settings.GetCategory(<title>)` returns nil on clients that have the Settings API, so the panel opens as a floating window. Route by the captured `categoryID` from `AddToBlizOptions`.
- **Registering a list-driven panel as a built table**: the Ignore List panel must be registered as its builder *function*, or AceConfig renders whatever the list looked like at login forever.
- **Mutating the shared AceDBOptions args table**: `AceDBOptions-3.0:GetOptionsTable` hands every database the *same* module-level `args` table, so adding a button or a confirm to it leaks that change into every other Ace3 add-on's Profiles panel — and a closure-bound `func` will act on the wrong add-on's database. Leave the returned table unmodified.
- **Bypassing the dispatcher**: register events only by adding to `ns.EVENT_NAMES` plus an `ns:OnXxx` handler. A feature that creates its own event frame escapes the diagnostics event-log tap.
- **Auto-Vend and `sellPrice == 0`**: filtered at scan time. Quest items aren't vendorable, so the eraser keeps them rather than the vendor swallowing them.
- **New Auto-Vend chat must use `PrintVendMessage`**: calling `ns:PrintMessage` directly from the vend path ignores the **Enable Auto-Vend Messages** toggle.
- **Settings are `global`, the per-character ignore list is `profile`**: new user settings go in `ns.db.global` via a `ns.DATABASE_DEFAULTS.global` default. Putting a setting in `profile` silently makes it per-character — and `Reset Profile` would then clear it while `ns:OnDatabaseReset` restores the others.
- **Checking only one ignore list**: protection is additive. Use `ns:IsIgnored`, never a direct read of either table, or an item protected account-wide gets erased on a character whose own list is empty.
- **Server silently drops bulk sells**: don't assume one `ScanAndVend` pass clears the bags. The multi-pass loop (`MAX_VEND_PASSES`) exists because `UseContainerItem` sells are dropped under load; keep the re-scan-between-passes structure.

## Contributing

Issues and PRs go on [GitHub](https://github.com/Gogo1951/Magic-Eraser/issues). Discussion happens on [Discord](https://discord.gg/eh8hKq992Q).

Bug reports should include game version (Classic Era 1.15.x or TBC Anniversary 2.5.x), locale, class + level, reproduction steps, and the relevant chat output. The Diagnostic Tools panel produces a copy-paste-ready report for exactly this.

PR guidelines:

- **One concern per PR.** A locale update, a database expansion, and a logic change are three PRs.
- **Match existing style** — 80-character section dividers, the `ns` namespace, `L["UPPER_SNAKE_CASE"]` for all user-facing strings, and the shared `ns.Options*` / `ns.GetColor` helpers. Run StyLua with its default configuration before committing.
- **New saved-variable fields** seed defaults through `ns.DATABASE_DEFAULTS` and rely on AceDB's metatable application; never hand-merge or overwrite user values.
- **Database edits** keep the column-header comment and the `TODO` marker; don't reformat existing rows.
- **Migration discipline** — migrations are one-time, guarded, and dated in `ns:OnPlayerLogin`; don't remove one before its noted date.
- **Run `README-Testing.md`** on both flavors before tagging a release, and cite the step number when something fails.
- **Output length** — Magic Eraser writes no macros and sends no chat, so the 255-character macro limit and 255-byte chat-line limit don't apply. If a change ever adds a sent message, measure the decorated line in bytes and check the widest-encoding locale (ruRU, not automatically deDE).
- **Update this document** when the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X" or "I fixed Y" — frame the change by who it helps and why.

    **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

    **Example:** *As a player who vendors at a quest-giver that can't actually buy, I wanted Magic Eraser to stop telling me it sold items it didn't, so the gold total in chat matches reality. This change records each sell attempt and only announces it once the item has actually left the bag.*

    The User Story makes review faster and gives future maintainers context the diff alone won't carry.
