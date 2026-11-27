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
│   ├── Flavor.lua                            Canonical copy: ns.FLAVOR, ns.EXPANSION, ns.IS_DISCOVERY, ns.DATA_FOLDER
│   ├── Data.lua                              Locale init, identity, links, list-scope sentinel, palette and class colors, bag range, race, side and class bits, kinds, priority, value-cap choices
│   ├── Default-Settings.lua                  The AceDB defaults, ns.DATABASE_DEFAULTS: profile, char and global scopes
│   ├── Vanilla/                              Classic Era; each file returns early on Season of Discovery
│   │   ├── Quest-Items-Vanilla.lua           ALLOWED_DELETE_QUEST_ITEMS: item to the quests that make it safe
│   │   ├── Quest-Starting-Items-Vanilla.lua  ALLOWED_DELETE_QUEST_STARTING_ITEMS: quest plus race and class masks
│   │   ├── Consumables-Vanilla.lua           ALLOWED_DELETE_CONSUMABLES: food and drink with use level
│   │   ├── Meat-Fish-Vanilla.lua             ALLOWED_DELETE_MEAT_FISH: cooking meat and fish, use level or item level
│   │   ├── Ammo-Vanilla.lua                  ALLOWED_DELETE_AMMO: use level and next vendor tier
│   │   ├── Equipment-Vanilla.lua             KEEP_EQUIPMENT: whites the white-gear rule must keep
│   │   ├── Class-Reagents-Vanilla.lua        CLASS_REAGENTS: hand-kept Erase List seed, never regenerated
│   │   └── Game-IDs-Vanilla.lua              EXAMPLE_JUNK_ITEM_ID: the Auto-Vend Example's item, a single constant
│   ├── Discovery/                            Season of Discovery; loaded after Vanilla/ with the inverse guard
│   ├── TBC/                                  TBC Anniversary
│   ├── Camelot/                              WoW Forever
│   ├── Wrath/                                Forward-prep, no TOC, not packaged
│   ├── Mists/                                Forward-prep, no TOC, not packaged; ammo table empty
│   └── Mainline/                             Forward-prep, no TOC, not packaged; ammo and meat-fish tables empty
├── Features/
│   ├── Core.lua                              Version, ns.EVENT_NAMES, dispatcher, merchant-open order, AceDB init, other-client prune, mini-map move, login sequence, ns:ApplyProfile, combat-held repaint
│   ├── Migrations.lua                        Tagged MIGRATION; storage-version stamp and the version 2 reshape
│   ├── Utilities.lua                         Colors, displayed-item, stat and tooltip reads, formatting (chat and icon money), free slots, carried and bank containers, list storage, character keys and names
│   ├── Tooltip-Kit.lua                       Shared tooltip kit, copied unchanged: hooks on the game's tooltips, blocks
│   ├── Announcements.lua                     Branded player-only print: ns.BRAND_PREFIX, ns:PrintMessage; no cross-player chat
│   ├── Ignore-List.lua                       Protect Lists (code name Ignore List): reads, menu and key-binding writers, Clear confirmation, scoped writes
│   ├── Erase-List.lua                        Erase Lists: reads, key-binding add, scoped writes, class-reagent seed, Restore Defaults
│   ├── Junk-Rules.lua                        The verdict: quest state, level gates, white-gear and crafted rules, junk kinds, value cap
│   ├── Eraser.lua                            Scan, rank, erase; scan cache, junk-slot and junk-reason maps; Erase Confirmation popup
│   ├── Quest-Item-Alerts.lua                 Chat alerts when a quest item or starter becomes erasable
│   ├── Manual-Delete.lua                     Skip Typing DELETE: turns the client's type-to-confirm delete prompt into Yes/No
│   ├── Bag-Warnings.lua                      Free-slot countdown and ns:IsBagWindowOpen
│   ├── Bank-Retrieval.lua                    Moves bank junk into the bags within a slot budget; owns ns:IsBankOpen and ns:IsBankJunk
│   ├── Auto-Vend.lua                         Merchant sell queue with confirmed-sale accounting
│   ├── Auto-Repair.lua                       Repairs everything at a repairing merchant: own gold, full cost or nothing
│   ├── Tint-Junk.lua                         Junk tint on bag and bank buttons, one adapter per bag window
│   ├── Item-Tooltips.lua                     Junk or Protected block on carried items' tooltips, through Tooltip-Kit
│   ├── Key-Bindings.lua                      Binding globals and handlers, hovered-item read, ns:OpenKeyBindings, Protect List chat keys
│   ├── Menu-Kit.lua                          Shared menu kit v2, copied unchanged: plates, rows, entry kinds, cursor test
│   ├── Minimap-Menu.lua                      What the mini-map menu shows, the button's one click, the More Features flyout, open and close
│   └── Minimap-Button.lua                    LDB launcher, icon, ns:RefreshDisplay, LibDBIcon registration and ns:ApplyMinimapButton
├── Diagnostics/                              Diagnostic Tools framework, copied whole; Manifests.lua is this add-on's part
├── Includes/
│   ├── Images/
│   │   ├── Magic-Eraser.tga                  IconTexture
│   │   ├── Menu-Arrow.tga                    Menu-Kit's sub-menu arrow
│   │   └── Menu-Plate.tga                    Menu-Kit's plate art
│   └── Libraries/                            Vendored from .pkgmeta; rewritten on every release
├── Locales/
│   ├── enUS.lua                              Source strings
│   └── deDE.lua … zhTW.lua                   Translations
├── Options/
│   ├── Options-Kit.lua                       Options-Kit, copied unchanged from Common-Core (never edit here): grid, rows, switches, Examples, item list, registration, One Refresh
│   ├── Options-Utilities.lua                 Kit strings, Skip Typing locale fill, ns.FEATURES, Example item links and lines, character list tree
│   ├── Options-Eraser.lua                    Junk kinds, value cap, Erase Confirmation sections
│   ├── Options-Manual-Delete.lua             Skip Typing DELETE section
│   ├── Options-Auto-Vend.lua                 Auto-Vend section and chat-report dropdown
│   ├── Options-Bank-Retrieval.lua            Bank Retrieval section and cushion status line
│   ├── Options-Auto-Repair.lua               Auto-Repair section and its Example line
│   ├── Options-Tint-Junk.lua                 Junk Item Tint switch and color
│   ├── Options-Quest-Item-Alerts.lua         Quest Item Alerts section; its one Example line uses the flavor's lowest quest-item id
│   ├── Options-Bag-Warnings.lua              Bag-Space Warnings section
│   ├── Options-Item-Tooltips.lua             Junk Item Tooltips section
│   ├── Options-General.lua                   Root panel: welcome, mini-map, Features, Key Bindings, /Commands
│   ├── Options-Erasing.lua                   Erasing panel from ERASING_SECTIONS
│   ├── Options-Merchant-Bank.lua             Merchant & Bank panel from MERCHANT_BANK_SECTIONS
│   ├── Options-Alerts-Tints.lua              Alerts & Tints panel from ALERTS_SECTIONS
│   ├── Options-Ignore-List.lua               Protect List panel, one tree node per list
│   ├── Options-Erase-List.lua                Erase List panel, one tree node per list
│   ├── Options-Profiles.lua                  Stock AceDBOptions table, unmodified
│   ├── Options-Feedback-Support.lua          Level Up note, links, version
│   └── Options.lua                           Kit.RegisterPanel calls in tree order, /eraser
├── LICENSE                                   MIT
├── README.md                                 Players
├── README-Notes.md                           Exceptions to the Style Guide
├── README-Technical.md                       This document
└── README-Testing.md                         Manual test plan
```

- Repo-only, stripped by `.pkgmeta`: `.github/`, dotfiles, `LICENSE`, the three `README-*.md`, `Data/Wrath`, `Data/Mists`, `Data/Mainline`. `README.md` ships. No `Tests/`.
- No unsuffixed `MagicEraser.toc`, on purpose (see *Pitfalls & Why*). The three TOCs match line for line except `## Interface`, `## X-Flavor` and their data-folder lines.
- Every data folder holds the same eight files, suffixed with the folder name, each declaring its table (or, for `Game-IDs`, its constant) whole. Each TOC lists only its own folder, except Vanilla, which lists `Data/Vanilla/` then `Data/Discovery/`; each of those files opens with a guard on `ns.IS_DISCOVERY` so exactly one set is built.
- Load order, by file-scope reads:
  - Locales before `Data/Data.lua` (`GetLocale` and `ns.L` at load); `Data/Flavor.lua` before the data folders (`ns.IS_DISCOVERY`); `Data/Default-Settings.lua` after them.
  - `Features/` after all of `Data/`: `Junk-Rules.lua` reads `ns.DATABASE_DEFAULTS`, `Utilities.lua` reads `ns.PALETTE` and `ns.LAST_BAG_INDEX`.
  - `Utilities.lua` before `Announcements.lua` (`ns.GetColor`) and `Junk-Rules.lua` (`ns.GetItemStats`). `Core.lua` loads before both and before `Migrations.lua`; safe only because it calls them at `PLAYER_LOGIN`, never at file scope.
  - `Menu-Kit.lua` before `Minimap-Menu.lua` before `Minimap-Button.lua`: each takes the previous one's table or functions at file scope.
  - `Tooltip-Kit.lua` before `Item-Tooltips.lua`, which takes `ns.TooltipKit` and walks `ns.ERASE_KINDS` at file scope.
- Inside `Options/`, `Options-Kit.lua` loads first (every other file takes `ns.OptionsKit` at file scope), then `Options-Utilities.lua`, then fragments before the panels that call their builders. `ns.FEATURES`' `apply` closures look up `ns.OnValueCapToggled` and `ns.OnTintJunkChanged` when called, so their files' order does not matter. `Diagnostics/Options-Diagnostics.lua` loads inside the Options block, just before `Options/Options.lua` registers it.
- `ns.EXPANSION` is unread here; `Data/Flavor.lua` is the Style Guide's canonical copy, so it stays.
- **Expiring code:** everything tagged `MIGRATION (remove after …)`: `Features/Migrations.lua`, its TOC line and its calls in `Features/Core.lua`, plus `MoveMinimapToProfiles` and its call in `Core.lua`. Dates are on the tags; see *Migration Chain*. Nothing else is deprecated or dead.

## Architecture

### Event Loop

- One frame in `Features/Core.lua`. `ns.EVENT_NAMES` is the full event surface; `EVENT_HANDLERS` maps each to an `ns:OnXxx` name, resolved on `ns` **at fire time**, so feature files loaded after Core define their own handlers.
- No feature file creates an event frame. The dispatcher taps `ns:LogEvent` first, behind `ns.diagnostics.logging`, so the Event Log sees every event. The shared kits keep their own, outside the Event Log: Tooltip-Kit's `PLAYER_LOGIN` frame installs its hooks, and Menu-Kit creates a `GET_ITEM_INFO_RECEIVED` watcher when it requests a cold item.
- Handler owners: Core (`ADDON_LOADED`, `PLAYER_LOGIN`, `BAG_UPDATE_DELAYED`, `PLAYERBANKSLOTS_CHANGED`, `PLAYER_REGEN_ENABLED`, `MERCHANT_SHOW`), Bag-Warnings (`PLAYER_ENTERING_WORLD`, `MAIL_CLOSED`), Junk-Rules (`PLAYER_LEVEL_UP`), Quest-Item-Alerts (`QUEST_TURNED_IN`), Manual-Delete (`DELETE_ITEM_CONFIRM`), Auto-Vend (`MERCHANT_CLOSED`), Bank-Retrieval (bank pair, which also sets the bank-open flag), Key-Bindings (`UPDATE_BINDINGS`).
- `MERCHANT_SHOW` → Core's `ns:OnMerchantShow`, which runs `ns:RepairAtMerchant` then `ns:VendAtMerchant`: repair first, then sell.
- `ns:OnPlayerLogin` order matters: raw-table migrations (`ns:MigrateSavedVariables`, `MoveMinimapToProfiles` while `global.minimap` exists) → `AceDB:New` → `PruneOtherClientCharacters` → `char.classToken` (`false` when `UnitClass` answers nil) → `ns:RegisterOptionsPanels` → profile callbacks → `ns:RegisterMinimapButton` → welcome → `ns:SeedEraseList` → bag-space and quest-starter baselines → `ns:RefreshDisplay` → `C_Timer.After(0, ns.SetupTintHooks)`.
- `ADDON_LOADED` fires for every add-on, before login too; `ns:OnAddonLoaded` only retries the tint hooks once `ns.db` exists. `UPDATE_BINDINGS` can also land before login, so everything `ns.RefreshSettings` reaches guards on `ns.db`.
- `BAG_UPDATE_DELAYED` is debounced behind `updatePending` into one `ProcessBagUpdate`; `PLAYERBANKSLOTS_CHANGED` joins the same debounce so bank tints repaint.
- `QUEST_TURNED_IN` work waits a moment so the server has flagged the quest before `C_QuestLog.IsQuestFlaggedCompleted` is read.

### Combat Lockdown

- **Refuse and print, no queue:** `ns:OpenOptionsPanel` (Style Guide → Combat Guard), `ns:OpenKeyBindings` (`CHAT_KEY_BINDINGS_IN_COMBAT`), `ns:RunEraser` and `ns:PerformErase` (`COMBAT_LOCKOUT`; pickup and `DeleteCursorItem` are protected). `PerformErase` re-guards because a confirmation dialog can stay open into combat. The menu's Erase and Options rows and their button clicks reach these same functions, so they refuse the same way.
- **Bag walk defers:** in combat `ProcessBagUpdate` drops the cache, sets `refreshAfterCombat` and repaints only the tints (`ns:RefreshTints`). The icon and menu repaint, `ns:CheckQuestStarters` and `ns:RedrawTintWindows` wait for `ns:OnPlayerRegenEnabled`. Level-up, quest turn-in and the eraser's retry ask through `ns:RefreshWhenOutOfCombat`, which holds behind the same flag (without the tint repaint); any held refresh replays the whole set, starter check and window redraw included. The bag-space check still runs.
- The combat tint repaint is not free: `ns:IsJunkSlot` runs a full scan when the cache is invalid, so it walks the bags and can spend a scan retry.
- **Auto-Vend defers and resumes:** `ns:VendAtMerchant` and each `ProcessSellQueue` tick stop in combat, set `vendPending`, announce once through `PrintVendMessage`. `ns:ResumeDeferredVend` (every combat end) starts a new *pass* if Auto-Vend is on and `MerchantFrame` is shown.
- **Bank Retrieval ends:** `StartPass` and each `ProcessMoveQueue` tick call `FinishPass` in combat or with the bank closed; nothing resumes.
- **Allowed in combat:** the two list key bindings, the menu's Protect, Clear and toggle rows, and quest-turn-in alerts, starter check included; nothing they call is protected.
- **No combat check:** `ns:RepairAtMerchant`, the item tooltips, and the full-bags line. The last two call `ns:FindItemToDelete`, so in combat, where every bag update drops the cache, the first read after one walks the bags.

### Main Pipeline: Scan → Evaluate → Rank → Erase

- **Scan** (`ForEachCandidate`, `Features/Eraser.lua`): walks `ns.CARRIED_BAGS`, skips slots with no hyperlink, skips `ns:IsIgnored` first. That gate is the only thing making the Protect List beat the Erase List.
- **Evaluate:** `ns:GetItemDeleteReason(itemId, rarity, sellPrice, bag, slot)` (see *Junk Rules*), then `ns:IsOverValueCap(totalValue, reason)`; over-cap is not a candidate.
- **Rank** (`IsBetterDeletionCandidate`): projectiles (`PROJECTILE_CLASS`, `Enum.ItemClass.Projectile` or its fallback) after everything else, then lowest stack value, then `ns.DELETE_PRIORITY`, where Erase List entries win ties. Strict `<` throughout, so a full tie goes to the stack the walk found first.
- **Erase:** `ns:RunEraser` → Erase Confirmation popup if `ns:NeedsSafetyConfirm` (reads `eraseConfirmEnabled`), else `ns:PerformErase`: `IsCandidateCurrent`, clear cursor, pick up, check `GetCursorInfo` id, `DeleteCursorItem`, sound, print `ERASED_ITEM` (link and count only, never value or reason), invalidate, delayed repaint. No candidate prints `BAGS_CLEAN_CONGRATS` plus `BAGS_CLEAN_HINT`.
- `ForEachCandidate` has one caller, `ns:FindItemToDelete`. The same walk fills the Clutter Report totals (`ns:GetReclaimSummary`), `cachedJunkSlots` (key `bag * SLOT_KEY_STRIDE + slot` → item id) for the tint (`ns:IsJunkSlot`), and `cachedJunkReasons` (item id → reason) for the item tooltips (`ns:GetJunkReason`). `ns:GetReclaimSummary` reads zeros after an invalidation until a `ns:FindItemToDelete` has run; `ns:GetJunkReason` and the full-bags line (`FullMessage`) call it first themselves.
- `ns:GetItemDeleteReason` is shared by the eraser, Auto-Vend, Bank Retrieval (via `ns:IsBankJunk`) and the tint. `ns:IsOverValueCap` sits outside it, applied only on the erase path.
- **Bag ranges:** `ns.LAST_BAG_INDEX` (`Data/Data.lua`) states the general range once. `ns.CARRIED_BAGS` / `ns.IS_CARRIED_BAG` (`Features/Utilities.lua`) add `Enum.BagIndex.ReagentBag` only when `CharacterBankTab_1` exists: Classic Era and TBC define `ReagentBag` too, but their container 5 is the first bank bag. `ns:CountFreeBagSlots` alone stops at `ns.LAST_BAG_INDEX`.
- Chosen once at file load in `Utilities.lua`, never re-checked: `ns.GetDisplayedItem`, `ns.GetItemStats`, `ns.GetTooltipLines`, the slot tooltip getter, `ns.CARRIED_BAGS`, `ns.BANK_CONTAINERS`, `ns.LEGACY_BANK_CONTAINER` (nil on clients with character bank tabs).

### Refresh Paths

- **Two paths, never swapped:**
  - `ns:RefreshDisplay` (`Features/Minimap-Button.lua`), for bag changes: invalidate, `ns.UpdateMinimapIcon`, `ns.RefreshMenu`, `ns:RefreshTints`. Never notifies an options panel. Returns early with no data object.
  - `ns.RefreshSettings` (Options-Kit), for settings changes: `NotifyChange` on every `ns.OPTIONS_REGISTRY` name, `ns.RefreshMenu`, `ns.UpdateMinimapIcon`. Does not invalidate.
- **Why apart:** a `NotifyChange` redraws an open list page and clears the item ID half-typed into its add box; loot landing mid-typing must not do that.
- Every settings writer ends in `ns.RefreshSettings`: `Kit.FeatureSwitch`'s `set`, every other options `set`, `Kit.ItemList` after each add, remove, restore or clear, every menu row click (`AfterChange`), the out-of-panel list writers, `ns:OnUpdateBindings`, `ns:ApplyProfile`.
- A writer that changes the verdict calls `ns:InvalidateCache()` and `ns:RefreshDisplay()` first (junk kinds, value cap and its toggle's `ns.OnValueCapToggled`, every list write), since `ns.UpdateMinimapIcon` reads the cache as it stands.
- Other `NotifyChange` callers repaint only their own panel: `Kit.WarmItems` as cold item rows load, and the Diagnostics framework on its panel.

### Caching

- **Item reads are `C_Item.*`** everywhere; WoW Forever has no bare legacy globals. The exception is `ns.GetItemStats`: `C_Item.GetItemStats` or the legacy `GetItemStats`.
- **Cold `C_Item.GetItemInfo`:**
  - The three scanners (`ForEachCandidate`, `ScanAndVend`, `ScanBank` via `ns:IsBankJunk`) request the data and retry behind each file's own `MAX_SCAN_RETRIES`. Auto-Vend and Bank Retrieval act on nothing while a retry is pending, then go ahead with what loaded.
  - The eraser's retry (`ScheduleScanRetry`) allows one pending timer (`retryPending`) and resets its count in `ns:InvalidateCache` unless the invalidation is the retry itself (`inScanRetry`). A retry firing in combat spends a try without scanning. Retries key on a missing item name only.
  - Tint: a cold item stays untinted until the next repaint. On the bank, `ns:IsBankJunk` requests the data (its third return is `true` while cold), so every bank repaint can issue requests.
  - Menu: a cold Protect List item draws a `LOADING_ITEM` row plus a request, and the menu redraws after `LOADING_RETRY`, one pending retry at a time (`state.retryPending`).
  - Options: cold list rows render `LOADING_ITEM` and go to `Kit.WarmItems`, one poll chain per registry name over every cold id handed in, `NotifyChange` only when an id resolves, bounded by the kit's attempt cap. `ns.ExampleItemLink` uses the same chain for the example lines' items. Cold rows in the Add from Bags picker are not warmed.
  - `IsCandidateCurrent` fails on a cold read, so a Yes on the popup can print `ERASE_CANDIDATE_CHANGED` when nothing changed.
- **Use levels never come from `GetItemInfo`** (`requiredLevel` is nil when cold); consumables, meat and fish, and ammo carry them in their data rows. A row with no level reads as 1.
- **White-gear verdict** (`whiteGearVerdicts`, `Junk-Rules.lua`): per item id for the session, never cleared; a keep (`false`) from `KEEP_EQUIPMENT` or a missing API is stored too. A nil read is not stored, and a nil stat read is re-read every scan but never retried (the item keeps its name).
- **Scan cache** (`cachedItem`, `isCacheValid`, Clutter totals, `cachedJunkSlots`, `cachedJunkReasons`): dropped by `ns:InvalidateCache`, which every list edit, junk-kind or value-cap change, profile change, erase, bag update, level-up, turn-in, seed that added rows and retrieval pass that moved something calls. `ns:RefreshDisplay` invalidates before recomputing, so the cache only serves reads between repaints (menu, Erase, tint, tooltips, full-bags line, diagnostics).

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
- **Starter reasons** (`ns:GetQuestStarterReason`):
  - `"questIneligible"` when `RequiredRaces`/`RequiredClasses` excludes the character (`bit.band` against `ns.RACE_BITS`/`ns.CLASS_BITS`, tokens from `UnitRace`/`UnitClass`; Undead is `Scourge`). Checked before the quest-item row is looked at.
  - A race with no bit (Forever's Skyborne, whose bits 2^32/2^33 the 32-bit `bit` library can't hold) is gated by `ns.SIDE_RACE_BITS[UnitFactionGroup]`: only a mask naming none of its side's races excludes it; with no faction yet it stays ungated. A class with no bit is never gated (`IsGatedOut` treats a 0 player bit as open). Nil or `0` mask = no gate.
  - Race and class bits are cached on the first call, even if the unit read was nil then (they stay 0 for the session); side bits are cached only once the faction answers.
  - `"quest"` once its quest is complete, **unless** the item also has a quest-item row, which is keyed to a later quest and decides instead.
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
  - Slot read: `C_TooltipInfo.GetBagItem` or the scan tooltip's `SetBagItem`; the Classic/TBC main bank (`ns.LEGACY_BANK_CONTAINER`) reads as an inventory slot through `BankButtonIDToInvSlotID`, and reads nil without it.
  - Stackable crafts (food, potions) carry no line; they stay with their own kind.

### Junk Kinds and Erase Confirmation

- `ns.ERASE_KINDS` (`Data/Data.lua`) lists each kind `{ reason, labelKey, descKey }` in panel order; `"manual"` has none. Stored in `profile.junkKinds`; `crafted` and `meatFish` default off.
- `ns:IsJunkKind`: `"manual"` always true; a kind with no saved answer falls back to `DEFAULT_JUNK_KINDS` (the defaults table), anything else unreadable counts as junk.
- Enforced once, in `ns:GetItemDeleteReason`, so an unchecked kind is never erased, sold, retrieved or tinted. Quest Item Alerts calls `ns:GetQuestStarterReason` directly, so `ShouldAlert` checks `ns:IsJunkKind` itself.
- **Erase Confirmation** (`MAGICERASER_CONFIRM_ERASE`, `eraseConfirmEnabled`, read through `ns:NeedsSafetyConfirm`): one switch for every kind, Erase List included. Candidate passed as dialog `data`; `preferredIndex = 3`. `IsCandidateCurrent` re-checks slot id and stack count, protection, cached data, verdict and cap; a stale dialog prints `ERASE_CANDIDATE_CHANGED` and erases nothing. Cursor mismatch prints `CURSOR_TOO_FAST`.

### Skip Typing DELETE

- `Features/Manual-Delete.lua`; code, settings and locale keys still say Manual Delete (`manualDeleteAutoFillEnabled`, `manualDeleteNoValueOnly`, `OPTIONS_MANUAL_DELETE_*`). The only feature acting on a delete the eraser didn't start. Unrelated to Erase Confirmation.
- The player-facing name carries the client's own delete word: three locale strings hold `%s`, filled with `DELETE_ITEM_CONFIRM_STRING` once at load in `Options/Options-Utilities.lua`, before the kit or the menu reads them.
- **The prompt cannot be removed**: `DeleteCursorItem` needs a hardware event, so the player's Yes is what makes it legal. Never call `StaticPopup_OnClick`, click the accept button, or call `OnAccept` from code: the delete drops while the dialog hides, leaving the item undeletable.
- Only `FILL_DIALOGS` (the good-item pair) have an edit box; the plain pair is left alone.
- `ClearDialog`: sets the box to `DELETE_ITEM_CONFIRM_STRING`, hides it, **enables the accept button itself** (the secure edit box's `OnTextChanged` doesn't fire for code-set text), cuts `TYPE_IT_OUT_LINE` (built from the client's `DELETE_GOOD_ITEM`, cut from both dialogs), calls `dialog:Resize()`. Lasts one showing. Needs the dialog's `GetEditBox`, `GetButton1`, `GetTextFontString`, `Resize`; without them it silently does nothing.
- Deferred one frame (`C_Timer.After(0)`): Blizzard's handler and ours answer the same event in no fixed order; `FillDeletePrompt` re-checks scope then.
- Scope: with `manualDeleteNoValueOnly` (the default) only a sale price of exactly 0 qualifies, and an uncached item prices nil and keeps the prompt; off, every typed prompt qualifies. Bound-ness deliberately ignored (armor tokens are tradable).

### Auto-Vend

- `Features/Auto-Vend.lua`: `ScanAndVend` builds `sellQueue` (not ignored, sells, has a verdict, Erase List included), cheapest first; `ProcessSellQueue` sells one per tick, re-checking slot id and protection, not the verdict.
- **Shift skips the visit:** `ns:VendAtMerchant` returns on `IsShiftKeyDown()` before `BeginVisit`. Every summary ends with `AUTO_VEND_SHIFT_HINT`.
- **Visit vs. pass:** `BeginVisit` (each `MERCHANT_SHOW` with Auto-Vend on) bumps `visitGeneration` and clears `announcedSales`, `pendingSales`, `saleLines`, summary totals. `StartPass` resets only `isSelling`, `sellIndex`, `scanRetries`, `vendPasses`. The combat resume calls `StartPass` only.
- **Every timer carries `visitGeneration`** and drops out when stale; `ns:OnMerchantClosed` bumps it before scheduling its own flush. So reopening a merchant within `CLOSE_CONFIRM_SECONDS` drops the last visit's summary and unconfirmed sales (a Shift-skipped reopen doesn't bump, so that flush still prints).
- **Confirmed sales:** `UseContainerItem` is optimistic (a dead vendor accepts silently). Attempts go to `pendingSales` (`"bag:slot:itemId"`); `ConfirmSales` counts one only when the slot no longer holds it. Runs at the top of every `ScanAndVend` and once more `CLOSE_CONFIRM_SECONDS` after close. `announcedSales` stops double counts.
- **Multi-pass:** the server drops bulk sells, so it re-scans from live bags up to `MAX_VEND_PASSES`.
- **Switch off mid-visit** (panel, or the menu's Toggle row): `ScanAndVend` and `ProcessSellQueue` re-read `autoVendEnabled` each tick and stop; attempted sales still confirm, and the close flush still prints, since it never re-reads the switch. **Switching on mid-visit sells nothing**: only `MERCHANT_SHOW` starts a pass.
- **Merchant close also runs the bag-space re-check**, inside the flush, whether or not Auto-Vend is on (`ns:OnMerchantClosed` has no enabled guard).
- **Chat:** all output through file-local `PrintVendMessage` (no-op unless `autoVendMessagesEnabled`). The dropdown maps No Chat / Summary / Every Sale onto `autoVendMessagesEnabled` + `autoVendSummaryEnabled`. Totals and sale lines accrue whatever the mode; at the close flush the summary prints first, then, under Every Sale, the held sale lines (`saleLines`), so the visit reads total on top.

### Auto-Repair

- `Features/Auto-Repair.lua`, `ns:RepairAtMerchant`, off by default (`autoRepairEnabled`). Runs from `ns:OnMerchantShow` before Auto-Vend.
- Gates, in order: the switch; Shift held as the merchant opens (the same skip as Auto-Vend); `CanMerchantRepair`; `GetRepairAllCost` reporting something to repair at a cost `GetMoney()` covers. Short of the full cost it does nothing and prints nothing: never a partial repair.
- `RepairAllItems(false)`: the player's own gold, never guild funds. Then one plain `ns:PrintMessage` (`REPAIRED_GEAR`, cost through `ns:FormatCurrency`), right after the call; nothing confirms the repair landed. No chat setting of its own; Auto-Vend's dropdown doesn't reach it.
- The Merchant & Bank Context's "Would repair now" line re-runs the same gates in the same order.

### Maximum Value to Erase

- `ns:IsOverValueCap` (`Junk-Rules.lua`): off unless `valueCapEnabled`; compares **stack** value against `ns:GetValueCapGold() * ns.COPPER_PER_GOLD`.
- `ns:GetValueCapGold` snaps a saved amount to the nearest `ns.VALUE_CAP_CHOICES` entry at or above it (the largest when above all), so the dropdown never shows blank. No zero choice, on purpose.
- `"manual"` is never capped: a list entry is the player's call, not a rule's guess.
- Callers: `ForEachCandidate`, `IsCandidateCurrent`, and the diagnostics tally. **Auto-Vend and Bank Retrieval never consult it**: selling an over-cap stack pays the player. So the bank tint marks over-cap stacks.
- The dropdown labels each choice with the client's `GOLD_AMOUNT` and needs `sorting` from `ns.VALUE_CAP_CHOICES`, or AceConfig orders by label text.

### Bank Retrieval

- `Features/Bank-Retrieval.lua`, one pass per `BANKFRAME_OPENED` while `bankRetrievalEnabled`.
- **Bank-open flag:** file-local `isBankOpen`, set by `ns:OnBankframeOpened` / `ns:OnBankframeClosed`, read everywhere else through `ns:IsBankOpen` (the bank tints, the bag-space hold, the Merchant & Bank report). Never `BankFrame`, which Baganator keeps hidden while its own bank window is open.
- The opener sets the flag and repaints the tints at once and again after `BANK_SETTLE_SECONDS`, whatever the switch; the closer clears it, repaints, and re-checks bag space.
- Waits `BANK_SETTLE_SECONDS` (bank reads empty at first), `ScanBank` queues junk **most valuable first** (the budget may run out), `ProcessMoveQueue` moves one per `MOVE_INTERVAL_SECONDS`.
- `ns.BANK_CONTAINERS` / `ns.IS_BANK_BAG` (`Features/Utilities.lua`): `Enum.BagIndex.CharacterBankTab_N` where present, else `BANK_CONTAINER` plus bank bags above the carried range. Warband tabs never included.
- `ns:IsBankJunk(itemId, link, bag, slot)` is the one bank verdict, shared with the tint: protection first, no value cap, items with no price included.
- **Budget** (`GetMoveBudget`): free general slots, less `bagsFullThreshold` **only while Bag-Space Warnings are on** (the threshold is hidden otherwise). Nil free count → no pass. Computed once in `StartPass`, before the scan and its retries, never recomputed.
- **Confirmed moves:** `pendingMove` counts only once the bank slot no longer holds it; the queue-end branch schedules one extra tick for the last move. Budget spent per attempt; a shifted slot is skipped free. A pass cut short (bank closed, combat) drops the last unconfirmed move from the summary.
- `passGeneration` orphans an old chain on reopen. `FinishPass` is the single exit: summary only if something moved, through plain `ns:PrintMessage` (no chat setting), then resets, so a second call is silent. `scanRetries` resets in the opener, not `StartPass`.
- Switching off mid-pass doesn't stop the current pass (only `isRetrieving` and the generation are checked).

### Tint Junk

- `Features/Tint-Junk.lua`, gated on `tintJunkEnabled`, color `tintColor`. Purely visual.
- Verdict: carried bags → `ns:IsJunkSlot` (the eraser's scan, so Protect List, cap and kinds match the eraser exactly); bank, only while `ns:IsBankOpen()` → `ns:IsBankJunk`.
- `CreateTint`: a texture in the icon's draw layer, one sublevel up, so it sits under count and border.
- **`TINT_ADAPTERS`** `{ name, folder, install, redraw }`: default bags (Classic `ContainerFrame_Update` + `BankFrameItemButton_Update`; Forever frames' `UpdateItems` + `CamelotBankPanelItemButtonMixin.Refresh`), Baganator (invisible corner widget), Bagnon and Bagnonium (`Item.Update`), AdiBags (`ItemButton` prototype), BetterBags (Events messages), ArkInventory (`API.ItemFrameUpdated`), ElvUI (`B:UpdateSlot`, only while `B.Initialized`). Each passes `PaintButton` the real Blizzard bag/slot and the item it shows; offline, guild or vault views get `ClearButton`.
  - Forever's bank hook works only because the button pool copies the mixin when it creates buttons, after the hook.
  - Bagnon guild and vault windows are refused by window id: a guild button's `GetBag` returns a tab number that looks like a carried bag.
  - Baganator: the player can remove the corner widget (`TINT_BAGANATOR_WIDGET_LABEL`) in Baganator's settings, which turns the tint off there; the widget's `OnHide` clears it.
- `paintedButtons` (weak-keyed) remembers bag, slot, item per button; `ns:RefreshTints` repaints them (plus every bank button) against the remembered item, so a carried button whose item left clears until its window redraws it. Callers: `ns:RefreshDisplay`, `ns.OnTintJunkChanged`, the bank opener and closer, `ProcessBagUpdate`'s combat branch.
- `ns:RedrawTintWindows` checks only that the tint is on; its callers (`ProcessBagUpdate` out of combat, the combat-end replay) keep it out of combat. Asks adapters with a `redraw` (Baganator's `RequestItemButtonsRefresh`, which rebuilds every button).
- Install: once at login + one frame, again on later `ADDON_LOADED`; only adapters whose folder is loaded; one that hooked nothing is retried; never hooked twice. `ns:GetTintAdapterNames` feeds diagnostics.

### Junk Item Tooltips

- `Features/Item-Tooltips.lua`: one `Tip.OnItem(fn, { bagsOnly = true })` registration on Tooltip-Kit; `tooltipsEnabled` is read at each show (a kit hook can't be removed).
- Protected first: `ns:IsIgnored` → `TOOLTIP_PROTECTED` with the list that protects it, this character's checked first, as `ns:IsIgnored` does.
- Otherwise `ns:GetJunkReason(itemId)` → its label through `KIND_LABELS` (each `ns.ERASE_KINDS` reason to its checkbox label, `"manual"` to `TAB_ERASE_LIST`); no reason, no block. `TOOLTIP_ERASED_NEXT` on the right when `ns:FindItemToDelete`'s candidate has the same id.
- **Per item id, not per stack:** the reason is whichever junk stack of that id the scan saw, so every carried stack of the id shows it (a crafted white beside a plain one of the same id, say). An over-cap stack is never a candidate, so it shows nothing.
- Route (the kit's, picked at `PLAYER_LOGIN`, after other add-ons' hooks): the tooltip-data post-call where `GameTooltip` has no `OnTooltipSetItem` script (WoW Forever), bag-checked by the owner's `GetBagID`; else a `hooksecurefunc` on `GameTooltip:SetBagItem` (Classic Era, TBC). The kit's carried range is its own (`NUM_BAG_SLOTS + NUM_REAGENTBAG_SLOTS`), not `ns.CARRIED_BAGS`.
- The Eraser Context prints the route through `ItemTooltipRoute` (`Manifests.lua`), which mirrors the kit's `UsesTooltipData`.

### Bag-Space Warnings

- `Features/Bag-Warnings.lua`, opt-in (`bagsFullNudgeEnabled`), threshold `bagsFullThreshold`.
- `ns:CountFreeBagSlots` returns nil, not 0, when no container has answered; only bag family 0 (or nil) counts.
- At zero free, `FullMessage` names how many slots junk holds (`BAGS_FULL_JUNK`, `BAGS_FULL_JUNK_ONE`) from `ns:GetReclaimSummary`, after its own `ns:FindItemToDelete`; with no junk, plain `BAGS_FULL`.
- Warns only on a **drop** below `lastSeenFree` at or under the threshold. Baseline updated before the other guards; seeded at login (`ns:SeedBagSpaceBaseline`). `BAG_SETTLE_SECONDS` hold after each `PLAYER_ENTERING_WORLD`.
- Held while merchant, mail or bank is open (`ns:IsBagWindowOpen`): `MerchantFrame` and `MailFrame` read live, the bank through `ns:IsBankOpen`. Each close re-checks once: mail and bank at once, the merchant inside Auto-Vend's close flush, skipped if a new visit began meanwhile.

### Quest Item Alerts

- `Features/Quest-Item-Alerts.lua`. Prints only while `questAlertsEnabled` and the kind is checked; items are still marked while off, so re-enabling doesn't replay. Protected items never announce and stay unmarked.
- `ns:CheckQuestStarters`: table lookup first, then `ns:GetQuestStarterReason`; marks `announcedStarters` (session, by id). `ns:SeedQuestStarterAlerts` at login marks what is already erasable. Bag updates and login scan starters only.
- `ns:OnQuestTurnedIn` (delayed): starter check (even in combat), then `QUEST_ITEM_READY` per held item whose row lists this quest, skipping `announcedStarters`. **Plain quest-item rows alert only here**, at turn-in of a quest their row lists. A starter with a quest-item row gets its `"quest"` alert here; a `"questIneligible"` one is announced and marked by the starter check, because the gate runs before the row is read. `alertedItems` is per callback, so multi-quest rows alert at each turn-in.
- Alerts append the total carried count (`StackSuffix`).

### Mini-map Button and Menu

- **Button** (`Features/Minimap-Button.lua`): `ns.dataBrokerObject` is an LDB `"launcher"` built at file scope. `OnEnter` → `ns.ShowMenu(self, "hover")`; `OnClick` → `ns.RunButtonClick(button, self)`. `OnLeave` is empty: the menu closes itself.
- **One click:** `ns.RunButtonClick` (`Minimap-Menu.lua`) answers Left-Click only, through `ns.ToggleMenu`: opens and holds the menu (`state.held`), or closes it when this launcher already holds it. A hover-opened menu isn't held, so the click after a hover holds it rather than closing it. Every other click, Shift or not, does nothing; their jobs live on the rows, and no row names a click. **Why:** players' hands know Right-Click as Protect, so it never gets another job.
- `ns:RegisterMinimapButton` registers with LibDBIcon under `ADDON_NAME` against `ns.db.profile.minimap` at login; `ns:ApplyMinimapButton` (`LibDBIcon:Refresh`) re-places and shows or hides it, from the Enable Mini-map Button switch and `ns:ApplyProfile`.
- On Camelot and Mainline it sizes, anchors and masks the icon directly (mask added once, at registration), never via `SetButtonIcon` (its `ResetButtonIcon` calls `icon:UpdateCoord()`, which errors if another add-on replaced the icon).
- `ns.UpdateMinimapIcon` sets only `ns.dataBrokerObject.icon` (the candidate's, else `ns.DEFAULT_ICON`), so LibDBIcon and every LDB display follow.
- **Renderer** (`Features/Menu-Kit.lua`, `ns.MenuKit`): the shared kit v2 (Style Guide → MINIMAP MENU), copied unchanged; its header comment names other add-ons because it is the same file everywhere. This menu still drives it through v1's `Kit.CreatePanel` + `Panel:Render(entries)`, which v2 keeps; the entry kinds are documented at the top of the file. The kit inserts a spacer before every heading itself; the menu file adds none.
- **Contents** (`Features/Minimap-Menu.lua`, `BuildMainEntries`): header and version; Lowest-Value Item (value through `ns:FormatCoins`) with Erase and Protect rows, or `BAGS_CLEAN_CONGRATS` with `BAGS_CLEAN_HINT` as a note under it; Auto-Vend block (status, description, Toggle); Clutter Report, only while there is clutter; this character's Protect List (sorted, `LIST_MAX` rows then `MENU_MORE`, Clear row), omitted while empty; More Features label with on and off counts; Options row. The Protect List sits last of the reports because it is the only one whose length varies.
- `AddClutterReport` relies on `ns:FindItemToDelete` having run earlier in `BuildMainEntries`: the totals are that scan's side effect.
- **Action rows** (`ActionRow(label, run, tooltip)`): blue, nothing on the right; the click runs the job, then `AfterChange` (`ns.RefreshSettings`). Erase `ns:RunEraser`; Protect adds the candidate via `ns:AddToIgnoreList` (add-only, one chat line from `ns.IGNORE_LIST_MESSAGE_KEYS`); Toggle flips `autoVendEnabled`; Clear Protect List `ns:ConfirmClearIgnoreList`; Options hides the menu and opens the panel.
  - Before `ns.db` exists `ns.ShowMenu` draws nothing, so the button does nothing.
- **Protect List rows:** a click removes the item (`ns:RemoveFromIgnoreList`, prints `PROTECT_LIST_REMOVED`). Their remove icon shows only on hover (`rightOnHover`): Menu-Kit v2 hides a marked row's right side off hover after each draw and on leave, in every panel, having measured it first, so the width never shifts. `ApplyHoverIcons` repeats the same on the main menu's pooled rows.
- **Clear Protect List** (the row) asks first through `MAGICERASER_CLEAR_PROTECT_LIST` (the panel's `OPTIONS_LIST_CLEAR_CONFIRM` text, `preferredIndex = 3`), and does nothing on an empty list.
- **More Features flyout** (`FLYOUTS.features`): every `ns.FEATURES` entry without `block`, one toggle row each, its page heading as the label, caption and description as the tooltip; its `apply` writes the value where it has one, else the row writes it. A child of the menu, so it hides with it; entering any other row closes it (`menu.onEnterRow`).
- **Open and close:** `ns.ShowMenu(anchor, how)` positions away from the screen edges (`PositionMenu`, which also picks the flyout side and tooltip anchor); a launcher already showing it keeps its place. An `OnUpdate` closes it `HOVER_CLOSE_DELAY` (or `CLICK_CLOSE_DELAY` after a click, which sticks for later hovers on that anchor until it closes) once the cursor is off the button, menu and flyout, or as soon as the anchor hides. Escape closes it through `UISpecialFrames` (frame name `ADDON_NAME .. "Menu"`).
- `Kit.IsCursorOver` reads `GetCursorPosition` rather than `IsMouseOver`, so a controller's virtual cursor keeps the menu open; every row is a plain left click for the same reason.
- `ns.RefreshMenu` redraws in place and is a no-op while hidden; `ns.IsMenuShown`, `ns.IsMenuFrame` and `ns.HideMenu` round out the API.

### Key Bindings

- `Bindings.xml` names `MAGICERASER_ERASE`, `MAGICERASER_ADD_TO_IGNORE_LIST`, `MAGICERASER_ADD_TO_ERASE_LIST`; handlers and `BINDING_NAME_*` globals in `Features/Key-Bindings.lua`, all in `.luacheckrc` `globals`.
- `MagicEraser_Erase` only calls `ns:RunEraser`; keep it synchronous so the key press stays the hardware event.
- List bindings read the hovered item via `ns.GetDisplayedItem` (`TooltipUtil.GetDisplayedItem` or `GameTooltip:GetItem`), only while `GameTooltip:IsShown()`; no other tooltip is read, and nothing hovered prints `NO_HOVERED_ITEM`. Add-only, this character's list; `ns:AddToIgnoreList` returns `"already"`/`"moved"`/`"added"`, `ns:AddToEraseList` `"protected"`/`"already"`/`"added"`, each turned into one chat line (nil before `ns.db`, silent). The Protect List keys (`ns.IGNORE_LIST_MESSAGE_KEYS`) are shared with the menu's Protect row.
- General panel's Key Bindings rows show `GetBindingKey` or **Not Bound** plus Set Key → `ns:OpenKeyBindings`, which tries at click time: `Settings.KEYBINDINGS_CATEGORY_ID`, a protected search of `SettingsPanel`'s categories, then `KeyBindingFrame`, else prints `KEY_BINDINGS_LOCATION`. `UPDATE_BINDINGS` → `ns.RefreshSettings`.

### Protect and Erase Lists

- Players see **Protect List**; code says Ignore List (`ignoreList`, `ns:IsIgnored`, `IgnoreList` registry key, the binding name). Locale keys say `PROTECT_*` where the copy is new. Never rename the saved keys or the binding: saved lists and bound keys would be lost.
- Each list kind is a pair, `ns.db.char.<list>` and `ns.db.global.<list>`; membership is additive (`ns:IsIgnored`, `ns:IsOnEraseList`).
- Storage goes through `ns:GetCharacterListForScope(listKey, scopeKey, createIfMissing)` and friends in `Features/Utilities.lua`. The played character resolves via `ns.db.char` (live table); others via `ns.db.sv.char`, since AceDB only materializes the current character and strips empty tables at logout. `createIfMissing` creates another character's `sv.char` entry. Scope keys: `ns.LIST_SCOPE_GLOBAL` or an AceDB character key (`"Name - Realm"`, or `"First Last"` on WoW Forever).
- **Promote, not copy:** adding to the global list calls `ns:ClearFromEveryCharacter`. Removing from global restores no one.
- **Protect always wins, enforced by callers:** `ForEachCandidate`, `IsCandidateCurrent`, `ScanAndVend` (and each sale), `ns:IsBankJunk` gate on `ns:IsIgnored` before the verdict. `ns:AddToEraseList` refuses a protected item only so the binding can say why. Only `ns:AddToIgnoreList` also drops this character's Erase List row (never the global one, and not when it answers `"already"` because the global list protects it); panel adds leave it, shown as a **Protected** tag (`IsProtectedInScope`).
- **Writers:** the panel's scoped writers (`ns:SetIgnoredInScope`, `ns:SetOnEraseListInScope`, `ns:Clear…ListInScope`, `ns:RestoreEraseListDefaults`) invalidate and repaint, and leave `ns.RefreshSettings` to `Kit.ItemList`, which calls them. Out-of-panel writers (`ns:RemoveFromIgnoreList`, `ns:ClearIgnoreList`, `ns:AddToIgnoreList`, `ns:AddToEraseList`) call it themselves.
- **Class-reagent seed** (`ns:SeedEraseList`, `SeedList`): once per character, tracked by `char.eraseListSeeded` (set before seeding, whatever the outcome), copies every *other* class's `ns.CLASS_REAGENTS` onto this character's Erase List, skipping ids its own class uses or that either list already decides. Reads the class live from `UnitClass`, not `char.classToken`. Nothing filters on the table at scan time.
- **Restore Defaults** (`ns:RestoreEraseListDefaults`): wipe and re-seed. Played character: clear the marker **first**, then seed. Other character: seed with its saved `classToken` (against its own Protect List and the live global lists), or leave empty with marker cleared. Global: empty.
- **Clear List** (`ns:ClearIgnoreListInScope`, `ns:ClearEraseListInScope`): the Erase List version sets `eraseListSeeded` true so the character doesn't refill next login.

### Options Panels

- `ns:RegisterOptionsPanels` (`Options/Options.lua`) runs at login, after `ns.db`. Tree: General (root) → Erasing (→ Erase List, Protect List) → Merchant & Bank → Alerts & Tints → Profiles → Feedback & Support → Diagnostic Tools. Registration order is tree order.
- **Every panel is a builder function** (`Kit.RegisterPanel` hands `builder` to `RegisterOptionsTable`), so each rebuilds on every open and `NotifyChange`. Profiles' builder is also called once at registration, only for the AceDBOptions-localized name.
- Nesting: the two list panels pass `"Erasing"` as parent key and attach by Erasing's **category ID** (AceConfigDialog maps only a root's display name to an ID). Any other panel after the first attaches by the display name `L["ADDON_TITLE"]`, so the root must register first, under exactly that name.
- `ns:OpenOptionsPanel(key)` is Options-Kit's: the Combat Guard, then `Settings.OpenToCategory` by the category ID `Kit.RegisterPanel` captured (default General), never by display name; with no `Settings.OpenToCategory` or no ID it falls back to `AceConfigDialog:Open`'s floating window. `ns.generalCategoryID` is only a copy for the Eraser Context report, which prints the route taken.
- **Fragments:** each `Options-{Feature}.lua` exposes `ns.Build…Options(args)` adding widgets in its own block of ten orders; panel files call them from `ERASING_SECTIONS`, `MERCHANT_BANK_SECTIONS` (Auto-Vend, Bank Retrieval, Auto-Repair), `ALERTS_SECTIONS` (Tint, Quest Item Alerts, Bag-Space Warnings, Junk Item Tooltips). `Options-Eraser.lua` holds two builders, placed around Skip Typing DELETE.
- **Features Mirror:** `ns.FEATURES` (`Options-Utilities.lua`) is the one list the root panel's Features section (`Kit.FeatureSwitches`), each feature's own Enable switch (`Kit.FeatureSwitch`) and the menu's More Features flyout all draw: `{ store, setting, name, caption, desc, block, apply }`.
  - `name` is the page heading the menu row shows, `caption`/`desc` the switch's; `block` (Auto-Vend) keeps an entry out of the flyout because the menu gives it its own block.
  - `apply`, where present, replaces the kit's own write: it writes the value itself (the kit's `WriteThen` writes `ns.db.profile`, so `apply` suits profile settings only) and then the side effect: `ns.OnValueCapToggled` (invalidate + repaint), `ns.OnTintJunkChanged` (`ns:RefreshTints`).
  - `Kit.FeatureSwitch` errors at build time for a setting with no `ns.FEATURES` entry.
  - Pairs go two to a line with `Kit.Pairs`; a switch with a control beside it uses `Kit.ToggleRow`, which drops the control to its own line when the caption is too long.
- **Examples:** `Kit.Example` draws a silver "Example" label under its control, then the lines indented. The label is `SAMPLE_EXAMPLE` with any trailing `%s`, space, colon or full-width colon trimmed, so a locale still on "Example: %s" reads right. Each line is `ns.ExampleLine(message)`, the very locale string printed, through `ns:FormatMessage`; `Kit.PrintedLine` isn't needed, since that helper already wraps the line in one color and closes it. `ns.ExampleItemLink(itemId, registryName)` gives it a real quality-colored link (`ns.EXAMPLE_JUNK_ITEM_ID` for Auto-Vend; for Quest Item Alerts the flavor's lowest quest-item id, looked up once per session). Auto-Repair's line prints a fixed sample cost (`EXAMPLE_COST`).
- `Kit.StatusLine` states a cross-feature coupling and hides on nil; `Kit.WarningLine` flags a wrong state (no junk kind checked).
- The layout grid is Options-Kit's (`Kit.ROW_WIDTH` and the rest, also published as `ns.OPTIONS_*`); only `ns.OPTIONS_PROMOTE_WIDTH` stays in `Data/Data.lua`. A captioned control is `Kit.Label` + control with `name = ""`; `Kit.SubLabelRow` indents a gated control. Gated settings are hidden, never greyed. Tint's switch-plus-picker line is a `README-Notes.md` exception.
- **List panels:** `ns.BuildCharacterListTree` (tree keyed by scope, not position; All Characters, blank row, characters with a list plus the played one, class-colored via `ns:GetCharacterDisplayName`). Every scope's pane is built on each rebuild, so each rebuild walks the bags once per scope for the picker.
  - `Kit.PrepareTree` seeds the 176-point sidebar and re-selects the played character on every hide. `ns.LeaveClearedScope` re-points selection after Clear List on another character; emptying that list by removing or promoting its last item drops the node without re-pointing.
  - Panes from `Kit.ItemList(spec)`; the kit's comment documents the spec. Erase List panes always show Restore Defaults (All Characters included); Clear List shows only while non-empty; the Protect List has no Restore. The Add by Item ID box takes a bare ID or a shift-clicked link and rejects ids `C_Item.DoesItemExistByID` denies.
  - Page titles read "Erasing > Erase List" and "Erasing > Protect List" (`Kit.SubPanelTitle`). **Add from Bags** picker replaces drag-and-drop (the game closes bags when options open); it walks the kit's own bag list, not `ns.CARRIED_BAGS`.
- The item rows' `ItemLink` AceGUI widget is the kit's, registered as `Kit.ITEM_LINK_WIDGET` (named off the add-on to avoid collisions).

### Diagnostic Tools (`Diagnostics/Manifests.lua`)

- The framework is shared and copied whole; only `Manifests.lua` is this add-on's. The framework's Display Context report (`Diagnostics/Settings-Reports.lua`) reads this add-on's mini-map wiring by name: `ns.dataBrokerObject` (and its `OnClick`), `LibDBIcon:GetMinimapButton(ADDON_NAME)` and that its `db` is `ns.db.profile.minimap`, the raw `_G[ns.SAVED_VARIABLES_NAME]` profile and `global.minimap`, `ns.ShowMenu`, `ns.RunButtonClick`, `ns.IsMenuShown`, `ns.FEATURES` (its "More Features rows" count includes Auto-Vend), and the menu frame name in `UISpecialFrames`.
- `ns.DIAGNOSTIC_API_CHECKS`: a row per API called or guarded, the menu's reads included. Modern/legacy pairs list **both halves**; a `[FAIL]` on one half shows which branch the client took. The item tooltips' two routes are listed the same way, Tooltip-Kit's reads included. No `BankFrame` row: nothing reads it.
- `ns:BuildEraserContextReport` and `ns:BuildMerchantBankContextReport`: probes; bag counts come from file-local `TallyContainers`, which applies `ns:IsIgnored` then `ns:GetItemDeleteReason` and requests nothing. The Eraser Context also calls `ns:FindItemToDelete`, which on an invalid cache rebuilds it and may request item data and schedule a retry. Quest gates print the race, class and (for a bitless race) side bits. The Eraser Context names the item tooltips' route (`ItemTooltipRoute`); the Merchant & Bank Context has an Auto-Repair block ending in a "Would repair now" verdict that copies `ns:RepairAtMerchant`'s gates. `TINT_BAG_ADDONS` mirrors `TINT_ADAPTERS` by folder to flag loaded-but-unhooked bag add-ons; `BINDING_NAMES` mirrors `Bindings.xml`.
- `ns.DIAGNOSTIC_NAME_LOOKUPS`: every GlobalStrings label shown or matched (`UiLabel` rows, `GOLD_AMOUNT` included), the built crafted and Skip Typing DELETE patterns, and `ns.EXAMPLE_JUNK_ITEM_ID`.
- `ns.DIAGNOSTIC_DATA_SOURCES`: one Validate Data report per data file; `label` is the file's table-name part. Each entry holds a `sources` list (`table`, `kind` `"item"` or `"quest"`, `rowId` or `collect`, `dataColumns`); Quest-Items and Quest-Starting-Items carry an item source and a quest source. The `Game-IDs` entry names a single constant: the framework's validator reads a number as a one-row table keyed by its own name (`RowValue` gives the id).
- Probes read state through accessors the features expose for this (`ns:GetScanRetryState`, `ns:GetAutoVendState`, `ns:GetBankMoveBudget`, `ns:IsBankRetrieving`, `ns:IsBankOpen`, `ns:GetBagWarningState`, `ns:GetPlayerQuestBits`, `ns:GetCraftedLinePattern`, `ns:GetManualDeleteInstructionPattern`, `ns:CountAnnouncedQuestStarters`).

### Localization

- `enUS.lua` alone passes the default flag to `NewLocale`. Never reuse a retired key name.
- `%s%s` in `CONFIRM_ERASE`, `ERASED_ITEM`, `SOLD_ITEM`, `QUEST_ITEM_READY`, `QUEST_STARTER_UNAVAILABLE` is one unit: link, then `" xN"` or empty.
- Money has two formats from one `MoneyParts` split: `ns:FormatCurrency` for chat and example lines (colored coin letters), `ns:FormatCoins` for the menu (coin icons at line height).
- Counts and money arrive pre-formatted (`ns:FormatCommaNumber`, `ns:FormatCurrency`) as `%s`; the raw `%d`s (`BAGS_FULL_NUDGE`, `BAGS_FULL_JUNK`, `OPTIONS_BANK_CUSHION_NOTE`) never get commas.
- Count of one has its own key (`*_ONE`, `*_ONE_ITEM`, `*_ONE_SLOT`, `BAGS_FULL` for zero).
- Links shown without brackets: `ns:StripLinkBrackets`, applied by the menu, the popup and `ns:GetItemDisplayName`; the options' list rows and picker strip their own through `Kit.ItemName`. Chat lines from `ns:PrintMessage` and the options' example lines keep them.
- Menu-Kit's toggle words come from the add-on (`Kit.SetToggleText(L["MENU_ON"], L["MENU_OFF"])`); the kit's own defaults are English fallbacks.
- Game names never go in `Locales/`: items by id, classes and races by token, Blizzard labels from GlobalStrings. Where copy needs one, the key carries `%s` and the code fills it: the delete word into the three Skip Typing keys (`Options-Utilities.lua`, at load) and the `OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION` build, `GOLD_AMOUNT` for the value-cap labels, the menu labels into `KEY_BINDINGS_LOCATION`.

## Files That Change Together

- **New event:** `ns.EVENT_NAMES` + `EVENT_HANDLERS` (`Features/Core.lua`) + its `ns:OnXxx` in a file loaded after Core.
- **New setting:** `ns.DATABASE_DEFAULTS.profile` key + its fragment row + `Locales/enUS.lua` keys + `ns.RefreshSettings()` at the end of its `set` (preceded by `ns:InvalidateCache()`/`ns:RefreshDisplay()` if it changes the verdict, or `ns:RefreshTints()` if it changes only the tint's look).
- **New feature switch:** an `ns.FEATURES` entry (`store`, `setting`, its page heading key as `name`, `caption`, `desc`, and `apply` if the change must reach beyond the saved value) + `Kit.FeatureSwitch(setting, order)` on its page (root panel and menu flyout both follow).
- **New feature panel section:** new `Options-{Feature}.lua` fragment + its TOC line before the panel + the panel's section list.
- **New junk kind:** a reason from `GetRuleDeleteReason` + `ns.DELETE_PRIORITY` + `ns.ERASE_KINDS` + `junkKinds` default + two locale keys.
- **New data table or constant:** a file in all seven `Data/{Game}/` folders (empty where it has no rows, with the `ns.IS_DISCOVERY` guard in Vanilla and Discovery) + each TOC's folder lines + `ns.DIAGNOSTIC_DATA_SOURCES` + the Eraser Context `Databases:` line for a table.
- **Changed data row:** the same id in every folder where it's true; Validate Data on each client.
- **New menu action:** an `ActionRow(label, run)` in `BuildMainEntries` + its label key; never a button click.
- **Changing Auto-Repair's gates:** `ns:RepairAtMerchant` + the Merchant & Bank Context's "Would repair now" verdict (`Manifests.lua`), same order.
- **New junk kind or Protect List scope, for the tooltips:** `KIND_LABELS` reads `ns.ERASE_KINDS` itself; a new list scope needs a `ProtectedBy` line and its `TOOLTIP_PROTECTED_*` key.
- **Tooltip-Kit refresh that changes its route pick:** `ItemTooltipRoute` and the tooltip API rows in `Manifests.lua`.
- **Renaming a mini-map symbol** (`ns.dataBrokerObject`, `ns.ShowMenu`, `ns.RunButtonClick`, `ns.IsMenuShown`, `ns.FEATURES`, the menu's frame name, the LibDBIcon name): `Diagnostics/Settings-Reports.lua`'s Display Context reads each.
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
- List panels find characters through `ns:GetCharacterKeys()` (`ns.db.sv.char` plus the played one, plain sort); profile names say nothing.
- **Seeding:** only the per-character Erase List (class reagents), once per character by `char.eraseListSeeded`, again only on Restore Defaults; never because the list is empty. Protect Lists and the global Erase List ship empty.

### Migration Chain

Both run on the raw table in `ns:OnPlayerLogin`, before `AceDB:New`, in this order:

1. `ns:MigrateSavedVariables` (`Migrations.lua`): `MigrateToVersion2` if `global.storageVersion` is below 2: per-character profiles collapse onto Default, lists move to `char`, every `global` key `DATABASE_DEFAULTS.profile` names moves into Default, old `safetyEnabled` becomes `eraseConfirmEnabled`. Stamps `STORAGE_VERSION` (a table at any version below it is restamped); a fresh install is created stamped, without migrating. `storageVersion` is stored, not inferred, because an all-defaults one-off profile is stored empty.
2. `MoveMinimapToProfiles` (`Core.lua`), only while `global.minimap` exists: copies it into Default and every profile `profiles` or `profileKeys` names (creating empty ones as needed; a profile with its own is left alone), then clears it from `global`. Keys on `global.minimap`, not `storageVersion`, and sits in `Core.lua` so it outlives `Migrations.lua`'s date. On a pre-version-2 table step 1 has already moved `global.minimap` into Default only (`minimap` is a profile default), so this step finds nothing.

Each step's `MIGRATION (remove after …)` date is on its code and its call; `Migrations.lua`'s TOC line carries the file's latest date.

## Pitfalls & Why

- **A scanner skipping `ns:IsIgnored`**: the verdict returns `"manual"` for a listed item without checking protection, so the Protect List silently loses.
- **Calling `ns:GetItemDeleteReason` without `bag` and `slot`**: every white weapon and armor piece answers nil and is kept.
- **Reading one list of a pair**: membership is additive. Use `ns:IsIgnored` / `ns:IsOnEraseList`.
- **A reason missing from `ns.DELETE_PRIORITY`**: the ranking compares nil with a number and the scan errors.
- **"Fixing" ammo to rank by value**: projectiles go last on purpose. Outgrown ammo is nearly worthless, so a cheapest-first pick would erase the quiver before the gray cloth.
- **Announcing a sale or move before confirming it**: `UseContainerItem` succeeds silently when nothing happens. Record, then confirm the slot emptied.
- **Calling `BeginVisit` on combat resume**: sales attempted before combat vanish from the lines and summary. Resume with `StartPass`.
- **A timed pass without a generation counter**: `isSelling`/`isRetrieving` flip back to true on reopen, so a stale chain runs on. Check the generation in every timer.
- **Assuming one sell pass clears the bags**: the server drops bulk sells; keep the re-scan loop.
- **Erasing without re-validating**: a dialog outlives its slot; a click lands before the client catches up. Keep `IsCandidateCurrent` and the cursor check.
- **Moving the erase binding off its synchronous path**: a timer loses the hardware event.
- **Answering the client's delete dialog from code**: the delete drops and the prompt hides, so the item can't be deleted.
- **Filling the delete prompt's box and expecting the button to enable**: it won't; `ClearDialog` must `Enable()` it.
- **Writing the delete word or "Gold" into a locale string**: each client's word differs. Keep the `%s` and fill it from GlobalStrings.
- **Loosening white-gear allowlists into exclusions**: a subclass a later client adds or repurposes (armor 5 is Cosmetic on modern clients) would be erased. New checks must fail toward keeping.
- **Caching the crafted check by item id**: the `<Made by>` line belongs to one copy.
- **Reading a use level from `GetItemInfo`**: nil when cold. It's in the data row.
- **Keying a quest-item row to the granting quest**: rows fire on the first completed listed quest, so the item is erased while still needed. Follow the data file's How We Got the Data rule.
- **Treating a 0 race or class bit as "matches nothing"**: every gated starter would read as dead-end junk. A bitless race gates by side; a bitless class never gates.
- **Editing one flavor folder**: each folder is a complete copy; check the id in every folder.
- **Hand-writing a bag range**: looping `0, 4` misses WoW Forever's reagent bag, and adding `Enum.BagIndex.ReagentBag` unconditionally takes Classic Era and TBC's first bank bag. Walk `ns.CARRIED_BAGS`, test `ns.IS_CARRIED_BAG` / `ns.IS_BANK_BAG`. Only `ns:CountFreeBagSlots` stops at `ns.LAST_BAG_INDEX`. Options-Kit's Add from Bags list is the kit's and adds `ReagentBag` whenever the enum exists; Tooltip-Kit's carried range is its own too (`NUM_BAG_SLOTS + NUM_REAGENTBAG_SLOTS`).
- **Treating no container data as zero free**: mid-loading-screen every bag reads nil. `ns:CountFreeBagSlots` returns nil; callers skip.
- **Refreshing straight from `BAG_UPDATE_DELAYED`**: it bursts. Use the `updatePending` debounce.
- **Doing protected bag work in combat**: defer it the way `ProcessBagUpdate` does, behind `refreshAfterCombat`.
- **Forgetting the level-up rescan or `ns:NoteLevelUp`**: level gates change with no bag update, and `UnitLevel` can lag the event.
- **Calling `ns.RefreshSettings` from a bag-change path**: every panel redraws and an item ID half-typed into a list's add box is lost. Bag changes go through `ns:RefreshDisplay`.
- **A settings writer that skips `ns.RefreshSettings`**: the switch's other copy, the menu row and the icon keep the old value until something else redraws them.
- **Expecting `ns.RefreshSettings` to rescan**: it reads the scan cache as it stands. A verdict change invalidates and calls `ns:RefreshDisplay` first.
- **Asking `ns:IsJunkSlot` about a bank slot**: the eraser scans carried bags only; always false. Use `ns:IsBankJunk`.
- **Reading bank-open state off `BankFrame`**: Baganator hides it while its bank window is open, so retrieval, the tint and the bag-space hold would think the bank closed. Use `ns:IsBankOpen`.
- **Reading `MerchantFrame` or `MailFrame` as the only open signal**: a UI that hides them loses Auto-Vend's combat resume and the bag-space hold. The same Baganator lesson; prefer an event flag when adding a new read.
- **Requesting a Baganator redraw on every repaint**: it rebuilds every button. Only after bag updates, tint on, out of combat.
- **Writing fields onto bag-window buttons**: taints them. Use a weak-keyed table (`paintedButtons`, `baganatorButtons`).
- **Editing `Features/Menu-Kit.lua` for a Magic Eraser need**: it is the shared kit, copied unchanged into every add-on with a menu. Work around it in `Minimap-Menu.lua`.
- **Giving the mini-map button Right-Click, or any click but Left**: deliberate. Players' hands know Right-Click as Protect; every job lives on a menu row, and the button only opens, holds and closes the menu.
- **Moving the Clutter Report above the Lowest-Value Item**: its totals come from that scan; drawn first it reads zeros.
- **Testing menu hover with `IsMouseOver`**: a controller's virtual cursor doesn't report there, so the menu closes under it. Use `Kit.IsCursorOver`.
- **Calling `ns:ClearIgnoreList` from a click**: skips the confirmation that guards a stray click under the item rows. Clicks go through `ns:ConfirmClearIgnoreList`.
- **Reading or registering the button against `ns.db.global.minimap`**: the position lives in `ns.db.profile.minimap`, and a profile change must reach `ns:ApplyMinimapButton` or the button stays where the old profile had it.
- **Moving `MoveMinimapToProfiles` into `Migrations.lua` or keying it on `storageVersion`**: it would be deleted with that file's earlier date, or skip tables already stamped current.
- **Opening the options panel by name**: nil on TBC Anniversary. Use `ns:OpenOptionsPanel`, which opens by captured category ID.
- **Registering a list panel as a built table**: it shows login-time lists forever. Every panel stays a builder.
- **Registering a top-level panel before General, or renaming the root**: later panels attach by `L["ADDON_TITLE"]` and land nowhere.
- **A list edit outside its panel without `ns.RefreshSettings`**: an open panel and the menu won't redraw. Only the login seed skips it.
- **Mutating the AceDBOptions table**: its `args` are shared with every Ace3 add-on's Profiles panel.
- **A feature with its own event frame**: escapes the Event Log.
- **Calling `ns:PrintMessage` from the vend path**: ignores the chat-report setting. Use `PrintVendMessage`.
- **Reading the tooltip's verdict as the hovered stack's**: `cachedJunkReasons` is keyed by item id, so one junk stack marks every stack of it. Per-stack checks (crafted, cap) aren't re-run for the hovered copy.
- **Letting Auto-Repair spend guild funds or repair what it can afford**: `RepairAllItems(false)` and the full-cost gate are deliberate; it never leaves the player broke or half repaired.
- **A setting in `global`, or a list in `profile`**: the setting escapes Reset Profile and one-off profiles; the list would be shared by everyone on Default.
- **An `apply` on a feature whose `store` isn't the profile**: the kit's write is skipped and `WriteThen` writes `ns.db.profile`.
- **Inferring the seed from an empty list**: only `eraseListSeeded` tells cleared from never seeded. Restore clears it first; Clear List sets it.
- **Branching a count of one through a plural string**: give the singular its own complete key.
- **Listing `Bindings.xml` in a TOC**: the bindings never appear.
- **Renaming a binding or the `ignoreList` keys**: keys come back unbound; saved lists are lost.
- **Reading the hovered item through `GameTooltip:GetItem` alone**: a deprecated wrapper on WoW Forever. Use `ns.GetDisplayedItem`.
- **Adding an unsuffixed `MagicEraser.toc`**: unsupported clients fall back to it and load the add-on.
