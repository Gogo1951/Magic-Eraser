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
- **Consumables that must never be flagged** — a **Scroll of Stamina** or **Scroll of Intellect** of any rank, and a piece of buff food such as **Savory Deviate Delight**, **Dragonbreath Chili**, or **Grilled Squid**. These were erasable in the last release and must not be now.
- **Junk you can park in the bank** — a dozen or more flagged items of clearly different values, for the Bank Retrieval steps. Grays of mixed prices work well.
- **Access to a bank**, and the ability to empty your bags down to a known free-slot count on demand.
- **Items that must never be touched**, for the protection steps: some **Linen Cloth** or other white trade goods, and a stack of something valuable.
- **A shaman** carrying **Fish Oil** or **Shiny Fish Scales** — these are gray with a sell price and must still never be flagged. Skip the shaman steps if you have none.
- **A mage**, for the conjured food and water steps. Skip those if you have none.
- **A second character on the same account**, for the per-character Ignore List steps, the Global list steps, and the account-wide settings steps.
- **Two merchants you can reach in quick succession**, and enough junk to sell fifteen-plus items in one visit.
- **Bags you can fill and empty on demand** for the bag-space warning steps.
- **Somewhere safe to be in combat** — a low-level open-world mob will do, ideally within sight of a merchant.
- **A quest you can hand in right now** that leaves its quest item in your bags, for the quest-alert steps.
- **An item ID or two you can type** — any item you can also shift-click as a link in chat, for the Ignore List panel steps.
- **A non-English client** — optional, only for the localization spot-check at the end.

Unless a step says otherwise, you are out of combat.

---

## Verify this release's changes

Six things changed since the last release. These steps are the highest-value part of the plan — run them first.

### Consumable erase levels now come from the data, not the game

The level at which food and drink counts as outgrown used to be read from the item's own required level through `GetItemInfo`. It now comes from the level stored beside each item in the curated list: **ten levels past that use level**, except items usable below level 5, which are flagged at **level 5 flat** rather than lingering until 11. Four different features ask the same question, so the point of these steps is that all four still agree.

**1.** Open **Diagnostic Tools**, turn it on, and click **Show Eraser Context**. The `Databases:` line must read **`consumables=347`**, with non-zero counts for quest and equipment beside it. Failure is `consumables=267`, which means the old data file is still installed, or a zero, which means the file failed to load.

**2.** On a character at **level 5 or higher**, put *Refreshing Spring Water* or *Tough Jerky* in your bags. It must be flagged as the erase candidate. Failure is it never being offered — that means the starter-item rule is missing and it is waiting for level 11 or 15 instead.

**3.** On a character at **level 4 or lower**, carry the same drink. It must **not** be flagged. Failure is a starting character's only water being offered up for deletion.

**4.** Carry *Ice Cold Milk* on a **level 14** character — not flagged — then on a **level 15** character, where it must be flagged. Failure is either half of that: flagged at 14, or still ignored at 15.

**5.** Carry *Melon Juice* on a **level 24** character — not flagged — then at **level 25**, where it must be flagged. Failure is the boundary landing anywhere else; this is the ordinary "ten levels past its use level" case, and step 4 is the same rule one item lower.

**6.** **The four features must agree.** Take one qualifying consumable on a qualifying character and confirm all four of these are true at once: it is the mini-map candidate, its bag tooltip carries the `Magic Eraser will erase this.` line, Auto-Vend sells it at a merchant, and Bank Retrieval pulls it out of the bank. Failure is **any one** of the four disagreeing with the other three — each of them asks the eraser the same question, and this release changed how that question is asked.

**7.** Repeat step 6 with the same item on an **under-level** character. None of the four may act on it: no candidate, no tooltip line, no sale, no retrieval. Failure is one feature still flagging what the other three skip.

**8.** Carry a drink one level short of qualifying and **level up** into range. The candidate must update on the level-up itself, without you touching your bags. Failure is having to move an item before the add-on notices.

**9.** On a **mage of level 5 or higher**, conjure water and bread and hover the mini-map button. Both are on the list at use level 1, so from level 5 both are treated as outgrown and can be flagged — including the rank you are currently drinking. Confirm that is what happens, and report it in your sign-off if you think it is wrong; it is the newest boundary in the release. Failure for this step is a Lua error, or the item being erased without ever appearing in the tooltip first.

### The consumable database was rebuilt

The list is now generated by a query rather than curated by hand, and it changed size and shape: **347 entries, up from 267**. Sixty-eight items came out — every stat scroll and every buff food — and a hundred and forty-seven went in.

**10.** Put a **Scroll of Stamina**, **Scroll of Spirit**, or **Scroll of Intellect** of any rank in your bags. It must **never** be flagged, never appear in a bag tooltip, and never sell at a merchant. Failure is any of them being offered — these were erasable in the last release and must not be now.

**11.** Put **buff food** in your bags — *Savory Deviate Delight*, *Dragonbreath Chili*, *Grilled Squid*, *Mightfish Steak*, or *Runn Tum Tuber Surprise*. None may be flagged or sold at any level. Failure is a stat-buff food being erased as outgrown clutter.

**12.** Put **holiday and novelty consumables** in your bags — *Winter Veil Candy*, *Harvest Boar*, *Rumsey Rum*, *Captain Rumsey's Lager*. None may be flagged. Failure is a seasonal item that cannot be re-obtained being erased.

**13.** Confirm ordinary **alcohol is still flagged**: *Cheap Beer*, *Darkmoon Special Reserve* and *Flask of Port* qualify from level 5, *Flagon of Mead* from level 25. Failure is the whole alcohol group dropping out of the list along with the buff drinks.

**14.** Confirm the **newly added groups are flagged** at the right levels: *Raw Sagefish* from level 20, and a battleground ration — *Warsong Gulch Field Ration* or *Arathi Basin Field Ration* — from level 35. Failure is a newly added item never being offered. Raw fish are cooking materials as well as food; note it in your sign-off if you would rather they were left alone.

**15.** Sanity-check the shape of the change overall: with an assortment of old and new consumables in your bags, nothing outside the four categories may ever be flagged, and nothing already protected may be touched. Failure is any item flagged that you cannot account for from the four categories in `README.md`.

### Auto-Vend tells a visit apart from a pass

A merchant visit and a selling pass used to be reset together. They are now separate: the visit's books — what has been announced, what is still awaiting confirmation, and the running summary totals — open once when the merchant window opens, and a pass restarted mid-visit no longer wipes them.

**16.** **The fix this release is for.** Turn on **Enable Auto-Vend** and **Enable Auto-Vend Messages** and set the mode to **Line Item**. Put fifteen or more grays in your bags, open a merchant, and **pull a mob so combat starts while the batch is still selling**. A single line must read that Auto-Vend will sell once combat ends. Let combat end with the merchant window still open. Every item that sold across **both** halves must be announced exactly once, and the count of `Sold ...` lines must equal the bag slots that actually emptied. Failure is one or two sales missing from the lines entirely — the items are gone from your bags but were never announced. That is the bug these changes fix.

**17.** Close the merchant window after step 16. The single closing line — `Sold N Items (M Bag Slots), worth X.` — must count **both** halves of the visit. Failure is a summary that only counts what sold after combat ended.

**18.** Repeat step 16 in **Summary Only** mode. No per-item lines may print, and the one closing line must still cover the whole visit with correct numbers. Failure is a short count.

**19.** Open a merchant **while already in combat**, with junk in your bags. The deferred notice must print once, nothing may sell yet, and no Lua error may appear. Leave combat with the window still open — everything must sell and be announced normally. Failure is an error, a repeated notice, or a silent pass that announces nothing.

**20.** **Visits must not bleed into each other.** Sell a batch at one merchant and close the window. Now start combat, open a **second** merchant while in combat, and let combat end. Every item that sells at the second merchant must be announced. Failure is items selling silently there because the first merchant's books were still open.

**21.** Visit two merchants back to back out of combat. Each must print its own closing summary with its own numbers. Failure is the second summary carrying the first visit's totals, or no second summary at all.

**22.** Find a merchant that opens a window but cannot complete a sale — the known case is a vendor NPC that has just been killed whose merchant window still opens. Open it with junk in your bags. **No** `Sold` lines and **no** summary may print, and every item must still be in your bags afterwards. Failure is the add-on announcing sales that never happened. If you cannot reproduce that state, step 16's count-matching check covers the same ground — note in your sign-off that you skipped this one.

### The Ignore List panel repaints while it is open

Editing an ignore list from the mini-map button used to leave an already-open Ignore List panel showing the rows it drew when it opened. Every edit path now repaints it.

**23.** Open **Options > AddOns > Magic Eraser > Ignore List** and select your character's scope. Leave the panel open, then **Right-Click the mini-map button** to ignore the flagged item. The new item must appear in the panel **immediately**, without you closing and reopening it. Failure is the row only showing up after a reopen — that is the bug this fixes.

**24.** With the panel still open, **Middle-Click the mini-map button**. Every row under your character's scope must clear at once, and the **Global** scope must be untouched. Failure is stale rows surviving in the pane.

**25.** With the panel open, go to **Profiles** and switch to a different profile, then come back to **Ignore List**. It must show the new profile's list. Failure is the previous profile's rows still on screen.

**26.** With the panel open, click **Reset Profile** on the Profiles page. This character's rows must clear immediately. Failure is the panel still listing items the reset removed.

**27.** With the panel open, use **Copy From** to copy another character's profile onto this one. The rows must become that character's list immediately. Failure is a stale pane until you reopen it.

### Reset Profile clears only this character's Ignore List

A profile now holds exactly one thing, and the reset button is honest about it: account-wide settings are outside the profile and survive untouched.

**28.** Change every account-wide setting away from its default — turn the welcome message off, Auto-Vend off, Bank Retrieval off, bag-space warnings on, confirmations on, tooltips off — ignore a couple of items, drag the mini-map button somewhere distinctive, then click **Reset Profile**. Open **General** and confirm **every one** of those settings is still where you left it. Failure is any account-wide setting snapping back to its default.

**29.** Confirm the same reset **did** clear this character's Ignore List: its pane in the Ignore List panel must be empty. Failure is the list surviving a reset that is supposed to clear it.

**30.** Confirm the **Global** list is untouched by that reset, and that the mini-map button is still where you dragged it and still shown. Failure is the account-wide list emptying or the button jumping to a default spot.

**31.** Confirm the mini-map icon and tooltip **re-scanned** on the reset — the newly unprotected item must be the candidate right away, without you touching your bags. Failure is a stale candidate.

**32.** With Diagnostic Tools on, click **Show Eraser Context** after the reset. The `Ignore list:` line must read `character=0, global=N`, with `N` matching what is still on the Global list. Failure is either number disagreeing with the panel.

### Renamed and reworded strings

Several string keys were renamed and two descriptions reworded. A rename that missed a locale shows up as the raw key on screen, so these are quick reads rather than deep tests.

**33.** Hover the mini-map button. The **Auto-Vend** line's right-hand status must read **Enabled** or **Disabled** — real words. Failure is `ENABLED`, `ON`, or a blank right-hand side.

**34.** Read the bottom of the same tooltip. It must read **Magic Eraser Options** with **Shift + Middle-Click** on the line beneath it. Failure is a raw key like `MINIMAP_OPTIONS_KEYBIND` in place of the keybind line.

**35.** Open the **Ignore List** panel on a character scope. Each row's promote button must be labelled **Global**. Failure is `OPTIONS_IGNORE_PROMOTE` or an empty button.

**36.** Read the **Auto-Vend** description in the mini-map tooltip and the **Bank Retrieval** description in the options. Both must say items flagged as **clutter** — not "junk". Failure is the old wording, which means the locale file did not update.

**37.** Read the description at the top of the **Ignore List** panel. It must begin "Items on an **Ignore List** are never erased and never sold." Failure is a raw key or a truncated sentence.

When steps 1–37 pass on both flavors, this release's changes are verified — proceed to `4 - Pre-Launch Review Prompt.md`.

---

## Loading and the welcome message

**38.** Log in with the add-on freshly enabled. A single branded line must print, naming the version and pointing at Options > AddOns > Magic Eraser. Failure is no message, a doubled message, or a version showing as a literal `%s`. On an unpackaged development copy the version reads `Dev` — that is correct; on a packaged release it must read a real version number.

**39.** Turn off **Enable Welcome Message** and `/reload`. No greeting must appear. Failure is the message still printing.

**40.** Turn it back on and `/reload`. The greeting must return. Failure is the setting not sticking.

---

## Options panel

**41.** Type `/eraser`. The settings must appear **docked inside the Blizzard Options window**, with Magic Eraser selected in the category list on the left. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame.

**42.** Close Options. Hold Shift and Middle-Click the mini-map button. The same docked panel must open. Failure is the same two shapes: nothing, or a floating window.

**43.** With the panel open, click each child entry under Magic Eraser in the category list — **Ignore List**, **Profiles**, then **Diagnostic Tools**. Each must open its own page inside the Options window, in that order. Failure is a child missing from the list, listed in the wrong order, or opening blank.

**44.** Run steps 41–43 again on **TBC Anniversary** before calling this section done. Both entry points must dock there exactly as they do on Classic Era. Anniversary is the client where an options panel historically floats free or refuses to open — an Era-only run tells you nothing.

**45.** Type `/eraser` a second time while the panel is already open. It must stay open and usable. Failure is a Lua error or the panel closing.

**46.** Under the **/Commands** header, `/eraser` must be listed in blue with a description. It is the add-on's only slash command. Failure is a missing or misspelled command.

**47.** Turn **Enable Auto-Vend** off. The **Enable Auto-Vend Messages** toggle and the message-mode dropdown beneath it must **disappear**. Turn it back on and both must return. Failure is them staying visible when Auto-Vend is off.

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

**64.** Empty your bags of everything flagged. The tooltip must replace the Lowest Value Item block with the "you'll have to manually erase something" hint, the Clutter Report must read the congratulations line, and the icon must fall back to the default green bag. Left-Click now — a chat line must say your bags are full of good stuff, and **nothing may be deleted**. Failure is anything being erased with clean bags.

---

## What gets flagged, and what never does

**65.** Put a **gray item with a sell price** in your bags. It must appear as a candidate, and its erase line must end with its value. Failure is gray trash never being flagged.

**66.** If you have a **gray item a vendor will not buy** (no sell price on its tooltip), confirm it is **never** flagged and never sold. Failure is a worthless gray being offered up.

**67.** Put a **white vendor-quality item from the curated list** in your bags — *Cracked Leather Vest* or *Rough Broad Axe*. It must be flagged. Failure is curated whites being skipped.

**68.** Put **Linen Cloth** or other white trade goods in your bags. They must **never** be flagged and must never sell. Failure is any white item that is not on the curated list being touched — that is the most dangerous possible bug in this add-on.

**69.** Confirm the consumable level gate end to end: *Refreshing Spring Water* flagged from level 5, *Ice Cold Milk* from level 15, *Melon Juice* from level 25, and none of the three flagged one level below that. Failure is any boundary landing somewhere else. Steps 2–5 test these one at a time; this is the same check as a single sweep.

**70.** Carry an item left over from a **quest you have completed**. It must be flagged, and its erase line must end with the note that it belonged to a completed quest. Failure is completed quest items never being offered.

**71.** Carry a quest item for a quest you have **not** completed. It must **never** be flagged. Failure is an in-progress quest item being offered for erasure.

**72.** With several flagged items in your bags of different values, confirm the Lowest Value Item really is the **cheapest** of them. Compare whole stacks, not single items — a stack of twenty 1c grays is worth 20c and ranks above a single 5c item. Failure is a more valuable stack being offered first.

**73.** Make two flagged items worth the same amount — one a completed quest item, one gray trash. The **quest item** must be offered first. Failure is the tie broken the other way.

**74.** Make a gray item and a consumable worth the same amount. The **gray** must be offered first; consumables and curated equipment rank last and tie with each other. Failure is the consumable jumping the queue.

**75.** On a **shaman**, carry **Fish Oil** and **Shiny Fish Scales**. Both are gray with a sell price, and both must be **completely invisible** to the add-on: never flagged, never sold, never pulled from the bank, and no line on their item tooltips. Failure is either one being offered or sold.

**76.** On a character that is **not** a shaman, the same two items are ordinary gray trash and **may** be flagged. Failure is the shaman exclusion leaking onto every class.

**77.** Ignore an item (Right-Click), then confirm it is skipped everywhere — it never becomes the candidate, it is not sold at a merchant with Auto-Vend on, and it is not pulled out of the bank. Failure is an ignored item being erased, sold, or retrieved.

**78.** Confirm an item on the **Global** list is skipped in exactly the same three places, from a character whose own list is empty. Failure is protection that only holds on the character that set it.

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

**88.** Close the merchant window. Exactly **one** closing line must print — `Sold N Items (M Bag Slots), worth X.` `M` must equal the slots that emptied, and `X` must match the gold you actually gained. Failure is a summary that overcounts, a missing summary, or more than one.

**89.** Sell a large batch — fifteen or more items in one visit. Every flagged item must sell, and none may be announced **twice**, even though the add-on re-scans and retries to catch sells the server drops. Failure is a duplicated `Sold` line, an inflated summary, or junk left behind when the window closes.

**90.** Switch to **Summary Only** and sell another batch. No per-item lines may print, and the single closing line must still appear with correct numbers. Failure is per-item lines still printing, or no closing line.

**91.** Open a merchant with nothing flagged and close it again. Nothing at all may print. Failure is any Auto-Vend output for a visit where nothing sold.

**92.** Carry a flagged item with **no** sell price — a completed quest item worth nothing is the easy case. It must **not** be sold, and it must still be in your bags and still erasable after the merchant visit. Failure is the add-on trying to sell something worthless.

**93.** Add an ignored item and, on a shaman, Fish Oil, then visit a merchant. Neither may be sold. Failure is a protected item being vendored.

**94.** Turn **Enable Auto-Vend** off and visit a merchant with junk in your bags. Nothing may sell and nothing may print. Failure is it selling anyway.

**95.** Turn Auto-Vend back on but turn **Enable Auto-Vend Messages** off. Junk must still sell, but **nothing** may print — no per-item lines, no summary, no combat notice. Failure is any Auto-Vend chat while messages are off.

**96.** Open a merchant while **in combat** with Auto-Vend on, then close the merchant window **before** combat ends. Nothing may sell, and no error may appear when combat finally ends. Failure is a sale firing at an empty merchant, or a Lua error.

---

## Bank Retrieval

**97.** On a fresh install, open the options. A **Bank Retrieval** section must exist, with a description and an **Enable Bank Retrieval** toggle reading **Enabled**. Failure is a missing section, or the toggle starting off.

**98.** Put several flagged junk items in your bank, empty your bags to well above the Free-Slot Threshold, and open the bank. About half a second later the items must move into your bags on their own, and one line must print — `Pulled N Items (M Bag Slots) out of your bank, worth X.` Failure is nothing moving, or items moving with no line.

**99.** Count the bank slots that emptied against `M` in that line. The two must match exactly, and `N` must count stacked quantity (a stack of five is one slot, five items). Failure is a line claiming more than actually moved.

**100.** **The budget check.** Set the **Free-Slot Threshold** to 4 and arrange exactly **six** free bag slots, with more than two flagged items waiting in the bank. Open the bank. Exactly **two** items may be pulled — free slots minus the threshold — leaving four slots still free. Failure is your bags being filled to the brim, or nothing being pulled at all. Note that the cushion applies whether or not bag-space warnings are switched on.

**101.** Repeat step 100 with the threshold at 1 and six free slots. Five items must come across. Failure is the count not tracking the threshold you set.

**102.** With free slots at or below the threshold, open the bank. **Nothing** may be pulled and nothing may print. Failure is retrieval running with no room for it.

**103.** **Most valuable first.** Park flagged items of clearly different values in the bank and give the pass a budget smaller than the number waiting — say two slots against six items. What arrives must be the **most valuable** of them; the cheap clutter stays in the bank. Failure is the cheapest items being pulled first, which is the opposite of the intent.

**104.** Open the bank with **nothing flagged** in it. Nothing may print — no line, no empty summary. Failure is any Bank Retrieval output for a visit that moved nothing.

**105.** Put an **ignored** item in the bank and open the bank. It must **not** be pulled. Failure is retrieval ignoring the protection the eraser respects. Repeat with an item on the **Global** list from a character whose own list is empty.

**106.** On a **shaman**, put **Fish Oil** or **Shiny Fish Scales** in the bank and open it. Neither may be pulled. Failure is a class reagent being dragged into your bags.

**107.** Put items in a **purchased bank bag** rather than the main bank window, and open the bank. Flagged items there must be pulled too. Failure is only the main bank being scanned.

**108.** **Close the bank while the pass is still moving items** — a big batch gives you the window. Moving must stop where it stopped, and the summary must report only what actually made it across, never the whole queue. Failure is a line claiming items still sitting in your bank.

**109.** **Close and immediately reopen the bank**, inside the first half-second, twice in a row. Items must be pulled **once**, and exactly **one** summary line may print. Failure is a doubled pull or two summary lines — that means two passes are walking the same queue.

**110.** With **Enable Bank Retrieval** turned off, open a bank with flagged junk in it. Nothing may move and nothing may print. Failure is it running anyway.

**111.** With bag-space warnings on, open the bank and let retrieval fill your bags past the threshold. **No** countdown may print while the bank window is open; at most one line may print once you close it, reflecting where your bags actually landed. Failure is a burst of warnings during the pull.

**112.** With retrieval on and room in your bags, open the bank twice in a row without changing anything in between. The second visit must pull nothing and print nothing, because the first one already cleared what it could. Failure is a repeated pull of items that are no longer there.

**113.** Open the bank, let a pass run to completion, and check that the mini-map button icon and Clutter Report **update** to account for the newly arrived junk. Failure is a stale candidate until you touch your bags.

**114.** Erase the items retrieval just pulled, then open the bank again. The next-most-valuable batch must come across. Failure is retrieval refusing to run a second time in the same session.

**115.** Open the bank with items whose data the client has not cached — log in and go straight to the bank. Retrieval must still find and pull them within a few seconds, rather than skipping them. Failure is a cold bank being treated as empty.

**116.** Start combat with the bank window open, if you can arrange it. No Lua error may appear, and the pass must simply stop. Failure is an error or items continuing to move in combat.

---

## The Ignore List panel

**117.** Open the options. An **Ignore List** entry must sit in the category list under Magic Eraser, **above Profiles**. Order top to bottom must be Magic Eraser, Ignore List, Profiles, Diagnostic Tools. Failure is a missing entry or the wrong order.

**118.** Open it. The left side must be a tree of scopes with **Global** at the top, then your current character as **"Name - Realm"**. Failure is a flat page with no scope tree.

**119.** Select a scope with nothing on it. It must read **This list is empty.** Failure is a blank pane with no explanation.

**120.** On your character's scope, type a plain **item ID** into **Add by Item ID** and press Enter. A row must appear for that item with its icon and quality-colored name, and the box must clear itself. Failure is nothing appearing, or the typed text staying in the box.

**121.** Shift-click an **item link in chat** while the Add box has focus. The link must drop into the box, and pressing Enter must add that item. Failure is the link being rejected as invalid.

**122.** Type something that is neither — a word, a stray number with letters — and press Enter. It must be rejected with the message **Type an item ID, or shift-click an item link in chat.**, and no row may appear. Failure is a junk row you can never resolve.

**123.** Hover an item row. The item's **own game tooltip** must appear — name, quality, stats, the real thing. Failure is no tooltip, or the row's raw text shown back to you.

**124.** Click the **X** button at the right of a row. That item must leave the list immediately. Failure is the row surviving, or the wrong row going.

**125.** On a **character** scope, each row must carry a **Global** button. Click it. The item must vanish from this character's list and reappear under the **Global** scope. Failure is it being copied rather than moved — it must not remain on the character's list.

**126.** On the **Global** scope, rows must have **no** Global button — only the item and the X. Failure is a promote button on a list that is already account-wide.

**127.** Put an item on the **Global** list, then log to a **second character** and carry that item. It must **never** be flagged, never sold, and never pulled from the bank. Failure is the Global list protecting only the character that set it.

**128.** With that item globally ignored, hover it in your bags. Its tooltip must read **Protected by your Ignore List.** Failure is no line, or the erase warning showing on a protected item.

**129.** Ignore an item on a **character** list, then promote a *different* item to Global. Middle-click the mini-map button to clear the ignore list. The **character** item must go; the **Global** item must stay protected. Failure is Middle-Click wiping the account-wide list — it must only ever clear what the mini-map tooltip was showing.

**130.** Add an item to **two** characters' lists, then promote it to Global from one of them. It must disappear from **both** characters' scopes and appear once under Global. Failure is a leftover row on the other character.

**131.** Remove an item from the **Global** list. It must **not** reappear on any character's list — removing from Global protects nobody, by design. Failure is it silently landing back on a character.

**132.** Look at the scope tree with a second character that has **nothing** ignored. That character must **not** be listed. Your current character must always be listed, even with an empty list. Failure is a tree full of empty characters, or your own character missing so you cannot add a first item.

**133.** Add an item the client has not cached yet — an ID for something you are not carrying, right after a fresh login. The row must first read **Loading ID: N** in gray, then resolve to the real name and icon within a few seconds without you touching anything. Failure is a row stuck on Loading forever, or the panel never repainting.

**134.** Fill a character's list with several items and confirm the panel sorts them **alphabetically by name**, with any unresolved `Loading ID:` rows last. Failure is a random order.

---

## Ignore lists from the mini-map button

**135.** Hover the mini-map button, note the item under **Lowest Value Item**, and Right-Click. The tooltip must gain an **Ignore List** section containing that item, and the flagged item must change to something else. Failure is the item staying flagged, or no Ignore List section appearing.

**136.** Confirm that item appears in the **Ignore List** panel under your character's scope — not under Global. Failure is a mini-map ignore landing on the account-wide list.

**137.** Add an item from the panel under your character's scope and confirm it shows up in the **mini-map tooltip's** Ignore List section. Failure is the two views disagreeing.

**138.** Add an item to the **Global** scope and confirm it does **not** appear in the mini-map tooltip's Ignore List section, which shows this character's list only — but that the item is still protected. Failure is the Global list showing up where Middle-Click would wrongly imply it can clear it.

**139.** Ignore an item, then `/reload`, then log out and back in. Both lists must survive all three. Failure is either list emptying.

**140.** Ignore every flagged item in your bags one after another. Once nothing is left, the mini-map tooltip must show the clean-bags state. Failure is a candidate that is on the ignore list still being offered.

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

**156.** Check **For Low-Level Consumable Items** and flag an outgrown drink. Left-Click must prompt. Failure is the consumable category ignoring its own toggle — worth its own step this release, since the category's membership changed.

**157.** Open the confirmation, then **enter combat** before answering, then click Yes. A line must read that items cannot be erased in combat, and **nothing** may be deleted. Failure is a deletion going through in combat, or a Lua error.

---

## Combat behavior

**158.** In combat, Left-Click the mini-map button. A line must read `Cannot erase items while in combat.`, nothing may be deleted, and no Lua error may appear. Failure is an error or a deletion.

**159.** In combat, Right-Click, Middle-Click and Shift + Right-Click the button. All three must work normally — ignoring, clearing and toggling Auto-Vend are not combat-restricted. Failure is a Lua error or a blocked-action message.

**160.** Out of combat, click the button as fast as you can, repeatedly. Either each click erases the next item cleanly, or a line reads `Slow down! You're clicking faster than the game can erase items.` **No item other than the one named in the tooltip may ever be deleted.** Failure is the wrong item being destroyed — treat this as a launch blocker.

**161.** Leave combat with nothing pending. No stray message may print. Failure is a deferred notice firing when nothing was deferred.

---

## Diagnostic Tools

**162.** Open **Diagnostic Tools** on a fresh login. **Enable Diagnostic Tools** must be **off**, with everything below it hidden and only the warning text showing. Failure is it remembering being on from an earlier session.

**163.** Turn it on. Every section below must appear, each under its own header — Event Log, Event Registration, API Endpoints, Eraser Context, Display Context, Other Add-ons, Saved Variables, Library Versions, Taint Log, External Tools. Failure is a missing section or a header with no content beneath it.

**164.** `/reload` and reopen the panel. The toggle must be **off** again — it is deliberately not remembered. Failure is it persisting across a reload.

**165.** Turn it on, click **Start Event Log**, then open your bags, visit a merchant, **open and close your bank**, and hand in a quest. Click **Show Captured Events**. The output must list events with timestamps — `BAG_UPDATE_DELAYED`, `MERCHANT_SHOW`, `MERCHANT_CLOSED`, `BANKFRAME_OPENED`, `BANKFRAME_CLOSED`, `QUEST_TURNED_IN`. Failure is an empty log, or the bank events missing after you clearly opened a bank.

**166.** Click **Stop Event Log**, then **Show Captured Events** again. The box must read `(no events captured)`. Failure is old entries persisting.

**167.** Click **Test Event Registration**. Every line must read `PASS`, and the list must include both `BANKFRAME_OPENED` and `BANKFRAME_CLOSED`. Failure is any `FAIL` — note which event and which flavor.

**168.** Click **Test WoW API Endpoints**. Two lines are expected to differ between the clients — `GetAddOnMetadata (legacy)` and `TooltipDataProcessor.AddTooltipPostCall`. Record what each flavor reports for those two. **Every other line must read PASS on both flavors.** Failure is a FAIL on anything else.

**169.** Click **Show Eraser Context**. It must name your class and level, the Auto-Vend state, the **Bank retrieval** state, an **Ignore list** line reading `character=N, global=M`, a **Databases** line reading `consumables=347`, the class reagent exclusion count, and the current erase candidate. Both ignore-list numbers must match what you actually have on each list, and the candidate must match what the mini-map tooltip is showing right now. Failure is a mismatch, a missing line, or a candidate reported when your bags are clean.

**170.** Click **Show Display Context**. `Minimap button created` must read `yes`, and a saved angle must be listed. Failure is `no` while the button is plainly on your mini-map.

**171.** Click **List Installed Add-ons**, **List Library Versions**, and **Dump Saved Variables** in turn. Each must fill its box with readable text. The saved-variables dump must show your settings, your profiles, and **each** ignore list as a count like `{ 3 entries }`, including the account-wide one under `global`. Failure is an empty box, a wall of raw item IDs, or an error.

**172.** Read the dump for your **own character's** "Name - Realm" profile. It must contain `ignoreList = { N entries }` matching what you have ignored, and **no** `ignoreLists` (plural) table. Failure is the plural table surviving in your own profile. An old `Default` profile further down may still list buckets for characters that have not logged in yet — that is expected, and clears as each one logs in.

**173.** Click **Turn On Taint Log** — the state line above must change to level 2 — then **Turn Off Taint Log**, which must return it to 0. Failure is a state line that does not follow the buttons.

**174.** Compare shades on this panel. The section hints — the event-log hint, the taint-log state line and hint, and the two External Tools lines — must read **silver**, visibly different from the white body text in the mini-map tooltip. On the two External Tools lines, the sentence must **stay silver after** the blue `/console scriptErrors 1` and `/etrace` text. Failure is everything rendering the same shade, or a line turning white partway through.

---

## Profiles

**175.** Open **Profiles**. The current profile must be your character's own **"Name - Realm"**. Failure is `Default`.

**176.** Log to a second character on the same account. Its Profiles page must show **its own** "Name - Realm", and anything you ignored on the first character must **not** be in its mini-map tooltip. Failure is one character's ignored items showing up on another.

**177.** On that second character, check the account-wide settings — Auto-Vend, Bank Retrieval, welcome message, bag-space warnings, confirmations. Every one must match what you set on the first character. Failure is settings resetting per character; only the per-character Ignore List is per-character.

**178.** Log back to the first character and confirm its Ignore List is intact. `/reload`, then log out and back in, and confirm it is still there. Failure is the list emptying on any of those.

**179.** **Upgrade check — only if you had items on your Ignore List before installing this build.** Log in on this build for the first time on that character. The items you had ignored must still be ignored, on that same character. Failure is an empty list, or another character's ignored items appearing in it.

**180.** Ignore a couple of items, then use **Copy From** to copy another character's profile onto this one. That character's per-character Ignore List must replace yours, and the mini-map button icon must update immediately to the new lowest-value item. Failure is a stale candidate until you touch your bags.

**181.** Create a new profile, switch to it, and confirm the per-character Ignore List is empty and the flagged item re-scans right away. Confirm the **Global** list is unaffected — it is account-wide and no profile switch may touch it. Switch back and confirm your original list returns, then delete the profile you created. Failure is a switch that leaves the button showing the old profile's item, or that empties the Global list.

---

## Flavor differences to watch

Do not let a clean Classic Era run stand in for both flavors. These are the places the two clients have behaved differently:

- **The options panel docking (steps 41–45).** This is the big one. Classic Era has always docked correctly; TBC Anniversary is the client where an options panel opens floating, or refuses to open at all. Run these on Anniversary or you have not tested the panel.
- **Which consumables exist (steps 2–15).** The rebuilt list spans both clients, so many entries are TBC-only — Bash Ale, the Warsong Gulch and Arathi Basin rations, the Blackrock waters, everything from Outland. Pick items that actually exist on the client you are testing rather than assuming an Era item is available on Anniversary or the reverse. *Refreshing Spring Water*, *Ice Cold Milk* and *Melon Juice* exist on both, which is why the level-boundary steps use them.
- **The Ignore List panel (steps 117–134).** It is the deepest panel the add-on renders — a scope tree with rows inside it. Check the columns line up on both clients, and that picking a different scope does not shuffle them sideways.
- **Bank Retrieval (steps 97–116).** Bank bag counts differ between the clients, so run the bank-bag step (107) on both rather than assuming the main bank window covers it.
- **Item tooltips (steps 79–84).** The two clients expose different tooltip APIs, so the warning line is added by a different mechanism on each. It must appear, exactly once, on both — a pass on one flavor proves nothing about the other.
- **The API Endpoints report (step 168).** `GetAddOnMetadata (legacy)` and `TooltipDataProcessor.AddTooltipPostCall` are expected to read differently on the two clients. Record both; everything else must PASS on both.
- **Any Lua error at all.** An error that appears on one flavor and not the other is a flavor difference by definition — note which client it happened on.

---

## Localization spot-check

Optional, and only worth doing on a non-English client.

**182.** Log in on a non-English client and open the options. Every label and description must be in that language. Failure is a raw key like `OPTIONS_ENABLE_BANK_RETRIEVAL` showing through, which means a string is missing.

**183.** Hover the mini-map button and read the **Auto-Vend** status word and the keybind line at the bottom. Both must be translated words, not `ENABLED` / `DISABLED` or `SHIFT_MIDDLE_CLICK`. These two keys were renamed this release, so a locale that missed the rename shows the key here first.

**184.** Open the **Ignore List** panel and check the promote button label. It must be a translated word, not `OPTIONS_IGNORE_GLOBAL`. Also check the add box's rejection message and the empty-list text render in that language, and that the **Global** scope label and the promote button both fit their space. Failure is a raw key, or clipped or overlapping text in the scope tree.

**185.** The **Diagnostic Tools** panel is deliberately English on every client — that is intended and not a bug. Failure would be a raw key, not English text.

**186.** Trigger the welcome message, an erase, an Auto-Vend sale, the closing summary, and a **bank retrieval** line. Each must read as a natural sentence in that language, with the version, item name, stack size, counts and money appearing in sensible places. Failure is a literal `%s`, a `nil`, a doubled value, or a number landing in the wrong slot.

**187.** Turn on bag-space warnings and fill your bags to exactly one free slot, then zero. Both the "1 slot remaining" and the "bags are full" lines must read naturally — the singular line is a separate string in every locale, so it must not come out as a plural with a 1 in it. Failure is a mangled or plural-looking singular.

**188.** Check **Russian (ruRU)** specifically. Russian is the widest text here, so it is the first to overflow. The mini-map tooltip, the options descriptions, the Ignore List panel and the chat lines must all still fit and read cleanly — no text running off the tooltip, no label overlapping its control. Failure is a truncated or overlapping string.

---

## Sign-off

Manual testing is complete when **every step passes on both Classic Era and TBC Anniversary**. One flavor is not enough — step 44 exists precisely because the options panel is the thing that has broken on Anniversary alone.

When both rows below are filled in and passing, the add-on is ready for `4 - Pre-Launch Review Prompt.md`.

| Flavor | Tester | Date | Result | Failed steps |
|---|---|---|---|---|
| Classic Era | | | Pass / Fail | |
| TBC Anniversary | | | Pass / Fail | |
