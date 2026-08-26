# Magic Eraser — Manual Test Plan

This is the manual test plan for Magic Eraser — the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Magic-Eraser/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Magic-Eraser/blob/main/README-Technical.md).

---

## How to run this plan

Run the whole list on Classic Era, then again on TBC Anniversary. Do a `/reload` before starting each flavor.

Every step names what you should see and what failure looks like. Steps are numbered continuously from 1, so a bug report only has to say "failed on step 34." Work top to bottom — later steps sometimes depend on settings an earlier step turned on.

Where a step calls out a difference between the two flavors, run it on **both**. The flavor it names as the one that tends to break is exactly the run where that step earns its keep — skipping it means you have not finished testing.

Nothing in this plan is reversible by the add-on: erasing an item **destroys it**. Use junk you are genuinely willing to lose.

---

## Before you start

Gather these once so you're not caught short mid-run.

- **Two game clients** — Classic Era and TBC Anniversary. The plan runs in full on each.
- **Characters at a spread of levels.** The consumable steps turn on exact level boundaries, so you need a character **below level 5**, one at **14 and one at 15**, and one at **24 or 25**. An alt parked at a low level covers the bottom end; the rest can be one character you level, or a second account character.
- **Junk in bags**, at least one of each kind:
    - **Gray trash a vendor will buy** — anything poor quality with a sell price.
    - **A white vendor-quality item from the curated list** — *Cracked Leather Vest* and *Rough Broad Axe* are on it.
    - **Low-level food and drink** — *Refreshing Spring Water* and *Tough Jerky* (both flagged from level 5), *Ice Cold Milk* (from level 15), and *Melon Juice* (from level 25). All four come from any innkeeper or general vendor.
    - **An item left over from a quest you have already completed.**
- **Consumables that must never be flagged** — a **Scroll of Stamina** or **Scroll of Intellect** of any rank, and a piece of buff food such as **Savory Deviate Delight**, **Dragonbreath Chili**, or **Grilled Squid**.
- **Junk you can park in the bank** — a dozen or more flagged items of clearly different values, for the Bank Retrieval steps. Grays of mixed prices work well.
- **Access to a bank**, and the ability to empty your bags down to a known free-slot count on demand.
- **Items that must never be touched**, for the protection steps: some **Linen Cloth** or other white trade goods, and a stack of something valuable.
- **A shaman** carrying **Fish Oil** or **Shiny Fish Scales** — these are white items on the curated equipment list and must still never be flagged. Skip the shaman steps if you have none.
- **A mage**, for the conjured food and water steps. Skip those if you have none.
- **A second character on the same account**, for the per-character Ignore List steps, the Global list steps, and the account-wide settings steps. Give it a long-ish **"Name - Realm"** key if you can — the Ignore List tree steps check that a full character name fits.
- **Two merchants you can reach in quick succession**, and enough junk to sell fifteen-plus items in one visit.
- **Bags you can fill and empty on demand** for the bag-space warning steps.
- **Somewhere safe to be in combat, where you can still type** — a low-level open-world mob you can hold aggro from will do. Several steps ask you to run a command *while* the combat flag is up.
- **A quest you can hand in right now** that leaves its quest item in your bags, for the quest-alert steps.
- **An item ID or two you can type** — any item you can also shift-click as a link in chat, for the Ignore List panel steps. Have one ID handy for something you are **not** carrying, to test an uncached row.
- **A non-English client** — optional, only for the localization spot-check at the end.

Unless a step says otherwise, you are out of combat.

---

## Verify this release's changes

Eight things changed since the last release, and all eight land in the options interface. These steps are the highest-value part of the plan — run them first.

### The options panel refuses to open in combat

Blizzard's Settings panel is protected while you are in combat, so every route the add-on could take to open it is blocked there. Instead of letting the client throw a blocked-action error, the add-on now checks combat first and says so.

**1.** Out of combat, type `/eraser`. The panel must open, docked inside the Blizzard Options window. This is your baseline — if this fails, stop and report it before running the rest of the section.

**2.** Get into combat and type `/eraser`. A single chat line must read **`Magic Eraser // As a safety precaution, the Options Interface cannot be opened during combat.`** and the panel must **not** open. Failure is the panel opening anyway, nothing printing at all, or a red `ADDON_ACTION_BLOCKED` error naming Magic Eraser.

**3.** Still in combat, **Shift + Middle-Click** the mini-map button. It must print the same line and refuse in exactly the same way. Failure is the two entry points behaving differently — the button opening the panel, erroring, or staying silent while `/eraser` prints.

**4.** Still in combat, ask three or four more times, both ways. The line must print **every** time. Failure is it printing once and then going quiet, which reads as a broken command.

**5.** Let combat end without touching anything. The panel must **not** open by itself. Then type `/eraser` — it must open normally. Failure is a panel that pops open on its own the moment you leave combat.

**6.** Run steps 2–5 again on **TBC Anniversary**. The two clients open the panel through different APIs, and the guard sits in front of both — this is exactly the kind of thing that can pass on one flavor and error on the other.

### Captions now sit beside their controls

Controls that need a caption are built as a label cell plus the control, so the words sit to the left of the box rather than stacked above it. Every row on the panel is meant to end at the same place.

**7.** Open the panel and scroll to **Feedback & Support**. Four rows — Discord, GitHub, CurseForge, Wago — each a gold label on the left and a URL box on the right, on **one line**. All four boxes must start at the same x and end at the same x. Failure is a label sitting above its box, a box wrapping onto its own line, or boxes of ragged lengths.

**8.** Click into any of those four URL boxes and select the text. The full URL must be there and selectable. Failure is a truncated URL you cannot copy.

### Sub-options are indented and silver

A control that only matters while the toggle above it is on is now marked two ways at once: its checkbox is indented past its parent's, and its caption is silver instead of white.

**9.** With **Enable Auto-Vend** on, look at the row beneath it. **Enable Auto-Vend Messages** and the message-mode dropdown must share **one** line, indented, with the toggle's caption in **silver**. The sub-option's checkbox must visibly start to the right of its parent's checkbox. Failure is the caption in white, the checkbox lined up flush with its parent's, or the dropdown wrapping onto a second line and leaving a blank indent stranded above it.

**10.** Turn **Enable Auto-Vend** off. The whole indented row must disappear — toggle and dropdown together, with no leftover blank line where the indent was. Turn it back on and both must return, still on one line. Failure is the dropdown surviving on its own, or an empty indented row left behind.

**11.** With Auto-Vend on, turn **Enable Auto-Vend Messages** off. The dropdown must stay visible and go **grayed out**. Failure is it disappearing, or staying clickable.

**12.** Compare that grayed-out dropdown with the silver sub-option caption beside it. They must read as clearly different shades — the silver caption is a live control, the grayed dropdown is switched off. Failure is the two looking the same, which makes every sub-option read as disabled.

**13.** Turn **Enable Eraser Confirmations** on. Four indented rows must appear — Completed Quest Items, Low-Level Consumable Items, White Vendor-Quality Items, Gray Vendor-Quality Items — one per line, every caption silver, every checkbox at the same indent. Failure is two of them sharing a line, indents that drift down the list, or a caption still in white.

**14.** Turn confirmations back off. All four rows must vanish together, with no stray blank line left behind. Failure is a gap where the rows were.

### The Ignore List panel is rebuilt on the shared item-list builder

The panel's rows now come from the same builder every player-managed item list uses: each row draws the real item link with its own tooltip, remove is an icon rather than a labelled button, and the add box is a label-beside-control row like the rest of the panel. The scope tree was widened so a full character name fits.

**15.** Open **Options > AddOns > Magic Eraser > Ignore List**. Your character's scope in the left tree must read the full **"Name - Realm"** with no truncation and no ellipsis. Failure is a clipped name — run this on **both** flavors, and on your longest character name.

**16.** Drag the splitter between the tree and the item pane to make the tree narrower. Close Options, reopen the panel. Your drag must be kept. Failure is the width snapping back every time you open the panel.

**17.** On your character's scope, look at **Add by Item ID**. The label must sit to the **left** of its input box on one line. Type an item ID and press Enter — a row appears and the box clears itself. Failure is the caption stacked above the box, or text left sitting in the box after the add.

**18.** Look at that row. It must show, left to right: the item's **icon**, the item's own **quality-colored link**, a **Global** button, and a small **remove icon** (the game's group-loot pass mark) at the right edge. Failure is a bare item ID, a plain uncolored name, or a wide labelled button whose caption is clipped to a sliver.

**19.** Hover the item on that row. The item's **own game tooltip** must appear — name, quality, stats, the real thing. Failure is no tooltip at all, or the row's own text shown back to you.

**20.** Hover the **remove icon**. A **Remove** label must appear on hover. Click it — the row must go immediately, one click, no confirmation dialog. Failure is no hover label, a confirmation prompt, or the wrong row going.

**21.** Select the **Global** scope. Its rows must have **no** Global button — the item cell widens to take that space, and the remove icon must stay in the **same column** it occupies on a character scope. Failure is a promote button on the account-wide list, or the remove icon sliding sideways as you click between scopes.

**22.** Add an item ID for something you are **not** carrying, right after a fresh login. The row must first read **Loading ID: N** in gray, then resolve to the real name, link and icon within a few seconds without you touching anything. Hover it **while it is still loading** — a tooltip must still appear. Failure is a row stuck on Loading forever, or no tooltip until the item resolves.

**23.** Put four or five items on one scope. They must be sorted **alphabetically by name**, with any unresolved `Loading ID:` rows last, and the order must not reshuffle when the panel repaints. Failure is a random order, or rows swapping places on every repaint.

### Clean bags read the same way everywhere

The clean-bags tooltip swapped its two lines: the congratulation now leads, where the flagged item normally sits, and the Clutter Report carries the follow-up hint. That is the order chat has always printed them in.

**24.** Empty your bags of everything flagged and hover the mini-map button. The **congratulations** line must be at the **top** of the tooltip, in green, in place of the Lowest Value Item block. Failure is the old order — congratulations down in the Clutter Report — or no green line at all.

**25.** On the same hover, read the **Clutter Report** section. It must carry the hint about manually erasing something, in white, instead of a slot count and a value. Failure is the hint missing, or slot/item/value numbers showing while your bags are clean.

**26.** Left-Click with clean bags. Chat must print the congratulation **first** and the hint **second** — the same order the tooltip shows them in, and nothing may be deleted. Failure is the two lines reversed, only one of them printing, or anything being erased.

### The sold and retrieved summaries were reworded

**27.** Sell a batch at a merchant and close the window. The closing line must read **`Sold N items (M bag slots), worth X.`** — lowercase "items" and "bag slots". Failure is the old `Sold N Items (M Bag Slots)`, which means the locale file did not update.

**28.** Open a bank with flagged junk in it. The line must read **`Pulled N items (M bag slots) out of your bank, worth X.`** — same lowercase wording. Failure is the old capitalization.

### Renamed string keys

Five string keys were renamed or added this release. A rename that missed a locale shows up as the raw key on screen, so these are quick reads rather than deep tests.

**29.** On the options main page, under the **/Commands** header, `/eraser` must be followed by **Opens the Options Interface for this add-on.** Failure is the old sentence ("Opens the Magic Eraser options panel."), or a raw key.

**30.** In the category list under Magic Eraser, the second entry must read **Ignore List**. Failure is a raw `TAB_IGNORE_LIST`.

**31.** Open the Auto-Vend message-mode dropdown. It must offer **Line Item** then **Summary Only**, in that order, as real words. Failure is a raw key or the two reversed.

**32.** Hover the mini-map button with clean bags (step 24). The congratulation must read as a sentence. Failure is a raw `BAGS_CLEAN_CONGRATS`.

**33.** Trigger the combat refusal from step 2. It must read as a sentence. Failure is a raw `CHAT_OPTIONS_IN_COMBAT`.

### The API Endpoints report lists both halves of a pair

Where the add-on guards on a modern API with a legacy fallback, the diagnostics report now names **both** halves — so a bug report says which branch that client actually took.

**34.** Turn on **Diagnostic Tools** and click **Test WoW API Endpoints**. The report must list both halves of three pairs: `C_AddOns.GetAddOnMetadata` with `GetAddOnMetadata (legacy)`, `Settings.OpenToCategory` with `InterfaceOptionsFrame_OpenToCategory (legacy)`, and `TooltipDataProcessor.AddTooltipPostCall` with `GameTooltip.SetBagItem (legacy)`. Failure is a missing half — the half that fails on the client in front of you is the one carrying the answer.

**35.** Inside each of those three pairs, at least **one** half must read PASS. A FAIL on the other half is the report working, not a defect. Write down which half passed for each pair, on each flavor. Failure is **both** halves of any pair reading FAIL.

**36.** Every other line in the report must read **PASS on both flavors**. Failure is a FAIL on anything outside those three pairs.

When steps 1–36 pass on both flavors, this release's changes are verified — proceed to `4 - Pre-Launch Review Prompt.md`.

---

## Loading and the welcome message

**37.** Log in with the add-on freshly enabled. A single branded line must print, naming the version and pointing at Options > AddOns > Magic Eraser. Failure is no message, a doubled message, or a version showing as a literal `%s`. On an unpackaged development copy the version reads `Dev` — that is correct; on a packaged release it must read a real version number.

**38.** Turn off **Enable Welcome Message** and `/reload`. No greeting must appear. Failure is the message still printing.

**39.** Turn it back on and `/reload`. The greeting must return. Failure is the setting not sticking.

---

## Options panel

**40.** Type `/eraser`. The settings must appear **docked inside the Blizzard Options window**, with Magic Eraser selected in the category list on the left. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame.

**41.** Close Options. Hold Shift and Middle-Click the mini-map button. The same docked panel must open. Failure is the same two shapes: nothing, or a floating window.

**42.** Close Options. Now open the Blizzard Options window yourself — Escape, then Options, then AddOns — and pick **Magic Eraser** out of the category list. The panel must be listed there and must render its content. Failure is the add-on missing from the list, or a page that opens blank.

**43.** With the panel open, click each child entry under Magic Eraser in the category list — **Ignore List**, **Profiles**, then **Diagnostic Tools**. Each must open its own page inside the Options window, in that order. Failure is a child missing from the list, listed in the wrong order, or opening blank.

**44.** Run steps 40–43 again on **TBC Anniversary** before calling this section done. All three entry points must dock there exactly as they do on Classic Era. Anniversary is the client where an options panel historically floats free or refuses to open — an Era-only run tells you nothing.

**45.** Type `/eraser` a second time while the panel is already open. It must stay open and usable. Failure is a Lua error or the panel closing.

**46.** Under the **/Commands** header, `/eraser` must be listed in blue with its description beside it. It is the add-on's only slash command. Failure is a missing or misspelled command.

**47.** Turn **Enable Auto-Vend** off. The indented **Enable Auto-Vend Messages** row and its message-mode dropdown must **disappear** together. Turn it back on and both must return on one line. Failure is either half staying visible when Auto-Vend is off.

**48.** With Auto-Vend on, turn **Enable Auto-Vend Messages** off. The message-mode dropdown must stay visible but go **grayed out**. Failure is it disappearing, or staying clickable.

**49.** Turn **Enable Bag-Space Warnings** on — the **Free-Slot Threshold** slider must appear, running 1 to 10. Turn the warnings off and the slider must vanish. Failure is the slider showing while warnings are off.

**50.** Turn **Enable Eraser Confirmations** on. Four indented sub-toggles must appear — Completed Quest Items, Low-Level Consumable Items, White Vendor-Quality Items, Gray Vendor-Quality Items. Turn it off and all four must vanish. Failure is any staying visible.

**51.** Turn **Enable Mini-map Button** off — the button must vanish from the mini-map immediately. Turn it back on and it must reappear in the same spot. Failure is it lingering, or returning somewhere else.

**52.** Change several settings, `/reload`, and confirm every one came back as you left it. Then log out and back in and check again. Failure is anything reverting to a default.

**53.** Scroll to the bottom of the main page. Four links must be listed in this order — Discord, GitHub, CurseForge, Wago — with a version line below them. Failure is a missing link, a wrong order, or a blank version.

---

## Mini-map button

**54.** Hover the mini-map button. The tooltip must show, top to bottom: the add-on name with the version on the right; a **Lowest Value Item** block with the item's icon, link and value; **Left-Click / Erase** and **Right-Click / Ignore**; an **Auto-Vend** line reading Enabled or Disabled with its description and **Shift + Right-Click / Toggle**; a **Clutter Report**; an **Ignore List** section if you have anything ignored; and finally **Magic Eraser Options / Shift + Middle-Click**. Failure is a missing block, a block out of that order, or an empty line where a value should be.

**55.** Compare the button's icon to the item named under Lowest Value Item. They must be the same icon. Failure is a mismatched or blank icon.

**56.** Read the **Clutter Report**. It must show a bag-slot count, an item count in parentheses, and a total value. Put more junk in your bags and hover again — the numbers must go up. Failure is numbers that never change, or a slot count higher than the junk you are actually carrying.

**57.** Left-Click. The item named in the tooltip must be destroyed, a chat line must read `Erased [item]...`, and a sound must play. The tooltip must then refresh to the next item **while you are still hovering**. Failure is the wrong item going, no chat line, or a tooltip that only updates after you move away and back.

**58.** For a stack, the erase line must include the stack size (`x5`) and the stack's total value. Failure is a value that looks like the price of a single item.

**59.** Erase a **completed quest item**. Its line must end with the note that it came from a quest you have completed, not a value. Failure is the wrong sentence for the category.

**60.** Right-Click to ignore the flagged item, then hover again. The **Ignore List** section must list it with its icon and quality color, and a **Middle-Click / Clear Ignore List** hint must appear beneath the list. Failure is the item not listed, or no Middle-Click hint.

**61.** Middle-Click. The Ignore List section must disappear from the tooltip entirely, and previously ignored items must become erasable again. Failure is the list surviving.

**62.** Shift + Right-Click. The Auto-Vend line must flip between Enabled and Disabled **while you are still hovering**, and the **Enable Auto-Vend** toggle in the options must be flipped to match. Failure is the tooltip not updating live, or the two disagreeing.

**63.** Drag the button around the mini-map, drop it, and `/reload`. It must still be where you dropped it. Then log to another character on the account — it must be in that same position, since the placement is account-wide. Failure is it snapping back, or differing per character.

**64.** Empty your bags of everything flagged. The tooltip must lead with the green congratulations line in place of the Lowest Value Item block, the Clutter Report must carry the manual-erase hint instead of numbers, and the icon must fall back to the default green bag. Left-Click now — chat must print the congratulation then the hint, and **nothing may be deleted**. Failure is anything being erased with clean bags.

---

## What gets flagged, and what never does

**65.** Put a **gray item with a sell price** in your bags. It must appear as a candidate, and its erase line must end with its value. Failure is gray trash never being flagged.

**66.** If you have a **gray item a vendor will not buy** (no sell price on its tooltip), confirm it is **never** flagged and never sold. Failure is a worthless gray being offered up.

**67.** Put a **white vendor-quality item from the curated list** in your bags — *Cracked Leather Vest* or *Rough Broad Axe*. It must be flagged. Failure is curated whites being skipped.

**68.** Put **Linen Cloth** or other white trade goods in your bags. They must **never** be flagged and must never sell. Failure is any white item that is not on the curated list being touched — that is the most dangerous possible bug in this add-on.

**69.** Confirm the consumable level gate end to end: *Refreshing Spring Water* flagged from level 5, *Ice Cold Milk* from level 15, *Melon Juice* from level 25, and none of the three flagged one level below that. Failure is any boundary landing somewhere else.

**70.** Carry a drink one level short of qualifying and **level up** into range. The candidate must update on the level-up itself, without you touching your bags. Failure is having to move an item before the add-on notices.

**71.** Put a **Scroll of Stamina**, **Scroll of Spirit**, or **Scroll of Intellect** of any rank in your bags, along with buff food such as *Savory Deviate Delight*, *Dragonbreath Chili* or *Grilled Squid*. None of them may be flagged, appear in a bag tooltip, or sell at a merchant. Failure is any stat scroll or buff food being offered up as outgrown clutter.

**72.** Carry an item left over from a **quest you have completed**. It must be flagged, and its erase line must end with the note that it belonged to a completed quest. Failure is completed quest items never being offered.

**73.** Carry a quest item for a quest you have **not** completed. It must **never** be flagged. Failure is an in-progress quest item being offered for erasure.

**74.** With several flagged items in your bags of different values, confirm the Lowest Value Item really is the **cheapest** of them. Compare whole stacks, not single items — a stack of twenty 1c grays is worth 20c and ranks above a single 5c item. Failure is a more valuable stack being offered first.

**75.** Make two flagged items worth the same amount — one a completed quest item, one gray trash. The **quest item** must be offered first. Failure is the tie broken the other way.

**76.** Make a gray item and a consumable worth the same amount. The **gray** must be offered first; consumables and curated equipment rank last and tie with each other. Failure is the consumable jumping the queue.

**77.** On a **shaman**, carry **Fish Oil** and **Shiny Fish Scales**. Both are white items on the curated equipment list, and both must be **completely invisible** to the add-on: never flagged, never sold, never pulled from the bank, and no line on their item tooltips. Failure is either one being offered or sold. On a character that is **not** a shaman, the same two items are ordinary vendor trash and **must** be flagged — check that too, so the exclusion is not leaking onto every class, and so the pair stays on the curated list where the exclusion has something to protect.

**78.** Ignore an item (Right-Click), then confirm it is skipped everywhere — it never becomes the candidate, it is not sold at a merchant with Auto-Vend on, and it is not pulled out of the bank. Repeat from a second character with an item on the **Global** list and an empty character list. Failure is a protected item being erased, sold, or retrieved on either list.

---

## Item tooltips

**79.** With **Enable Tooltips for In-Bag Items** on, open your bags and hover a flagged item. One line must be appended, reading `Magic Eraser // Magic Eraser will erase this.` in red. Failure is no line, or the line appearing twice.

**80.** Hover an item on **either** ignore list — your character's or the Global list. The line must instead read `Protected by your Ignore List.` in white. Failure is the erase warning showing on a protected item, or the Global list producing no line.

**81.** Hover an item the add-on would not touch — Linen Cloth, a green, your equipped gear, a Scroll of Stamina. **No** Magic Eraser line may appear. Failure is a line on an item that is not flagged.

**82.** Hover the *same* flagged item somewhere other than your bags — at a merchant, in your bank, or from a chat link. No line may appear; the warning is for carried bag slots only. Failure is the line leaking onto merchant or bank tooltips.

**83.** Turn **Enable Tooltips for In-Bag Items** off and hover a flagged item again. No line. Failure is it still appearing.

**84.** If you run a heavy tooltip add-on (TradeSkillMaster, AtlasLoot, an auction add-on), repeat step 79 with it enabled. The line must still appear, exactly once, and must not be wiped by the other add-on's own tooltip work. Failure is the line vanishing or doubling. Run this on **both** flavors — the two clients use different tooltip hooks, so a pass on one proves nothing about the other.

---

## Auto-Vend

**85.** On a fresh install with no saved settings, open the options. **Enable Auto-Vend** must read **Enabled**, messages must be on, and the mode must be **Summary Only**. Failure is a different starting state.

**86.** With Auto-Vend on, walk up to a merchant. Everything flagged **that has a sell price** must sell on its own, with no click from you. Failure is an empty sale, or having to open a bag first.

**87.** In **Line Item** mode, count the `Sold ...` lines against the bag slots that actually emptied. The two numbers must match exactly, and every item named must be gone from your bags. Failure is more lines than slots freed — that is a phantom sale being announced.

**88.** Close the merchant window. Exactly **one** closing line must print — `Sold N items (M bag slots), worth X.` `M` must equal the slots that emptied, and `X` must match the gold you actually gained. Failure is a summary that overcounts, a missing summary, or more than one.

**89.** Sell a large batch — fifteen or more items in one visit. Every flagged item must sell, and none may be announced **twice**, even though the add-on re-scans and retries to catch sells the server drops. Failure is a duplicated `Sold` line, an inflated summary, or junk left behind when the window closes.

**90.** Switch to **Summary Only** and sell another batch. No per-item lines may print, and the single closing line must still appear with correct numbers. Failure is per-item lines still printing, or no closing line.

**91.** Open a merchant with nothing flagged and close it again. Nothing at all may print. Failure is any Auto-Vend output for a visit where nothing sold.

**92.** Carry a flagged item with **no** sell price — a completed quest item worth nothing is the easy case. It must **not** be sold, and it must still be in your bags and still erasable after the merchant visit. Failure is the add-on trying to sell something worthless.

**93.** Add an ignored item and, on a shaman, Fish Oil, then visit a merchant. Neither may be sold. Failure is a protected item being vendored.

**94.** **Combat mid-batch.** In Line Item mode, put fifteen or more grays in your bags, open a merchant, and pull a mob so combat starts while the batch is still selling. A single line must read that Auto-Vend will sell once combat ends. Let combat end with the merchant window still open. Every item that sold across **both** halves must be announced exactly once, and the count of `Sold ...` lines must equal the bag slots that actually emptied. Close the window — the one closing line must count **both** halves of the visit. Failure is a sale missing from the lines, a duplicate, or a summary that only counts what sold after combat ended.

**95.** **Visits must not bleed into each other.** Sell a batch at one merchant and close the window. Now start combat, open a **second** merchant while in combat, and let combat end. Every item that sells at the second merchant must be announced, and its closing summary must carry its own numbers only. Failure is silent sales at the second merchant, or the first visit's totals turning up in the second summary.

**96.** Open a merchant while **in combat** with Auto-Vend on, then close the merchant window **before** combat ends. Nothing may sell, and no error may appear when combat finally ends. Failure is a sale firing at an empty merchant, or a Lua error.

**97.** Turn **Enable Auto-Vend** off and visit a merchant with junk in your bags. Nothing may sell and nothing may print. Failure is it selling anyway.

**98.** Turn Auto-Vend back on but turn **Enable Auto-Vend Messages** off. Junk must still sell, but **nothing** may print — no per-item lines, no summary, no combat notice. Failure is any Auto-Vend chat while messages are off.

---

## Bank Retrieval

**99.** On a fresh install, open the options. A **Bank Retrieval** section must exist, with a description and an **Enable Bank Retrieval** toggle reading **Enabled**. Failure is a missing section, or the toggle starting off.

**100.** Put several flagged junk items in your bank, empty your bags to well above the Free-Slot Threshold, and open the bank. About half a second later the items must move into your bags on their own, and one line must print — `Pulled N items (M bag slots) out of your bank, worth X.` Failure is nothing moving, or items moving with no line.

**101.** Count the bank slots that emptied against `M` in that line. The two must match exactly, and `N` must count stacked quantity (a stack of five is one slot, five items). Failure is a line claiming more than actually moved.

**102.** **The budget check.** Set the **Free-Slot Threshold** to 4 and arrange exactly **six** free bag slots, with more than two flagged items waiting in the bank. Open the bank. Exactly **two** items may be pulled — free slots minus the threshold — leaving four slots still free. Failure is your bags being filled to the brim, or nothing being pulled at all. Note that the cushion applies whether or not bag-space warnings are switched on.

**103.** Repeat step 102 with the threshold at 1 and six free slots. Five items must come across. Failure is the count not tracking the threshold you set.

**104.** With free slots at or below the threshold, open the bank. **Nothing** may be pulled and nothing may print. Failure is retrieval running with no room for it.

**105.** **Most valuable first.** Park flagged items of clearly different values in the bank and give the pass a budget smaller than the number waiting — say two slots against six items. What arrives must be the **most valuable** of them; the cheap clutter stays in the bank. Failure is the cheapest items being pulled first, which is the opposite of the intent.

**106.** Open the bank with **nothing flagged** in it. Nothing may print — no line, no empty summary. Failure is any Bank Retrieval output for a visit that moved nothing.

**107.** Put an **ignored** item in the bank and open the bank. It must **not** be pulled. Failure is retrieval ignoring the protection the eraser respects. Repeat with an item on the **Global** list from a character whose own list is empty.

**108.** On a **shaman**, put **Fish Oil** or **Shiny Fish Scales** in the bank and open it. Neither may be pulled. Failure is a class reagent being dragged into your bags.

**109.** Put items in a **purchased bank bag** rather than the main bank window, and open the bank. Flagged items there must be pulled too. Failure is only the main bank being scanned.

**110.** **Close the bank while the pass is still moving items** — a big batch gives you the window. Moving must stop where it stopped, and the summary must report only what actually made it across, never the whole queue. Failure is a line claiming items still sitting in your bank.

**111.** **Close and immediately reopen the bank**, inside the first half-second, twice in a row. Items must be pulled **once**, and exactly **one** summary line may print. Failure is a doubled pull or two summary lines — that means two passes are walking the same queue.

**112.** With **Enable Bank Retrieval** turned off, open a bank with flagged junk in it. Nothing may move and nothing may print. Failure is it running anyway.

**113.** With bag-space warnings on, open the bank and let retrieval fill your bags past the threshold. **No** countdown may print while the bank window is open; at most one line may print once you close it, reflecting where your bags actually landed. Failure is a burst of warnings during the pull.

**114.** With retrieval on and room in your bags, open the bank twice in a row without changing anything in between. The second visit must pull nothing and print nothing, because the first one already cleared what it could. Failure is a repeated pull of items that are no longer there.

**115.** Open the bank, let a pass run to completion, and check that the mini-map button icon and Clutter Report **update** to account for the newly arrived junk. Failure is a stale candidate until you touch your bags.

**116.** Erase the items retrieval just pulled, then open the bank again. The next-most-valuable batch must come across. Failure is retrieval refusing to run a second time in the same session.

**117.** Open the bank with items whose data the client has not cached — log in and go straight to the bank. Retrieval must still find and pull them within a few seconds, rather than skipping them. Failure is a cold bank being treated as empty.

**118.** Start combat with the bank window open, if you can arrange it. No Lua error may appear, and the pass must simply stop. Failure is an error or items continuing to move in combat.

---

## The Ignore List panel

**119.** Open the options. An **Ignore List** entry must sit in the category list under Magic Eraser, **above Profiles**. Order top to bottom must be Magic Eraser, Ignore List, Profiles, Diagnostic Tools. Failure is a missing entry or the wrong order.

**120.** Open it. The left side must be a tree of scopes with **Global** at the top, then your current character as **"Name - Realm"**. Failure is a flat page with no scope tree.

**121.** Select a scope with nothing on it. It must read **This list is empty.** Failure is a blank pane with no explanation.

**122.** On your character's scope, type a plain **item ID** into **Add by Item ID** and press Enter. A row must appear for that item, and the box must clear itself. Failure is nothing appearing, or the typed text staying in the box.

**123.** Shift-click an **item link in chat** while the Add box has focus. The link must drop into the box, and pressing Enter must add that item. Failure is the link being rejected as invalid.

**124.** Type something that is neither — a word, a stray number with letters — and press Enter. It must be rejected with the message **Type an item ID, or shift-click an item link in chat.**, and no row may appear. Failure is a junk row you can never resolve.

**125.** On a **character** scope, click a row's **Global** button. The item must vanish from this character's list and reappear under the **Global** scope. Failure is it being copied rather than moved — it must not remain on the character's list.

**126.** Put an item on the **Global** list, then log to a **second character** and carry that item. It must **never** be flagged, never sold, and never pulled from the bank. Failure is the Global list protecting only the character that set it.

**127.** With that item globally ignored, hover it in your bags. Its tooltip must read **Protected by your Ignore List.** Failure is no line, or the erase warning showing on a protected item.

**128.** Ignore an item on a **character** list, then promote a *different* item to Global. Middle-click the mini-map button to clear the ignore list. The **character** item must go; the **Global** item must stay protected. Failure is Middle-Click wiping the account-wide list — it must only ever clear what the mini-map tooltip was showing.

**129.** Add an item to **two** characters' lists, then promote it to Global from one of them. It must disappear from **both** characters' scopes and appear once under Global. Failure is a leftover row on the other character.

**130.** Remove an item from the **Global** list. It must **not** reappear on any character's list — removing from Global protects nobody, by design. Failure is it silently landing back on a character.

**131.** Look at the scope tree with a second character that has **nothing** ignored. That character must **not** be listed. Your current character must always be listed, even with an empty list. Failure is a tree full of empty characters, or your own character missing so you cannot add a first item.

**132.** Leave the panel **open** on your character's scope, then **Right-Click the mini-map button** to ignore the flagged item. The new row must appear in the panel **immediately**, without you closing and reopening it. Failure is the row only showing up after a reopen.

**133.** With the panel still open, **Middle-Click the mini-map button**. Every row under your character's scope must clear at once, and the **Global** scope must be untouched. Failure is stale rows surviving in the pane.

**134.** With the panel open, go to **Profiles** and switch to a different profile, then come back to **Ignore List**. It must show the new profile's list. Do the same with **Reset Profile** and with **Copy From** — each must repaint the pane immediately. Failure is the previous profile's rows still on screen after any of the three.

---

## Ignore lists from the mini-map button

**135.** Hover the mini-map button, note the item under **Lowest Value Item**, and Right-Click. The tooltip must gain an **Ignore List** section containing that item, and the flagged item must change to something else. Failure is the item staying flagged, or no Ignore List section appearing.

**136.** Confirm that item appears in the **Ignore List** panel under your character's scope — not under Global. Failure is a mini-map ignore landing on the account-wide list.

**137.** Add an item from the panel under your character's scope and confirm it shows up in the **mini-map tooltip's** Ignore List section. Failure is the two views disagreeing.

**138.** Add an item to the **Global** scope and confirm it does **not** appear in the mini-map tooltip's Ignore List section, which shows this character's list only — but that the item is still protected. Failure is the Global list showing up where Middle-Click would wrongly imply it can clear it.

**139.** Ignore an item, then `/reload`, then log out and back in. Both lists must survive all three. Failure is either list emptying.

**140.** Ignore every flagged item in your bags one after another. Once nothing is left, the mini-map tooltip must show the clean-bags state from step 24. Failure is a candidate that is on the ignore list still being offered.

---

## Bag-space warnings

**141.** On a fresh install, confirm **Enable Bag-Space Warnings** is **off** by default. Failure is warnings on out of the box.

**142.** Turn warnings on and leave the **Free-Slot Threshold** at 4. Fill your bags until you cross that threshold. A line must print counting down — `Your bags are nearly full. You have 4 slots remaining.` then 3, then 2. Failure is no warning, or the same number printing twice in a row.

**143.** Fill down to exactly **one** free slot. The line must read `You have 1 slot remaining.` — singular, no `1 slots`. Failure is the plural wording.

**144.** Fill the last slot. The line must read `Your bags are full!` Failure is a "0 slots remaining" line instead.

**145.** Free several slots so you are back above the threshold, then fill down past it again. The countdown must warn again. Failure is silence the second time.

**146.** **Regression check for an earlier release's fix.** With warnings on and **plenty of free space** (well above the threshold), log in, then zone through several loading screens — hearth, take a portal or boat, enter and leave an instance. **No** bag-space warning of any kind may print, and especially not `Your bags are full!` Failure is a full-bags warning fired at a player with free slots — that bug appeared on every zone change.

**147.** With warnings on, open a merchant and sell junk, then close the window. No countdown may print **while** the window is open; at most one line may print once it closes. Do the same with a mailbox, and with the bank. Failure is a burst of warnings while any of those windows is open.

**148.** Turn warnings off and fill your bags completely. Nothing may print. Failure is a warning while the feature is off.

---

## Quest alerts

**149.** Hand in a quest whose quest item is still in your bags. About a second later, a line must print reading `[item] can now be safely erased!`, and that item must become the flagged candidate on the mini-map button. Failure is no alert, or an alert naming an item you are not carrying.

**150.** If you are carrying more than one of the same quest item, the alert must print **once**, not once per copy. Failure is a repeated line.

---

## Eraser Confirmations

**151.** On a fresh install, confirm **Enable Eraser Confirmations** is **off** and that Left-Clicking the mini-map button erases immediately, with no dialog. Failure is a prompt appearing while the setting is off.

**152.** Turn confirmations on. Of the four sub-toggles, **For Completed Quest Items** must be checked and the other three unchecked. Failure is a different starting state.

**153.** With a completed quest item flagged, Left-Click. A confirmation must appear asking `Erase [item]?` with Yes and No. Click **No** — the item must still be in your bags. Failure is it being erased anyway.

**154.** Left-Click again and click **Yes**. The item must be erased, with the usual chat line. Failure is nothing happening, or the wrong item going.

**155.** With a gray item flagged and **For Gray Vendor-Quality Items** unchecked, Left-Click. It must erase immediately with **no** prompt. Failure is a prompt for a category you did not check.

**156.** Check **For Low-Level Consumable Items** and flag an outgrown drink. Left-Click must prompt. Failure is the consumable category ignoring its own toggle.

**157.** Open the confirmation, then **enter combat** before answering, then click Yes. A line must read that items cannot be erased in combat, and **nothing** may be deleted. Failure is a deletion going through in combat, or a Lua error.

---

## Combat behavior

**158.** In combat, Left-Click the mini-map button. A line must read `Cannot erase items while in combat.`, nothing may be deleted, and no Lua error may appear. Failure is an error or a deletion.

**159.** In combat, Right-Click, Middle-Click and Shift + Right-Click the button. All three must work normally — ignoring, clearing and toggling Auto-Vend are not combat-restricted. Failure is a Lua error or a blocked-action message.

**160.** In combat, type `/eraser`, then Shift + Middle-Click the button. Both must print `As a safety precaution, the Options Interface cannot be opened during combat.` and neither may open the panel. Failure is the panel opening, silence, or a red `ADDON_ACTION_BLOCKED` error naming Magic Eraser.

**161.** Out of combat, click the button as fast as you can, repeatedly. Either each click erases the next item cleanly, or a line reads `Slow down! You're clicking faster than the game can erase items.` **No item other than the one named in the tooltip may ever be deleted.** Failure is the wrong item being destroyed — treat this as a launch blocker.

**162.** Leave combat with nothing pending. No stray message may print, and the options panel must not open by itself. Failure is a deferred notice firing when nothing was deferred.

---

## Diagnostic Tools

**163.** Open **Diagnostic Tools** on a fresh login. **Enable Diagnostic Tools** must be **off**, with everything below it hidden and only the warning text showing. Failure is it remembering being on from an earlier session.

**164.** Turn it on. Every section below must appear, each under its own header — Event Log, Event Registration, API Endpoints, Eraser Context, Display Context, Other Add-ons, Saved Variables, Library Versions, Taint Log, External Tools. Failure is a missing section or a header with no content beneath it.

**165.** `/reload` and reopen the panel. The toggle must be **off** again — it is deliberately not remembered. Failure is it persisting across a reload.

**166.** Turn it on, click **Start Event Log**, then open your bags, visit a merchant, **open and close your bank**, hand in a quest, and level up if you can. Click **Show Captured Events**. The output must list events with timestamps — `BAG_UPDATE_DELAYED`, `MERCHANT_SHOW`, `MERCHANT_CLOSED`, `BANKFRAME_OPENED`, `BANKFRAME_CLOSED`, `QUEST_TURNED_IN`. Nothing is filtered out of this log, so anything the add-on registered for and that actually fired must be in there. Failure is an empty log, or the bank events missing after you clearly opened a bank.

**167.** Click **Stop Event Log**, then **Show Captured Events** again. The box must read `(no events captured)`. Failure is old entries persisting.

**168.** Click **Test Event Registration**. Every line must read `PASS`, and the list must include both `BANKFRAME_OPENED` and `BANKFRAME_CLOSED`. Failure is any `FAIL` — note which event and which flavor.

**169.** Click **Test WoW API Endpoints**. Steps 34–36 cover the three modern/legacy pairs; here just confirm the report builds and that **every line outside those pairs reads PASS** on this flavor. Failure is a FAIL on anything else.

**170.** Click **Show Eraser Context**. It must name your class and level, the Auto-Vend state, the **Bank retrieval** state, an **Ignore list** line reading `character=N, global=M`, a **Databases** line reading `consumables=347` with quest and equipment both in the high hundreds (868 and 996 as shipped), the class reagent exclusion count, and the current erase candidate. Both ignore-list numbers must match what you actually have on each list, and the candidate must match what the mini-map tooltip is showing right now. Failure is a mismatch, a missing line, a zero for any database, or a candidate reported when your bags are clean.

**171.** Click **Show Display Context**. `Minimap button created` must read `yes`, and a saved angle must be listed. Failure is `no` while the button is plainly on your mini-map.

**172.** Click **List Installed Add-ons**, **List Library Versions**, and **Dump Saved Variables** in turn. Each must fill its box with readable text. The saved-variables dump must show your settings, your profiles, and **each** ignore list as a count like `{ 3 entries }`, including the account-wide one under `global`. Failure is an empty box, a wall of raw item IDs, or an error.

**173.** Read the dump for your **own character's** "Name - Realm" profile. It must contain `ignoreList = { N entries }` matching what you have ignored, and **no** `ignoreLists` (plural) table. Failure is the plural table surviving in your own profile. An old `Default` profile further down may still list buckets for characters that have not logged in yet — that is expected, and clears as each one logs in.

**174.** Click **Turn On Taint Log** — the state line above must change to level 2 — then **Turn Off Taint Log**, which must return it to 0. Failure is a state line that does not follow the buttons.

**175.** Compare shades on this panel. The section hints — the event-log hint, the taint-log state line and hint, and the two External Tools lines — must read **silver**, visibly different from the white body text in the mini-map tooltip. On the two External Tools lines, the sentence must **stay silver after** the blue `/console scriptErrors 1` and `/etrace` text. Failure is everything rendering the same shade, or a line turning white partway through.

---

## Profiles

**176.** Open **Profiles**. The current profile must be your character's own **"Name - Realm"**. Failure is `Default`.

**177.** Log to a second character on the same account. Its Profiles page must show **its own** "Name - Realm", and anything you ignored on the first character must **not** be in its mini-map tooltip. Failure is one character's ignored items showing up on another.

**178.** On that second character, check the account-wide settings — Auto-Vend, Bank Retrieval, welcome message, bag-space warnings, confirmations. Every one must match what you set on the first character. Failure is settings resetting per character; only the per-character Ignore List is per-character.

**179.** Log back to the first character and confirm its Ignore List is intact. `/reload`, then log out and back in, and confirm it is still there. Failure is the list emptying on any of those.

**180.** **Reset Profile clears only the Ignore List.** Change every account-wide setting away from its default, ignore a couple of items, drag the mini-map button somewhere distinctive, then click **Reset Profile**. This character's Ignore List must clear; **every** account-wide setting, the **Global** list, and the button's position must survive untouched. The mini-map icon and tooltip must re-scan immediately, so the newly unprotected item is the candidate without you touching your bags. Failure is any account-wide setting snapping back, the Global list emptying, the button jumping, or a stale candidate.

**181.** **Upgrade check — only if you had items on your Ignore List before installing this build.** Log in on this build for the first time on that character. The items you had ignored must still be ignored, on that same character. Failure is an empty list, or another character's ignored items appearing in it.

**182.** Ignore a couple of items, then use **Copy From** to copy another character's profile onto this one. That character's per-character Ignore List must replace yours, and the mini-map button icon must update immediately to the new lowest-value item. Failure is a stale candidate until you touch your bags.

**183.** Create a new profile, switch to it, and confirm the per-character Ignore List is empty and the flagged item re-scans right away. Confirm the **Global** list is unaffected — it is account-wide and no profile switch may touch it. Switch back and confirm your original list returns, then delete the profile you created. Failure is a switch that leaves the button showing the old profile's item, or that empties the Global list.

---

## Flavor differences to watch

Do not let a clean Classic Era run stand in for both flavors. These are the places the two clients have behaved differently:

- **Opening the options panel (steps 1–6, 40–45).** This is the big one, and it is bigger this release. The two clients reach the Settings panel through **different APIs** — Era has the legacy opener, Anniversary needs the modern one — so the docking check *and* the new combat guard both have to be run on Anniversary. Anniversary is the client where an options panel opens floating, refuses to open, or throws a blocked-action error. Run steps 1–6 and 40–45 there or you have not tested the panel.
- **The Ignore List panel (steps 15–23, 119–134).** It is the deepest panel the add-on renders — a scope tree with item rows inside it, and this release changed how those rows are drawn. Check the columns line up on both clients, that the widened tree shows a full "Name - Realm" on both, and that picking a different scope does not shuffle the remove icon sideways.
- **Item tooltips (steps 79–84).** The two clients expose different tooltip APIs, so the warning line is added by a different mechanism on each — the modern data processor on one, a hook on the bag-item setter on the other. It must appear, exactly once, on both; a pass on one flavor proves nothing about the other.
- **The API Endpoints report (steps 34–36, 169).** Three modern/legacy pairs are expected to split differently across the two clients. Record which half passes for each pair on each flavor; everything outside those pairs must PASS on both.
- **Which consumables exist (steps 69–71).** The consumable list spans both clients, so many entries are TBC-only — Bash Ale, the battleground rations, everything from Outland. Pick items that actually exist on the client you are testing. *Refreshing Spring Water*, *Ice Cold Milk* and *Melon Juice* exist on both, which is why the level-boundary steps use them.
- **Bank Retrieval (steps 99–118).** Bank bag counts differ between the clients, so run the bank-bag step (109) on both rather than assuming the main bank window covers it.
- **Any Lua error at all.** An error that appears on one flavor and not the other is a flavor difference by definition — note which client it happened on.

---

## Localization spot-check

Optional, and only worth doing on a non-English client.

**184.** Log in on a non-English client and open the options. Every label and description must be in that language. Failure is a raw key like `OPTIONS_ENABLE_BANK_RETRIEVAL` showing through, which means a string is missing.

**185.** Check this release's **new and renamed keys** specifically, since a locale that missed one shows the key here first: the in-combat refusal (`/eraser` while in combat), the **Ignore List** entry in the category list, the `/eraser` description under /Commands, the **Line Item** / **Summary Only** dropdown, and the clean-bags congratulation in the mini-map tooltip. All five must be translated sentences or words. Failure is any raw key.

**186.** Read the **sub-option captions** — Enable Auto-Vend Messages and the four confirmation categories. In a long-worded locale these are the first captions to run into the control beside them. Each must fit its row, stay silver, and not overlap the dropdown or wrap awkwardly. Failure is a caption colliding with its neighbour or pushing the row onto two lines.

**187.** Open the **Ignore List** panel. The **Global** scope label, the character "Name - Realm" scope keys, the promote button caption and the add box's rejection message must all render in that language and fit their space. The scope tree is sized for a translated **Global** plus a full character name — failure is either one clipped, or the promote button's caption overflowing its column.

**188.** The **Diagnostic Tools** panel is deliberately English on every client — that is intended and not a bug. Failure would be a raw key, not English text.

**189.** Trigger the welcome message, an erase, an Auto-Vend sale, the closing summary, and a **bank retrieval** line. Each must read as a natural sentence in that language, with the version, item name, stack size, counts and money appearing in sensible places. Failure is a literal `%s`, a `nil`, a doubled value, or a number landing in the wrong slot.

**190.** Turn on bag-space warnings and fill your bags to exactly one free slot, then zero. Both the "1 slot remaining" and the "bags are full" lines must read naturally — the singular line is a separate string in every locale, so it must not come out as a plural with a 1 in it. Failure is a mangled or plural-looking singular.

**191.** Check **Russian (ruRU)** specifically. Russian is the widest text here, so it is the first to overflow. The mini-map tooltip, the options descriptions and sub-option captions, the Ignore List panel and the chat lines must all still fit and read cleanly — no text running off the tooltip, no label overlapping its control. Failure is a truncated or overlapping string.

---

## Sign-off

Manual testing is complete when **every step passes on both Classic Era and TBC Anniversary**. One flavor is not enough — steps 6 and 44 exist precisely because the options panel is the thing that has broken on Anniversary alone, and this release changed both how it opens and what it refuses to do.

When both rows below are filled in and passing, the add-on is ready for `4 - Pre-Launch Review Prompt.md`.

| Flavor | Tester | Date | Result | Failed steps |
|---|---|---|---|---|
| Classic Era | | | Pass / Fail | |
| TBC Anniversary | | | Pass / Fail | |
