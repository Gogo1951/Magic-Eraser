# Magic Eraser // Technical Reference

> Code map for working on Magic Eraser: where things live, how they connect, and the traps. Where this and the code disagree, the code wins. For players, see [README.md](https://github.com/Gogo1951/Magic-Eraser/blob/main/README.md).

## File Map

```text
Magic-Eraser/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── config.yml                        Per-add-on New issue page links
│   │   ├── defect.yml                        Shared from Common-Core
│   │   └── request.yml                       Shared from Common-Core
│   └── workflows/
│       ├── ci.yml                            Calls Common-Core: shared-file, externals, Lua 5.1 syntax, luacheck and StyLua checks
│       ├── issue-labels.yml                  Calls Common-Core: labels a new Defect by its Issue Type answer
│       └── package.yml                       Calls Common-Core: library vendoring, then the CurseForge and Wago release
├── .gitattributes                            Shared from Common-Core
├── .gitignore                                Shared from Common-Core
├── .luacheckrc                               Lint config; every global the add-on reads or writes
├── .pkgmeta                                  Externals; ignore list strips the repo-only files and the three forward-prep data folders
├── MagicEraser_Vanilla.toc                   Classic Era, Season of Discovery included
├── MagicEraser_TBC.toc                       TBC Anniversary
├── MagicEraser_Camelot.toc                   WoW Forever
├── Bindings.xml                              The three key bindings; found at the root by the client, never in a TOC
├── Data/
│   ├── Flavor.lua                            Flavor identity from the TOC's X-Flavor: ns.FLAVOR, ns.IS_DISCOVERY, ns.DATA_FOLDER
│   ├── Data.lua                              Locale init and shared constants: registry names, layout grid, bag range, race and class bits, kinds, example item
│   ├── Default-Settings.lua                  The AceDB defaults, ns.DATABASE_DEFAULTS: profile, char and global scopes
│   ├── Vanilla/                              Classic Era; each file returns early on Season of Discovery
│   │   ├── Quest-Items-Vanilla.lua           ALLOWED_DELETE_QUEST_ITEMS: item to the quests that make it safe
│   │   ├── Quest-Starting-Items-Vanilla.lua  ALLOWED_DELETE_QUEST_STARTING_ITEMS: quest plus race and class masks
│   │   ├── Consumables-Vanilla.lua           ALLOWED_DELETE_CONSUMABLES: food and drink with use level
│   │   ├── Meat-Fish-Vanilla.lua             ALLOWED_DELETE_MEAT_FISH: cooking meat and fish, use level or item level
│   │   ├── Ammo-Vanilla.lua                  ALLOWED_DELETE_AMMO: use level and next vendor tier
│   │   ├── Equipment-Vanilla.lua             KEEP_EQUIPMENT: whites the white-gear rule must keep
│   │   └── Class-Reagents-Vanilla.lua        CLASS_REAGENTS: hand-kept Erase List seed, never regenerated
│   ├── Discovery/                            Season of Discovery; loaded after Vanilla/ with the inverse guard
│   ├── TBC/                                  TBC Anniversary
│   ├── Camelot/                              WoW Forever
│   ├── Wrath/                                Forward-prep, no TOC, not packaged
│   ├── Mists/                                Forward-prep, no TOC, not packaged; ammo table empty
│   └── Mainline/                             Forward-prep, no TOC, not packaged; ammo and meat-fish tables empty
├── Features/
│   ├── Core.lua                              Version, ns.EVENT_NAMES, dispatcher, AceDB init, other-client prune, mini-map move, login sequence, ns:ApplyProfile, combat-held repaint
│   ├── Migrations.lua                        Tagged MIGRATION; storage-version stamp and the version 2 reshape, two retired-key cleanups
│   ├── Utilities.lua                         Colors, displayed-item, stat and tooltip reads, formatting, free slots, carried and bank containers, list storage, ns.RefreshSettings
│   ├── Announcements.lua                     Branded player-only print: ns.BRAND_PREFIX, ns:PrintMessage; no cross-player chat
│   ├── Ignore-List.lua                       Protect Lists (code name Ignore List): reads, menu and key-binding writers, Clear confirmation, scoped writes
│   ├── Erase-List.lua                        Erase Lists: reads, key-binding add, scoped writes, class-reagent seed, Restore Defaults
│   ├── Junk-Rules.lua                        The verdict: quest state, level gates, white-gear and crafted rules, junk kinds, value cap
│   ├── Eraser.lua                            Scan, rank, erase; scan cache and junk-slot map; Erase Confirmation popup
│   ├── Quest-Item-Alerts.lua                 Chat alerts when a quest item or starter becomes erasable
│   ├── Manual-Delete.lua                     Delete Without Typing: turns the client's type-to-confirm delete prompt into Yes/No
│   ├── Bag-Warnings.lua                      Free-slot countdown and ns:IsBagWindowOpen
│   ├── Bank-Retrieval.lua                    Moves bank junk into the bags within a slot budget; owns ns:IsBankJunk
│   ├── Auto-Vend.lua                         Merchant sell queue with confirmed-sale accounting
│   ├── Tint-Junk.lua                         Junk tint on bag and bank buttons, one adapter per bag window
│   ├── Key-Bindings.lua                      Binding globals and handlers, hovered-item read, ns:OpenKeyBindings, Protect List chat keys
│   ├── Menu-Kit.lua                          Shared menu renderer, copied unchanged: plates, rows, entry kinds, cursor test
│   ├── Minimap-Menu.lua                      What the mini-map menu shows, the CLICKS table, the More Features flyout, open and close
│   └── Minimap-Button.lua                    LDB launcher, icon, ns:RefreshDisplay, LibDBIcon registration and ns:ApplyMinimapButton
├── Diagnostics/                              Diagnostic Tools framework, copied whole; Manifests.lua is this add-on's part
├── Includes/
│   ├── Images/
│   │   ├── Magic-Eraser.tga                  IconTexture
│   │   └── Menu-Plate.tga                    Menu-Kit's plate art
│   └── Libraries/                            Vendored from .pkgmeta; rewritten on every release
├── Locales/
│   ├── enUS.lua                              Source strings
│   └── deDE.lua … zhTW.lua                   Translations
├── Options/
│   ├── Options-Utilities.lua                 Row helpers, toggles, examples and example links, status lines, cache warming, item-list builder, list tree, ItemLink widget
│   ├── Options-Eraser.lua                    Junk kinds, value cap, Erase Confirmation sections
│   ├── Options-Manual-Delete.lua             Delete Without Typing section
│   ├── Options-Auto-Vend.lua                 Auto-Vend section and chat-report dropdown
│   ├── Options-Bank-Retrieval.lua            Bank Retrieval section and cushion status line
│   ├── Options-Tint-Junk.lua                 Junk Item Tint switch and color
│   ├── Options-Quest-Item-Alerts.lua         Quest Item Alerts section; examples use each flavor's lowest quest-item id
│   ├── Options-Bag-Warnings.lua              Bag-Space Warnings section; owns the file-local SubRow
│   ├── Options-General.lua                   Root panel: welcome, mini-map, Features, Key Bindings, /Commands; owns ns.FEATURES
│   ├── Options-Erasing.lua                   Erasing panel from ERASING_SECTIONS
│   ├── Options-Merchant-Bank.lua             Merchant & Bank panel from MERCHANT_BANK_SECTIONS
│   ├── Options-Alerts-Tints.lua              Alerts & Tints panel from ALERTS_SECTIONS
│   ├── Options-Ignore-List.lua               Protect List panel, one tree node per list
│   ├── Options-Erase-List.lua                Erase List panel, one tree node per list
│   ├── Options-Profiles.lua                  Stock AceDBOptions table, unmodified
│   ├── Options-Feedback-Support.lua          Level Up note, links, version
│   └── Options.lua                           Registration, ns:OpenOptionsPanel, /eraser
├── LICENSE                                   MIT
├── README.md                                 Players
├── README-Notes.md                           Exceptions to the Style Guide
├── README-Technical.md                       This document
└── README-Testing.md                         Manual test plan
```

- Repo-only, stripped by `.pkgmeta`: `.github/`, dotfiles, `LICENSE`, the three `README-*.md`, `Data/Wrath`, `Data/Mists`, `Data/Mainline`. No `Tests/`.
- No unsuffixed `MagicEraser.toc`, on purpose (see *Pitfalls & Why*). The three TOCs match line for line except `## Interface`, `## X-Flavor` and their data-folder lines.
- Every data folder holds the same seven files, suffixed with the folder name, each declaring its table whole. Each TOC lists only its own folder, except Vanilla, which lists `Data/Vanilla/` then `Data/Discovery/`; each of those files opens with a guard on `ns.IS_DISCOVERY` so exactly one set of tables is built.
- Load order: `Data/Default-Settings.lua` after the data folders, `Features/` after all of `Data/` (`Junk-Rules.lua` reads `ns.DATABASE_DEFAULTS` at file load). `Menu-Kit.lua` before `Minimap-Menu.lua` before `Minimap-Button.lua`: each takes the previous one's table or functions at file scope.
- Inside `Options/`, fragments load before the panels that call their builders, and `Options-General.lua` after `Options-Eraser.lua` and `Options-Tint-Junk.lua`, because `ns.FEATURES` captures `ns.OnValueCapToggled` and `ns.OnTintJunkChanged` at file load. `Diagnostics/Options-Diagnostics.lua` loads inside the Options block, just before `Options/Options.lua` registers it.
- **Expiring code:** everything tagged `MIGRATION (remove after …)`: `Features/Migrations.lua`, its TOC line and its calls in `Features/Core.lua`, plus `MoveMinimapToProfiles` and its call in `Core.lua`. Dates are on the tags; see *Migration Chain*. Nothing else is deprecated or dead.

## Architecture

### Event Loop

- One frame in `Features/Core.lua`. `ns.EVENT_NAMES` is the full event surface; `EVENT_HANDLERS` maps each to an `ns:OnXxx` name, resolved on `ns` **at fire time**, so feature files loaded after Core define their own handlers.
- No feature file creates an event frame. The dispatcher taps `ns:LogEvent` first, behind `ns.diagnostics.logging`, so the Event Log sees every event.
- Handler owners: Core (`ADDON_LOADED`, `PLAYER_LOGIN`, `BAG_UPDATE_DELAYED`, `PLAYERBANKSLOTS_CHANGED`, `PLAYER_REGEN_ENABLED`), Bag-Warnings (`PLAYER_ENTERING_WORLD`, `MAIL_CLOSED`), Junk-Rules (`PLAYER_LEVEL_UP`), Quest-Item-Alerts (`QUEST_TURNED_IN`), Manual-Delete (`DELETE_ITEM_CONFIRM`), Auto-Vend (merchant pair), Bank-Retrieval (bank pair), Key-Bindings (`UPDATE_BINDINGS`).
- `ns:OnPlayerLogin` order matters: raw-table migrations (`ns:MigrateSavedVariables`, the mini-map move, `ns:MigrateRetiredTooltipSwitch`) → `AceDB:New` → `PruneOtherClientCharacters` → `char.classToken` → `ns:RegisterOptionsPanels` → profile callbacks → `ns:RegisterMinimapButton` → welcome → `ns:SeedEraseList` and the retired-seed cleanup → bag-space and quest-starter baselines → `ns:RefreshDisplay` → `C_Timer.After(0, ns.SetupTintHooks)`.
- `ADDON_LOADED` fires for every add-on, before login too; `ns:OnAddonLoaded` only retries the tint hooks once `ns.db` exists. `UPDATE_BINDINGS` can also land before login, so everything `ns.RefreshSettings` reaches guards on `ns.db`.
- `BAG_UPDATE_DELAYED` is debounced behind `updatePending` into one `ProcessBagUpdate`; `PLAYERBANKSLOTS_CHANGED` joins the same debounce so bank tints repaint.
- `QUEST_TURNED_IN` work waits a moment so the server has flagged the quest before `C_QuestLog.IsQuestFlaggedCompleted` is read.

### Combat Lockdown

- **Refuse and print, no queue:** `ns:OpenOptionsPanel` (Style Guide → Combat Guard), `ns:OpenKeyBindings` (`CHAT_KEY_BINDINGS_IN_COMBAT`), `ns:RunEraser` and `ns:PerformErase` (`COMBAT_LOCKOUT`; pickup and `DeleteCursorItem` are protected). `PerformErase` re-guards because a confirmation dialog can stay open into combat. The menu's Erase and Options rows and their button clicks reach these same functions, so they refuse the same way.
- **Bag walk defers:** in combat `ProcessBagUpdate` drops the cache, sets `refreshAfterCombat` and repaints only the tints (`ns:RefreshTints`). The icon and menu repaint, `ns:CheckQuestStarters` and `ns:RedrawTintWindows` wait for `ns:OnPlayerRegenEnabled`. Level-up, quest turn-in and the eraser's retry ask through `ns:RefreshWhenOutOfCombat`, which holds behind the same flag. The bag-space check still runs.
- **Auto-Vend defers and resumes:** `ns:OnMerchantShow` and each `ProcessSellQueue` tick stop in combat, set `vendPending`, announce once through `PrintVendMessage`. `ns:ResumeDeferredVend` (every combat end) starts a new *pass* if Auto-Vend is on and `MerchantFrame` is shown.
- **Bank Retrieval ends:** `StartPass` and each `ProcessMoveQueue` tick call `FinishPass` in combat or with the bank closed; nothing resumes.
- **Allowed in combat:** the two list key bindings, the menu's Protect, Clear and toggle rows (and their clicks), and quest-turn-in alerts; nothing they call is protected.

### Main Pipeline: Scan → Evaluate → Rank → Erase

- **Scan** (`ForEachCandidate`, `Features/Eraser.lua`): walks `ns.CARRIED_BAGS`, skips `ns:IsIgnored` first. That gate is the only thing making the Protect List beat the Erase List.
- **Evaluate:** `ns:GetItemDeleteReason(itemId, rarity, sellPrice, bag, slot)` (see *Junk Rules*), then `ns:IsOverValueCap(totalValue, reason)`; over-cap is not a candidate.
- **Rank** (`IsBetterDeletionCandidate`): projectiles (`PROJECTILE_CLASS`) after everything else, then lowest stack value, then `ns.DELETE_PRIORITY`, where Erase List entries win ties.
- **Erase:** `ns:RunEraser` → Erase Confirmation popup if `eraseConfirmEnabled`, else `ns:PerformErase`: `IsCandidateCurrent`, clear cursor, pick up, check `GetCursorInfo` id, `DeleteCursorItem`, print `ERASED_ITEM` (link and count only, never value or reason), invalidate, delayed repaint.
- `ForEachCandidate` has one caller, `ns:FindItemToDelete`. The same walk fills the Clutter Report totals (`ns:GetReclaimSummary`) and `cachedJunkSlots` (key `bag * SLOT_KEY_STRIDE + slot` → item id) for the tint (`ns:IsJunkSlot`).
- `ns:GetItemDeleteReason` is shared by the eraser, Auto-Vend, Bank Retrieval (via `ns:IsBankJunk`) and the tint. `ns:IsOverValueCap` sits outside it, applied only on the erase path.
- **Bag ranges:** `ns.LAST_BAG_INDEX` (`Data/Data.lua`) states the general range once. `ns.CARRIED_BAGS` / `ns.IS_CARRIED_BAG` (`Features/Utilities.lua`) add `Enum.BagIndex.ReagentBag` only when `CharacterBankTab_1` exists: Classic Era and TBC define `ReagentBag` too, but their container 5 is the first bank bag. `ns:CountFreeBagSlots` alone stops at `ns.LAST_BAG_INDEX`.

### Refresh Paths

- **Two paths, never swapped:**
  - `ns:RefreshDisplay` (`Features/Minimap-Button.lua`), for bag changes: invalidate, `ns.UpdateMinimapIcon`, `ns.RefreshMenu`, `ns:RefreshTints`. Never notifies an options panel. Returns early with no data object.
  - `ns.RefreshSettings` (`Features/Utilities.lua`), for settings changes: `NotifyChange` on every `ns.OPTIONS_REGISTRY` name, `ns.RefreshMenu`, `ns.UpdateMinimapIcon`. Does not invalidate.
- **Why apart:** a `NotifyChange` redraws an open list page and clears the item ID half-typed into its add box; loot landing mid-typing must not do that.
- Every settings writer ends in `ns.RefreshSettings`: `ns.OptionsFeatureToggle`'s `set`, every other options `set`, the item-list builder after each add, remove, restore or clear, every menu row and button click (`AfterChange`), the out-of-panel list writers, `ns:OnUpdateBindings`, `ns:ApplyProfile`.
- A writer that changes the verdict calls `ns:InvalidateCache()` and `ns:RefreshDisplay()` first (junk kinds, value cap and its toggle's `ns.OnValueCapToggled`, every list write), since `ns.UpdateMinimapIcon` reads the cache as it stands.
- `ns.WarmItemCache` is the one other `NotifyChange` caller: it repaints only its own panel as cold item rows load.

### Caching

- **Item reads are `C_Item.*`** everywhere; WoW Forever has no bare legacy globals. The exception is `ns.GetItemStats`: `C_Item.GetItemStats` or the legacy `GetItemStats`.
- **Cold `C_Item.GetItemInfo`:**
  - The three scanners (`ForEachCandidate`, `ScanAndVend`, `ScanBank` via `ns:IsBankJunk`) request the data and retry behind each file's own `MAX_SCAN_RETRIES`. Auto-Vend and Bank Retrieval act on nothing while a retry is pending, then go ahead with what loaded.
  - The eraser's retry (`ScheduleScanRetry`) allows one pending timer (`retryPending`) and resets its count in `ns:InvalidateCache` unless the invalidation is the retry itself (`inScanRetry`). A retry firing in combat spends a try without scanning.
  - Tint: a cold item stays untinted until the next repaint.
  - Menu: a cold Protect List item draws a `LOADING_ITEM` row plus a request, and the menu redraws after `LOADING_RETRY`, one pending retry at a time (`state.retryPending`).
  - Options: cold rows render `LOADING_ITEM` and go to `ns.WarmItemCache`, one poll chain per registry name over every cold id handed in (`warmingIds`), `NotifyChange` only when an id resolves; bounded by `WARM_MAX_ATTEMPTS`. `ns.ExampleItemLink` uses the same chain for the example lines' items.
- **Use levels never come from `GetItemInfo`** (`requiredLevel` is nil when cold); consumables, meat and fish, and ammo carry them in their data rows.
- **White-gear verdict** (`whiteGearVerdicts`, `Junk-Rules.lua`): per item id for the session; a nil read (still loading) is not stored.
- **Scan cache** (`cachedItem`, `isCacheValid`, Clutter totals, `cachedJunkSlots`): dropped by `ns:InvalidateCache`, which every list edit, junk-kind or value-cap change, profile change, erase, bag update, level-up, turn-in, seed that added rows and retrieval pass that moved something calls. `ns:RefreshDisplay` invalidates before recomputing, so the cache only serves reads between repaints (menu, click, tint, diagnostics).

### Junk Rules

- `GetRuleDeleteReason` (`Features/Junk-Rules.lua`) is an ordered fall-through; first match wins:
  1. `ns:IsOnEraseList` → `"manual"`, before the chain, whatever rarity or tables say. The only way a white trade good other than meat or fish is ever erasable.
  2. Starter **or** quest-item row (one branch) → `ns:GetQuestStarterReason`, else `"quest"` once **any** listed quest is complete; never falls through to the gray or white rules.
  3. Meat-Fish row → `"meatFish"` at `GetMeatFishEraseLevel(level)` (the consumable curve).
  4. Consumable row → `"consumable"` at `GetConsumableEraseLevel(useLevel)`.
  5. Ammo row → `"ammo"` at its `nextTierLevel`; a row without one is never junk on that client.
  6. White, sells, `IsWhiteGearTrash` → `"crafted"` or `"equipment"` by `IsCraftedSlot`; nil (unreadable) when it can't tell.
  7. Gray that sells → `"gray"`.
- `ns:GetItemDeleteReason` wraps it and returns nil for an unchecked kind.
- **Why one quest branch:** most starters are also quest-item rows, and only the starter row carries the masks, so an `elseif` would shadow the race/class gate.
- **Starter reasons:** `"questIneligible"` when `RequiredRaces`/`RequiredClasses` excludes the character (via `bit.band` against `ns.RACE_BITS`/`ns.CLASS_BITS`, tokens from `UnitRace`/`UnitClass`, Undead is `Scourge`; bits cached per session). `"quest"` once its quest is complete, **unless** the item also has a quest-item row, which is keyed to a later quest and decides instead. Nil or `0` mask = no gate.
- Quest-item rows are keyed to the quest whose completion makes the item safe; the rule and its reasoning live in each `Quest-Items-{Flavor}.lua`'s How We Got the Data block.
- **Level:** every level gate compares `ns:GetJunkRulesLevel()`, the higher of `UnitLevel` and the level `PLAYER_LEVEL_UP` reported (`ns:NoteLevelUp`), because `UnitLevel` can lag the event.
- **Consumables:** `CONSUMABLE_OUTGROWN_DELTA` past use level, except anything below `CONSUMABLE_STARTER_LEVEL` goes at that level flat. The step is deliberate, not smoothed. No zone column.
- **Meat & Fish:** edible raw fish carry their use level, cook-only meat its item level; both outgrow on the consumable curve. Their own kind so a fisher or cook keeps what they gather.
- **White gear** (`ReadWhiteGearVerdict`): every check fails toward keeping.
  - Subclass **allowlists** (`WEAPON_SUBCLASSES`, `ARMOR_SUBCLASSES`), never exclusions; `VANITY_SLOTS` kept.
  - Item level below 1 (unreadable), quest binding, or any on-use spell keeps it. Item level 1 is judged normally; the ilvl-1 whites worth keeping are `ns.KEEP_EQUIPMENT` rows.
  - Weapons need DPS, armor needs armor, via `ns.GetItemStats`.
  - `ns.KEEP_EQUIPMENT` is checked first: formal wear, Equip: effects (`GetItemSpell` reports Use: only), quest turn-ins. Missing `C_Item.GetItemSpell` or the stat read keeps every white.
- **Crafted split** (`IsCraftedSlot`): looks for the client's `ITEM_CREATED_BY` line, made into `CREATED_BY_PATTERN` once at load, on the stack's own tooltip via `ns.GetSlotTooltipLines(bag, slot)`.
  - Per copy, never cached: the line belongs to the copy, not the id.
  - Any failure (no pattern, no bag/slot, a throw, empty tooltip) returns nil and the item is kept. Hence every caller passes `bag` and `slot`.
  - Slot read: `C_TooltipInfo.GetBagItem` or the scan tooltip's `SetBagItem`; the Classic/TBC main bank (`ns.LEGACY_BANK_CONTAINER`) reads as an inventory slot through `BankButtonIDToInvSlotID`.
  - Stackable crafts (food, potions) carry no line; they stay with their own kind.

### Junk Kinds and Erase Confirmation

- `ns.ERASE_KINDS` (`Data/Data.lua`) lists each kind `{ reason, labelKey, descKey }` in panel order; `"manual"` has none. Stored in `profile.junkKinds`; `crafted` and `meatFish` default off.
- `ns:IsJunkKind`: `"manual"` always true; a kind with no saved answer falls back to `DEFAULT_JUNK_KINDS` (the defaults table), anything else unreadable counts as junk.
- Enforced once, in `ns:GetItemDeleteReason`, so an unchecked kind is never erased, sold, retrieved or tinted. Quest Item Alerts calls `ns:GetQuestStarterReason` directly, so `ShouldAlert` checks `ns:IsJunkKind` itself.
- **Erase Confirmation** (`MAGICERASER_CONFIRM_ERASE`, `eraseConfirmEnabled`): one switch for every kind, Erase List included. Candidate passed as dialog `data`; `preferredIndex = 3`. `IsCandidateCurrent` re-checks slot id and stack count, protection, cached data, verdict and cap; a stale dialog prints `ERASE_CANDIDATE_CHANGED` and erases nothing. Cursor mismatch prints `CURSOR_TOO_FAST`.

### Delete Without Typing

- `Features/Manual-Delete.lua` (settings keys still `manualDelete*`); the only feature acting on a delete the eraser didn't start. Unrelated to Erase Confirmation.
- **The prompt cannot be removed**: `DeleteCursorItem` needs a hardware event, so the player's Yes is what makes it legal. Never call `StaticPopup_OnClick`, click the accept button, or call `OnAccept` from code: the delete drops while the dialog hides, leaving the item undeletable.
- Only `FILL_DIALOGS` (the good-item pair) have an edit box; the plain pair is left alone.
- `ClearDialog`: sets the box to `DELETE_ITEM_CONFIRM_STRING`, hides it, **enables the accept button itself** (the secure edit box's `OnTextChanged` doesn't fire for code-set text), cuts `TYPE_IT_OUT_LINE` (built from the client's `DELETE_GOOD_ITEM`), calls `dialog:Resize()`. Lasts one showing.
- Deferred one frame (`C_Timer.After(0)`): Blizzard's handler and ours answer the same event in no fixed order; `FillDeletePrompt` re-checks scope then.
- Scope is sale price only (`manualDeleteNoValueOnly`): exactly 0 qualifies; an uncached item prices nil and keeps the prompt. Bound-ness deliberately ignored (armor tokens are tradable).

### Auto-Vend

- `Features/Auto-Vend.lua`: `ScanAndVend` builds `sellQueue` (not ignored, sells, has a verdict, Erase List included), cheapest first; `ProcessSellQueue` sells one per tick, re-checking slot id and protection, not the verdict.
- **Shift skips the visit:** `ns:OnMerchantShow` returns on `IsShiftKeyDown()` before `BeginVisit`. Every summary ends with `AUTO_VEND_SHIFT_HINT`.
- **Visit vs. pass:** `BeginVisit` (each `MERCHANT_SHOW` with Auto-Vend on) bumps `visitGeneration` and clears `announcedSales`, `pendingSales`, summary totals. `StartPass` resets only `isSelling`, `sellIndex`, `scanRetries`, `vendPasses`. The combat resume calls `StartPass` only.
- **Every timer carries `visitGeneration`** and drops out when stale; `ns:OnMerchantClosed` bumps it before scheduling its own flush.
- **Confirmed sales:** `UseContainerItem` is optimistic (a dead vendor accepts silently). Attempts go to `pendingSales` (`"bag:slot:itemId"`); `ConfirmSales` counts one only when the slot no longer holds it. Runs at the top of every `ScanAndVend` and once more `CLOSE_CONFIRM_SECONDS` after close. `announcedSales` stops double counts.
- **Multi-pass:** the server drops bulk sells, so it re-scans from live bags up to `MAX_VEND_PASSES`.
- **Switch off mid-visit** (panel, the menu's Toggle row, or Shift + Right-Click): `ScanAndVend` and `ProcessSellQueue` re-read `autoVendEnabled` each tick and stop; attempted sales still confirm at close.
- **Chat:** all output through file-local `PrintVendMessage` (no-op unless `autoVendMessagesEnabled`). The dropdown maps No Chat / Summary / Every Sale onto `autoVendMessagesEnabled` + `autoVendSummaryEnabled`. Totals accrue whatever the mode.

### Maximum Value to Erase

- `ns:IsOverValueCap` (`Junk-Rules.lua`): off unless `valueCapEnabled`; compares **stack** value against `ns:GetValueCapGold() * ns.COPPER_PER_GOLD`.
- `ns:GetValueCapGold` snaps a saved amount to the nearest `ns.VALUE_CAP_CHOICES` entry at or above it, so the dropdown never shows blank. No zero choice, on purpose.
- `"manual"` is never capped: a list entry is the player's call, not a rule's guess.
- Callers: `ForEachCandidate`, `IsCandidateCurrent`, and the diagnostics tally. **Auto-Vend and Bank Retrieval never consult it**: selling an over-cap stack pays the player. So the bank tint marks over-cap stacks.
- The dropdown needs `sorting` from `ns.VALUE_CAP_CHOICES`, or AceConfig orders by label text.

### Bank Retrieval

- `Features/Bank-Retrieval.lua`, one pass per `BANKFRAME_OPENED` while `bankRetrievalEnabled`. The opener turns bank tints on first, whatever the switch.
- Waits `BANK_SETTLE_SECONDS` (bank reads empty at first), `ScanBank` queues junk **most valuable first** (the budget may run out), `ProcessMoveQueue` moves one per `MOVE_INTERVAL_SECONDS`.
- `ns.BANK_CONTAINERS` / `ns.IS_BANK_BAG` (`Features/Utilities.lua`): `Enum.BagIndex.CharacterBankTab_N` where present, else `BANK_CONTAINER` plus bank bags above the carried range. Warband tabs never included.
- `ns:IsBankJunk(itemId, link, bag, slot)` is the one bank verdict, shared with the tint: protection first, no value cap, items with no price included.
- **Budget** (`GetMoveBudget`): free general slots, less `bagsFullThreshold` **only while Bag-Space Warnings are on** (the threshold is hidden otherwise). Nil free count → no pass.
- **Confirmed moves:** `pendingMove` counts only once the bank slot no longer holds it; the queue-end branch schedules one extra tick for the last move. Budget spent per attempt; a shifted slot is skipped free.
- `passGeneration` orphans an old chain on reopen. `FinishPass` is the single exit: summary only if something moved, then resets, so a second call is silent.
- Switching off mid-pass doesn't stop the current pass (only `isRetrieving` and the generation are checked).

### Tint Junk

- `Features/Tint-Junk.lua`, gated on `tintJunkEnabled`, color `tintColor`. Purely visual.
- Verdict: carried bags → `ns:IsJunkSlot` (the eraser's scan, so Protect List, cap and kinds match the eraser exactly); bank, only while open → `ns:IsBankJunk`.
- `isBankOpen` comes from `ns:SetTintBankOpen` (bank handlers), never `BankFrame`, which Baganator keeps hidden.
- `CreateTint`: a texture in the icon's draw layer, one sublevel up, so it sits under count and border.
- **`TINT_ADAPTERS`** `{ name, folder, install, redraw }`: default bags (Classic `ContainerFrame_Update` + `BankFrameItemButton_Update`; Forever frames' `UpdateItems` + `CamelotBankPanelItemButtonMixin.Refresh`), Baganator (invisible corner widget), Bagnon and Bagnonium (`Item.Update`), AdiBags (`ItemButton` prototype), BetterBags (Events messages), ArkInventory (`API.ItemFrameUpdated`), ElvUI (`B:UpdateSlot`, only while `B.Initialized`). Each passes `PaintButton` the real Blizzard bag/slot and the item it shows; offline, guild or vault views get `ClearButton`.
- `paintedButtons` (weak-keyed) remembers bag, slot, item per button; `ns:RefreshTints` repaints them (plus every bank button), called from `ns:RefreshDisplay` and `ns.OnTintJunkChanged`.
- `ns:RedrawTintWindows`: after bag updates only, tint on, never in combat; asks adapters with a `redraw` (Baganator's `RequestItemButtonsRefresh`, which rebuilds every button).
- Install: once at login + one frame, again on later `ADDON_LOADED`; only adapters whose folder is loaded; one that hooked nothing is retried; never hooked twice. `ns:GetTintAdapterNames` feeds diagnostics.

### Bag-Space Warnings

- `Features/Bag-Warnings.lua`, opt-in (`bagsFullNudgeEnabled`), threshold `bagsFullThreshold`.
- `ns:CountFreeBagSlots` returns nil, not 0, when no container has answered; only bag family 0 counts.
- Warns only on a **drop** below `lastSeenFree` at or under the threshold. Baseline updated before the other guards; seeded at login (`ns:SeedBagSpaceBaseline`). `BAG_SETTLE_SECONDS` hold after each `PLAYER_ENTERING_WORLD`.
- Held while merchant, mail or bank is open (`ns:IsBagWindowOpen`, read live); each close re-checks once.

### Quest Item Alerts

- `Features/Quest-Item-Alerts.lua`. Prints only while `questAlertsEnabled` and the kind is checked; items are still marked while off, so re-enabling doesn't replay. Protected items never announce and stay unmarked.
- `ns:CheckQuestStarters`: table lookup first, then `ns:GetQuestStarterReason`; marks `announcedStarters` (session, by id). `ns:SeedQuestStarterAlerts` at login marks what is already erasable.
- `ns:OnQuestTurnedIn` (delayed): starter check, then `QUEST_ITEM_READY` per held item whose row lists this quest, skipping `announcedStarters`. A starter with a quest-item row is announced here, never by the starter check. `alertedItems` is per callback, so multi-quest rows alert at each turn-in.
- Alerts append the total carried count (`StackSuffix`).

### Mini-map Button and Menu

- **Button** (`Features/Minimap-Button.lua`): `ns.dataBrokerObject` is an LDB `"launcher"` built at file scope. `OnEnter` → `ns.ShowMenu(self, "hover")`; `OnClick` → `ns.RunButtonClick(button)`, and a click with no job (Shift + Left) opens and holds the menu (`"click"`). `OnLeave` is empty: the menu closes itself.
- `ns:RegisterMinimapButton` registers with LibDBIcon against `ns.db.profile.minimap` at login; `ns:ApplyMinimapButton` (`LibDBIcon:Refresh`) re-places and shows or hides it, from the Enable Mini-map Button switch and `ns:ApplyProfile`.
- On Camelot and Mainline it sizes, anchors and masks the icon directly, never via `SetButtonIcon` (its `ResetButtonIcon` calls `icon:UpdateCoord()`, which errors if another add-on replaced the icon).
- `ns.UpdateMinimapIcon` sets only `ns.dataBrokerObject.icon` (the candidate's, else `ns.DEFAULT_ICON`), so LibDBIcon and every LDB display follow.
- **Renderer** (`Features/Menu-Kit.lua`, `ns.MenuKit`): the shared kit (Style Guide → MINIMAP MENU), copied unchanged; its header comment names another add-on because it is the same file everywhere. `Kit.CreatePanel` + `Panel:Render(entries)`; the entry kinds are documented at the top of the file.
- **Contents** (`Features/Minimap-Menu.lua`, `BuildMainEntries`): header and version; Lowest-Value Item with Erase and Protect rows, or `BAGS_CLEAN_CONGRATS`; Auto-Vend block (status, description, Toggle); Clutter Report, or `BAGS_CLEAN_HINT`; this character's Protect List (sorted, `LIST_MAX` rows then `MENU_MORE`, Clear row), omitted while empty; More Features label with on and off counts; Options row. The Protect List sits last of the reports because it is the only one whose length varies.
- **`CLICKS`** is the one table for both ways in: `ns.RunButtonClick` matches button + Shift against it, and `ClickRow` names the same entry's click on the row's right, so a row can never name a click that does something else.
  - Left `ns:RunEraser`; Right protects the candidate via `ns:AddToIgnoreList` (add-only, one chat line from `ns.IGNORE_LIST_MESSAGE_KEYS`); Middle `ns:ConfirmClearIgnoreList`; Shift + Right toggles `autoVendEnabled`; Shift + Middle hides the menu and opens options.
  - Before `ns.db` exists every click but Options does nothing.
- **Protect List rows:** a click removes the item (`ns:RemoveFromIgnoreList`, prints `PROTECT_LIST_REMOVED`). Their remove icon shows only on hover (`rightOnHover`), done after each draw in `ApplyHoverIcons` by hooking the pooled rows, because Menu-Kit stays unchanged. The kit has already measured the icon, so the width never shifts.
- **Clear Protect List** (row or Middle-Click) asks first through `MAGICERASER_CLEAR_PROTECT_LIST` (the panel's `OPTIONS_LIST_CLEAR_CONFIRM` text, `preferredIndex = 3`), and does nothing on an empty list.
- **More Features flyout** (`FLYOUTS.features`): every `ns.FEATURES` entry without `block`, one toggle row each, its page heading as the label, caption and description as the tooltip, its `onSet` after the write. A child of the menu, so it hides with it; entering any other row closes it (`menu.onEnterRow`).
- **Open and close:** `ns.ShowMenu(anchor, how)` positions away from the screen edges (`PositionMenu`, which also picks the flyout side and tooltip anchor); a launcher already showing it keeps its place. An `OnUpdate` closes it `HOVER_CLOSE_DELAY` (or `CLICK_CLOSE_DELAY` after a click) once the cursor is off the button, menu and flyout, or as soon as the anchor hides. Escape closes it through `UISpecialFrames` (frame name `ADDON_NAME .. "Menu"`).
- `Kit.IsCursorOver` reads `GetCursorPosition` rather than `IsMouseOver`, so a controller's virtual cursor keeps the menu open; every row is a plain left click for the same reason.
- `ns.RefreshMenu` redraws in place and is a no-op while hidden; `ns.IsMenuShown`, `ns.IsMenuFrame` and `ns.HideMenu` round out the API.

### Key Bindings

- `Bindings.xml` names `MAGICERASER_ERASE`, `MAGICERASER_ADD_TO_IGNORE_LIST`, `MAGICERASER_ADD_TO_ERASE_LIST`; handlers and `BINDING_NAME_*` globals in `Features/Key-Bindings.lua`, all in `.luacheckrc` `globals`.
- `MagicEraser_Erase` only calls `ns:RunEraser`; keep it synchronous so the key press stays the hardware event.
- List bindings read the hovered item via `ns.GetDisplayedItem` (`TooltipUtil.GetDisplayedItem` or `GameTooltip:GetItem`), only while `GameTooltip:IsShown()`. Add-only, this character's list; `ns:AddToIgnoreList` returns `"already"`/`"moved"`/`"added"`, `ns:AddToEraseList` `"protected"`/`"already"`/`"added"`, each turned into one chat line. The Protect List keys (`ns.IGNORE_LIST_MESSAGE_KEYS`) are shared with the menu's Protect row and Right-Click.
- General panel's Key Bindings rows show `GetBindingKey` or **Not Bound** plus Set Key → `ns:OpenKeyBindings`, which tries at click time: `Settings.KEYBINDINGS_CATEGORY_ID`, a protected search of `SettingsPanel`'s categories, then `KeyBindingFrame`, else prints `KEY_BINDINGS_LOCATION`. `UPDATE_BINDINGS` → `ns.RefreshSettings`.

### Protect and Erase Lists

- Players see **Protect List**; code says Ignore List (`ignoreList`, `ns:IsIgnored`, `IgnoreList` registry key, the binding name). Locale keys say `PROTECT_*` where the copy is new. Never rename the saved keys or the binding: saved lists and bound keys would be lost.
- Each list kind is a pair, `ns.db.char.<list>` and `ns.db.global.<list>`; membership is additive (`ns:IsIgnored`, `ns:IsOnEraseList`).
- Storage goes through `ns:GetCharacterListForScope(listKey, scopeKey, createIfMissing)` and friends in `Features/Utilities.lua`. The played character resolves via `ns.db.char` (live table); others via `ns.db.sv.char`, since AceDB only materializes the current character and strips empty tables at logout. Scope keys: `ns.LIST_SCOPE_GLOBAL` or an AceDB character key (`"Name - Realm"`, or `"First Last"` on WoW Forever).
- **Promote, not copy:** adding to the global list calls `ns:ClearFromEveryCharacter`. Removing from global restores no one.
- **Protect always wins, enforced by callers:** `ForEachCandidate`, `IsCandidateCurrent`, `ScanAndVend` (and each sale), `ns:IsBankJunk` gate on `ns:IsIgnored` before the verdict. `ns:AddToEraseList` refuses a protected item only so the binding can say why. Only `ns:AddToIgnoreList` also drops this character's Erase List row; panel adds leave it, shown as a **Protected** tag (`IsProtectedInScope`).
- **Writers:** the panel's scoped writers (`ns:SetIgnoredInScope`, `ns:SetOnEraseListInScope`, `ns:Clear…ListInScope`, `ns:RestoreEraseListDefaults`) invalidate and repaint, and leave `ns.RefreshSettings` to the item-list builder that calls them. Out-of-panel writers (`ns:RemoveFromIgnoreList`, `ns:ClearIgnoreList`, `ns:AddToIgnoreList`, `ns:AddToEraseList`) call it themselves.
- **Class-reagent seed** (`ns:SeedEraseList`, `SeedList`): once per character, tracked by `char.eraseListSeeded`, copies every *other* class's `ns.CLASS_REAGENTS` onto this character's Erase List, skipping ids its own class uses or that either list already decides. Nothing filters on the table at scan time.
- **Restore Defaults** (`ns:RestoreEraseListDefaults`): wipe and re-seed. Played character: clear the marker **first**, then seed. Other character: seed with its saved `classToken`, or leave empty with marker cleared. Global: empty.
- **Clear List** (`ns:ClearIgnoreListInScope`, `ns:ClearEraseListInScope`): the Erase List version sets `eraseListSeeded` true so the character doesn't refill next login.

### Options Panels

- `ns:RegisterOptionsPanels` (`Options/Options.lua`) runs at login, after `ns.db`. Tree: General (root) → Erasing (→ Erase List, Protect List) → Merchant & Bank → Alerts & Tints → Profiles → Feedback & Support → Diagnostic Tools. Registration order is tree order.
- The two nested panels pass Erasing's **category ID** as parent: AceConfigDialog maps only a root's display name to an ID.
- `ns:OpenOptionsPanel` opens `Settings.OpenToCategory(ns.generalCategoryID)` (captured from `AddToBlizOptions`), `AceConfigDialog:Open` as last resort. Never by display name.
- Built tables: General, Erasing, Merchant & Bank, Alerts & Tints, Profiles, Feedback & Support. **Builder functions** (re-run on every open and `NotifyChange`): both list panels and Diagnostic Tools.
- **Fragments:** each `Options-{Feature}.lua` exposes `ns.Build…Options(args)` adding widgets in its own block of ten orders; panel files call them from `ERASING_SECTIONS`, `MERCHANT_BANK_SECTIONS`, `ALERTS_SECTIONS`. `Options-Eraser.lua` holds two builders, placed around Delete Without Typing.
- **Features Mirror:** `ns.FEATURES` (`Options-General.lua`) is the one list the root panel's Features section and the menu's More Features flyout both draw: `{ setting, name, caption, desc, onSet, block }`. `name` is the page heading the menu row shows, `caption`/`desc` the switch's; `block` (Auto-Vend) keeps an entry out of the flyout because the menu gives it its own block. Each switch is built by `ns.OptionsFeatureToggle`, which also builds the copy on the feature's own page, paired two to a line by `ns.OptionsTogglePairs`. Shared onSets: `ns.OnValueCapToggled` (invalidate + repaint), `ns.OnTintJunkChanged` (`ns:RefreshTints`).
- `ns.OptionsExample` builds an example from the very locale string printed; `ns.ExampleItemLink(itemId, registryName)` gives it a real quality-colored link (`ns.EXAMPLE_JUNK_ITEM_ID` for Auto-Vend, the flavor's lowest quest-item and quest-starter ids for Quest Item Alerts). `ns.OptionsStatusLine` states a cross-feature coupling and hides on nil.
- Layout grid constants live in `Data/Data.lua`; a captioned control is `ns.OptionsRowLabel` + control with `name = ""`. `SubRow` (file-local, `Options-Bag-Warnings.lua`) indents a gated control with `ns.OPTIONS_SUB_INDENT_WIDTH`; move it to `Options-Utilities.lua` when a second panel needs it. Gated settings are hidden, never greyed. Tint's switch-plus-picker line is a `README-Notes.md` exception.
- **List panels:** `ns.BuildCharacterListTree` (tree keyed by scope, not position; All Characters, blank row, characters with a list plus the played one, class-colored via `ns:GetCharacterDisplayName`). `PrepareListTree` seeds `treewidth` and re-selects the played character on every hide. `ns.LeaveClearedScope` re-points selection after clearing another character. Panes from `ns:BuildItemListOptions(spec)`; its comment documents the spec. **Add from Bags** picker replaces drag-and-drop (the game closes bags when options open).
- `ItemLink` AceGUI widget registered as `ns.ITEM_LINK_WIDGET_TYPE` (named off the add-on to avoid collisions).

### Diagnostic Tools (`Diagnostics/Manifests.lua`)

- The framework is shared and copied whole; only `Manifests.lua` is this add-on's. The framework's Display Context report (`Diagnostics/Settings-Reports.lua`) reads this add-on's mini-map wiring by name: `ns.db.profile.minimap`, `ns.ShowMenu`, `ns.RunButtonClick`, `ns.IsMenuShown`, `ns.FEATURES`, the menu frame name in `UISpecialFrames`, and a leftover `global.minimap`.
- `ns.DIAGNOSTIC_API_CHECKS`: a row per API called or guarded, the menu's reads included. Modern/legacy pairs list **both halves**; a `[FAIL]` on one half shows which branch the client took.
- `ns:BuildEraserContextReport` and `ns:BuildMerchantBankContextReport`: read-only probes; bag counts come from file-local `TallyContainers`, which applies `ns:IsIgnored` then `ns:GetItemDeleteReason` and requests nothing. `TINT_BAG_ADDONS` mirrors `TINT_ADAPTERS` by folder to flag loaded-but-unhooked bag add-ons; `BINDING_NAMES` mirrors `Bindings.xml`.
- `ns.DIAGNOSTIC_NAME_LOOKUPS`: every GlobalStrings label shown or matched (`UiLabel` rows), the built crafted and Delete Without Typing patterns, and `ns.EXAMPLE_JUNK_ITEM_ID`.
- `ns.DIAGNOSTIC_DATA_SOURCES`: one Validate Data report per data file; `label` is the file's table-name part.
- Probes read state through accessors the features expose for this (`ns:GetScanRetryState`, `ns:GetAutoVendState`, `ns:GetBankMoveBudget`, `ns:GetBagWarningState`, `ns:GetPlayerQuestBits`, `ns:GetCraftedLinePattern`, `ns:GetManualDeleteInstructionPattern`, `ns:CountAnnouncedQuestStarters`).

### Localization

- `enUS.lua` alone passes the default flag to `NewLocale`. Never reuse a retired key name.
- `%s%s` in `CONFIRM_ERASE`, `ERASED_ITEM`, `SOLD_ITEM`, `QUEST_ITEM_READY`, `QUEST_STARTER_UNAVAILABLE` is one unit: link, then `" xN"` or empty.
- Counts and money arrive pre-formatted (`ns:FormatCommaNumber`, `ns:FormatCurrency`) as `%s`; the raw `%d`s never get commas.
- Count of one has its own key (`*_ONE`, `*_ONE_ITEM`, `*_ONE_SLOT`, `BAGS_FULL` for zero).
- Links shown without brackets: `ns:StripLinkBrackets`, applied by the menu, the popup and `ns:GetItemDisplayName`. Chat lines from `ns:PrintMessage` and the options' example lines keep them.
- Menu-Kit's toggle words come from the add-on (`Kit.SetToggleText(L["MENU_ON"], L["MENU_OFF"])`); the kit's own defaults are English fallbacks.
- Game names never go in `Locales/`: items by id, classes and races by token, Blizzard labels from GlobalStrings.

## Files That Change Together

- **New event:** `ns.EVENT_NAMES` + `EVENT_HANDLERS` (`Features/Core.lua`) + its `ns:OnXxx` in a file loaded after Core.
- **New setting:** `ns.DATABASE_DEFAULTS.profile` key + its fragment row + `Locales/enUS.lua` keys + `ns.RefreshSettings()` at the end of its `set` (preceded by `ns:InvalidateCache()`/`ns:RefreshDisplay()` if it changes the verdict, or `ns:RefreshTints()` if it changes only the tint's look).
- **New feature switch:** its page's `ns.OptionsFeatureToggle` + an `ns.FEATURES` entry with the same setting, keys and `onSet` (root panel and menu flyout both follow) + its page heading key as `name`.
- **New feature panel section:** new `Options-{Feature}.lua` fragment + its TOC line before the panel + the panel's section list.
- **New junk kind:** a reason from `GetRuleDeleteReason` + `ns.DELETE_PRIORITY` + `ns.ERASE_KINDS` + `junkKinds` default + two locale keys.
- **New data table:** a file in all seven `Data/{Game}/` folders (empty where it has no rows) + each TOC's folder lines + `ns.DIAGNOSTIC_DATA_SOURCES` + the Eraser Context `Databases:` line.
- **Changed data row:** the same id in every folder where it's true; Validate Data on each client.
- **New menu click or click-named row:** a `CLICKS` entry + its `MENU_CLICK_*` key + the row through `ClickRow`.
- **Renaming a mini-map menu symbol** (`ns.ShowMenu`, `ns.RunButtonClick`, `ns.IsMenuShown`, `ns.FEATURES`, the menu's frame name): `Diagnostics/Settings-Reports.lua`'s Display Context reads each.
- **New bag add-on for the tint:** `TINT_ADAPTERS` + `TINT_BAG_ADDONS` + `.luacheckrc` `read_globals` + `OPTIONS_ENABLE_TINT_DESCRIPTION`.
- **New GlobalStrings label:** its read + a `UiLabel` row in `ns.DIAGNOSTIC_NAME_LOOKUPS` + `.luacheckrc` `read_globals`.
- **New API call or guard:** an `ns.DIAGNOSTIC_API_CHECKS` row (both halves for a modern/legacy pair) + `.luacheckrc` `read_globals`.
- **New key binding:** `Bindings.xml` + handler and `BINDING_NAME_*` in `Features/Key-Bindings.lua` + `.luacheckrc` `globals` + `KEY_BINDINGS` rows in `Options-General.lua` + `BINDING_NAMES` in `Manifests.lua`.

## Saved Variables

- `MagicEraserDB` (`ns.SAVED_VARIABLES_NAME`): every setting and all four item lists, via AceDB-3.0 in `ns:OnPlayerLogin`.
- **Model: Simple, by a `README-Notes.md` exception.** The rule would say Per-Character (each character keeps its own lists); instead `AceDB:New(..., true)` puts everyone on Default and the lists live in `char`.
  - `profile`: every setting, `minimap` (button position and its Enable switch) included.
  - `char`: that character's `ignoreList`, `eraseList`, `eraseListSeeded`, `classToken`.
  - `global`: the All Characters lists and `storageVersion`.
  - **Reset Profile clears every setting, tint color and mini-map position included; never the lists, seed marker or saved class.** A new setting goes in `profile`; per-character state in `char`; reset-proof state in `global`.
- All three profile callbacks → `ns:ApplyProfile` (invalidate, `ns:ApplyMinimapButton`, repaint, `ns.RefreshSettings`).
- **Other-client characters:** `PruneOtherClientCharacters` (`Core.lua`) runs right after `AceDB:New`, per Style Guide → SAVED VARIABLES → Other-Client Characters. Not a migration.
- List panels find characters through `ns:GetCharacterKeys()` (`ns.db.sv.char` plus the played one); profile names say nothing.
- **Seeding:** only the per-character Erase List (class reagents), once per character by `char.eraseListSeeded`, again only on Restore Defaults; never because the list is empty. Protect Lists and the global Erase List ship empty.

### Migration Chain

1. `ns:MigrateSavedVariables` (`Migrations.lua`, raw table, before `AceDB:New`): `MigrateToVersion2` if `global.storageVersion` is below 2: per-character profiles collapse onto Default, lists move to `char`, settings move from `global` into Default, old `safetyEnabled` becomes `eraseConfirmEnabled`. Stamps `STORAGE_VERSION`; a fresh install is stamped without migrating. `storageVersion` is stored, not inferred, because an all-defaults one-off profile is stored empty.
2. `MoveMinimapToProfiles` (`Core.lua`, raw table, before `AceDB:New`): while `global.minimap` exists, copies it into Default and every profile `profiles` or `profileKeys` names (a profile with its own is left alone), then clears it from `global`. Keys on `global.minimap`, not `storageVersion`, and sits in `Core.lua` so it outlives `Migrations.lua`'s earlier dates.
3. `ns:MigrateRetiredTooltipSwitch` (`Migrations.lua`, raw table, before `AceDB:New`): clears `tooltipWarningEnabled` from every profile and `global`. No marker.
4. `ns:MigrateRetiredSeedReagents` (`Migrations.lua`, after `ns:SeedEraseList`): takes `RETIRED_SEED_REAGENTS` off each seeded character's Erase List unless that character is the owning class or the loaded folder still seeds it from another class. No marker; runs every login of its window.

Each step's `MIGRATION (remove after …)` date is on its code, its call and (for `Migrations.lua`) the TOC line.

## Pitfalls & Why

- **A scanner skipping `ns:IsIgnored`**: the verdict returns `"manual"` for a listed item without checking protection, so the Protect List silently loses.
- **Calling `ns:GetItemDeleteReason` without `bag` and `slot`**: every white weapon and armor piece answers nil and is kept.
- **Reading one list of a pair**: membership is additive. Use `ns:IsIgnored` / `ns:IsOnEraseList`.
- **"Fixing" ammo to rank by value**: projectiles go last on purpose. Outgrown ammo is nearly worthless, so a cheapest-first pick would erase the quiver before the gray cloth.
- **Announcing a sale or move before confirming it**: `UseContainerItem` succeeds silently when nothing happens. Record, then confirm the slot emptied.
- **Calling `BeginVisit` on combat resume**: sales attempted before combat vanish from the lines and summary. Resume with `StartPass`.
- **A timed pass without a generation counter**: `isSelling`/`isRetrieving` flip back to true on reopen, so a stale chain runs on. Check the generation in every timer.
- **Assuming one sell pass clears the bags**: the server drops bulk sells; keep the re-scan loop.
- **Erasing without re-validating**: a dialog outlives its slot; a click lands before the client catches up. Keep `IsCandidateCurrent` and the cursor check.
- **Moving the erase binding off its synchronous path**: a timer loses the hardware event.
- **Answering the client's delete dialog from code**: the delete drops and the prompt hides, so the item can't be deleted.
- **Filling the delete prompt's box and expecting the button to enable**: it won't; `ClearDialog` must `Enable()` it.
- **Loosening white-gear allowlists into exclusions**: a subclass a later client adds or repurposes (armor 5 is Cosmetic on modern clients) would be erased. New checks must fail toward keeping.
- **Caching the crafted check by item id**: the `<Made by>` line belongs to one copy.
- **Reading a use level from `GetItemInfo`**: nil when cold. It's in the data row.
- **Keying a quest-item row to the granting quest**: rows fire on the first completed listed quest, so the item is erased while still needed. Follow the data file's How We Got the Data rule.
- **Editing one flavor folder**: each folder is a complete copy; check the id in every folder.
- **Hand-writing a bag range**: looping `0, 4` misses WoW Forever's reagent bag. Walk `ns.CARRIED_BAGS`, test `ns.IS_CARRIED_BAG` / `ns.IS_BANK_BAG`. Only `ns:CountFreeBagSlots` stops at `ns.LAST_BAG_INDEX`.
- **Treating no container data as zero free**: mid-loading-screen every bag reads nil. `ns:CountFreeBagSlots` returns nil; callers skip.
- **Refreshing straight from `BAG_UPDATE_DELAYED`**: it bursts. Use the `updatePending` debounce.
- **Doing protected bag work in combat**: defer it the way `ProcessBagUpdate` does, behind `refreshAfterCombat`.
- **Forgetting the level-up rescan or `ns:NoteLevelUp`**: level gates change with no bag update, and `UnitLevel` can lag the event.
- **Calling `ns.RefreshSettings` from a bag-change path**: every panel redraws and an item ID half-typed into a list's add box is lost. Bag changes go through `ns:RefreshDisplay`.
- **A settings writer that skips `ns.RefreshSettings`**: the switch's other copy, the menu row and the icon keep the old value until something else redraws them.
- **Expecting `ns.RefreshSettings` to rescan**: it reads the scan cache as it stands. A verdict change invalidates and calls `ns:RefreshDisplay` first.
- **Asking `ns:IsJunkSlot` about a bank slot**: the eraser scans carried bags only; always false. Use `ns:IsBankJunk`.
- **Reading bank-open state off `BankFrame` for the tint**: Baganator hides it. Use `isBankOpen`.
- **Requesting a Baganator redraw on every repaint**: it rebuilds every button. Only after bag updates, tint on, out of combat.
- **Writing fields onto bag-window buttons**: taints them. Use a weak-keyed table (`paintedButtons`, `baganatorButtons`).
- **Editing `Features/Menu-Kit.lua` for a Magic Eraser need**: it is the shared kit, copied unchanged into every add-on with a menu. Work around it in `Minimap-Menu.lua`, as `ApplyHoverIcons` does.
- **Writing a menu row's click label by hand, or a click handler outside `CLICKS`**: the row and the button drift apart. One `CLICKS` entry drives both.
- **Testing menu hover with `IsMouseOver`**: a controller's virtual cursor doesn't report there, so the menu closes under it. Use `Kit.IsCursorOver`.
- **Calling `ns:ClearIgnoreList` from a click**: skips the confirmation that guards a stray click under the item rows. Clicks go through `ns:ConfirmClearIgnoreList`.
- **Reading or registering the button against `ns.db.global.minimap`**: the position lives in `ns.db.profile.minimap`, and a profile change must reach `ns:ApplyMinimapButton` or the button stays where the old profile had it.
- **Moving `MoveMinimapToProfiles` into `Migrations.lua` or keying it on `storageVersion`**: it would be deleted with that file's earlier-dated steps, or skip tables already stamped current.
- **Opening the options panel by name**: nil on TBC Anniversary. Use `ns.generalCategoryID`.
- **Registering a list panel as a built table**: it shows login-time lists forever.
- **A list edit outside its panel without `ns.RefreshSettings`**: an open panel and the menu won't redraw. Only the login seed and cleanup skip it.
- **Mutating the AceDBOptions table**: its `args` are shared with every Ace3 add-on's Profiles panel.
- **A feature with its own event frame**: escapes the Event Log.
- **Calling `ns:PrintMessage` from the vend path**: ignores the chat-report setting. Use `PrintVendMessage`.
- **A setting in `global`, or a list in `profile`**: the setting escapes Reset Profile and one-off profiles; the list would be shared by everyone on Default.
- **Inferring the seed from an empty list**: only `eraseListSeeded` tells cleared from never seeded. Restore clears it first; Clear List sets it.
- **Branching a count of one through a plural string**: give the singular its own complete key.
- **Listing `Bindings.xml` in a TOC**: the bindings never appear.
- **Renaming a binding or the `ignoreList` keys**: keys come back unbound; saved lists are lost.
- **Reading the hovered item through `GameTooltip:GetItem` alone**: a deprecated wrapper on WoW Forever. Use `ns.GetDisplayedItem`.
- **Adding an unsuffixed `MagicEraser.toc`**: unsupported clients fall back to it and load the add-on.
