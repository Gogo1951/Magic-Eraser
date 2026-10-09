# Magic Eraser // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Magic Eraser. For end-user documentation, see [README.md](https://github.com/Gogo1951/Magic-Eraser/blob/main/README.md).

## File Map

```text
Magic-Eraser/
├── .github/
│   └── workflows/
│       ├── ci.yml                            Calls Common-Core: Lua 5.1 syntax, luacheck, StyLua and tests on every PR
│       └── package.yml                       Calls Common-Core: CurseForge and Wago release plus library vendoring
├── .gitattributes                            Line-ending normalization
├── .gitignore                                Dev-clutter ignore list
├── .luacheckrc                               Lint config
├── .pkgmeta                                  Externals and the packager ignore list
├── MagicEraser_Vanilla.toc                   Classic Era, Season of Discovery included
├── MagicEraser_TBC.toc                       TBC Anniversary
├── MagicEraser_Camelot.toc                   WoW Forever
├── Bindings.xml                              The three key bindings, found at the root by the client and never listed in a TOC
├── Data/
│   ├── Flavor.lua                            Canonical flavor identity, read from the chosen TOC's X-Flavor
│   ├── Data.lua                              Locale init and shared constants: registry names, layout grid, bag range, race and class bits, erase kinds
│   ├── Default-Settings.lua                  The AceDB defaults: profile (settings), char (own lists), global (All Characters lists, mini-map)
│   ├── Vanilla/                              Classic Era tables; each file returns early on Season of Discovery
│   │   ├── Quest-Items-Vanilla.lua           Items a finished quest leaves behind, keyed to the quest that makes them safe
│   │   ├── Quest-Starting-Items-Vanilla.lua  Items that hand out a quest, with race and class masks
│   │   ├── Consumables-Vanilla.lua           Food and drink, each carrying its use level
│   │   ├── Ammo-Vanilla.lua                  Arrows and bullets, each carrying its use level and next vendor tier
│   │   ├── Equipment-Vanilla.lua             The whites the white-gear rule must keep
│   │   └── Class-Reagents-Vanilla.lua        Hand-kept seed for the Erase List, never a query table
│   ├── Discovery/                            Season of Discovery; listed after Vanilla/ in the Vanilla TOC, inverse guard
│   ├── TBC/                                  TBC Anniversary
│   ├── Camelot/                              WoW Forever
│   ├── Wrath/                                Forward-prep with no TOC; kept out of the zip by .pkgmeta
│   ├── Mists/                                Forward-prep with no TOC; kept out of the zip by .pkgmeta
│   └── Mainline/                             Forward-prep with no TOC; kept out of the zip by .pkgmeta
├── Features/
│   ├── Core.lua                              Version, ns.EVENT_NAMES, the dispatcher, AceDB init, the login sequence, ns:ApplyProfile
│   ├── Migrations.lua                        Storage versions 2 and 3, run on the raw table before AceDB opens; tagged for removal
│   ├── Utilities.lua                         Colors, displayed-item and tooltip-text reads, formatting, free slots, carried and bank containers, character keys
│   ├── Announcements.lua                     Branded player-only print; the add-on sends no cross-player chat
│   ├── Ignore-List.lua                       Both Protect Lists, the mini-map and key-binding mutators, per-scope reads and writes
│   ├── Erase-List.lua                        Both Erase Lists, the key-binding add, per-scope writes, the class-reagent seed and Restore Defaults
│   ├── Junk-Rules.lua                        What counts as junk: quest state, outgrown levels, the white-gear rule, junk kinds, the value cap
│   ├── Eraser.lua                            Scan, rank, erase, the scan cache and the Erase Confirmation dialog
│   ├── Quest-Item-Alerts.lua                 Chat alerts when a quest item or starter becomes safe to erase
│   ├── Manual-Delete.lua                     Turns the client's own type-to-confirm delete prompt into Yes/No
│   ├── Bag-Warnings.lua                      Free-slot countdown and the shared bag-window gate
│   ├── Bank-Retrieval.lua                    Pulls junk out of the bank within a free-slot budget
│   ├── Auto-Vend.lua                         Merchant sell pipeline with confirmed-sale accounting
│   ├── Item-Tooltips.lua                     Adds the will-erase, Erase List or protected line to bag-item tooltips
│   ├── Key-Bindings.lua                      Binding globals and handlers, the hovered-item read, ns:OpenKeyBindings
│   └── Minimap-Button.lua                    LDB object, tooltip, click handlers, ns:RefreshDisplay
├── Diagnostics/                              The Diagnostic Tools template: copied whole into another add-on, Manifests.lua re-authored
│   ├── Diagnostics-Core.lua                  Runtime state, strings, the enable gate, report header, protected tooltip reads
│   ├── Manifests.lua                         The per-add-on parts: API rows, both context probes, the name lookups, the data-source manifest
│   ├── Event-Log.lua                         The event log and the Taint Log toggle
│   ├── Code-Reports.lua                      Event Registration, API Endpoints, Library Versions
│   ├── Settings-Reports.lua                  Display Context, Other Add-ons, Saved Variables
│   ├── Validate-Data.lua                     The batched Validate Data engine
│   ├── Localization-Reports.lua              Locale Context, Game Names
│   ├── Report-Runner.lua                     Report and tab registry, one-run-at-a-time runner
│   └── Options-Diagnostics.lua               Diagnostic Tools panel, loaded in the TOC's Options block and registered last
├── Includes/
│   ├── Images/
│   │   └── Magic-Eraser.tga                  The TOCs' IconTexture
│   └── Libraries/                            Vendored Ace3 stack plus LibDataBroker and LibDBIcon, never edited by hand
├── Locales/
│   ├── enUS.lua                              Source strings
│   └── deDE.lua … zhTW.lua                   Ten translations
├── Options/
│   ├── Options-Utilities.lua                 Row helpers, feature switch, example and status lines, item-cache warming, item-list builder and widget
│   ├── Options-Eraser.lua                    What Counts as Junk, Maximum Value to Erase and Erase Confirmation, merged into Erasing
│   ├── Options-Manual-Delete.lua             Manual Delete Assistance, merged into Erasing
│   ├── Options-Auto-Vend.lua                 Auto-Vend and its chat-report dropdown, merged into Merchant & Bank
│   ├── Options-Bank-Retrieval.lua            Bank Retrieval, merged into Merchant & Bank
│   ├── Options-Item-Tooltips.lua             Tooltip Warnings, merged into Alerts & Tooltips
│   ├── Options-Quest-Item-Alerts.lua         Quest Item Alerts, merged into Alerts & Tooltips
│   ├── Options-Bag-Warnings.lua              Bag-Space Warnings, merged into Alerts & Tooltips
│   ├── Options-General.lua                   Root panel: welcome and mini-map, Features, Key Bindings, /Commands, Feedback & Support
│   ├── Options-Your-Current-Bags.lua         The live erase queue with Erase and Protect, then every carried item
│   ├── Options-Erasing.lua                   Erasing panel, composed from three builders in two fragment files
│   ├── Options-Merchant-Bank.lua             Merchant & Bank panel, composed from two fragments
│   ├── Options-Alerts-Tooltips.lua           Alerts & Tooltips panel, composed from three fragments
│   ├── Options-Ignore-List.lua               Protect List panel: one tree node per list on the account
│   ├── Options-Erase-List.lua                Erase List panel: one tree node per list on the account
│   ├── Options-Profiles.lua                  Stock AceDBOptions-3.0 table, returned unmodified
│   └── Options.lua                           Registration, ns:OpenOptionsPanel, the /eraser command
├── LICENSE                                   MIT
├── README.md                                 Player-facing documentation
├── README-Notes.md                           The maintainer's settled exceptions and decisions
├── README-Technical.md                       This document
└── README-Testing.md                         Manual test plan
```

`.github/`, `.gitattributes`, `.gitignore`, `.luacheckrc`, `.pkgmeta` and `LICENSE` are repo-only; the packager strips them, so an installed copy does not carry them. There is one TOC per flavor and deliberately no unsuffixed `MagicEraser.toc` (see *Common Pitfalls*). The three TOCs match line for line except `## Interface`, `## X-Flavor` and their data-folder lines.

Every data folder holds the same six files, each suffixed with its folder's name (`Ammo-TBC.lua`, `Ammo-Camelot.lua`), and each file declares its table whole, so feature code reads every table without asking which flavor built it. Each TOC lists only its own folder; the one pairing is Season of Discovery, which runs on the Classic Era client, so the Vanilla TOC lists `Data/Vanilla/` then `Data/Discovery/` and each file opens with a guard on `ns.IS_DISCOVERY` so exactly one folder's tables are built. Wrath, Mists and Mainline have no TOC yet; they are forward-prep and sit in the `.pkgmeta` ignore list until a TOC ships for them. The Mists and Mainline ammo tables are empty on purpose, since Cataclysm removed ammunition.

`Features/`, `Diagnostics/` and `Options/` are listed in TOC load order rather than alphabetically, because load order is what makes a fragment's builder exist by the time a panel calls it. The one file out of place is `Diagnostics/Options-Diagnostics.lua`, which the TOCs load inside the Options block, after `Options/Options-Profiles.lua` and just before `Options/Options.lua` registers it. `Features/Migrations.lua` is the one file with an expiry: its storage-version-3 step is tagged `MIGRATION (remove after 2026-11-03)` and goes first, and the file itself, its TOC line and its call in `Features/Core.lua` are tagged `MIGRATION (remove after 2026-11-30)` and go once that date passes. Nothing else is deprecated or dead. `Includes/Libraries/` is rewritten by the release workflow from `.pkgmeta` on every tag, so a hand edit there is overwritten by the next release.

## Architecture

### Event Loop

Every event routes through a single frame in `Features/Core.lua`. `ns.EVENT_NAMES` is the one source of truth: the dispatcher registers each name in it, and `EVENT_HANDLERS` maps each name to an `ns:OnXxx` method named for the event and resolved *by name at fire time*, so feature files that load after Core supply their own handlers. No feature file creates an event frame. The one other frame that registers events is the Event Registration probe in `Diagnostics/Code-Reports.lua`, which registers and unregisters each name to test it and has no `OnEvent` handler.

| Event | Handler (file) | Purpose |
|-------|----------------|---------|
| `PLAYER_LOGIN` | `ns:OnPlayerLogin` (Core) | Migration, AceDB init, the character's `classToken`, options registration, profile callbacks, LibDBIcon and its icon fit, welcome print, Erase List seed, the two alert baselines, first repaint, tooltip hooks |
| `PLAYER_ENTERING_WORLD` | `ns:OnPlayerEnteringWorld` (Bag-Warnings) | Holds bag-space warnings while containers repopulate after a loading screen |
| `PLAYER_LEVEL_UP` | `ns:OnPlayerLevelUp` (Core) | Consumable and ammo eligibility is level-gated, so a ding records the event's level for the junk rules (`ns:NoteLevelUp`) and re-scans |
| `BAG_UPDATE_DELAYED` | `ns:OnBagUpdateDelayed` (Core) | Debounced re-scan, repaint, quest-starter check, bag-space check |
| `QUEST_TURNED_IN` | `ns:OnQuestTurnedIn` (Quest-Item-Alerts) | After 1.0s: the quest-starter check, the quest-item-ready alerts, then a re-scan |
| `DELETE_ITEM_CONFIRM` | `ns:OnDeleteItemConfirm` (Manual-Delete) | Simplifies the client's own delete prompt |
| `MERCHANT_SHOW` / `MERCHANT_CLOSED` | `ns:OnMerchantShow` / `ns:OnMerchantClosed` (Auto-Vend) | Open a vend visit; final confirmation, summary, bag-space re-check |
| `MAIL_CLOSED` | `ns:OnMailClosed` (Bag-Warnings) | Re-check bag space as soon as the mailbox closes |
| `BANKFRAME_OPENED` / `BANKFRAME_CLOSED` | `ns:OnBankframeOpened` / `ns:OnBankframeClosed` (Bank-Retrieval) | Start a retrieval pass; end it, print its summary, re-check bag space |
| `PLAYER_REGEN_ENABLED` | `ns:OnPlayerRegenEnabled` (Core) | Replay the bag work combat held back, then `ns:ResumeDeferredVend` |
| `UPDATE_BINDINGS` | `ns:OnUpdateBindings` (Core) | Repaint the General panel, whose Key Bindings rows show each key |

`BAG_UPDATE_DELAYED` is debounced with a 0.1s `C_Timer.After` behind the `updatePending` flag, so a burst from looting or a vendor turn-in coalesces into one `ProcessBagUpdate`. `QUEST_TURNED_IN` work waits 1.0s so the server has flagged the quest complete before `C_QuestLog.IsQuestFlaggedCompleted` is read.

The dispatcher taps the diagnostics event log *before* calling the handler, behind one boolean check (`ns.diagnostics.logging`), so it costs nothing while logging is off. Because every event passes through this one point, the event log is complete; a feature with its own event frame would escape it.

### Combat Lockdown

Four entry points refuse outright and print why, with no queue and no replay:

- `ns:OpenOptionsPanel` prints `L["CHAT_OPTIONS_IN_COMBAT"]`. Blizzard's Settings panel is protected in combat, so without the gate the player gets an `ADDON_ACTION_BLOCKED` error naming the add-on. The gate is the function's first statement rather than living in the slash handler or the mini-map `OnClick`, so `/eraser` and Shift + Middle-Click answer identically.
- `ns:OpenKeyBindings` (the General panel's **Set Key** buttons) prints `L["CHAT_KEY_BINDINGS_IN_COMBAT"]`, for the same reason.
- `ns:RunEraser` and `ns:PerformErase` print `L["COMBAT_LOCKOUT"]`, because `C_Container.PickupContainerItem` and `DeleteCursorItem` are protected. The mini-map Left-Click, the erase key binding and the Your Current Bags **Erase** button all enter through `RunEraser`. `PerformErase` re-guards because an Erase Confirmation dialog can stay open across the moment combat begins.

Everything else that touches bags defers or ends:

- **The bag-update repaint defers.** Nothing can be erased in combat, so `ProcessBagUpdate` only drops the scan cache there and sets `refreshAfterCombat`; the mini-map repaint and the quest-starter walk wait for `ns:OnPlayerRegenEnabled`. Hovering the button still rescans on demand, since the cache is invalid. The bag-space check still runs, because it calls nothing protected (and, as always, only while no merchant, mailbox or bank window is open).
- **Auto-Vend defers and resumes.** A merchant frame can be open in combat, and `C_Container.UseContainerItem` throws `ADDON_ACTION_FORBIDDEN` there. `ns:OnMerchantShow` (opened in combat) and each `ProcessSellQueue` tick (combat began mid-queue) stop, set `vendPending`, and announce `L["AUTO_VEND_COMBAT_DEFERRED"]` once through `PrintVendMessage`, so the line obeys the chat-report setting like every other vend line. `ns:ResumeDeferredVend`, called from `ns:OnPlayerRegenEnabled` on every combat end, starts a fresh *pass* if Auto-Vend is still on and the merchant is still open. `MERCHANT_CLOSED` clears `vendPending`.
- **Bank Retrieval ends outright.** The bank window does not survive combat, so there is nothing to come back to: `StartPass` and every `ProcessMoveQueue` tick call `FinishPass` on `InCombatLockdown()` or a closed `BankFrame`. Reopening the bank starts a fresh pass.
- **The two list key bindings work in combat.** A list edit calls nothing protected.

### Scan → Evaluate → Rank → Erase

The pipeline lives in `Features/Eraser.lua`, with the verdict in `Features/Junk-Rules.lua`:

1. **Scan.** `ForEachCandidate` walks every bag in `ns.CARRIED_BAGS` with `C_Container.GetContainerItemInfo`, skipping anything `ns:IsIgnored` protects. That gate is what makes the Protect List beat the Erase List: a protected item never reaches the verdict.
2. **Evaluate.** `ns:GetItemDeleteReason(itemId, rarity, sellPrice)` returns `"manual"`, `"quest"`, `"questIneligible"`, `"consumable"`, `"ammo"`, `"equipment"`, `"gray"`, or `nil` (see *Junk Rules*). A reason then passes through `ns:IsOverValueCap(totalValue, deleteReason)` (see *Maximum Value to Erase*); an item over the cap is not a candidate at all.
3. **Rank.** `IsBetterDeletionCandidate` ranks by total stack value, then by `ns.DELETE_PRIORITY` (`manual` 0, `quest` and `questIneligible` 1, `gray` 2, `consumable`, `ammo` and `equipment` 3), so the cheapest stack goes first and, at equal value, a hand-listed item beats a rule-matched one.
4. **Erase.** `ns:RunEraser` shows the Erase Confirmation dialog when the switch is on (see *Junk Kinds and Erase Confirmation*), and otherwise calls `ns:PerformErase`, which re-validates the slot, clears anything already on the cursor, picks the item up, checks the cursor, and calls `DeleteCursorItem`. It plays a sound, prints `L["ERASED_ITEM"]`, invalidates the cache, and repaints after 0.2s. The line carries the link and stack size only, never the value or the reason: a quest leftover already had its ready alert, and the price of something gone for good only stings. With nothing to erase, `ns:RunEraser` prints the clean-bags line instead.

`ForEachCandidate` has two callers, so they can never disagree about what counts. `ns:FindItemToDelete` keeps the single best candidate in a cache and fills the Clutter Report totals (`cachedReclaimSlots`, `Items`, `Value`, read back through `ns:GetReclaimSummary`) as a side effect of the same walk: slots count one per qualifying stack, items count stacked quantity. `ns:GetEraseQueue` returns every candidate sorted the same way, with bag and slot as the final tie-break so the order holds still between repaints; its first entry is always the mini-map button's item.

`ns:GetItemDeleteReason` is the shared verdict: Auto-Vend, Bank Retrieval and the item tooltip all call it, so a rule change lands everywhere at once. `ns:IsOverValueCap` deliberately sits *outside* it, applied only on the erase path and by the bag tooltip that previews it, so the cap can hold the eraser back without switching off the features that move an item rather than destroy it.

`ns.LAST_BAG_INDEX` in `Data/Data.lua` states the general-bag range once, as `NUM_BAG_SLOTS` with a numeric fallback. `ns.CARRIED_BAGS` (`Features/Utilities.lua`) is built from it at load, plus `Enum.BagIndex.ReagentBag` on clients with character bank tabs (WoW Forever's container 5), and `ns.IS_CARRIED_BAG` is its lookup set. Every carried-bag walk and range test reads those. `ns.LAST_BAG_INDEX` alone bounds `ns:CountFreeBagSlots`, since ordinary loot can't go in a reagent bag. Classic Era and TBC Anniversary define `Enum.BagIndex.ReagentBag` as 5 as well, but their own `BankFrame.lua` numbers bank bag N as container `N + NUM_BAG_SLOTS`, and with the bank open container 5 reads as the first bank bag (16 slots in the maintainer's test), so the reagent bag is gated on `CharacterBankTab_1` rather than on the enum entry alone.

### Item Data Caching

Every item read calls `C_Item` directly (`GetItemInfo`, `GetItemInfoInstant`, `GetItemQualityColor`, `GetItemSpell`). All three clients ship them, and WoW Forever's Retail engine has no bare legacy globals, so a bare `GetItemInfo` errors there. The one exception is the stat read: only WoW Forever ships `C_Item.GetItemStats`, so `ns.GetItemStats` (`Features/Utilities.lua`) falls back to the legacy global `GetItemStats` on Classic Era and TBC Anniversary, which returns the same table.

`C_Item.GetItemInfo` returns `nil` on a cold cache, and each reader handles that its own way:

- **The three scanners** (`ForEachCandidate`, `ScanAndVend`, `ScanBank`) call `C_Item.RequestLoadItemDataByID`, and a bounded re-scan follows, `MAX_SCAN_RETRIES` 5 in each file, so an item whose data never resolves cannot loop forever. Auto-Vend and Bank Retrieval act on nothing while a retry is pending; once the retries run out, they go ahead with the items whose data did load. `ForEachCandidate` only reports the miss: `ns:FindItemToDelete` schedules the eraser's retry, and `ns:GetEraseQueue` never retries, because the retry's repaint redraws Your Current Bags anyway. The eraser waits 1.0s and allows one pending retry (`retryPending`); its counter resets in `ns:InvalidateCache` unless the invalidation is the retry itself (`inScanRetry`), so only a genuinely fresh trigger starts the count over. Auto-Vend waits 0.5s and resets at every `StartPass`; Bank Retrieval waits 0.5s and resets on `BANKFRAME_OPENED`.
- **The bag tooltip** adds nothing for a cold item. The client re-sets a hovered tooltip every 0.2s, so the line arrives once the data does.
- **The mini-map tooltip's Protect List section** shows `L["LOADING_ITEM"]` for a cold id and requests it.
- **Options panels** render cold rows as `L["LOADING_ITEM"]` and hand the ids to `ns.WarmItemCache` (`Options/Options-Utilities.lua`), which requests each one and polls (`WARM_RETRY_SECONDS` 0.5, `WARM_MAX_ATTEMPTS` 10), firing `NotifyChange` only when the cold count actually drops. One chain per registry name at a time, guarded by `warmingPending`, because the repaint re-enters the function with the still-cold ids.

**Use levels are never read from `GetItemInfo`.** Consumables and ammo carry them in their flavor's data file, so the level gates answer correctly on a cold cache, where `requiredLevel` would read as nil.

**The white-gear verdict is remembered per item id for the session** (`whiteGearVerdicts` in `Junk-Rules.lua`), since the tooltip asks every 0.2s while hovered and `GetItemStats` builds a new table each call. A read the cache cannot answer yet returns nil, which is not stored, so a cold item is asked again rather than settled as kept.

**The eraser's candidate cache** (`cachedItem`, `isCacheValid`) is dropped by `ns:InvalidateCache`, which the bag update, level-up, every list edit, every junk-kind or value-cap change, a profile change, an erase or an aborted one, a quest turn-in, an Erase List seed that added something and a retrieval pass that moved something all call. `ns:RefreshDisplay` invalidates too before recomputing, so every repaint is a fresh scan and the cache serves only the reads between two repaints: an open tooltip, a click, the Clutter Report, a diagnostics report.

## Junk Rules

`GetRuleDeleteReason` in `Features/Junk-Rules.lua` is an ordered fall-through, so an item in two tables is classified by the first match:

```lua
if ns:IsOnEraseList(itemId) then return "manual" end        -- the player said so
if questStarterDatabase[itemId] or questItemDatabase[itemId] then
elseif consumableDatabase[itemId] then                      -- outgrown, per its use level
elseif ammoDatabase[itemId] then                            -- a vendor tier replaces it
elseif rarity == 1 and (sellPrice or 0) > 0 and IsWhiteGearTrash(itemId) then
elseif rarity == 0 and (sellPrice or 0) > 0 then            -- generic gray
```

`ns:GetItemDeleteReason` wraps it and answers `nil` for a kind the player unchecked (see *Junk Kinds and Erase Confirmation*).

**The Erase List sits outside the chain.** A listed item matches whatever its rarity and whatever the tables say, so it returns before the first branch. A white trade good matches nothing below, which is exactly the gap the list exists to close.

**The two quest tables share one branch.** Most starters also appear in `Quest-Items`, and only the starter row carries the race and class masks, so an `elseif` would shadow the gate that makes the wrong-faction case erasable. Either table matching also stops the item falling through to the white-gear and gray rules, which is what keeps a quest item of either quality safe until its quest is done. Quest-item rows are `itemId → { questId, ... }`, erasable once **any** listed quest is flagged complete.

**A quest-item row is keyed to the quest whose completion makes the item safe**, which is the *latest* point the item could still be needed, because the two ways to be wrong are not symmetric: erasing an item the player still needs is unrecoverable, while erasing it a few minutes late costs nothing. The full rule, the sibling-quest case and the two candidate queries live in each `Quest-Items-{Flavor}.lua`'s How We Got the Data block; see *Adding a New Trash Item*.

**Quest starters are erasable for two independent reasons.** `ns:GetQuestStarterReason` returns `"questIneligible"` when the row's `RequiredRaces` or `RequiredClasses` mask excludes this character (true the moment the item drops, with no quest state), and `"quest"` once the quest is flagged complete. A nil or `0` mask means "no gate", never "nobody qualifies". Masks are tested against `ns.RACE_BITS` and `ns.CLASS_BITS`, keyed by the tokens `UnitRace` and `UnitClass` return (Undead is `Scourge`).

**Consumables carry their own use level**, `itemId → { useLevel }`, and a row without one counts as 1. `GetConsumableEraseLevel` makes one outgrown at `useLevel + 10`, except that anything usable below level 5 goes at 5 flat: the starter food and drink a new character is handed are replaced long before level 11. The gap is deliberate rather than smoothed, so a `useLevel` 4 item clears at 5 and a `useLevel` 5 item not until 15.

**The level both rules compare against is `ns:GetJunkRulesLevel()`**, the higher of `UnitLevel("player")` and the level the last `PLAYER_LEVEL_UP` reported (recorded by `ns:NoteLevelUp`), because `UnitLevel` can still read the old level while the event is being handled.

**Ammo carries its use level and its replacement**, `itemId → { useLevel, nextTierLevel }`, or `{ useLevel }` alone for ammo nothing at a vendor replaces. An arrow or bullet is junk the moment the player can use the next kind a vendor sells, with no ten-level wait, because a hunter buys the new tier on the spot. A row with no `nextTierLevel` is never junk on that client (Jagged Arrow on Classic Era). `useLevel` is carried for Validate Data and is not part of the rule.

**White gear is decided by rule, the way grays are.** `IsWhiteGearTrash` takes a white weapon that deals damage or a white piece of worn armor that carries armor, and every check fails toward keeping:

- **Subclass allowlists**, never exclusions. Weapons leave out 14 (profession tools), 20 (fishing poles), and 11, 12 and 17, which no real item uses; armor is cloth, leather, mail, plate and shields only, which leaves out Miscellaneous (rings, necks, trinkets, shirts, tabards), relics, and subclass 5, the unused Buckler in the WotLK DB and Cosmetic on modern clients.
- **Structural checks.** Shirt and tabard slots, an item level of 1 or below, or none (developer junk and formal wear such as the Tuxedo Jacket), quest binding, and an on-use spell (Borrowed Broom) all keep the item.
- **Stats.** `ns.GetItemStats` has to report damage per second for a weapon and armor for armor, which separates worn gear from costume pieces.

The rule reads the client the player is on, so quality that differs between clients decides itself. What it cannot see is `ns.KEEP_EQUIPMENT`, checked first: formal wear with real armor values, an Equip: effect (which `GetItemSpell` does not report), and whites a quest takes back at turn-in. A kept item a player wants gone goes on their Erase List.

## Junk Kinds and Erase Confirmation

Each kind of junk has one checkbox on the Erasing panel's **What Counts as Junk** section, two to a line, stored in `ns.db.profile.junkKinds` keyed by delete reason: checked counts the kind as junk, unchecked takes it out of the junk pile. The kinds are listed once, in `ns.ERASE_KINDS` (`Data/Data.lua`), as `{ deleteReason, labelKey, descKey, tagKey }`; the Erasing panel draws one checkbox per entry and Your Current Bags reads the tag keys. When no box is checked, the panel shows a red line saying only the Erase List still acts. Confirmation is a separate question with one answer for every kind: the **Erase Confirmation** switch (`eraseConfirmEnabled`, off by default), alone in the last section of the panel.

**An unchecked kind is enforced in one place.** `ns:GetItemDeleteReason` answers `nil` for it, and every caller goes through it, so an unchecked kind is never erased, sold, retrieved or marked in a tooltip, with no check at any of them. Quest Item Alerts calls `ns:GetQuestStarterReason` directly, so it checks `ns:IsJunkKind` itself.

`ns:IsJunkKind` answers true for `"manual"` and for anything unreadable. Erase Confirmation covers Erase List entries too: a player who turned on a safety switch expects every erase to ask.

**Erase Confirmation** is the `MAGICERASER_CONFIRM_ERASE` static popup. The candidate is passed as the dialog's `data`, so each showing acts on the exact item the player saw, and `preferredIndex = 3` avoids tainting the shared dialog stack. Before deleting, `PerformErase` runs `IsCandidateCurrent`: the slot must still hold the same item id at the same stack count, the item must not have been protected meanwhile, its data must still be cached, and it must still be junk under the cap. A dialog that outlived its candidate therefore erases nothing and prints `L["ERASE_CANDIDATE_CHANGED"]`, rather than erasing more than the player agreed to. After pickup, `GetCursorInfo` must hold the same id or the cursor is cleared with `L["CURSOR_TOO_FAST"]`.

## Manual Delete Assistance

The only feature that acts on a delete Magic Eraser did not start. When the player drags an item out of their bags and the client asks them to type a word to confirm, `Features/Manual-Delete.lua` turns that prompt into a plain Yes/No. It is unrelated to Erase Confirmation, which is why the two panel sections are named apart.

**The prompt cannot be removed; that is the ceiling, not a design choice.** `DeleteCursorItem` requires a hardware event, one item per event, so the player's click on Yes is what makes the delete legal. Leatrix Plus, Easy Delete Confirm and NoDeleteConfirm all stop at the same wall. Answering the dialog from code is worse than ineffective: `StaticPopup_OnClick` from a timer drops the delete while the unprotected dialog hides itself anyway, leaving the item alive with its prompt gone. Never reach for `StaticPopup_OnClick`, the accept button, or `OnAccept`.

**Only the typed dialogs are touched.** `UIParent`'s `DELETE_ITEM_CONFIRM` handler raises `DELETE_GOOD_ITEM` for rare and better (heirlooms excepted) and the plain `DELETE_ITEM` for the rest, and only the good-item pair has an edit box. `FILL_DIALOGS` lists `DELETE_GOOD_ITEM` and `DELETE_GOOD_QUEST_ITEM`; the plain pair has nothing to empty and no click to save.

`ClearDialog` sets the box to `DELETE_ITEM_CONFIRM_STRING`, hides it, **enables the accept button outright**, cuts the type-to-confirm line out of the text, and calls `dialog:Resize()`. Enabling the button is load-bearing: this client's edit box is the `SetSecureText` widget, whose `OnTextChanged` does not fire for text set from code, so filling the box alone leaves the button greyed and the item undeletable. The text is still set so the dialog's state agrees with its button. `TYPE_IT_OUT_LINE` is derived from the client's own `DELETE_GOOD_ITEM` and pattern-escaped, so the cut matches the player's locale, and a client that stops shipping the two-line form leaves the text alone. Every change lasts one showing: the next `StaticPopup_Show` rebuilds the dialog from its definition.

**The fill is deferred one frame** (`C_Timer.After(0)`), because Blizzard's handler and ours answer the same event in no fixed order. The item stays on the cursor while the dialog is open, so `FillDeletePrompt` re-checks scope then.

**Scope is sale price and nothing else.** Past the feature's switch (`manualDeleteAutoFillEnabled`, on by default), the scope dropdown's two values, `all` and `noValue`, are stored as the one boolean `manualDeleteNoValueOnly`. **All Items** never reads the cursor. **Items with No Sale Value** (the default) handles only an item that sells for exactly 0, the set with no disposal route but deleting it. Bound-ness is deliberately not part of it: the items this exists for are armor tokens, which are tradable and so not yet bound. An uncached item prices as nil, which is not 0, so an item that cannot be priced keeps the game's protection. The section's description fills its `%s` placeholders from the client's own `DELETE_ITEM_CONFIRM_STRING` and `ITEM_QUALITY3_DESC`, so it quotes exactly the word and quality name the player's client uses.

The eraser's own deletes never reach this handler: `ns:PerformErase` runs inside the player's own input (a click, a key press, or the Yes on Erase Confirmation), which is the hardware event, so the client never asks.

## Auto-Vend

`Features/Auto-Vend.lua` scans, then sells from a queue, rather than selling inside the scan:

1. `ScanAndVend` walks `ns.CARRIED_BAGS`, applies the same `ns:IsIgnored` gate as the eraser, and queues every item with a positive sell price and a non-nil `ns:GetItemDeleteReason`, Erase List entries included, sorted by stack value ascending. Items with no sell price, most quest items among them, are left for the eraser.
2. `ProcessSellQueue` sells one item per 0.1s tick, re-reading the slot and its protection first because bag positions shift after a sale. It does not re-ask the verdict, so an item that stops being junk mid-pass (its kind unchecked, its Erase List row removed) still sells until the next re-scan drops it.

**Visit state versus pass state.** `BeginVisit`, called from `ns:OnMerchantShow` whenever Auto-Vend is on, whether or not a pass can start, bumps `visitGeneration` and clears what the *visit* owns: `announcedSales`, `pendingSales` and the summary totals. `StartPass` resets only what a *pass* owns (`isSelling`, `sellIndex`, `scanRetries`, `vendPasses`). The combat resume calls `StartPass`, never `BeginVisit`, because the merchant never closed: a sale attempted just before combat is still in `pendingSales` and still owed an announcement. For the same reason `ProcessSellQueue`'s combat branch drops `sellQueue` and marks the vend pending, but leaves `pendingSales` alone.

**Every timer carries its visit generation** and drops out once a newer one exists. `isSelling` alone would not catch a close-and-reopen mid-pass, because the second visit sets it back to true. `ns:OnMerchantClosed` bumps the generation before scheduling its own flush.

**Sales are announced only once confirmed.** `UseContainerItem` is optimistic: a merchant that cannot buy (a dead corpse vendor that still opens a frame) accepts the call silently. `ProcessSellQueue` records each attempt in `pendingSales`, keyed `"bag:slot:itemId"`, and `ConfirmSales` counts one only when the slot no longer holds that item. Confirmation runs at the top of every `ScanAndVend`: the first scan of each pass, the 0.3s re-scan after one, and the 0.5s cold-cache retries. It runs once more `CLOSE_CONFIRM_SECONDS` (0.4s) after `MERCHANT_CLOSED`. The combat resume's first scan is what announces a sale attempted just before combat. `announcedSales` keeps a retried slot from being announced twice.

**Multi-pass re-sell.** The server drops some sells when many arrive quickly, so after a pass Auto-Vend re-scans from live bag state and runs again, up to `MAX_VEND_PASSES` (4), which stops a flagged-but-unsellable item looping forever.

**Chat output.** Everything routes through the file-local `PrintVendMessage`, a no-op unless `autoVendMessagesEnabled`. The panel shows the two saved switches as one dropdown: **No Chat Report** is `autoVendMessagesEnabled` false; **Summary in Chat** and **Every Sale in Chat** are it true with `autoVendSummaryEnabled` true or false. Per-item `L["SOLD_ITEM"]` lines print only in Every Sale mode; the closing summary prints in both, on the deferred close flush. Totals accrue for every confirmed sale whatever the mode, so changing the dropdown mid-visit still yields a correct summary.

## Maximum Value to Erase

`ns:IsOverValueCap(totalValue, deleteReason)` in `Junk-Rules.lua` is the whole feature. Off unless `valueCapEnabled`; on, it answers true for a stack worth more than `ns:GetValueCapGold() * ns.COPPER_PER_GOLD`. `ns:GetValueCapGold` snaps a saved amount the dropdown no longer offers to the nearest choice at or above it (the largest choice, for an amount above them all), so the dropdown never draws blank and the cap applied is the one shown.

**Stack value, not unit price**, because the stack is what the eraser destroys: forty grays at two silver each is exactly the pile worth guarding.

**`"manual"` is never capped**, and the exemption lives inside the function so it is stated once. Everything else the cap guards is a rule's guess about what the player values; an Erase List entry is not a guess, and capping one would leave a list the player built doing nothing with no line anywhere to say why.

**Three callers, all on the erase path:** `ForEachCandidate` (the mini-map pick, the Clutter Report and Your Current Bags), `IsCandidateCurrent` (the re-check before an erase), and the bag tooltip, so a tooltip never promises an erase that will not happen. The `SetBagItem` hook reads the stack from the slot it is handed; the `TooltipDataProcessor` path finds it through `GetCarriedBagSlot` and `GetBagStackCount`, which re-checks the slot's item id and falls back to a count of 1, so an unresolved anchor caps on unit price: it protects less than it should, never more.

**Auto-Vend and Bank Retrieval never consult it.** The cap exists to stop the player losing gold; selling an over-cap stack hands them that gold.

Choices live in `ns.VALUE_CAP_CHOICES` (`Data/Data.lua`) as gold amounts starting at 1; the run deliberately has no zero. `Options-Eraser.lua` builds the dropdown's `values` and `sorting` from that one array. `sorting` is required: AceConfig otherwise orders a dropdown by label text and lands "13 Gold" between "1 Gold" and "2 Gold".

## Bank Retrieval

`Features/Bank-Retrieval.lua` runs one pass per `BANKFRAME_OPENED`, moving junk from the bank into the bags so the eraser and Auto-Vend can act on it.

**Containers.** `ns.BANK_CONTAINERS` (`Features/Utilities.lua`) is built once at load: the client's `Enum.BagIndex.CharacterBankTab_N` entries where it has them (WoW Forever), otherwise `BANK_CONTAINER` plus the bank bags directly above the carried range, each global with a numeric fallback so a missing one never quietly scans nothing. The account-wide Warband tabs are never included. The Merchant & Bank Context report's Bank layout block shows a client laid out differently without a bank window open.

The pass waits `BANK_SETTLE_SECONDS` (0.5s), because bank containers read empty for a moment after the frame opens, then `ScanBank` applies the eraser's predicate without the value cap and `ProcessMoveQueue` moves one stack per 0.1s tick. Unlike Auto-Vend it takes items with no sell price too, since the eraser can still act on them once they are in the bags.

**The budget is the free-slot count, less the Free-Slot Threshold only while Bag-Space Warnings are on.** The cushion exists solely to keep retrieval from triggering that warning, and the threshold slider is hidden while the warnings are off, so reserving then would let an invisible setting hold back a visible feature. A nil free count (containers not ready) yields no budget and no pass. The Bank Retrieval section shows a status line, `ns.OptionsStatusLine`, only while the cushion applies.

**Most valuable first**, the opposite of Auto-Vend: this pass is capped by free slots, so when the budget runs out what stays in the bank should be the gold that mattered least.

**Confirmed moves.** `pendingMove` holds the last attempt, counted by `ConfirmPendingMove` only once the bank slot no longer holds it; the branch that ends the queue, whether the queue or the budget ran out, schedules one extra tick so the final move gets the same chance. The budget is spent per move attempted, and a dropped move is not retried that visit; a queued slot that no longer holds its item is skipped at no cost. There is one pass per bank visit, with no re-scan.

**`passGeneration`** is bumped on each `BANKFRAME_OPENED`, so a reopened bank orphans the old chain. Closing the bank stops the chain through `FinishPass` clearing `isRetrieving`; the extra final tick checks only the generation, so it can run after a close, which is harmless because of the next rule. **`FinishPass` is the single exit**, however the pass ended: it prints the summary only when something was confirmed moved, then resets, so a second call (pass finished, then `BANKFRAME_CLOSED`) stays silent. A pass cut short by a close drops `pendingMove`, so its last move goes uncounted.

## Protect Lists

Players see these as the **Protect List**. The code keeps the Ignore List name (`ignoreList`, `ns:IsIgnored`, `Features/Ignore-List.lua`, the `IgnoreList` registry key, the `IGNORE_LIST_*` locale keys, the `MAGICERASER_ADD_TO_IGNORE_LIST` binding), because renaming a saved key would cost every player their list and renaming the binding would unbind every key.

There are two lists and protection is **additive**: `ns:IsIgnored` answers true if either holds the item.

- **Per-character**, `ns.db.char.ignoreList`.
- **All Characters**, `ns.db.global.ignoreList`.

The mini-map Right-Click (`ns:ToggleIgnore`) and Middle-Click (`ns:ClearIgnoreList`) act on this character's list only, which is exactly what the mini-map tooltip's list section shows; that section, and the Middle-Click hint inside it, appear only while the list holds something. The Right-Click's target is the current candidate, which is never protected, so in practice the toggle only adds. The **Add Hovered Item to Protect List** binding, the Your Current Bags **Protect** buttons and its Protect checkbox write the same list through `ns:AddToIgnoreList`; unticking the checkbox goes through `ns:SetIgnoredInScope`.

**Only `ns:AddToIgnoreList` drops the item's Erase List row.** `ns:ToggleIgnore`, a panel add and a promote (both `ns:SetIgnoredInScope`) leave it in place, overruled. That is what the Erase List panel's **Protected** tag is for.

**Out-of-panel edits repaint the panel themselves.** The panel is a builder function, so a repaint rebuilds it from the live lists, but something has to ask. `ns:ToggleIgnore`, `ns:ClearIgnoreList`, `ns:AddToIgnoreList` and `ns:AddToEraseList` each fire `NotifyChange`, and Your Current Bags' checkboxes repaint both list panels themselves; edits made inside a list panel are covered by the shared item-list builder.

`ns:GetIgnoreListForScope(scopeKey, createIfMissing)` is the panel's accessor. The character being played resolves through `ns.db.char`, so an edit lands on the very table the eraser reads. Every other character is read from `ns.db.sv.char`, because AceDB only materializes the current character and strips default-valued tables at logout; a read returns nil for a character with nothing stored, and a write passes `createIfMissing`.

**Promote, not copy.** Per-character rows carry an **All Characters** button that only issues the account-wide add; `ns:SetIgnoredInScope` then drops the item from every character's list, since the global list already covers them. Removing from the global list does not put the item back on anyone: there is no record of who held it.

`ns.LIST_SCOPE_GLOBAL` is `"**global**"`, shared by both list panels. Every other scope key is an AceDB character key (`"Name - Realm"`, never localized), and no character or realm name can contain asterisks.

## Erase Lists

The Protect List in reverse, built to the same shape: two lists, membership additive, `ns:IsOnEraseList` answering true if either holds the item (`ns.db.char.eraseList`, `ns.db.global.eraseList`). `Features/Erase-List.lua` mirrors `Ignore-List.lua`'s per-scope accessors as `ns:GetEraseListForScope` and `ns:SetOnEraseListInScope`, and has no toggle or clear, since no mini-map click writes it. A listed item returns `"manual"` before the rule chain runs, so it is erased whatever its rarity, and sold if it has a price. That is the point of the feature: the query-built tables are regenerated, and the white-gear rule is structural, so an item neither can express has no durable home in `Data/`.

**Promoting widens the other way.** On the Protect List a promote only protects more; here it erases more, on every character, including a Shaman the fishing reagents were deliberately never seeded for. The button's description says "every character" outright.

**The Protect List always wins, and nothing in the Erase List enforces it.** `ForEachCandidate`, `IsCandidateCurrent`, `ScanAndVend` (and each sale after it) and `ScanBank` gate on `ns:IsIgnored` before calling the verdict, and the bag tooltip returns its protected line first. A new caller that skips the gate would silently invert the rule. `ns:AddToEraseList` turns a protected item away only so the key binding can say why. The Erase List panel tags a row a Protect List overrules as **Protected**, so the list never looks like it is doing something it isn't.

**No mini-map click.** All five click combinations are taken, so the list's out-of-panel writers are the key binding, `ns:AddToIgnoreList` (which takes this character's row away when it protects the item), the Your Current Bags checkboxes, and the login seed.

### The Class-Reagent Seed

`ns.CLASS_REAGENTS`, in each flavor's `Class-Reagents-{Flavor}.lua`, maps a class token to items only that class needs. `ns:SeedEraseList` is its only actor: on a character's first login it copies every *other* class's reagents onto that character's list, so a non-Shaman starts with Shiny Fish Scales and Fish Oil listed and a Shaman with neither. Nothing filters on the table at scan time, so a Shaman who deliberately lists Fish Oil is obeyed. The table is hand-kept in its own file, never in one of the query tables, because a regenerated file drops hand-added rows.

`char.eraseListSeeded` records that the seed ran. It has to be stored: an empty list cannot tell "the player cleared it" from "never seeded". It lives in `char` beside the list, so a profile switch, copy or reset never re-seeds. The seed skips an id this character's own class also uses, one already protected, and one already listed, since each would change nothing. It only drops the scan cache; both callers repaint.

**Restore Defaults** (`ns:RestoreEraseListDefaults`) wipes this character's list, clears the marker, and seeds again, so the player's own additions go with it, which the `confirmText` warns about. Clearing the marker first is load-bearing: the seed returns early while it is set. The button appears only on the pane of the character being played, because the seed reads that character's class and writes `ns.db.char`; the All Characters scope ships no defaults.

## Item Tooltip Warnings

`Features/Item-Tooltips.lua` appends one branded line to a carried-bag item's `GameTooltip`, gated on `tooltipWarningEnabled`: a white `L["TOOLTIP_IGNORED"]` when a Protect List shields it, a red `L["TOOLTIP_ON_ERASE_LIST"]` when the player listed it, or a red `L["TOOLTIP_WILL_ERASE"]` when a rule matched. Protection is checked first. The rest comes from the very verdict and cap the scan uses, so the line appears only when the item truly would be erased.

There are two hook paths, chosen by feature detection rather than flavor, and only one is ever installed:

- **`TooltipDataProcessor.AddTooltipPostCall`** where the client has it and `GameTooltip` is data-driven (`GameTooltip.ProcessInfo`, WoW Forever). TBC Anniversary loads `TooltipDataProcessor` too, but its `GameTooltip` never mixes in the data handler (only the Mainline `GameTooltip.xml` does, per wow-ui-source), so a post-call there would never fire. It fires for every item tooltip, so `GetCarriedBagSlot` filters to owners whose `GetBagID()` (protected by `pcall`) or `ContainerFrame` parent id is in `ns.IS_CARRIED_BAG`.
- **`hooksecurefunc(GameTooltip, "SetBagItem")`** elsewhere, already bag-scoped by its arguments. It re-`Show()`s after adding a line, because by then the tooltip has been sized.

The hooks install from `ns:OnPlayerLogin` via `C_Timer.After(0, ns.SetupTooltipHooks)`, after every add-on's own login setup, so ours wraps the outermost layer. A tooltip add-on such as TSM that clears and re-fills the tooltip would otherwise wipe the line.

## Bag-Space Warnings

`Features/Bag-Warnings.lua`: an opt-in countdown (`bagsFullNudgeEnabled`, off by default) that warns as free slots drop to or below `bagsFullThreshold` (1 to 10). It never deletes and does not care what is erasable.

`ns:CountFreeBagSlots` (`Features/Utilities.lua`, shared with Bank Retrieval) sums only general-purpose bags and returns `nil`, never `0`, when no container has answered. Summing `(bagFree or 0)` cannot tell "no data yet" from "zero free", so mid-loading-screen it would cry "bags full" at a half-empty inventory. Readiness is judged from the data: a zero slot total, or no bag answering, means nothing is loaded.

**It warns on a drop and only on a drop.** `lastSeenFree` holds the previous reading, and a line prints only when the count is strictly lower and at or below the threshold. Freeing a slot inside the zone is silent, and a repeated `BAG_UPDATE_DELAYED` for one purchase reads the same count twice. The baseline is taken before the other guards, so a silent tick still tracks the bags; `ns:SeedBagSpaceBaseline` primes it at login so the login burst counts as known. `BAG_SETTLE_SECONDS` (2s), refreshed on every `PLAYER_ENTERING_WORLD`, keeps the check idle while containers repopulate.

Warnings are held while a merchant, mailbox or bank window is open (`ns:IsBagWindowOpen`, read live rather than from a tracked flag), because those visits churn bags hardest. Each close re-checks once: `ns:OnMailClosed`, Auto-Vend's deferred merchant flush, and `ns:OnBankframeClosed`.

## Quest Item Alerts

`Features/Quest-Item-Alerts.lua`. Alerts print only while `questAlertsEnabled` is on and the kind is checked (`ShouldAlert`); items are still marked as announced while alerts are off, so turning them back on doesn't replay every quest item in the bags. Protected items never announce and are left unmarked, so lifting the protection lets them speak later.

`ns:CheckQuestStarters` runs from `ProcessBagUpdate`, from `ns:OnQuestTurnedIn`, and from `ns:OnPlayerRegenEnabled`, which replays the walk combat held back. It gates on a lookup in `ALLOWED_DELETE_QUEST_STARTING_ITEMS` before any race, class or quest check, then prints `L["QUEST_ITEM_READY"]` or `L["QUEST_STARTER_UNAVAILABLE"]` by the reason `ns:GetQuestStarterReason` returns. `announcedStarters` is keyed by item id for the session, so moving a stack never speaks twice. `ns:SeedQuestStarterAlerts` runs once at login and marks what is already erasable, the same reasoning as the bag-space baseline; held-but-not-yet-erasable starters stay unmarked so finishing their quest still alerts.

`ns:OnQuestTurnedIn` waits 1.0s, runs the starter check, then prints `L["QUEST_ITEM_READY"]` once per held item whose row lists the quest just completed, skipping anything already in `announcedStarters` (announced, seeded at login, or marked while alerts were off), since nearly every starter also has a `Quest-Items` row under the same quest id. Both alerts append the item's total count across every carried stack.

## Mini-map Button

`Features/Minimap-Button.lua` builds an LDB data object, registered with LibDBIcon against `ns.db.global.minimap`, whose icon mirrors the current erase candidate and falls back to `ns.DEFAULT_ICON`. On WoW Forever (and Mainline), `ns:OnPlayerLogin` re-fits the icon right after `LibDBIcon:Register`, sizing and centering it with `SetButtonIcon` and masking it round, because LibDBIcon otherwise leaves the square icon off-center in its ring there.

| Click | Action |
|-------|--------|
| Left | `ns:RunEraser` |
| Right | Toggle the current candidate on this character's Protect List |
| Middle | Clear this character's Protect List (no confirmation, by maintainer decision) |
| Shift + Right | Toggle Auto-Vend, repaint the General and Merchant & Bank panels and the tooltip |
| Shift + Middle | `ns:OpenOptionsPanel` |

Shift + Middle is checked first in `OnClick`. `RefreshTooltip` composes, in order: the title and version, the lowest-value item with its click hints (or the clean-bags line), Auto-Vend status, the Clutter Report, this character's Protect List, then the options hint. The list comes last of the content sections because it is the only one whose length varies, so everything above it holds its position.

`ns:RefreshDisplay` invalidates the cache, recomputes the candidate, repoints the icon, re-renders the tooltip if the button owns it, and fires `NotifyChange` on Your Current Bags. It is the one repaint path, called after anything that can change the candidate.

## Key Bindings

Three bindings, defined in `Bindings.xml` and drawn in the **Magic Eraser** section of the game's Key Bindings list:

| Binding | Name attribute | Handler | Enters through |
|---------|----------------|---------|----------------|
| Erase Lowest-Value Item | `MAGICERASER_ERASE` | `MagicEraser_Erase` | `ns:RunEraser` |
| Add Hovered Item to Protect List | `MAGICERASER_ADD_TO_IGNORE_LIST` | `MagicEraser_AddToIgnoreList` | `ns:AddToIgnoreList` |
| Add Hovered Item to Erase List | `MAGICERASER_ADD_TO_ERASE_LIST` | `MagicEraser_AddToEraseList` | `ns:AddToEraseList` |

**The erase binding is the Left-Click on a key.** Its handler only calls `ns:RunEraser`, so the combat refusal, Erase Confirmation, the value cap and both Protect Lists hold for a key press exactly as for a click. Keep it synchronous: the key press is the hardware event `DeleteCursorItem` needs, and a timer in between would lose it. Because a key press shows no preview, the General panel says so and advises a key that won't be hit by accident.

**The list bindings act on the item under the mouse**, wherever `GameTooltip` is showing one. `GetHoveredItem` reads it through `ns.GetDisplayedItem` (`Features/Utilities.lua`), resolved once at load: `TooltipUtil.GetDisplayedItem` where the client ships it (WoW Forever, where `GameTooltip:GetItem` survives only as a wrapper marked for removal), and `GameTooltip:GetItem` elsewhere. It answers only while the tooltip is shown, so a late press never acts on the last item it held. No item prints `L["NO_HOVERED_ITEM"]`.

**Both write this character's list and both only add.** Removing protection is the one edit where a stray press costs an item, so removal stays in the panels. `ns:AddToIgnoreList` returns `"already"`, `"moved"` (it also dropped this character's Erase List row, since protection wins) or `"added"`; `ns:AddToEraseList` returns `"protected"`, `"already"` or `"added"`. `Key-Bindings.lua` turns each into one complete chat sentence around the item link, so every press is answered. `ns:ProtectItemWithMessage` is the same path for the Your Current Bags **Protect** button.

**The bag tooltip catches up on its own.** The client re-sets a hovered bag item's tooltip every `TOOLTIP_UPDATE_TIME` (0.2s), and each re-set runs the tooltip hook again. Calling a bag button's `OnEnter` from add-on code would taint it.

**Every binding needs two globals:** its handler, because `Bindings.xml` can only call a global, and `BINDING_NAME_<name>`, the label the Key Bindings list looks up. All six are in `.luacheckrc`'s `globals`. The `name` attribute is also what the client saves a player's key against, so a shipped binding keeps its name for good. `Bindings.xml` is found at the add-on root by the client and is never listed in a TOC; its root element is `<Bindings>`, and the shared `category` attribute is what gathers the three into one section.

The General panel's **Key Bindings** section shows state, since a binding cannot be set from AceConfig: one row per binding with its key from `GetBindingKey` (or a muted **Not Bound**) and a **Set Key** button. Past its combat gate, `ns:OpenKeyBindings` tries, at click time, `Settings.KEYBINDINGS_CATEGORY_ID`, then a protected search of `SettingsPanel`'s category list for the Key Bindings title, then the legacy `KeyBindingFrame`, and prints `L["KEY_BINDINGS_LOCATION"]` naming the client's own menu labels when none works. Every API a route touches has a Diagnostic Tools API row. `UPDATE_BINDINGS` repaints the panel.

## Options Panels

`ns:RegisterOptionsPanels` (`Options/Options.lua`) runs from `ns:OnPlayerLogin` once `ns.db` exists, because the list and Profiles builders need the database. Registration order is tree order: **General** (root), **Erasing**, **Merchant & Bank**, **Alerts & Tooltips**, **Protect List**, **Erase List**, **Your Current Bags**, **Profiles**, **Diagnostic Tools**. Feature pages come before the lists because they are configuration and the lists are data; Your Current Bags follows the lists because its rows are where a player sorts what they carry onto them.

**Opening.** The root's `AddToBlizOptions` returns `(frame, categoryID)`, captured as `ns.generalPanel` and `ns.generalCategoryID`. Past the combat gate, `ns:OpenOptionsPanel` calls `Settings.OpenToCategory(ns.generalCategoryID)` and reaches `AceConfigDialog:Open` only as a last resort. Never look the category up by display name: AceConfigDialog aliases the ID to the name only on clients lacking `C_SettingsUtil.OpenSettingsPanel`, so a name lookup returns nil on TBC Anniversary and the panel opens as a floating window.

**Built tables versus builder functions.** General, Erasing, Merchant & Bank, Alerts & Tooltips and Profiles are built once. The two list panels, Your Current Bags and Diagnostic Tools are registered as their builder *functions*, so AceConfig re-invokes them on every open and `NotifyChange` and they can never show a stale list or stale bags.

**Feature pages are composed from fragments.** Each feature's settings live in an `Options-{Feature-Name}.lua` named for the `Features/` file it configures (`Options-Eraser.lua` covers the eraser as a whole: its junk-kind and value-cap settings are read in `Junk-Rules.lua`, Erase Confirmation in `Eraser.lua`), exposing a dot-defined builder per section that adds widgets to the `args` it is handed. `Options-Eraser.lua` holds two, `ns.BuildEraserOptions` (kinds and value cap) and `ns.BuildEraseConfirmOptions`, which the Erasing panel places around Manual Delete. Each panel file seeds `args`, calls its builders through a section list (`ERASING_SECTIONS`, `MERCHANT_BANK_SECTIONS`, `ALERTS_SECTIONS`), and returns the group. Fragments load before the panels that call them. Moving a section between panels is a one-line section-list change plus a renumber.

**Order on screen comes from each widget's `order`, in blocks of ten per panel.** General: intro 1, welcome and mini-map 5 to 7, Features 10, Key Bindings 30, /Commands 90, Feedback & Support 100, version 998 and 999. Erasing: intro 1 and 2, kinds 10, value cap 30, Manual Delete 40, Erase Confirmation 50. Merchant & Bank: Auto-Vend 10, Bank Retrieval 20. Alerts & Tooltips: tooltips 10, quest alerts 20, bag space 30.

**One switch, two places.** `ns.OptionsFeatureToggle(settingKey, nameKey, descKey, order, width, onSet)` builds every feature switch; `FEATURE_TOGGLES` in `Options-General.lua` places each a second time in the root's Features section, laid out two to a line by `ns.OptionsTogglePairs` (which sets each pair's width and order), with the same setting and locale keys, so both copies are one setting with one caption and tooltip. A switch whose change has to reach past the saved value passes the same onSet in both places: Maximum Value to Erase shares `ns.OnValueCapToggled`. Bag-Space Warnings' own onSet only repaints the Merchant & Bank cushion line, which redraws on its own when that panel is next opened, so the General copy leaves it out.

**Show what it says.** A chat-printing feature shows an example under its switch, `ns.OptionsExample`, built from the very locale string it prints with `ns.BRAND_PREFIX` and `ns.EXAMPLE_ITEM_LINK`. A coupling between features is stated on the page of the feature being changed, through `ns.OptionsStatusLine`, which hides while its text is nil.

**Layout grid.** Shared widths come from `Data/Data.lua`; a width only one file uses is a named local constant at the top of that file, never a number typed at the call site. A captioned control is two args, an `ns.OptionsRowLabel` at `ns.OPTIONS_LABEL_WIDTH` then the control with `name = ""` at `ns.OPTIONS_CONTROL_WIDTH`, which sum to `ns.OPTIONS_ROW_WIDTH` so every row ends at the same edge. Maximum Value to Erase, Manual Delete Assistance and Auto-Vend put their switch in the caption's place with the dropdown beside it. The file-local `SubRow` in `Options/Options-Bag-Warnings.lua` wraps a control a switch above it gates in an unnamed inline group led by an indent cell (`ns.OPTIONS_SUB_INDENT_WIDTH`, matched to the checkbox's visible square), with `hidden` on the group, never the members; the caption takes `ns.OPTIONS_SUB_LABEL_WIDTH`, which leaves 0.05 of slack because a row exactly on the wrap boundary tips its control onto its own line. Only Bag-Space Warnings builds one today, so the builder stays in that panel file until a second panel needs it and it moves to `Options/Options-Utilities.lua`. **A setting under a switch that is off is hidden, never greyed.**

**Your Current Bags** draws the next item up with **Erase** (`ns:RunEraser`) and **Protect** (`ns:ProtectItemWithMessage`), the next five items grouped by item id under **Up Next**, each with its own **Protect**, and a Clutter Report total over the whole queue, all from `ns:GetEraseQueue`. Below that, **Everything in Your Bags** lists every distinct carried item with two exclusive checkboxes acting on this character's lists: ticking Protect goes through `ns:AddToIgnoreList`, and ticking Erase first drops this character's Protect row, so the boxes follow the Protect-always-wins rule. An item an All Characters list holds has that list's box disabled, because changing it here would change every character; the Erase box is also disabled, and reads unticked, while the All Characters Protect List holds the item, since protection wins on every character.

**The list panels** use `childGroups = "tree"`, keyed by scope rather than position, because the tree remembers the selected node by arg key. All Characters comes first, then a disabled blank row, then each character in its class color (`ns:GetCharacterDisplayName`: the character being played from `UnitClass`, every other from the `classToken` it saved at its last login). Characters with an empty list are left out, except the one being played. `PrepareListTree` seeds the tree width (`ns.OPTIONS_TREE_WIDTH`, 180px; AceGUI fills `treewidth` only when absent, so the seed wins while a player's drag still overrides it) and selects the current character at registration and again on every hide. Each panel's description sits on the root group, which a tree renders once above the tree rather than in every pane. There is no drop target: the game closes the bags when the Options Interface opens, so an **Add from Bags** picker stands in.

Every pane comes from `ns:BuildItemListOptions`, the shared item-list builder: an add box that parses an id or shift-clicked link, name-sorted rows drawn by the `ItemLink` AceGUI widget (registered as `ns.ITEM_LINK_WIDGET_TYPE` so two add-ons never collide), and a one-click remove icon. Each caller hands it a `getSourceTable` function, add and remove callbacks, labels, the notify key, `rowWidth` and `startOrder`, plus the optional `actionColumn` (the **All Characters** promote button on per-character panes), `getRowTag`, `addFromBags` (whose picker leaves out items already listed), and `onRestore`. Restore Defaults is emitted only for a caller passing `onRestore`, today the current character's Erase List pane, and always sits last. Panes spend `ns.OPTIONS_TREE_ROW_WIDTH`, since the sidebar takes its share first.

The **Profiles** panel is the stock AceDBOptions-3.0 table returned unmodified.

## Diagnostic Tools

The files in `Diagnostics/` provide **Options > AddOns > Magic Eraser > Diagnostic Tools**, for bug reports: environment probing and state capture, not tests. State lives in `ns.diagnostics`, a plain table that is never saved, so the panel starts off every session. When off, only the warning and the enable toggle render. The five tabs are left out of the table rather than hidden, because AceConfigDialog reads `hidden` as inherited from the parent when deciding whether to draw a tab frame, so five hidden tabs still leave an empty bordered box; the panel is registered as the `ns.BuildDiagnosticsOptions` builder, so each repaint rebuilds it. Reports build only on a button press. Every report opens with one header line: add-on version, client version, build, TOC number, locale, `ns.FLAVOR` (with Season of Discovery named when `ns.IS_DISCOVERY`), and `ns.DATA_FOLDER`.

The panel is `childGroups = "tab"` with five tabs:

- **Run Tests.** The live tools, none of which is a report: the Event Log (Start, Stop, Show, and its own box once shown), the Taint Log (its current level, with **Turn On** setting the CVar to 2 and **Turn Off** to 0, each disabled when it would change nothing), **In-Game Tools** (copy boxes for `/etrace` and `/console scriptErrors 1`) and **External Tools** (Funkeh's Bug Grabber and Bug Sack, as copy boxes holding their CurseForge URLs, since the game can't open links).
- **Settings** (Eraser Context, Merchant & Bank Context, Saved Variables, Display Context, Other Add-ons), **Code** (Event Registration, API Endpoints, Library Versions), **Data** (one Validate Data report per data file) and **Localization** (Locale Context, Game Names). Each has a Run All, a row per report (its name and last state, what it covers, and its button on the right), and one box that shows whatever ran last on that tab: the client header once, then a `---- title ----` block per report, each report's own header line stripped. The Data tab adds a hint under its box.

Rows sit label-left, controls-right, each in an unnamed inline group so it pins its own line, sized to the tab's pane: AceGUI's TabGroup insets 60px and a titled box 20px more, so the panel's `TAB_ROW_WIDTH` and `BOX_ROW_WIDTH` spend less than `ns.OPTIONS_ROW_WIDTH`.

The runner (`ns.DIAGNOSTIC_REPORTS`, `ns.DIAGNOSTIC_SECTIONS`, `ns:RunDiagnosticSection`, `ns:RunDiagnosticReport`, `ns:StopDiagnosticRun`) runs one report at a time, a frame apart, and runs one run at a time; every run button is disabled while one is going. A report either builds its text at once (`build`) or runs over several frames (`start`, handed a callback taking the text, its note and any problem, with `stop` to cancel it). A data report's `start` hands over to the batched validation through `ns:StartDataValidation`, and its status row reads the live count from `ns:GetDataValidationProgress`; Game Names starts through `ns:StartNameLookupReport`. **Stop** calls the `stop` of the report in flight. Every step checks the run's generation, so **Stop** or switching the panel off ends the chain; reports that finished stay in the box above a "stopped before finishing" line. A report that throws is written into the box as an error and the run goes on; for a data file that includes a validation step failing outside a single read, which ends that file's report. Status notes: Event Registration counts its `[FAIL]` rows, each data file tallies its `STATUS` column, Game Names counts its `[NIL]` rows, and API Endpoints has none on purpose (see below).

- **Event Log.** The dispatcher tap: a 500-entry ring buffer, 8 args at 255 bytes each. `ns.DIAGNOSTIC_EVENT_EXCLUDE` is deliberately empty, since the log only sees registered events and none is a firehose, and so is the second filter, `ns.MESSAGE_ID_FILTERED_EVENTS`, whose suppressed count the report would close with.
- **Event Registration.** Every `ns.EVENT_NAMES` entry, checked with `C_EventUtils.IsEventValid` and a register/unregister round-trip on a probe frame.
- **API Endpoints.** `ns.DIAGNOSTIC_API_CHECKS`, one row per API the add-on calls or guards, existence and shape only. `Manifests.lua` writes the add-on's rows; `Validate-Data.lua` appends one row per reader it uses, labelled `(Validate Data)`, which is most of the report. Every modern/legacy pair is listed as both halves: the tooltip hook, the tooltip-text read, the stat read, the quest-title read, the hovered-item read, the bank layout (`Enum.BagIndex.CharacterBankTab_1` versus `BANK_CONTAINER`), and the Key Bindings routes. **A `[FAIL]` on one half of a pair is the report working**, since it says which branch that client took; never drop the half that fails on the client in front of you. The Manual Delete rows cover the two client strings and four dialog methods that feature relies on. `MerchantFrame`, `MailFrame` and `BankFrame` have rows because Auto-Vend, Bank Retrieval and the bag-space warning read whether those windows are open, and `GetBindingKey` and the guarded `GetBindingText` have rows for the root panel's key list.
- **Eraser Context.** Race, class, level and the level the rules use (`ns:GetJunkRulesLevel`), combat state, the race and class bits the quest-starter gate compares (`ns:GetPlayerQuestBits`, a 0 flagged `UNKNOWN`), every switch that can quiet a feature (each junk kind through `ns:IsJunkKind`, the value cap through `ns:GetValueCapGold`, Erase Confirmation, the tooltip line, quest alerts, both Manual Delete switches), the key for each binding, which tooltip hook installed (`ns:GetTooltipHookPath`), how many quest starters have been announced, whether Manual Delete found its instruction line, how many carried stacks are still loading item data beside the scan's retry state (`ns:GetScanRetryState`), both Protect List counts, both Erase List counts with the seed marker, table sizes, the class-reagent count, and the live candidate with its full tooltip.
- **Merchant & Bank Context.** Combat state and the free general bag slots (`ns:CountFreeBagSlots`, `unknown` before the containers answer); Auto-Vend's switch, chat report, whether the merchant window is open, and the pass in flight (`ns:GetAutoVendState`: selling, waiting for combat to end, passes used); Bank Retrieval's switch, whether the bank window is open, whether it is retrieving, and the move budget left after the warning threshold (`ns:GetBankMoveBudget`); Bag-Space Warnings' switch, threshold, baseline and remaining post-loading-screen hold (`ns:GetBagWarningState`), and whether any window holding the warning is open; then a Bank layout block (the raw globals, `ns.CARRIED_BAGS`, `ns.BANK_CONTAINERS`, the client's `Enum.BagIndex` sorted by value, and the slot count of every container index from -1 up).
- **Validate Data.** One report per data file on the Data tab, built from `ns.DIAGNOSTIC_DATA_SOURCES`. Each entry's `label` is the table-name part of its file name, so `ns.DataSourceFileName` names the file this client's folder built; each source names the `ns` table, its kind (`item` or `quest`), how to reach its ids (`rowId` over the table's pairs, or `collect` for a table not keyed by the id, such as `CLASS_REAGENTS` or the quest ids inside item rows), and `dataColumns`, the shipped row's own values as `DATA_*` columns. A run works in batches of 100: an item id `C_Item.DoesItemExistByID` rejects is `NOT ON CLIENT` on the spot, the rest are requested and polled every 0.5s, re-requested every 3 idle polls, and settled after 12 idle polls (`NOT ON CLIENT`, `INCOMPLETE` for an item whose data loaded without its tooltip or its spell's data, or `NO TITLE` for a quest whose title never loaded, which is not grounds to prune). An item row is `OK` only once its data, its tooltip and its spell have all loaded; many quest-object spells have no description at all, so an empty one counts once `C_Spell.IsSpellDataCached` says the spell is loaded, or one poll after the request on a client without it. A read that throws marks the row `ERROR` rather than ending the run, and a table this client never built prints `TABLE MISSING`. The report is the header, then an item TSV block and a quest TSV block, handed to the run's callback with its `STATUS` tallies. Item columns, in order: status, source, id; every item-info and instant return; the `DATA_*` columns; the item's spell, its description, every `SPELL_READERS` column and the spell's own tooltip (`SPELL_TOOLTIP`); the item-level, class and stat reads; every `ITEM_READERS` column; and the whole item tooltip in one `TOOLTIP` cell. Quest columns: title, completion flag, the items pointing at it, then every `QUEST_READERS` column. The three reader lists hold every reader the clients ship that answers from the id alone (taken from the generated API documentation of all three branches), each resolved once at load so a missing reader leaves blank cells, and each with its own API Endpoints row. Table returns print as sorted `key=value` pairs. Tooltips come through `ns.DiagnosticTooltipLines`, a protected wrapper around `ns.GetTooltipLines(kind, id)` (`Features/Utilities.lua`): `C_TooltipInfo` on WoW Forever, a hidden scan tooltip on Classic Era and TBC Anniversary. Every timer carries the run's generation, so disabling the panel cancels a run.
- **Locale Context.** `GetLocale()`, the `textLocale` and `audioLocale` CVars, and how many keys `ns.L` defines.
- **Game Names.** One line per `ns.DIAGNOSTIC_NAME_LOOKUPS` row, `[OK]` or `[NIL]`, then the constant, its kind and id, and the name this client returns through the row's own lookup (or the error, for a lookup that throws): the Blizzard UI labels Magic Eraser shows or matches, and `TYPE_IT_OUT_LINE`, the instruction Manual Delete Assistance cuts out of `DELETE_GOOD_ITEM` (from `ns:GetManualDeleteInstructionPattern`). A row with a `request` function would be asked for and polled on Validate Data's cadence before settling as `[NIL]`; no row has one today, since every name the add-on looks up is a GlobalStrings label, so the report finishes in one frame. There is no Message Length report, because Magic Eraser sends no chat and writes no macros.
- **Display Context.** Screen size, UI scale and the button's saved placement, plus the link-by-link trace of a dragged position (`math.atan2`, the LibDBIcon minor, whether the button's `db` is the very `ns.db.global.minimap` table, and the raw saved angle).
- **Other Add-ons**, **Saved Variables** (`MagicEraserDB` dumped whole to depth 8) and **Library Versions**. The Taint Log buttons set the `taintLog` CVar, the only thing the panel ever writes; the add-on can't read `Logs\taint.log`, so the Taint Log is a switch rather than a report.

All diagnostics strings live in `ns.DiagnosticsStrings` as plain English and are never localized; the one localized read is `ns.ADDON_TITLE`, which the shared strings take their add-on name from, as the Saved Variables and Display Context reports take theirs from `ns.SAVED_VARIABLES_NAME` (`Data/Data.lua`). The per-add-on pieces, the parts a copy into another add-on re-authors, are the `ns.DIAGNOSTIC_API_CHECKS` rows, `ns.DIAGNOSTIC_DATA_SOURCES`, `ns.DIAGNOSTIC_NAME_LOOKUPS`, the Eraser Context and Merchant & Bank Context probes and `EVENT_LOG_EXAMPLES` beside it; the rest is shared as-is.

## Saved Variables

Magic Eraser declares one SavedVariables global, `MagicEraserDB`, handed to AceDB-3.0 in `ns:OnPlayerLogin`. It holds every setting and all four item lists.

**Model: Simple.** `AceDB:New(ns.SAVED_VARIABLES_NAME, ns.DATABASE_DEFAULTS, true)` (the name is `"MagicEraserDB"`, in `Data/Data.lua`) puts every character on the one shared **Default** profile; a player who needs a one-off (a bank alt with Auto-Vend off) makes a profile by hand. **Reset Profile returns every setting on the active profile to its install default; it never touches the item lists, the seed marker or the mini-map position, which live outside the profile.** The add-on uses three AceDB scopes, and which one a new key belongs in is the decision to get right:

- **`profile`** holds every setting, `junkKinds` and `eraseConfirmEnabled` included.
- **`char`** holds what belongs to one character whatever profile it is on: its own `ignoreList` and `eraseList`, `eraseListSeeded`, and `classToken` (its class at last login, which the list panels read to color its name).
- **`global`** holds reset-proof state: the All Characters `ignoreList` and `eraseList`, the LibDBIcon `minimap` table (so switching or resetting a profile never moves the button), and `storageVersion`, written by the migration.

The list panels find characters through `ns:GetCharacterKeys()`: every key in `ns.db.sv.char` plus the one being played. Profile names say nothing about who has a list, since everyone is on Default.

All three profile callbacks (`OnProfileChanged`, `OnProfileReset`, `OnProfileCopied`) go to `ns:ApplyProfile`, because under this model they mean the same thing: the settings the candidate is computed from may have changed. It drops the cache, repaints, and fires `NotifyChange` for every registered panel.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied by AceDB-3.0 when a scope is first accessed, and explicit user values, including `false`, are never overridden. Note that scalar and table defaults are physically copied into the saved table (`copyDefaults` via `rawset`); only `*`/`**` wildcard defaults resolve through metatables. This add-on defines no wildcard defaults.

**Default-list seeding.** The Protect Lists ship no defaults. The per-character Erase List's defaults, the class-reagent seed, go in once per character, tracked by `char.eraseListSeeded`, and again only on Restore Defaults; never because the list is empty, since an empty list is what a player who cleared it asked for. The All Characters Erase List ships none. The curated junk tables are static `Data/` tables, not saved data.

### Migration Chain

`ns:MigrateSavedVariables` reads `global.storageVersion` and runs each step the saved table hasn't reached, in order:

- `MigrateToVersion2` (`MIGRATION (remove after 2026-11-30)`): per-character profiles collapse onto shared Default, with each character's lists moved into `char`.
- `MigrateToVersion3` (`MIGRATION (remove after 2026-11-03)`): each profile's `eraseActions` becomes `junkKinds` plus `eraseConfirmEnabled`.

Both steps live in `Features/Migrations.lua`. The 2026-11-30 tag sits on the file's header, its version check and `ns:MigrateSavedVariables`, its TOC line and its call in `Features/Core.lua`; the 2026-11-03 tag on `MigrateToVersion3` and its call inside `ns:MigrateSavedVariables`. The call runs on the raw `MagicEraserDB` from `ns:OnPlayerLogin` *before* `AceDB:New`, because AceDB picks each character's profile the moment it opens the table. Version 2 moves every setting from `global` into Default (the global value wins, being the one in effect), turns the old `safetyEnabled` switch into Erase Confirmation when any of its per-kind toggles asked, clears the lists out of every profile, drops the profiles left empty, and points every character at Default. Version 3 brings a `"keep"` kind in unchecked and turns Erase Confirmation on when any kind was `"ask"`, so nobody loses a confirmation they chose. `global.storageVersion` records the version reached; it is stored rather than inferred because a one-off profile holding only defaults is stored empty and would otherwise be sent back to Default every login. A fresh install is stamped 3 and never migrated.

## Adding a New Trash Item

Every flavor folder holds its own complete copy of each table, so a row goes into the file of **every folder where it is true**, and nowhere else. Copies drift: when you change a row, look the same id up in the other six folders and say in the PR which copies you changed and why. For a table over 20 rows, edit only the rows at issue in place, and copy rows between folders with a script, never by retyping. Keep the column-header comment and the How We Got the Data block, which says what belongs in each table and how its fields are derived, and run Validate Data for that file on each client you can; a `NOT ON CLIENT` row is a row in the wrong folder.

1. **Consumable.** Add `[itemId] = { useLevel }` to `Consumables-{Flavor}.lua` in its kind block (Food, Water, Both, Alcohol).
2. **Ammo.** Add `[itemId] = { useLevel, nextTierLevel }` to `Ammo-{Flavor}.lua`, Arrows or Bullets, or `{ useLevel }` for ammo no vendor tier replaces. A new *vendor* arrow or bullet joins the hand-listed vendor line and moves `nextTierLevel` on every row below it, so regenerate that file rather than adding one row.
3. **White gear.** Nothing to add: `IsWhiteGearTrash` finds white weapons and armor on every client. `Equipment-{Flavor}.lua` takes the opposite, `[itemId] = true` in `ns.KEEP_EQUIPMENT`, for a white the rule would erase and must not: formal wear, an Equip: effect, or a quest turn-in.
4. **Quest item.** Add `[itemId] = { questId, ... }` to `Quest-Items-{Flavor}.lua`, keyed per the rule in the file's notes: the quest whose completion makes the item safe, never the one that hands it out, and for converging siblings the converging quest alone. The file's queries find candidates; they never produce rows to paste. Audit a change by comparing the parsed item-to-quest pairs before and after, not by reading a raw diff.
5. **Quest-starting item.** Add `[itemId] = { questId, racesMask, classesMask }` to `Quest-Starting-Items-{Flavor}.lua`. Drop both masks (`{ questId }`) only when both are 0; otherwise write both, with 0 for the unrestricted one.
6. **Class reagent.** Add to `ns.CLASS_REAGENTS[CLASS_TOKEN]` in `Class-Reagents-{Flavor}.lua`. It is seed data: a row added after release reaches only characters not yet seeded, so say so in the release notes.
7. **Anything no query or rule can express** belongs on the player's own Erase List, not in `Data/`.

A **new data file** goes into all seven folders (declared empty where it has no rows), into each TOC's own folder lines, and gets an entry in `ns.DIAGNOSTIC_DATA_SOURCES`; the Diagnostic Tools panel builds its Data tab row from that entry alone.

## Adding a New Event

1. Add the name to `ns.EVENT_NAMES` in `Features/Core.lua`.
2. Add `EVENT_NAME = "OnEventName"` to `EVENT_HANDLERS` in the same file, named for the event.
3. Define `ns:OnEventName(...)` in the file that owns it, Core or any feature file loaded after Core.

The dispatcher and the Event Registration probe read `ns.EVENT_NAMES`, and the Event Log records whatever the dispatcher hands it, so nothing else needs updating. An event a flavor's client lacks throws when registered, so a flavor-only event goes with a flavor-only feature (Style Guide → COMPATIBILITY).

## Adding a New Setting

1. Add the key and its default to `ns.DATABASE_DEFAULTS.profile` in `Data/Default-Settings.lua`. Settings live in the profile; only a character's own lists and markers belong in `char`, and only reset-proof state in `global`.
2. Add the widget to its feature's `Options/Options-{Feature-Name}.lua` builder, reading and writing `ns.db.profile.<key>`, with an order inside that section's block of ten. A feature switch is built with `ns.OptionsFeatureToggle` and also added to `FEATURE_TOGGLES` in `Options-General.lua`. A control that only means anything while a switch is on is hidden while it is off, never greyed. A setting that prints to chat gets an `ns.OptionsExample`. A new feature gets a new fragment, listed in each TOC before the panel that calls it and added to that panel's section list.
3. If the setting changes what the eraser would pick, pair `ns:InvalidateCache()` with `ns:RefreshDisplay()` in its `set`, as the junk-kind checkboxes and the value-cap controls do, or the mini-map icon stays stale until the next bag update.
4. Add its strings to `Locales/enUS.lua`; the Localization Review carries them into the other ten.

Changing a shipped default reaches every player who never changed that setting, because AceDB strips default-valued keys from the saved table at logout, so a changed default belongs in the release notes.

Magic Eraser writes no macros and sends no cross-player chat, so neither ceiling in Style Guide → MESSAGES → Message Length constrains a new string; every player-visible line is a local print or an options label, and the practical limit is that a translation has to fit its widget.

## Localization

WoW ships a fixed locale set and every supported file already exists in `Locales/`, so localization is maintenance, not expansion.

- **`enUS.lua` is the source of truth** and the only file that passes the `true` default-fallback flag to `NewLocale("MagicEraser", ...)`. The other ten are owned by the Localization Review (`07 - Localization Review.md`) and are never hand-edited during ordinary work. A retired key name is never reused, because a stale translation of a reused name would silently win over the English fallback.
- **Placeholders.** `%s` and `%d` count, type and order must match `enUS` per key in every locale, or the string crashes at runtime. `string.format` has no positional placeholders, so a translation may move words around its placeholders but never reorder them. The `%s%s` pair in `CONFIRM_ERASE`, `ERASED_ITEM`, `SOLD_ITEM`, `QUEST_ITEM_READY` and `QUEST_STARTER_UNAVAILABLE` is one unit, the link then `" x5"` or an empty string, so a translation keeps the two together. Counts and money arrive pre-formatted through `ns:FormatCommaNumber` and `ns:FormatCurrency`, so each is a `%s`; turning one into `%d` errors on the first comma. The raw-number `%d`s (`BAGS_FULL_NUDGE`, `LOADING_ITEM`, `OPTIONS_STACKS`, `OPTIONS_VALUE_CAP_GOLD`, `OPTIONS_BANK_CUSHION_NOTE`) never carry one.
- **A count of one gets its own complete string**, rather than "1 bag slots": `SOLD_SUMMARY_ONE_ITEM` and `_ONE_SLOT` beside `SOLD_SUMMARY`, the same pair beside `BANK_RETRIEVED`, `CLUTTER_ITEMS_ONE` and `CLUTTER_SLOTS_ONE`, `BAGS_FULL` (none free) and `BAGS_FULL_NUDGE_ONE` beside `BAGS_FULL_NUDGE`, and `OPTIONS_BANK_CUSHION_NOTE_ONE`. Nothing branches past one, so a language with more plural forms phrases the general string as a label and a number (ruRU's `CLUTTER_ITEMS` is `"(предметов: %s)"`).
- **Item links are shown without brackets everywhere.** `ns:StripLinkBrackets` drops them and keeps the link working; `ns:PrintMessage` applies it to every chat line, and the mini-map tooltip, Erase Confirmation and `ns:GetItemDisplayName` to what they draw. A new place that shows a link routes it through one of those.
- **Game names never go in `Locales/`.** Items are stored as ids and named by `C_Item.GetItemInfo`; class tokens come from `UnitClass` and race tokens from `UnitRace`. Blizzard labels are read from their GlobalStrings: `DELETE_ITEM_CONFIRM_STRING`, `ITEM_QUALITY3_DESC` and `DELETE_GOOD_ITEM` (Manual Delete), `GAMEMENU_OPTIONS`, `SETTINGS_KEYBINDINGS_LABEL` and `KEY_BINDINGS` (the key-bindings fallback line), `NOT_BOUND` (an unbound key on the root panel), and `YES`/`NO` (Erase Confirmation). The names in data-row comments are English labels for maintainers only.
- **Not localized:** `ns.DiagnosticsStrings`, the `ns.OPTIONS_REGISTRY` names, `ns.LIST_SCOPE_GLOBAL`, `ns.ITEM_LINK_WIDGET_TYPE`, AceDB character keys, and the `category` attribute in `Bindings.xml`.

Everything else, including the Spanish file pairing and the overflow canary, is per Style Guide → LOCALIZATION and MESSAGES → Message Length.

## Common Pitfalls

- **Announcing a sale or bank move before it is confirmed**: `UseContainerItem` succeeds silently against a merchant that cannot buy, and the server can drop the call. Record the attempt (`pendingSales`, `pendingMove`) and count it only once the item has left its slot.
- **Restarting an Auto-Vend visit when you meant a pass**: the combat resume must call `StartPass`, never `BeginVisit`, or sales attempted just before combat vanish from the lines and the summary.
- **A reopened window reviving a stale timer chain**: `isSelling` and `isRetrieving` go back to true on reopen. Any new timed pass needs a generation counter checked inside every timer, as `visitGeneration` and `passGeneration` do.
- **Keying a quest-item row one step early**: a row fires on the first listed quest that is complete, so keying to the granting quest, or to one sibling of a converging pair, erases an item the player still needs. Follow the rule in the file's How We Got the Data notes, and never paste its queries' output over the table.
- **Editing one flavor folder and forgetting the others**: each folder is a complete copy, so a fix in `Data/Vanilla/` alone leaves TBC and Forever wrong. Check the same id in every folder.
- **Reading a use level from `GetItemInfo`**: `requiredLevel` is nil on a cold cache. The level lives in the data file.
- **Loosening the white-gear allowlists into exclusions**: "armor subclasses 1 to 6" would erase any subclass a later client adds or repurposes (subclass 5 is Cosmetic on modern clients). Every check in `IsWhiteGearTrash` fails toward keeping; a new one should too.
- **Erasing without re-validating**: an Erase Confirmation dialog can outlive its slot, and a second click can land before the client finishes the first. `IsCandidateCurrent` and the `GetCursorInfo` check in `PerformErase` are what stop a wrong or larger delete.
- **Answering the client's delete dialog from code**: the delete is dropped and the dialog hides anyway, leaving the item alive with no prompt. Manual Delete Assistance only clears the typing.
- **Filling the delete prompt's edit box and expecting the button to enable**: on this client it doesn't; `ClearDialog` must `Enable()` the accept button itself.
- **Moving the erase binding off its synchronous path**: a timer between the key press and `DeleteCursorItem` loses the hardware event.
- **Writing a bag range by hand**: looping `0, 4` or comparing against `NUM_BAG_SLOTS` skips WoW Forever's reagent bag and disagrees with every other scan. Walk `ns.CARRIED_BAGS` and test `ns.IS_CARRIED_BAG`; the one deliberate exception is `ns:CountFreeBagSlots`, which stops at `ns.LAST_BAG_INDEX` because ordinary loot can't go in a reagent bag.
- **Treating "no container data" as "no free slots"**: mid-loading-screen every bag reads nil. `ns:CountFreeBagSlots` returns nil for unknown, and every caller skips on it.
- **Adding eager fallbacks for a cold `GetItemInfo`**: request the data and let the bounded retry resolve it; don't parse hyperlinks.
- **Refreshing straight from `BAG_UPDATE_DELAYED`**: it fires in bursts. Go through the 0.1s `updatePending` debounce.
- **Doing the full bag work in combat**: `ProcessBagUpdate` defers the repaint and starter walk to `PLAYER_REGEN_ENABLED`; a new per-bag-update task that calls something protected must defer the same way.
- **Forgetting the level-up refresh**: consumable and ammo eligibility is level-gated, and a ding brings no bag update. The handler also records the event's own level, which the junk rules read alongside `UnitLevel`, because `UnitLevel` may not be updated yet when `PLAYER_LEVEL_UP` fires.
- **Opening the options panel by name**: works on Classic Era, returns nil on TBC Anniversary. Route by the captured `ns.generalCategoryID`.
- **Registering a list-driven panel as a built table**: the list panels and Your Current Bags must be registered as builder functions, or they render login-time data forever.
- **Editing a list from outside its panel without notifying**: an open panel will not notice. Every out-of-panel writer fires `NotifyChange` on each list panel it changed.
- **Mutating the AceDBOptions table**: `GetOptionsTable` returns a table shared with every Ace3 add-on in the session. Leave it unmodified.
- **Bypassing the dispatcher**: a feature with its own event frame escapes the diagnostics event log.
- **Calling `ns:PrintMessage` from the vend path**: it ignores the chat-report setting. Use `PrintVendMessage`.
- **Putting a setting in `global` or a list in `profile`**: a setting in `global` can't be changed by a one-off profile or restored by Reset Profile; a list in `profile` would be shared by every character on Default.
- **Reading one list of a pair**: membership is additive. Use `ns:IsIgnored` and `ns:IsOnEraseList`, never one table directly.
- **A scanner that skips the `ns:IsIgnored` gate**: `ns:GetItemDeleteReason` returns `"manual"` for a listed item without consulting protection, so a new caller that skips the gate erases an item the player protected.
- **Inferring the Erase List seed from an empty list**: only `char.eraseListSeeded` tells a cleared list from a never-seeded one, and Restore Defaults must clear it before re-seeding.
- **Assuming one sell pass clears the bags**: the server drops bulk sells. Keep the re-scan-between-passes loop.
- **A count of one read through a plural string**: branch on the count and give the singular its own complete key.
- **Listing `Bindings.xml` in a TOC**: the UI parser rejects it and the bindings never appear.
- **Renaming a key binding, or the `ignoreList` keys**: a renamed binding comes back unbound for everyone, and a renamed saved key loses every player's list.
- **Reading the hovered item through `GameTooltip:GetItem` alone**: on WoW Forever it is a wrapper marked for removal. Use `ns.GetDisplayedItem`.
- **Forcing a hovered tooltip to repaint**: calling a bag button's `OnEnter` taints it; the tooltip re-sets itself every 0.2s.
- **Adding an unsuffixed `MagicEraser.toc`**: a client falls back to it when no suffixed TOC matches, loading the add-on on clients it doesn't support.
- **"Fixing" `GetColor("ON") .. L["ENABLED"]`**: `ON`/`OFF` are palette colors and `ENABLED`/`DISABLED` the tooltip's state words; the pairing is correct.

## Contributing

Issues and PRs go on [GitHub](https://github.com/Gogo1951/Magic-Eraser/issues). Discussion happens on [Discord](https://discord.gg/eh8hKq992Q).

Bug reports should include the game version (Classic Era 1.15.x, with or without Season of Discovery, WoW Forever 1.60.x, or TBC Anniversary 2.5.x) and locale, class and level, reproduction steps, and the relevant chat output. The Diagnostic Tools panel produces copy-paste-ready reports for exactly this.

PR guidelines:

- **One concern per PR.** A locale update, a data change and a logic change are three PRs.
- **Match the house style**: 80-character section dividers, the `ns` namespace, `L["UPPER_SNAKE_CASE"]` for every player-facing string, the shared `ns.Options*` and `ns.GetColor` helpers. Run StyLua (default configuration, `--syntax lua51`) and a clean `luacheck .` before committing.
- **New saved keys** get their default in `ns.DATABASE_DEFAULTS` and let AceDB apply it. Never hand-merge, and never write `db.field = db.field or default`, which overwrites an explicit `false`.
- **Saved-data changes carry a migration.** A change to the shape, name or scope of saved data ships its own migration for the data players already have, tagged `MIGRATION (remove after YYYY-MM-DD)` 30 days past its release, per Style Guide → SAVED VARIABLES → Migration Windows. A retired key is nil'd explicitly inside that migration.
- **Data edits** keep the column-header comment and the How We Got the Data block, don't reformat existing rows, and say which flavor folders changed.
- **Output length**: nothing here sends chat or writes a macro, so neither ceiling in Style Guide → MESSAGES → Message Length applies today. A change that adds a sent message measures the decorated line in bytes against the widest-encoding locale (usually ruRU).
- **Release notes are written on GitHub by hand.** Common-Core's `.github/workflows/package.yml` explains why it carries no GitHub token; never add one.
- **Run `README-Testing.md`** on every flavor before tagging a release, and cite the step number when something fails.
- **Update this document** when the architecture or file map changes.
- **PR descriptions say what a player will notice**, in plain language, the way release notes do. Commit messages carry the developer detail.
