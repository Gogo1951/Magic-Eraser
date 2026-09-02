# Magic Eraser // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Magic Eraser. For end-user documentation, see [README.md](https://github.com/Gogo1951/Magic-Eraser/blob/main/README.md).

## File Map

```text
Magic-Eraser/
├── .github/
│   └── workflows/
│       └── package.yml           CurseForge and Wago release plus library vendoring, no GitHub token by design
├── .gitattributes                Line-ending normalization
├── .gitignore                    Dev-clutter ignore list
├── .luacheckrc                   Lint config, excludes Includes/
├── .pkgmeta                      Externals and the packager ignore list
├── MagicEraser.toc               Load order, one TOC for both flavors
├── Data/
│   ├── Data.lua                  Locale init, identity, links, options grid, palette, class reagents, race and class bits
│   ├── Default-Settings.lua      The AceDB defaults table, global and profile scopes
│   ├── Quest-Items.lua           Items a finished quest leaves behind, keyed to the quest that makes them safe
│   ├── Quest-Starting-Items.lua  Items that hand out a quest, with race and class masks
│   ├── Consumables.lua           Outgrown food and drink, each carrying its use level
│   └── Equipment.lua             Curated vendor-quality whites, weapons then armor
├── Features/
│   ├── Core.lua                  Version, ns.EVENT_NAMES, the dispatcher, AceDB init, the login sequence
│   ├── Utilities.lua             Color accessor, currency and number formatting, free-slot count
│   ├── Announcements.lua         Branded player-only print, the add-on sends no cross-player chat
│   ├── Ignore-List.lua           Both ignore lists, the mini-map mutators, the per-scope reads and writes
│   ├── Erase-List.lua            Both erase lists, their per-scope writes, and the class-reagent seed
│   ├── Eraser.lua                Scan, evaluate, rank, erase, the value cap, and the quest-item alerts
│   ├── Bag-Warnings.lua          Free-slot countdown and the shared bag-window gate
│   ├── Bank-Retrieval.lua        Pulls flagged items out of the bank within a free-slot budget
│   ├── Auto-Vend.lua             Merchant sell pipeline with confirmed-sale accounting
│   ├── Item-Tooltips.lua         Adds the will-erase, Erase List, or protected line to bag-item tooltips
│   ├── Diagnostics.lua           Report builders, event log, API and event probes, data validator, taint log
│   └── Minimap-Button.lua        LDB object, tooltip composition, click handlers, ns:RefreshDisplay
├── Includes/
│   ├── Images/
│   │   └── Magic-Eraser.tga      The TOC's IconTexture
│   └── Libraries/                Vendored Ace3 stack plus LibDataBroker and LibDBIcon, never edited by hand
├── Locales/
│   ├── enUS.lua                  Source of truth, the only file passing AceLocale's default flag
│   └── deDE.lua … zhTW.lua       Ten translations, owned by the Localization pass
├── Options/
│   ├── Options-Utilities.lua     Widget helpers, item-cache warming, the shared item-list builder and its widget
│   ├── Options-General.lua       Root panel, and the sub-option row builders it defines
│   ├── Options-Ignore-List.lua   One tree node per ignore list on the account
│   ├── Options-Erase-List.lua    One tree node per erase list on the account
│   ├── Options-Profiles.lua      Stock AceDBOptions-3.0 table, returned unmodified
│   ├── Options-Diagnostics.lua   Diagnostic Tools panel, registered last
│   └── Options.lua               Registration, ns:OpenOptionsPanel, the /eraser command
├── LICENSE                       MIT
├── README.md                     Player-facing documentation
├── README-Technical.md           This document
└── README-Testing.md             Manual test plan, run on both flavors before a release
```

`.github/`, `.gitattributes`, `.gitignore`, `.luacheckrc`, `.pkgmeta` and `LICENSE` are repo-only; the packager strips them, so an installed copy does not carry them. There are no deprecated or dead files: everything under `Data/`, `Features/` and `Options/` is listed in the TOC and reachable at runtime. `Includes/Libraries/` is rewritten by the release workflow from `.pkgmeta` on every tag, so a hand edit there is overwritten by the next release.

## Architecture

### Event Loop

Every event routes through a single frame in `Core.lua`. `ns.EVENT_NAMES` is the one source of truth: the dispatcher registers each name in it, and `EVENT_HANDLERS` maps each name to an `ns:OnXxx` method resolved *by name at fire time*, so feature files that load after Core supply their own handlers. `Auto-Vend.lua` owns the merchant handlers and `ns:OnCombatEnded`, `Bag-Warnings.lua` owns `ns:OnEnteringWorld` and `ns:OnMailClosed`, `Bank-Retrieval.lua` owns the bank pair, and `Eraser.lua` owns `ns:OnQuestTurnedIn`. Add an event to `ns.EVENT_NAMES` and it is registered, dispatched, and covered by the Diagnostic Tools panel with no second list to maintain.

| Event | Handler | Purpose |
|-------|---------|---------|
| `PLAYER_LOGIN` | `ns:OnPlayerLogin` | AceDB init, options registration, profile callbacks, LibDBIcon registration, welcome print, the Erase List seed, the two alert baselines, tooltip-hook install |
| `PLAYER_ENTERING_WORLD` | `ns:OnEnteringWorld` | Holds bag-space warnings briefly while the client repopulates containers after a loading screen |
| `PLAYER_LEVEL_UP` | `ns:OnPlayerLevelUp` | Consumable eligibility is level-gated, so a ding can newly qualify outgrown food; re-scan |
| `BAG_UPDATE_DELAYED` | `ns:OnBagUpdateDelayed` | Debounced re-scan, display refresh, quest-starter check, bag-space check |
| `QUEST_TURNED_IN` | `ns:OnQuestTurnedIn` | Quest-item-ready chat alerts, then a re-scan |
| `MERCHANT_SHOW` / `MERCHANT_CLOSED` | `ns:OnMerchantShow` / `ns:OnMerchantClosed` | Open an Auto-Vend visit; final sale confirmation, summary flush, re-check bag space |
| `MAIL_CLOSED` | `ns:OnMailClosed` | Re-check bag space once mail looting settles |
| `BANKFRAME_OPENED` / `BANKFRAME_CLOSED` | `ns:OnBankOpened` / `ns:OnBankClosed` | Start a bank-retrieval pass; end it, print its summary, re-check bag space |
| `PLAYER_REGEN_ENABLED` | `ns:OnCombatEnded` | Resume a vend pass deferred because it began in combat |

`BAG_UPDATE_DELAYED` is debounced with a 0.1s `C_Timer.After` behind the `updatePending` flag, so a burst from looting or a vendor turn-in coalesces into one rescan. `QUEST_TURNED_IN` work is delayed 1.0s to give the server time to flag the quest complete before `IsQuestFlaggedCompleted` is read.

The dispatcher taps the diagnostics event log *before* calling the handler, behind a single boolean check (`ns.diagnostics.logging`) so it costs nothing when logging is off. Because every event passes through this one point, the event log is complete: a feature that created its own event frame would bypass the tap and go unlogged.

### Combat Lockdown

Three surfaces refuse outright rather than deferring:

- `ns:OpenOptionsPanel` prints `L["CHAT_OPTIONS_IN_COMBAT"]` and returns. Blizzard's Settings panel is protected in combat, so without the gate the player gets an `ADDON_ACTION_BLOCKED` error naming the add-on. It never queues the open for combat end, and the gate lives at that one entry point rather than in the slash handler or the mini-map `OnClick`, so `/eraser` and Shift + Middle-Click answer identically.
- `RunEraser` and `PerformErase` both check `InCombatLockdown()` at entry and print `L["COMBAT_LOCKOUT"]`, because `DeleteCursorItem` and `PickupContainerItem` are protected. There is no deferred replay; the player clicks again after combat. `PerformErase` re-guards on entry because a safety confirmation dialog can span the moment combat begins.

The two automatic features face combat differently, and the difference is the window they run behind:

- **Auto-Vend defers and resumes.** A merchant frame can be open while in combat, and `UseContainerItem` is protected, so calling it under lockdown throws `ADDON_ACTION_FORBIDDEN`. Auto-Vend guards in two places, `ns:OnMerchantShow` (opened in combat) and each `ProcessSellQueue` tick (combat started mid-queue), and on either it stops, sets `vendPending`, and announces the deferral once via `PrintVendMessage`. `ns:OnCombatEnded` then starts a fresh *pass* if the merchant is still open, rebuilding the queue from live bag state since slots may have shifted. `MERCHANT_CLOSED` clears `vendPending`.
- **Bank Retrieval ends outright.** The bank window does not survive combat, so there is nothing to come back to. `StartPass` and every `ProcessMoveQueue` tick check `InCombatLockdown()` or a closed `BankFrame` and call `FinishPass`: no pending flag, no `PLAYER_REGEN_ENABLED` resume. Reopening the bank starts a fresh pass.

### Scan → Evaluate → Rank → Erase

The pipeline lives in `Eraser.lua`:

1. **Scan.** `FindItemToDelete` walks bags 0 to 4 via `C_Container.GetContainerItemInfo`, skipping items on either ignore list. That gate is what makes the Ignore List beat the Erase List: an ignored item never reaches the predicate at all.
2. **Evaluate.** `GetItemDeleteReason` returns `"manual"`, `"quest"`, `"questIneligible"`, `"consumable"`, `"equipment"`, `"gray"`, or `nil` (see *Eraser Categories*). A reason is then filtered through `ns:IsOverValueCap(totalValue, deleteReason)` (see *Maximum Value to Erase*), which drops the item from the scan entirely: no candidate, no Clutter Report line. `"manual"` is exempt from that filter.
3. **Rank.** `isBetterDeletionCandidate` ranks by total stack value first; ties break by `ns.DeletePriority` (`manual` 0, `quest` and `questIneligible` 1, `gray` 2, `consumable` and `equipment` 3), so the cheapest item wins and, at equal value, a hand-listed item beats a rule-matched one.
4. **Erase.** `RunEraser`, optionally behind a safety confirmation, calls `PerformErase`: `PickupContainerItem`, then `GetCursorInfo` verification, then `DeleteCursorItem`. It plays a sound, prints the outcome line, invalidates the cache, and refreshes the display after 0.2s.

The same single scan populates the tooltip's Clutter Report totals (`cachedReclaimSlots` / `Items` / `Value`) as a side effect, read back through `ns:GetReclaimSummary`. Slots counts one per qualifying bag slot; items counts stacked quantity.

`ns:GetItemDeleteReason` is the shared predicate: Auto-Vend, Bank Retrieval and the item tooltip all call it, so a category change lands everywhere at once and nothing can classify an item differently from the eraser. `ns:IsOverValueCap` deliberately sits *outside* it, applied by the two erase-path callers only, so the cap can hold the eraser back without also switching off the features that move an item rather than destroy it.

### Item Data Caching

`GetItemInfo` returns `nil` on a cold cache. All three scanners, `FindItemToDelete` (Eraser), `ScanAndVend` (Auto-Vend) and `ScanBank` (Bank Retrieval), detect this, call `C_Item.RequestLoadItemDataByID`, and schedule a bounded retry capped at `MAX_SCAN_RETRIES` (5 in each file) so an item whose data never resolves cannot loop forever. Eraser's `ScheduleScanRetry` allows one pending retry (`retryPending`) and uses an `inScanRetry` flag so the attempt counter resets only on a genuinely fresh scan trigger: every fresh trigger flows through `InvalidateCache`, which resets the counter unless a retry is in progress. Auto-Vend resets its counter on `MERCHANT_SHOW`, Bank Retrieval on `BANKFRAME_OPENED`.

Four fields are read off `GetItemInfo` in the erase path: name (as a resolved-yet check), rarity, icon and sell price. The vend and bank scans skip the icon, which only the mini-map button needs. **Item use levels are not among them.** They are carried statically in `Data/Consumables.lua`, so the consumable gate answers correctly even on a cold cache, where `GetItemInfo`'s `requiredLevel` would come back `nil` and silently read as level 1.

The eraser also keeps a short-lived candidate cache (`cachedItem` plus `isCacheValid`) invalidated on bag update, level-up, any list edit, profile switch, deletion, quest turn-in, a value-cap change, the Erase List seed, and a completed retrieval pass.

Options panels that list item ids have a fourth path: `ns.WarmItemCache` in `Options/Options-Utilities.lua`. A panel renders cold rows as `L["LOADING_ITEM"]` and hands the cold ids over; the helper requests each one, then polls (`WARM_RETRY_SECONDS` 0.5, `WARM_MAX_ATTEMPTS` 10) and fires `NotifyChange` only when the cold count actually drops, so every repaint means a row really changed. One chain per registry name at a time, guarded by `warmingPending`, since the repaint re-enters the function with the still-cold ids.

### Per-Character Profiles

`Core.lua` creates the database **without** AceDB's shared-Default flag (`AceDB:New("MagicEraserDB", ns.DATABASE_DEFAULTS)`), so every character lands on its own `"Name - Realm"` profile. That profile holds the character's two item lists as flat `profile.ignoreList` and `profile.eraseList` tables, plus the `profile.eraseListSeeded` marker, which makes all three per-character for free with no keying inside a shared profile.

Everything else lives in `global`: account-wide, identical on every character, and untouched by profile switches. That split is deliberate. Settings should not vary per character, but a character's item lists should, and expressing "per character" as an actual AceDB profile means the stock Profiles panel behaves normally: the picker shows the real character, and Copy From or switching moves one character's lists rather than swapping a whole hidden set at once.

All three profile callbacks, `OnProfileChanged`, `OnProfileReset` and `OnProfileCopied`, are hooked to `ns:OnProfileSwitched`, because under this model they all mean the same thing: the lists the erase candidate is computed from just changed. It re-runs `ns:SeedEraseList` (a switch can land on a never-seeded profile, and a reset clears the marker), then `ns:RefreshDisplay`, then fires `NotifyChange` for both list panels so an open panel repaints against the new lists. Nothing re-applies `global` after a reset, because a reset never touches it and every setting is read live from `ns.db.global`; the one imperative consumer, LibDBIcon, holds the `global.minimap` table itself.

### Colors

The raw hex palette is data (`ns.PALETTE` in `Data/Data.lua`); the derived escape strings (`COLORS`) and the accessor (`ns.GetColor`) are logic (`Features/Utilities.lua`), built by iterating the palette so a new key needs no second edit. `COLORS` is file-local, so consumers never read it directly: each consuming file aliases the accessor once (`local GetColor = ns.GetColor`) and calls `GetColor("KEY")`. Keys are `TITLE`, `INFO`, `BODY`, `HELP`, `TEXT`, `ON`, `OFF`, `SEPARATOR` and `MUTED`. Color constants carry no `|cff` prefix; it is prepended once in Utilities, and `|r` is appended at each call site. `ns.CurrencyColors` (gold, silver, copper) sits beside the palette in `Data.lua` and is consumed only by `ns:FormatCurrency`.

Note that the palette keys `ON` and `OFF` are *colors*, unrelated to the locale keys `ENABLED` and `DISABLED` that carry the tooltip's state words. `GetColor("ON") .. L["ENABLED"]` is correct and not a typo.

## Eraser Categories

`GetItemDeleteReason` is an ordered fall-through, so an item appearing in two databases is classified by the first match:

```lua
if ns:IsOnEraseList(itemId) then return "manual" end               -- the player said so; leaves early

if questStarterDatabase[itemId] or questItemDatabase[itemId] then  -- masks, then completion
elseif consumableDatabase[itemId] then                             -- outgrown, per its use level
elseif equipmentDatabase[itemId] then                              -- curated white, if still white
elseif rarity == 0 and sellPrice > 0 then                          -- generic gray fallback
```

**The Erase List sits outside the chain, not in it.** A listed item has to match whatever its rarity and whatever the databases say, so it returns before the first `if` rather than joining as another branch. A white trade good matches nothing below (not quest, not consumable, not equipment, and the gray fallback needs rarity 0), which is exactly the gap the list exists to close. See *Erase Lists*.

**The two quest tables share one branch.** Most starter items also appear in `Quest-Items.lua`, and only the starter entry carries the race and class masks, so an `elseif` would shadow the gate that makes the wrong-faction case erasable at all. Quest data is `itemId → { questId, ... }`, and an item is erasable if **any** listed quest is flagged complete. Because this branch is checked first, a gray-quality quest item is protected until its quest is done rather than being swept up by the gray fallback.

**A quest-item row is keyed to the quest whose completion makes the item safe, and it fires on the first listed quest that is complete.** The safe key is therefore the *latest* point at which the item could still be needed, and the two failure modes are wildly asymmetric: erasing an item the player still needs is unrecoverable, while erasing it a few minutes late costs nothing. In the plain linear case that is the quest that takes the item at turn-in, never the one that hands it out. Where mutually exclusive sibling quests converge on a final quest, the row is keyed to the converging quest and lists no sibling, so one id covers every branch: Black Dragonflight Molt (10575) is keyed to 4024, not to its sibling 4023, because finishing 4023 is what spawns the dragon the molt drops from. Where the granting quest is itself the last step, the row is keyed to that quest and not the step before it, which would erase the item at the moment it is handed over. The rows are a hand-curated slice of what the file's two queries return, and never a paste of their output; see *Adding a New Trash Item*.

**Quest starters are erasable for two independent reasons**, and the second needs no quest state: the quest is flagged complete, or `RequiredRaces` / `RequiredClasses` exclude this character, which is true the moment the item drops. `ns:GetQuestStarterReason` returns `"questIneligible"` for the second case so the erase line reads `L["ERASED_ITEM_QUEST_UNAVAILABLE"]` instead of claiming the player completed a quest their character can never take. It shares the `safetyQuest` confirmation toggle, so no new option appears in the interface.

**Curated whites are re-checked against live rarity.** `Data/Equipment.lua` is derived from a WotLK world database, but the add-on runs on Era and TBC, and item quality drifted between them: Bronze Mace and most low-level crafted gear are white in Era and green by WotLK. The branch therefore returns `"equipment"` only when the client reports `rarity == 1`, which makes the table expansion-proof in both directions. The client the player is on decides, and a row that is wrong for one flavor simply does nothing there.

**Consumables carry their own use level.** `Data/Consumables.lua` maps `itemId → { useLevel }`, and `GetConsumableEraseLevel` turns that into the player level at which the item becomes trash:

```lua
useLevel < 5   -->  erasable at level 5
otherwise      -->  erasable at useLevel + 10
```

The normal rule is a ten-level gap. The under-5 carve-out exists because the starter food and drink a character is handed in the first few minutes are worthless long before level 11: by 5 they have already been replaced, so they should not squat in the bags waiting for the general rule. The gap is deliberate rather than smoothed, so a `useLevel` 4 item clears at 5 and a `useLevel` 5 item not until 15. The level comes from the data file and never from `GetItemInfo`; see *Item Data Caching* for why that matters.

## Safety Confirmations

Erasing is normally a single click with no prompt, and the safety model is the hand-curated databases. When the player opts in (**Eraser Confirmations**, off by default), `ns:NeedsSafetyConfirm` maps the candidate's delete reason to its per-reason toggle through `SAFETY_REASON_KEYS`: `quest` and `questIneligible` both to `safetyQuest`, `consumable` to `safetyConsumable`, `equipment` to `safetyWhite`, `gray` to `safetyGray`. Five reasons map onto four toggles because the two quest reasons share one.

`"manual"` is deliberately absent from that map, so an Erase List entry never confirms: an unmapped reason falls through to false. Asking the player to approve erasing an item they typed in themselves tells them nothing they did not already know, and a mistyped id is caught earlier and better, because the Erase List panel renders every row as the real item link, icon and tooltip included.

When both the master toggle and the matching per-reason toggle are on, `RunEraser` shows the `MAGICERASER_CONFIRM_ERASE` static popup instead of erasing directly. The candidate is passed as the dialog's `data` so each showing acts on the exact item the player saw, and `PerformErase` re-validates the slot (the cursor's item id must match) before deleting, so a slot that shifted while the dialog was open aborts rather than deleting the wrong item. `preferredIndex = 3` avoids tainting the shared dialog stack.

## Auto-Vend

Auto-Vend lives in `Auto-Vend.lua` and uses a scan-then-process pattern rather than selling inside the scan:

1. `ScanAndVend` walks bags, applies the same ignore-list gate as the eraser, and queues every item with a positive `sellPrice` and a non-nil `GetItemDeleteReason`, Erase List entries included. The queue is sorted by total stack value ascending, so the cheapest items sell first.
2. `ProcessSellQueue` advances one item per 0.1s tick and re-reads the slot before selling, because bag positions shift after a sale.

**Visit state versus pass state.** These are two different lifetimes and conflating them loses sales. `BeginVisit`, called from `ns:OnMerchantShow` whether or not a pass can start immediately, bumps `visitGeneration` and clears what the *visit* owns: `announcedSales`, `pendingSales`, and the summary totals. `StartPass` resets only what a *pass* owns (`isSelling`, `sellIndex`, `scanRetries`, `vendPasses`) and runs `ScanAndVend`. The split matters on the combat resume: `ns:OnCombatEnded` calls `StartPass`, never `BeginVisit`, because the merchant window never closed, so a sale attempted moments before combat interrupted the queue is still in `pendingSales` and still owed an announcement. Restarting the visit there would silently drop those sales from both the per-item lines and the closing summary. `ProcessSellQueue`'s combat branch drops only `sellQueue`, for the same reason.

**Every timer carries its visit generation.** Each timer a pass schedules captures the `visitGeneration` it was created under and drops out once a newer one exists, the same guard `Bank-Retrieval.lua` applies with `passGeneration`. `isSelling` alone would not catch a close-and-reopen mid-pass, because the second visit sets that flag back to true and the stale chain would sail through. `ns:OnMerchantClosed` bumps the generation before scheduling its own deferred flush, so closing and reopening a merchant cannot leave the old chain walking the new visit's queue.

**Sales are announced only once confirmed.** `UseContainerItem` is optimistic: a merchant that cannot complete a transaction, such as a "dead" corpse vendor that still opens a merchant frame, accepts the call silently and sells nothing. Announcing at send time would report phantom sales, so `ProcessSellQueue` records each attempt in `pendingSales` and announces nothing. `ConfirmSales` then counts a sale only when the slot no longer holds the attempted item; anything still sitting in its slot did not sell and stays pending for a later pass. Confirmation runs at the top of each `ScanAndVend` re-scan (0.3s after a pass, long enough for the sell round-trip) and once more `CLOSE_CONFIRM_SECONDS` (0.4s) after `MERCHANT_CLOSED`, deferred so the last sells have time to leave their slots. `announcedSales`, keyed `"bag:slot:itemId"`, keeps a retried slot from being announced twice.

**Multi-pass re-sell.** The server silently drops some `UseContainerItem` sells when many arrive in quick succession, leaving one or two flagged items behind on large batches. After a pass finishes, Auto-Vend re-scans and runs another pass (up to `MAX_VEND_PASSES`, 4), rebuilding the queue from live bag state so only items that did not actually sell get re-queued. The cap prevents a flagged-but-unsellable item from looping forever.

**Message modes.** All Auto-Vend chat routes through the file-local `PrintVendMessage`, a no-op unless `ns.db.global.autoVendMessagesEnabled` is set. With messages on, the **Line Item / Summary Only** dropdown (`autoVendSummaryEnabled`) chooses whether a per-item `L["SOLD_ITEM"]` line prints as each sale is confirmed; the closing `L["SOLD_SUMMARY"]` line prints in both modes on the deferred `MERCHANT_CLOSED` flush. Per-visit totals accrue for every newly confirmed sale regardless of the current mode, so flipping the dropdown mid-visit still produces a correct closing line.

Items with `sellPrice == 0`, which is most quest items, are filtered at scan time. They cannot be vendored, so the eraser handles them instead.

## Maximum Value to Erase

`ns:IsOverValueCap(totalValue, deleteReason)` in `Eraser.lua` is the whole feature. Off unless `valueCapEnabled` is set; on, it answers true for any total worth more than `valueCapGold * ns.COPPER_PER_GOLD`, and an item it answers true for stops being an erase candidate.

**Stack value, not unit price.** The comparison takes `sellPrice * stackCount`, because the stack is what the eraser would actually destroy. Forty grays at two silver each is precisely the pile the cap exists for, and no single one of them ever looks like enough to guard.

**Two callers, both on the erase path.** `FindItemToDelete` gates its candidate on it, which covers the mini-map pick, `RunEraser` and the Clutter Report totals in one place, since all three come off that single scan. `AddEraserWarning` gates the tooltip line on it separately, so a bag tooltip never promises an erase the eraser will not perform. Both pass the delete reason through, which is the only reason the parameter exists.

**`"manual"` is never capped.** The exemption lives inside `ns:IsOverValueCap` rather than at its call sites, so the rule is stated once. Everything else the cap guards is the add-on picking an item out by rule, and a rule can be wrong about what the player values; an Erase List entry is not a guess. Capping one would leave a player watching a list they built do nothing, with no tooltip line and no chat message to explain why.

**Auto-Vend and Bank Retrieval never consult it, by design.** The cap exists to stop the player losing gold; selling an over-cap stack hands them that gold, so the features that move an item rather than destroy it keep working on it. An over-cap stack therefore still sells at a merchant and still walks home from the bank.

The tooltip is the one caller that has to work for its stack count. `GetCarriedBagSlot` returns the anchor's bag **and slot**, and `GetBagStackCount` reads the slot back through `C_Container.GetContainerItemInfo`, re-checking `info.itemID` against the item being described. A slot that fails that check falls back to a count of 1, so an unresolved anchor caps on the unit price: it protects less than it should, never more, which is the safe direction to miss in.

Choices live in `ns.VALUE_CAP_CHOICES` (`Data/Data.lua`) as gold amounts, and the setting stores gold rather than copper because gold is what the player picked. `Options-General.lua` builds the dropdown's `values` and `sorting` from that one array at file scope. `sorting` is not optional: AceConfig otherwise orders a dropdown by its label text and lands "13 Gold" between "1 Gold" and "2 Gold". Both controls pair `ns:InvalidateCache()` with `ns:RefreshDisplay()`, the house pattern for a setting that changes what the eraser picks; without it the mini-map button keeps wearing the icon of an item the eraser will no longer touch.

## Bank Retrieval

`Bank-Retrieval.lua` runs one pass per `BANKFRAME_OPENED`, pulling flagged items out of the bank so the eraser can act on them. `BANK_CONTAINERS` is built once at load from `BANK_CONTAINER` plus the purchasable bank bags (`NUM_BAG_SLOTS + 1` through `+ NUM_BANKBAGSLOTS`), with the same numeric fallbacks Utilities uses so a missing global can never quietly scan nothing. Neither flavor has a reagent bank, so nothing else is scanned.

The pass waits `BANK_SETTLE_SECONDS` (0.5s) before its first scan, because the bank containers read empty for a moment after the frame opens. `ScanBank` then applies exactly the eraser's predicate over those containers, and `ProcessMoveQueue` moves one item per `MOVE_INTERVAL_SECONDS` (0.1s) tick, the same pacing as Auto-Vend and for the same reason.

**The budget is the free-slot count, less the player's own threshold only while Bag-Space Warnings are on.** `GetMoveBudget` returns `ns:CountFreeBagSlots() - bagsFullThreshold` when `bagsFullNudgeEnabled` is set, so retrieval stops short of triggering the bag-space warning it would otherwise cause, and the full free-slot count when it is not: the cushion exists solely to avoid that warning, and the Free-Slot Threshold slider is a sub-option hidden while the warnings toggle is off, so reserving there would let an unreachable setting hold back a visible feature. A `nil` free count (containers not ready) yields no budget and the pass simply does not run.

**Sorted most-valuable-first**, the opposite of Auto-Vend's ascending sell order. Auto-Vend has the whole merchant visit to work through its queue, so it starts with the cheapest clutter; this pass is capped by however many bag slots happen to be free, so when the budget runs out mid-queue what stays in the bank should be the gold that mattered least.

**Confirmed-move accounting.** `UseContainerItem` can be dropped by the server here too, so `pendingMove` holds the last attempted move and `ConfirmPendingMove` counts it only once the bank slot no longer holds that item. The queue-exhausted branch schedules one extra tick so the final move of a pass gets the same chance. A pass cut short by combat or the window closing therefore leaves its last move uncounted rather than claiming one it could not verify.

**`passGeneration` guards the timer chains.** It is bumped on every `BANKFRAME_OPENED`, and every timer this file schedules carries the generation it was created under and drops out if a newer pass has begun. `isRetrieving` alone would not catch a close-and-reopen inside the settle window: the second open sets that flag back to true and the first pass's stale timer would sail straight through.

`FinishPass` is the single exit, however the pass ended. It prints `L["BANK_RETRIEVED"]` only when something was confirmed moved, then resets the totals and drops any unconfirmed move, so the second call (the pass finishing, then `BANKFRAME_CLOSED` arriving) stays silent and nothing leaks into the next pass.

## Ignore Lists

There are two lists and protection is **additive**: `ns:IsIgnored` answers true if either one holds the item, and neither can override the other.

- **Per-character**, `ns.db.profile.ignoreList` (see *Per-Character Profiles*).
- **Account-wide**, `ns.db.global.ignoreList`, its mirror in the global scope, protecting an item on every character.

The mini-map button's right-click (toggle) and middle-click (clear) act on the **current character's list only**, which is exactly what the mini-map tooltip's Ignore List section shows, so both keep meaning what the player just read. The account-wide list is edited from the Ignore List panel.

**Who repaints the panel.** The Ignore List panel is registered as a builder function, so a repaint rebuilds its rows straight off the live lists, but something has to ask for one. An edit made *in* the panel is covered by the shared item-list builder, which fires `NotifyChange` on `ns.OPTIONS_REGISTRY.IgnoreList` after every add, remove and promote it drives. A mini-map click while the panel is already on screen is the edit path outside the builder, which is why `ns:ToggleIgnore` and `ns:ClearIgnoreList` fire `NotifyChange` themselves. `ns:SetIgnoredInScope` deliberately does not, so a panel edit notifies exactly once rather than twice.

`ns:GetIgnoreListForScope(scopeKey, createIfMissing)` is the panel's single accessor. The current profile resolves through `ns.db.profile` rather than the raw saved table, so an edit lands on the very list the eraser reads and applies live. Every *other* profile is read straight out of `ns.db.sv.profiles`, because AceDB only materializes the profile you are on, and it strips default-valued tables at logout: a character who never added an entry has no stored `ignoreList`, and one who never changed a setting has no stored profile at all. A read returns `nil` in those cases; a write passes `createIfMissing` and builds what it needs on the spot.

**Promote, not copy.** The panel's per-character rows carry a Global button that only ever issues the account-wide add; `ns:SetIgnoredInScope` then calls `ClearFromAllProfiles`, dropping the item from every character's list. Protection only widens doing it this way, because the global list already covers everyone it just left, and the item ends up living in exactly one place instead of cluttering panes with rows that can no longer change any outcome. Removing from the account-wide list deliberately does *not* put the item back on anyone: there is no record of who held it.

`ns.LIST_SCOPE_GLOBAL` is the literal `"**global**"`, shared by both list panels. Every other scope key is an AceDB profile name (`"Name - Realm"`, never localized), so the account-wide list needs a key no profile can collide with, and the asterisks are something the profile picker's name box would never produce. One constant serves both panels because a scope key is only ever resolved against one list at a time.

## Erase Lists

The Ignore List in reverse, and deliberately the same shape: two lists, membership **additive**, `ns:IsOnEraseList` answering true if either holds the item.

- **Per-character**, `ns.db.profile.eraseList`.
- **Account-wide**, `ns.db.global.eraseList`.

An item on either list returns `"manual"` from `ns:GetItemDeleteReason` **before** the category chain runs, so it is erased and sold whatever its rarity and whether or not any curated database carries it. That is the point of the feature: the four `Data/` tables are regenerated from SQL queries over a world DB, so an item no query can express has no durable home in them. `Features/Erase-List.lua` mirrors `Ignore-List.lua` accessor for accessor, with `ns:GetEraseListForScope` and `ns:SetOnEraseListInScope` doing the same jobs under the same reasoning, including `ClearFromAllProfiles` on a promote.

**Promoting widens the other way.** On the Ignore List a promote only ever protects more. Here it erases more, on every character including one the item was deliberately never seeded for, a Shaman and their fishing reagents being the live case. The Global button's description says "every character" outright so that is a decision rather than a discovery.

**The Ignore List always wins**, and not by a check inside the erase list. All three scanners gate on `ns:IsIgnored` before they ever call the predicate, and `Item-Tooltips.lua` returns its protected line first, so an ignored item never reaches the erase list at all. Each of those four gates carries a comment saying so; a new caller that skips the gate would silently invert the rule.

**No mini-map binding.** All five click combinations are taken, so the Erase List is edited from its panel only. There is no `ToggleErase` or `ClearEraseList`, and consequently no out-of-panel writer that has to fire its own `NotifyChange`: the shared item-list builder covers every edit path this list has.

### The Class-Reagent Seed

`ns.ClassReagents` in `Data/Data.lua` maps a class token to the items only that class needs. `ns:SeedEraseList` is its **only** actor: on a character's first login it copies every *other* class's reagents onto that character's list. Shiny Fish Scales (17057) and Fish Oil (17058) are the Shaman's, so every non-Shaman starts with both listed and a Shaman starts with neither. Diagnostics reads the table too, for a count, and nothing filters on it at scan time: a Shaman who deliberately lists Fish Oil is obeyed rather than silently overridden, and the panel can never show a row that does nothing.

`profile.eraseListSeeded` records that the seed ran. It has to be stored rather than inferred: an empty list cannot distinguish *the player cleared it* from *never seeded*, so without the marker every login would restore exactly what the player just removed. It is profile-scoped, so Reset Profile clears the marker with the list and the character seeds again. The seed runs from both `ns:OnPlayerLogin` and `ns:OnProfileSwitched`, because a switch can land on a never-seeded profile and a reset clears the marker mid-session. A Copy From carries the source profile's marker and so does not re-seed, which is correct: the player asked for that list verbatim.

Three items are skipped rather than seeded, each because the row could not change an outcome: reagents this character's own class also uses (an id shared by two classes would otherwise be seeded onto a class that needs it), anything already ignored, and anything already listed. The seed only drops the scan cache; both callers repaint immediately afterwards, so a second `RefreshDisplay` inside it would draw the same frame twice.

**Restore Defaults.** `ns:RestoreEraseListDefaults` wipes the current character's list, clears `profile.eraseListSeeded`, and calls `ns:SeedEraseList` again. That is a wipe and re-seed, so the player's own additions go with it, which is what the `confirmText` warns about. Clearing the marker first is load-bearing: the seed returns early while it is set. It is also the reason the button is scoped to the character being played and appears on no other pane: the seed reads that character's own class and writes `ns.db.profile`, so it cannot re-seed another profile, and the Global scope ships no defaults at all.

It is the only caller passing `onRestore` to `ns:BuildItemListOptions`, which is why that callback is optional rather than part of the builder's shape: a list built from nothing has nothing to restore, so the row would only offer to empty it.

## Item Tooltip Warnings

`Features/Item-Tooltips.lua` appends a single branded line to a carried-bag item's tooltip: a white protection notice (`L["TOOLTIP_IGNORED"]`) when an ignore list is shielding it, a red Erase List line (`L["TOOLTIP_ON_ERASE_LIST"]`) when the player listed it themselves, or the red generic warning (`L["TOOLTIP_WILL_ERASE"]`) when a rule matched it. Protection is checked first and wins over any erase verdict. The rest of the verdict comes from the very rules the eraser's scan uses (`ns:GetItemDeleteReason`, `ns:IsOverValueCap`), so the line appears only when the item truly would be erased, level gate, quest-completion check and value cap included. Purely read-only, and gated on `tooltipWarningEnabled`.

The verdict is read *before* the cap here, where the scan reads it after. Same outcome either way, since the cap only ever suppresses; this order just lets the `"manual"` exemption be decided inside `ns:IsOverValueCap` instead of at two call sites.

There are two hook paths because the tooltip API differs across the flavors we target, and only one is ever active, so the line is never doubled:

- **Modern** clients expose `TooltipDataProcessor`; the post-call fires for every item tooltip, so `GetCarriedBagSlot` filters to owners whose `GetBagID()` (or `ContainerFrame` parent id) is in `0..NUM_BAG_SLOTS`, returning that bag and the button's own slot id.
- **Older** clients get a `hooksecurefunc` on `GameTooltip:SetBagItem`, already bag-scoped by its arguments. Bank bags (5 to 11) fall outside the range check, so no owner sniffing is needed.

The choice is made by feature detection, never by flavor, so a client that gains the API needs no code change. Hooks install from `ns:OnPlayerLogin` via `C_Timer.After(0, ns.SetupTooltipHooks)`, not at file load, so ours wraps the **outermost** layer other add-ons installed. A heavy tooltip add-on like TSM that clears and re-fills the tooltip in its own `OnTooltipSetItem` would otherwise wipe our line; landing last, we survive its rebuild. Running outermost also means the tooltip has already been sized, so the `SetBagItem` path re-`Show()`s when it added a line, letting the frame grow to include it.

## Bag-Space Warnings

Lives in `Features/Bag-Warnings.lua`. An opt-in countdown (`bagsFullNudgeEnabled`, off by default) that warns as free slots drop to or below `bagsFullThreshold`. It never deletes and does not care whether anything is erasable: it is purely a free-space alert.

The count comes from `ns:CountFreeBagSlots` in `Features/Utilities.lua`, which is shared with Bank Retrieval's budget and lives there rather than in either consumer. It sums only general-purpose bags, excluding specialty bags (quiver, soul, profession) since ordinary loot cannot go there, and it returns `nil`, never `0`, when no container has answered yet. Summing `(bagFree or 0)` across bags cannot tell "the API has no data yet" apart from "zero free slots", so mid-loading-screen every container reads nil, the total collapses to 0, and the add-on cries "bags full" at a player with a half-empty inventory. Reporting "unknown" lets the caller skip instead. Readiness is judged from the data itself: the backpack always has slots and always answers once the inventory is loaded, so a zero slot total, or no bag answering at all, means nothing is loaded yet.

A `BAG_SETTLE_SECONDS` (2s) hold refreshed on every `PLAYER_ENTERING_WORLD` is the secondary guard, keeping the check idle while the client repopulates containers. **The warning fires on a drop and only on a drop**: `lastSeenFree` holds the previous reading, and a line prints only when the current count is strictly lower than it and at or below the threshold. Freeing a slot inside the warning zone is silent, so no "nearly full" line lands at the moment the player made room, and a repeated `BAG_UPDATE_DELAYED` for one purchase reads the same count twice and says nothing, which is why no separate same-number dedup exists. The baseline is taken before the settle hold and the threshold test, so a tick that prints nothing still tracks the bags and cannot leave a stale reading for a later check to measure a phantom drop against; it is seeded at login by `ns:SeedBagSpaceBaseline` so the login-time `BAG_UPDATE_DELAYED` burst is treated as already known.

Warnings are suppressed while a merchant, mailbox **or bank** window is open (`ns:IsBagWindowOpen`, checked live rather than via a tracked flag so a missed SHOW event cannot strand it), because those visits churn bags hardest. Each of the three close handlers re-checks once: `ns:OnMailClosed`, Auto-Vend's deferred merchant flush, and `ns:OnBankClosed`.

## Quest-Item Alerts

`ns:OnQuestTurnedIn` waits 1.0s, then walks bags and prints `L["QUEST_ITEM_READY"]` once per held item whose newly-completed quest matches one of its tracked ids, and finishes by invalidating the cache and refreshing the display. Purely a UX nudge: the eraser's own evaluation already classifies the same items.

`ns:CheckQuestStarters` covers the other direction, running from `OnBagUpdateDelayed` and from `OnQuestTurnedIn`. It walks bags, gates on a table lookup against `AllowedDeleteQuestStartingItems` so an item that starts no quest never reaches the race, class or quest-state checks, and prints `L["QUEST_ITEM_READY"]` or `L["QUEST_STARTER_UNAVAILABLE"]` depending on which of the two reasons `GetQuestStarterReason` returns. `BAG_UPDATE_DELAYED` fires a burst at login, so `ns:SeedQuestStarterAlerts` runs once from `OnPlayerLogin` and marks everything already erasable in the bags as announced, the same reasoning as `SeedBagSpaceBaseline`. Items that are held but not yet erasable are deliberately left unseeded, so completing their quest later still alerts. The seen set is keyed by item id and lives for the session, so moving a stack between bags cannot make the same item speak twice.

## Mini-map Button and Display

`Minimap-Button.lua` builds an LDB data object (registered with LibDBIcon) whose icon mirrors the current erase candidate, falling back to `ns.DefaultIcon` when bags are clean. Click handlers:

| Click | Action |
|-------|--------|
| Left | `RunEraser`, erasing the lowest-value candidate |
| Right | Toggle the current candidate on this character's ignore list |
| Middle | Clear this character's ignore list |
| Shift + Right | Toggle Auto-Vend, then repaint the General panel and the tooltip |
| Shift + Middle | Open the Options Interface |

Shift + Middle-Click is checked first in `OnClick`, before any feature button, and the combat refusal lives inside `ns:OpenOptionsPanel` rather than being repeated here.

`RefreshTooltip` composes the whole tooltip in a fixed order: the lowest-value item with its click hints, Auto-Vend status, the Clutter Report, then the ignore list, then the options keybind. The list is last of the content sections because it is the only one whose length varies with how much the player has protected, so everything above it holds a fixed position no matter how long the list grows. Item names in it resolve lazily, with `L["LOADING_ITEM"]` shown for cold ones. `ns:RefreshDisplay` invalidates the cache, recomputes the candidate, repoints the icon, and re-renders the tooltip if the button currently owns it.

## Diagnostic Tools

`Features/Diagnostics.lua` plus `Options/Options-Diagnostics.lua` provide a gated panel at **Options > AddOns > Magic Eraser > Diagnostic Tools** for bug reports: environment probing and state capture, not unit tests. State lives in `ns.diagnostics` (`{ enabled, logging, log }`, plus the last-built report string per section), a plain namespace table that is never a SavedVariable, so it defaults off and resets every session. A single runtime toggle gates the panel: when off, only the warning text and the enable toggle render and everything below is hidden rather than grayed. Because every gated section hides on that one condition, the panel defines local `SectionHeader`, `ReportOutput`, `Hidden` and `Refresh` builders that bake it in once instead of repeating it per widget. Every report builds only on a button press, never on load or panel open. Sections:

- **Event Log**, the dispatcher tap: a 500-entry ring buffer capping 8 args at 255 bytes each, pipes escaped *after* the length cut so item links paste as plain text and a cut can never leave a dangling pipe. `ns.DIAGNOSTIC_EVENT_EXCLUDE` is deliberately empty, since the log only ever sees events the add-on registers and none of them is a firehose.
- **Event Registration**, every `ns.EVENT_NAMES` entry tested for `C_EventUtils.IsEventValid` and a register/unregister round-trip on a probe frame with no handler attached.
- **API Endpoints**, `ns.DIAGNOSTIC_API_CHECKS`, kept one-to-one with the APIs the add-on calls or guards; existence and shape checks only. Every modern/legacy pair the add-on guards on is listed as both halves. **A `[FAIL]` on one half of a pair is the report working, not a defect**: the pair is what tells a bug report which branch that client took, so the failing half is the one carrying the answer and is never dropped. The tooltip pair is the worked example, `[FAIL]` on Era and `[PASS]` on TBC Anniversary, which is the measurement behind the two hook paths in *Item Tooltip Warnings*; the options-opener pair answers the same question for `ns:OpenOptionsPanel`.
- **Eraser Context**, player level and class, the Auto-Vend and Bank Retrieval toggles, both ignore-list counts, both erase-list counts with the seed marker, database sizes, class-reagent count, and the live candidate.
- **Validate Data**, one section per data file, driven by `ns.DIAGNOSTIC_DATA_SOURCES`: each manifest entry names the file, the static table on `ns`, its kind, and how to reach the id in a row (every table here is keyed by item id, so the key is the id). A run collects the ids, sorts them, and works in batches of 100 per 0.1s tick so a thousand lookups never stall one frame: an id `C_Item.DoesItemExistByID` rejects is flagged `NOT ON CLIENT` on the spot, a cached id is exported on the spot, and the rest are requested with `RequestLoadItemDataByID` and polled every 0.5s, up to 20 polls, after which a still-cold id is flagged `NOT LOADED` rather than holding the run open. The box shows `Validated N / M` until the finished report replaces it. The report is the client header, a one-line tally, a blank line, then one TSV block: a `STATUS` column, the source table, the id, the full `GetItemInfo` return set and the `GetItemInfoInstant` fields, tabs and newlines stripped from values and pipes escaped so item links paste as text. Flagged rows keep their id and source table so the bad entry is copyable straight out of the sheet. Every timer carries the run's generation, so a second click restarts cleanly and disabling the panel cancels the run and clears its progress text. Adding a data file adds a manifest row, and the panel builds its section from the manifest with no second list.
- **Display Context**, screen size, UI scale, and the mini-map button's saved placement; answers "the button is gone or off-screen".
- **Other Add-ons**, every installed add-on with version and loadable state.
- **Saved Variables**, `MagicEraserDB` dumped to a depth cap of 8, with every `ignoreList` and `eraseList` table, in either scope, replaced by an entry count rather than every item id.
- **Library Versions**, **Taint Log** and **External Tools**. The `taintLog` CVar is the only state the panel ever writes; External Tools is text only, pointing at BugSack, `/console scriptErrors 1` and `/etrace` rather than reimplementing them.

All diagnostics strings live in `ns.DiagnosticsStrings` as plain English and are never localized, being developer-facing with zero player value. The one exception is `ns.AddonTitle`, which is identity rather than a diagnostics string. The panel is registered last so it sits at the bottom of the settings tree.

## Options and Profiles

`ns:RegisterOptionsPanels`, called from `OnPlayerLogin` once `ns.db` exists because the Ignore List, Erase List and Profiles builders all need the database, registers five AceConfig tables from `ns.OPTIONS_REGISTRY` and nests them under Magic Eraser in Blizzard options, in order: **General** (root), **Ignore List**, **Erase List**, **Profiles**, **Diagnostic Tools**. Each child passes `ns.AddonTitle` as its third `AddToBlizOptions` argument. Panel content lives in the per-panel builder files; `Options.lua` is registration only. Widget constructors (`ns.OptionsHeader`, `ns.OptionsDesc`, `ns.OptionsSpacer`, `ns.OptionsRowLabel`) are shared from `Options-Utilities.lua`, and `ns.OptionsHeader` takes an optional third `hidden` argument for gated sections. The **Profiles** panel is the stock `AceDBOptions-3.0` table returned unmodified.

Widths come from the layout grid in `Data/Data.lua`, not from numbers typed at the call site. AceConfig renders a widget's own name above it, so a captioned control is built as two args, an `ns.OptionsRowLabel` cell at `ns.OPTIONS_LABEL_WIDTH` and then the control with `name = ""` at `ns.OPTIONS_CONTROL_WIDTH` ordered immediately after, and the pair flows onto one line because the two widths sum to `ns.OPTIONS_ROW_WIDTH`. A row whose control needs more room passes its own label width and gives the control the remainder, so every row still ends where every other row ends. The rest of the grid sizes the item-list columns (`ns.OPTIONS_REMOVE_ICON_WIDTH`, `ns.OPTIONS_PROMOTE_WIDTH`), the sub-option indent (`ns.OPTIONS_SUB_INDENT_WIDTH`, matched to the checkbox's visible square rather than its 24px texture footprint), and the tree pair (`ns.OPTIONS_TREE_WIDTH` and `ns.OPTIONS_TREE_ROW_WIDTH`, which move together because the sidebar costs the item pane exactly what it gains).

Sub-options are built by the file-local `SubRow` and `SubLabel` in `Options-General.lua`: an unnamed inline group whose first arg is a blank indent cell, then the controls, with `hidden` on the group and never on the members. Per-control widths inside a sub-row are sized to their captions with slack, never to the full row budget, because a row sitting on the wrap boundary tips its control onto its own line and strands the indent above it.

The Ignore List and Erase List panels are registered as their **builder functions**, not built tables: their rows are the lists themselves, so AceConfig re-invokes the builder on every open and every `NotifyChange` and the panel can never render a stale list. Both use `childGroups = "tree"`, keyed by scope rather than by position, because the tree remembers the selected node by its arg key and a key that moved when a profile appeared or dropped out would silently reselect a different character. Character scopes with an empty list are left out of the tree entirely, except the one being played, whose list has to stay reachable to put a first item in it. There is no drop target, deliberately: the game closes the bags when the Options Interface opens, so typing an id or shift-clicking a link into the add box is the only path that can actually work. Each panel's description sits on the **root group**, not in the scope panes, because a tree group renders its own non-group args once, full width, between the panel title and the tree, so the copy reads once above the whole panel instead of repeating in every pane.

Each scope's pane comes from `ns:BuildItemListOptions`, the shared item-list builder in `Options/Options-Utilities.lua`, so both lists add and remove the way every other player-managed list does: an add box that parses an id or a shift-clicked link and clears itself, name-sorted rows drawn by the `ItemLink` AceGUI widget (icon, colored link, the item's own tooltip on hover, registered under `ns.ITEM_LINK_WIDGET_TYPE` so two add-ons in one session never collide), and a one-click unconfirmed remove icon. Restore Defaults is emitted only for a caller passing `onRestore`, which today is the Erase List's own character pane; the ignore lists ship no defaults to restore. The per-character panes pass the promote button as the builder's `actionColumn`; the Global pane passes none and its item cell absorbs that column, so the remove icon holds its position as scopes are picked. Panes spend `ns.OPTIONS_TREE_ROW_WIDTH` rather than the full row width, because the tree sidebar takes its share of the panel first, and that sidebar is widened from AceGUI's 175px default to `ns.OPTIONS_TREE_WIDTH` for both panels in `Options.lua`, since 175px truncates the longer `"Name - Realm"` scope keys. AceGUI fills `treewidth` in only when the key is absent, so seeding the status table wins while a player's own drag still overrides it.

`/eraser` opens the Options Interface. Registration is in `Options.lua` (`SLASH_MAGICERASER1` plus `SlashCmdList.MAGICERASER`), and the handler does nothing but call the opener. Past the combat gate described in *Combat Lockdown*, `AddToBlizOptions` returns `(frame, categoryID)` and **both are captured** at the root panel's registration; `ns:OpenOptionsPanel` routes `Settings.OpenToCategory(<captured categoryID>)` first, falls back to `InterfaceOptionsFrame_OpenToCategory(<captured frame>)` called twice, and reaches `AceConfigDialog:Open` only as a last resort. Never look the category up by display name: AceConfigDialog only aliases the category ID to the panel's name on clients lacking `C_SettingsUtil.OpenSettingsPanel`, so a name lookup returns `nil` on TBC Anniversary and the panel opens as a floating standalone window instead of docking into Blizzard's settings.

## Release Packaging

`.github/workflows/package.yml` runs on any tag push. It re-exports every external in `.pkgmeta` into `Includes/Libraries/`, commits that back to the default branch, force-moves the tag onto that commit so the packager builds a clean release rather than an alpha, and uploads to CurseForge and Wago with `CF_API_KEY` and `WAGO_API_TOKEN`.

**The workflow carries no GitHub token, and none may be added.** Given `GITHUB_OAUTH` or `GITHUB_API_TOKEN`, the packager's `upload_github()` finds the release by tag and overwrites its name with the bare tag and its body with a changelog built from commit messages, silently replacing the hand-written release notes on every build. There is no flag that suppresses only the body; `-d` would also skip CurseForge and Wago. Without a token that function returns at its first guard and never reads, creates or edits a release, so the notes written on GitHub are the only thing that has ever been there. The one trade is that the zip and `release.json` are no longer attached to the GitHub release. The CurseForge and Wago uploads authenticate with their own tokens and are unaffected.

## Saved Variables

Magic Eraser declares one SavedVariables global, `MagicEraserDB`, and hands it to AceDB-3.0 in `ns:OnPlayerLogin`. It holds every setting the player can change plus all four item lists. There is no second table and no `SavedVariablesPerCharacter` line.

**Model: Per-Character.** `AceDB:New` deliberately omits the shared-Default third argument, so each character gets its own `"Name - Realm"` profile. **Reset Profile therefore clears only the active character's two item lists and its seed marker, and every account-wide setting survives it.** That is the fact to check before adding a setting: user settings go in `global`, and only state that genuinely differs per character belongs in `profile`.

- **`global`** (account-wide) holds every user setting, the account-wide `ignoreList` and `eraseList`, and the LibDBIcon placement table.
- **`profile`** (per character) holds `ignoreList` and `eraseList`, that character's flat sets of protected and always-erase item ids, plus the boolean `eraseListSeeded`.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied by AceDB-3.0 when a scope is first accessed, and explicit user values, including `false`, are never overridden. Note that scalar and table defaults are physically copied into the saved table (`copyDefaults` via `rawset`); only `*`/`**` wildcard defaults resolve through metatables. This add-on defines no wildcard defaults.

There is no refill-on-empty logic and nothing needs one. The curated item databases (`AllowedDeleteQuestItems`, `AllowedDeleteQuestStartingItems`, `AllowedDeleteConsumables`, `AllowedDeleteEquipment`) are static Lua tables shipped in `Data/`, not saved variables, so they can never be emptied at runtime. The saved lists that *can* be emptied are the ignore and erase lists, where empty is exactly what the player asked for. The erase lists are seeded once per character rather than refilled, guarded by `profile.eraseListSeeded`; see *The Class-Reagent Seed*.

The add-on carries no migration code. A key that is retired is cleaned up explicitly (`ns.db.global.oldField = nil`) rather than left behind a migration marker.

## Adding a New Trash Item

1. **Consumable.** Append `[itemId] = { useLevel }` to `Data/Consumables.lua` with a name comment, in the right kind block (Food, Water, Both, Alcohol), where `useLevel` is the level the item becomes usable. That level is carried in the data on purpose and is never read from `GetItemInfo`, so the gate works on a cold item cache and cannot shift between client versions. Eligibility is `useLevel + 10`, or level 5 flat when `useLevel` is under 5 (`GetConsumableEraseLevel` in `Eraser.lua`).
2. **Equipment.** Append `[itemId] = true` to `Data/Equipment.lua` with a name comment, in the **WEAPONS** or **ARMOR** block and then the right expansion block inside it. White vendor trash, no level gate, soulbound included. A weapon qualifies on `class = 2` with `dmg_max1 > 0` and a subclass that is not a profession tool (14 and 20); armor on `class = 4`, a worn subclass (1 to 6), and `armor > 0`. The file carries both queries. Remember that the runtime branch also requires the live client to report the item as white, so a row that turned green in a later expansion simply does nothing on the client where it is green.
3. **Quest item.** Append `[itemId] = { questId, ... }` to `Data/Quest-Items.lua`. Key the row to the quest whose completion makes the item safe, which is the *latest* point the item could still be needed: in the linear case the quest that takes it at turn-in (`ReqItemId` in `quest_template`), never the one that hands it out; where mutually exclusive sibling quests converge on a final quest, that final quest alone, with no sibling listed; where the granting quest is the last step, that quest and not the one before it. Treat one quest title repeated across several ids as a signal to check for siblings, and confirm chain order from the quest pages rather than Wowhead's previous/next widget, which misreports siblings as sequential. The header's two queries find candidates and prove which items can still be in a bag after their quest is done; they never produce rows to paste. A past wholesale regeneration keyed 34 rows one step early and 12 of them had to be restored by hand, so audit a proposed change with a normalized parse of the table rather than a raw diff.
4. **Quest-starting item.** Append `[itemId] = { questId, racesMask, classesMask }` to `Data/Quest-Starting-Items.lua`. These hand the player a quest rather than being consumed by one, so they are erasable for two independent reasons: the quest is flagged complete, or `RequiredRaces` / `RequiredClasses` exclude this character, which needs no quest state at all and fires the moment the item drops. Omit both masks when the quest is unrestricted; a nil or `0` mask means "no gate", never "nobody qualifies". Bit values live in `ns.RaceBits` and `ns.ClassBits` in `Data/Data.lua`, keyed by the tokens `UnitRace` and `UnitClass` return (Undead is `Scourge`). Poor and common quality, bound to the looter, non-repeatable quests only, since several quest starters are epics and legendaries and an unbound starter can still be handed to someone who qualifies.
5. **Class reagent.** Add to `ns.ClassReagents[CLASS_TOKEN]` in `Data/Data.lua`. This is seed data, not a filter: `ns:SeedEraseList` puts every *other* class's reagents on a character's Erase List the first time it plays, and nothing reads the table at scan time. A row added here therefore only reaches characters that have not yet been seeded, so an addition after release wants a note in the release notes rather than a silent edit. See *The Class-Reagent Seed*.
6. **Neither of the above.** Anything a player wants gone that no query can express belongs on their own Erase List, not in a `Data/` table. Hand-added rows in a SQL-regenerated file do not survive the next regeneration, which is the failure that produced the Erase List: the two Shaman reagents sat in `Equipment.lua` for three weeks and left with a refresh.

Most of `Quest-Starting-Items.lua` also appears in `Quest-Items.lua`. That overlap is deliberate; see *Eraser Categories* for why the two tables share one branch. The second Quest-Items query refuses to propose a starter for the same reason: its row would be the starter's own quest id with the masks stripped off, which could never fire first.

Section conventions differ by table and that is deliberate: `Consumables.lua` groups by kind, `Quest-Items.lua` and `Quest-Starting-Items.lua` group by expansion, and `Equipment.lua` uses both levels (weapons or armor, then expansion) because it is the largest of the four. In each case the sections mirror whatever the originating query groups by.

Keep entries alphabetized by the trailing name comment so diffs stay readable. Per the style guide these tables are appended to, never reformatted or reproduced wholesale, and each carries its originating SQL query so the table stays regenerable. All four currently carry a real query, so a `-- TODO: Add SQL Query` marker should never reappear in any of them.

A **new data file** also gets an entry in `ns.DIAGNOSTIC_DATA_SOURCES` in `Features/Diagnostics.lua` naming its table and how to reach the id in a row; the Diagnostic Tools panel builds a Validate Data section for it from that entry alone. Run that section on both flavors after any database change, and treat a `NOT ON CLIENT` row as an id to remove or re-check rather than ship.

## Adding a New Event

1. Add the event name to `ns.EVENT_NAMES` in `Features/Core.lua`.
2. Add an `EVENT_NAME = "OnXxx"` entry to `EVENT_HANDLERS` in the same file.
3. Define `ns:OnXxx(...)` in whichever feature file owns it, either Core or a feature file loaded after Core, since the handler is resolved by name at fire time.

That is the whole registration. The dispatcher, the Diagnostic Tools event log and the Event Registration probe all read `ns.EVENT_NAMES`, so they pick the event up automatically with no second list to update. Never create a separate event frame: it would escape the diagnostics tap.

## Adding a New Setting

1. Add the key and its default to `ns.DATABASE_DEFAULTS.global` in `Data/Default-Settings.lua`. Settings are account-wide; only the per-character item lists and the Erase List seed marker belong in `profile`.
2. Add the widget to `ns.BuildGeneralOptions` in `Options/Options-General.lua`, reading and writing `ns.db.global.<key>` directly. AceDB applies the default when the scope is first accessed, so there is nothing to initialize. A control that only means anything while a toggle above it is on goes in a `SubRow` with `hidden` on the row.
3. If the setting changes what the eraser would pick, pair `ns:InvalidateCache()` with `ns:RefreshDisplay()` in its `set`, the way both Maximum Value to Erase controls do. Without it the mini-map button keeps wearing a stale icon until the next bag update.
4. Add the label strings to `Locales/enUS.lua`; the Localization pass carries them into the other ten locales.
5. If the setting gates chat output, route that output through the feature's existing print wrapper rather than calling `ns:PrintMessage` directly.

Magic Eraser writes no macros and sends no cross-player chat, so neither output ceiling in Style Guide → MESSAGES → Message Length constrains any of this: every player-visible string is a local `print` or an options-panel label. The practical ceiling is visual, since a translated label has to fit its widget.

## Localization

WoW ships a fixed locale set, and every supported locale file already exists in `Locales/`, so localization here is **maintenance, not expansion**. There is no "add a new locale" step.

- **`enUS.lua` is the source of truth** and the only file that passes the `true` default-fallback flag to `NewLocale("MagicEraser", ...)`; every string originates there, and AceLocale falls back to it for any key a locale does not define. The other ten files are owned by the Localization pass and are never hand-edited during ordinary work. A renamed key leaves harmless orphans in the translated files until that pass runs, and a retired key name is never reused, because a stale translation of a reused name would silently win over the English fallback.
- **Placeholders.** `%s` and `%d` count, type and order must match `enUS` per key in every locale, or the string crashes at runtime. The multi-placeholder lines are the ones to watch: `SOLD_SUMMARY`, `BANK_RETRIEVED`, `ERASED_ITEM_WITH_VALUE`, `ERASED_ITEM_FROM_QUEST`, `ERASED_ITEM_QUEST_UNAVAILABLE`, `CONFIRM_ERASE` and `SOLD_ITEM`.
- **Not localized:** `ns.DiagnosticsStrings` (developer-facing), the AceConfig registry names in `ns.OPTIONS_REGISTRY`, `ns.LIST_SCOPE_GLOBAL`, `ns.ITEM_LINK_WIDGET_TYPE`, and AceDB profile names, which are `"Name - Realm"` character keys.
- **One verified native-vocabulary case:** `OPTIONS_LIST_GLOBAL` is "Global" in esES, esMX, frFR and ptBR because the word is native there, while the other six locales translate it. Do not "fix" either side.

Everything else, including the Spanish file pairing and the overflow canary, is per Style Guide → LOCALIZATION and MESSAGES → Message Length.

## Common Pitfalls

- **Announcing a sale or a bank move before it is confirmed**: `UseContainerItem` succeeds silently against a merchant that cannot actually buy, and the server can drop the call outright. Record the attempt (`pendingSales` or `pendingMove`) and count it only once the item has left its slot.
- **Restarting an Auto-Vend *visit* when you meant a *pass***: the combat resume must call `StartPass`, not `BeginVisit`. Clearing `pendingSales` and the summary totals mid-visit silently discards sales that were attempted just before combat interrupted the queue.
- **A reopened window restarting a timer chain**: `isSelling` and `isRetrieving` alone cannot stop a stale chain, because reopening sets the flag back to true. Any new timed pass needs a generation counter checked inside every timer, as `visitGeneration` and `passGeneration` do.
- **Keying a quest-item row one step early**: a row fires on the first listed quest that is complete, so a row keyed to the quest that grants the item, or to one sibling of a converging pair, erases the item while the player still needs it. Key to the quest that makes the item safe, per *Adding a New Trash Item*, and never paste the header query's output over the table.
- **Reading an item's use level from `GetItemInfo`**: `requiredLevel` is `nil` on a cold cache and would read as level 1, erasing consumables the player still wants. The level lives in `Data/Consumables.lua`; use it.
- **Trusting the equipment table without the live rarity check**: the rows come from a WotLK database, and several of those items are green on a later client. The branch requires `rarity == 1` so the client in front of the player decides.
- **Cursor latency between pickup and delete**: `PickupContainerItem` is asynchronous. `PerformErase` verifies `GetCursorInfo` holds the expected `itemId` before `DeleteCursorItem`, printing `L["CURSOR_TOO_FAST"]` and clearing the cursor on a mismatch.
- **Treating "no container data" as "no free slots"**: mid-loading-screen every bag reads nil, so `(bagFree or 0)` sums to a false "bags full". `ns:CountFreeBagSlots` returns nil for unknown and callers skip, including Bank Retrieval, where a nil count must mean "no budget", not "no free slots".
- **Stale `GetItemInfo` on first scan**: cold-cache nils are handled by `RequestLoadItemDataByID` plus the bounded retry. Do not add eager fallbacks like hyperlink parsing; let the API resolve.
- **`BAG_UPDATE_DELAYED` fires repeatedly**: coalesce with the 0.1s `updatePending` guard already in `ns:OnBagUpdateDelayed`, and do not refresh straight from the handler.
- **Consumable eligibility is level-dependent**: `GetItemDeleteReason` reads `UnitLevel`, so the candidate must refresh on `PLAYER_LEVEL_UP`. A bag update is not guaranteed after a ding.
- **Opening the options panel by name**: `Settings.GetCategory(<title>)` returns nil on clients that have the Settings API, so the panel opens as a floating window. Route by the captured `categoryID` from `AddToBlizOptions`.
- **Registering a list-driven panel as a built table**: the Ignore List and Erase List panels must be registered as their builder *functions*, or AceConfig renders whatever the list looked like at login forever.
- **Editing an item list from outside its options panel**: an open panel will not notice. The mini-map ignore mutators fire `NotifyChange` themselves, and any new out-of-panel writer must do the same. The Erase List has no such writer today, which is the only reason it needs no equivalent.
- **Mutating the shared AceDBOptions args table**: `AceDBOptions-3.0:GetOptionsTable` hands every database the *same* module-level `args` table, so adding a button or a confirm to it leaks that change into every other Ace3 add-on's Profiles panel, and a closure-bound `func` will act on the wrong add-on's database. Leave the returned table unmodified.
- **Bypassing the dispatcher**: register events only by adding to `ns.EVENT_NAMES` plus an `ns:OnXxx` handler. A feature that creates its own event frame escapes the diagnostics event-log tap.
- **Auto-Vend and `sellPrice == 0`**: filtered at scan time. Quest items are not vendorable, so the eraser keeps them rather than the vendor swallowing them.
- **New Auto-Vend chat must use `PrintVendMessage`**: calling `ns:PrintMessage` directly from the vend path ignores the **Enable Auto-Vend Messages** toggle.
- **Settings are `global`, the per-character item lists are `profile`**: new user settings go in `ns.db.global` via a `ns.DATABASE_DEFAULTS.global` default. Putting a setting in `profile` silently makes it per-character, and Reset Profile would then wipe it while every setting in `global` survived.
- **Checking only one list of a pair**: membership is additive on both features. Use `ns:IsIgnored` and `ns:IsOnEraseList`, never a direct read of one table, or an item handled account-wide gets the wrong answer on a character whose own list is empty.
- **Adding a scanner that skips the `ns:IsIgnored` gate**: that gate is the *only* thing making the Ignore List beat the Erase List. `ns:GetItemDeleteReason` returns `"manual"` for a listed item without consulting the ignore lists at all, so a caller that reaches the predicate directly would erase an item the player explicitly protected.
- **Inferring the Erase List seed from an empty list**: an empty list is what a player who cleared it asked for. Only `profile.eraseListSeeded` can tell that apart from a never-seeded character, and Restore Defaults has to clear that marker before re-seeding or the seed returns early.
- **Server silently drops bulk sells**: do not assume one `ScanAndVend` pass clears the bags. The multi-pass loop (`MAX_VEND_PASSES`) exists because `UseContainerItem` sells are dropped under load, so keep the re-scan-between-passes structure.
- **Adding a GitHub token to `package.yml`**: `GITHUB_OAUTH` or `GITHUB_API_TOKEN` lets the packager rewrite the GitHub release's name and body from commit messages on every build, destroying the hand-written release notes. The workflow deliberately carries neither; see *Release Packaging*.

## Contributing

Issues and PRs go on [GitHub](https://github.com/Gogo1951/Magic-Eraser/issues). Discussion happens on [Discord](https://discord.gg/eh8hKq992Q).

Bug reports should include game version (Classic Era 1.15.x or TBC Anniversary 2.5.x), locale, class and level, reproduction steps, and the relevant chat output. The Diagnostic Tools panel produces a copy-paste-ready report for exactly this.

PR guidelines:

- **One concern per PR.** A locale update, a database expansion and a logic change are three PRs.
- **Match existing style**: 80-character section dividers, the `ns` namespace, `L["UPPER_SNAKE_CASE"]` for all user-facing strings, and the shared `ns.Options*` and `ns.GetColor` helpers. Run StyLua with its default configuration, and a clean `luacheck .`, before committing.
- **New saved-variable fields** seed defaults through `ns.DATABASE_DEFAULTS` and let AceDB apply them. Never hand-merge or overwrite user values, and never write `db.field = db.field or default`, which overwrites an explicit `false`.
- **Database edits** keep the column-header comment and the SQL query, do not reformat existing rows, and key quest-item rows per *Adding a New Trash Item*.
- **No migration code.** The add-on ships none. A retired key is nil'd explicitly and that is the whole story.
- **Release notes are written on GitHub by hand.** Never add a GitHub token to the packaging workflow; see *Release Packaging*.
- **Run `README-Testing.md`** on both flavors before tagging a release, and cite the step number when something fails.
- **Output length**: Magic Eraser writes no macros and sends no cross-player chat, so neither ceiling in Style Guide → MESSAGES → Message Length applies. If a change ever adds a sent message, measure the decorated line in bytes and check the widest-encoding locale (ruRU, not automatically deDE).
- **Update this document** when the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Do not just say "I changed X" or "I fixed Y"; frame the change by who it helps and why.

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a player levelling an alt, I wanted the starter bread and water handed out at level 1 flagged as trash before level 11, so my opening bag slots were not hostage to food I replaced hours ago. This change adds `GetConsumableEraseLevel`, which clears any consumable with a use level under 5 at level 5 instead of the usual ten-level gap.*
