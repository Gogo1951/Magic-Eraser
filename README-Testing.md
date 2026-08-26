# Magic Eraser // Manual Test Plan

This is the manual test plan for Magic Eraser, the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Magic-Eraser/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Magic-Eraser/blob/main/README-Technical.md).

## Before you start

**Run the whole list on Classic Era, then `/reload` and run it again on TBC Anniversary.** Steps are numbered continuously so you can report "failed on step N."

Gather these first, so you are not caught short halfway through:

- **Characters.** One character at level 15 or higher on each flavor. A second character on the same account for the Global list checks in steps 14 and 24. For steps 1 to 5 you also want a character who is locked out of a quest by race or class, and one who is not: any non-Human for *Goldshire Gift Voucher*, any non-Tauren for *Bloodhoof Village Gift Voucher*, any non-Rogue for *Elegant Letter*.
- **Items and bags.** Gray trash with a sell price. A curated white, *Cracked Leather Vest* or *Rough Broad Axe*. An item your client draws in green. White trade goods such as *Linen Cloth*. *Refreshing Spring Water*, *Ice Cold Milk* and *Melon Juice*. A single stack of junk worth more than one gold. A bound item that starts a quest and is already spent, meaning either the quest is done or your race or class can never take it. A quest item for a quest you have not finished. Keep a few free bag slots.
- **Location and state.** Out of combat except where a step says otherwise. A merchant and a bank you can reach, and something willing to fight you for step 18.
- **A non-English client**, for the optional last step only.

Every step below has a pass or fail you can see. To stay short enough to finish in one sitting, this plan deliberately skips the erase confirmation dialog, the welcome and mini-map toggles, profile switching, adding items by ID inside either list panel, the bag-space countdown, and Auto-Vend deferring a sale until combat ends.

## Verify this release's changes

Everything in this section is new since the last packaged build, so this is the part worth running carefully.

### Quest starters your character can never use

**1.** Log in with a spent quest starter already sitting in your bags. Chat must say **nothing** about it. Failure is an alert line for every such item on every single load, which is exactly what the login pass exists to prevent.

**2.** With the add-on already loaded, put a fresh spent quest starter into your bags, by looting one or pulling one out of the bank. Within about a second chat must print exactly one branded line: `[item] can now be safely erased!` when the quest is already complete, or `[item] can be safely erased, from a quest your character cannot take.` when your race or class is locked out. Failure is silence, the wrong one of those two sentences, or a raw key such as `QUEST_STARTER_UNAVAILABLE`.

**3.** Move that item between bag slots, then open a merchant and close it again. The alert must **not** print a second time. Failure is a repeat line every time your bags change, which turns one heads-up into chat spam.

**4.** Hover the mini-map button. That item must be named under **Lowest Value Item**, or be counted in the **Clutter Report** if something cheaper outranks it. Left-Click once it is the named candidate. Chat must read `Erased [item], from a quest your character cannot take.` for a race or class lock-out, and `Erased [item], from a quest you have completed.` for a quest you finished. Failure is the wrong sentence for the reason, or the item never becoming a candidate at all.

**5.** Now carry that same race-locked or class-locked item on a character who **can** take the quest and has not done it. It must never be flagged: no chat alert, no line on its tooltip in your bags, and it never becomes the candidate. Failure here is the dangerous one, because it means the add-on is offering to erase a quest starter the character still needs.

### Maximum Value to Erase

**6.** Type `/eraser` and find the **Maximum Value to Erase** section. On a fresh profile **Enable Maximum Value to Erase** must be **off**, and no limit row may be visible beneath it. Failure is the section missing entirely, or the toggle shipping switched on.

**7.** Turn it on. One indented row must appear on a single line: the caption **Never Erase Anything Worth More Than** in silver, with a dropdown beside it rather than stacked under it. Open the dropdown. It must read **1 Gold, 2 Gold, 3 Gold, 5 Gold, 8 Gold, 13 Gold, 21 Gold** in that order. Failure is "13 Gold" sitting between "1 Gold" and "2 Gold", which means the list is being sorted as text.

**8.** Pick **1 Gold** with a stack of junk in your bags worth more than a gold. Without reloading: the mini-map icon and the Lowest Value Item block must move to something cheaper, the **Clutter Report** slot count and total must drop by that stack, and hovering the stack in your bags must show **no** Magic Eraser erase line. Failure is the button still wearing that stack's icon, or a tooltip still promising an erase that can no longer happen.

**9.** With the cap still at 1 Gold, take that same over-cap stack to a merchant with Auto-Vend on. It must still sell. Put another in your bank and reopen the bank: it must still walk back into your bags. Failure is the cap blocking either one. The cap stops an item being destroyed, never stops it being turned into gold.

### White gear is judged by the quality your client shows

**10.** Put a curated white in your bags, *Cracked Leather Vest* or *Rough Broad Axe*. Its name must be white, and its tooltip must carry the `Magic Eraser will erase this.` line. Then find an item your client draws in **green** and confirm it is never flagged: no tooltip line, never the candidate, never sold. Run the green half on **both** flavors with the same item, because a handful of low-level crafted pieces are white on one client and green on the other, and the point of this change is that the client in front of you decides. Failure is a curated white being skipped, or any green item being offered for erasure.

### Bag-Space Warnings threshold

**11.** Turn **Enable Bag-Space Warnings** on. The **Free-Slot Threshold** slider must appear on **one** indented line, with its caption in silver beside it rather than above it. Turn the warnings back off: the whole row must vanish at once, leaving no blank indented line behind. Failure is the slider outliving its parent toggle, or an empty gap where the row was.

### Ignore List panel copy

**12.** Open **Options > AddOns > Magic Eraser > Ignore List**. The paragraph explaining the two lists must appear **once**, full width, above the scope list on the left. Click **Global**, then click a character scope. The paragraph must stay exactly where it is. Failure is the same copy repeated inside every scope, or the paragraph disappearing when you change scope.

### Erase List seeding

**13.** Log in on a character that is **not** a Shaman and open **Options > AddOns > Magic Eraser > Erase List**. That character's own scope must already list **Shiny Fish Scales** and **Fish Oil**, each drawn as a real item link with its icon rather than a raw id. Click the **Global** button on one of them: that row must leave this pane and turn up under **Global**. Remove both rows, then `/reload` and reopen the panel: they must **stay** removed. Now log in on a Shaman and check the same pane: it must list **neither**. Failure is an empty list on a fresh non-Shaman, either row coming back after a reload, or a Shaman starting with their own reagents listed.

### Erase List behavior

**14.** With a stack of *Fish Oil* in a non-Shaman's bags, confirm it is junk everywhere: it can become the candidate, its bag tooltip reads `On your Erase List, so it will be erased.`, it sells at a merchant, and it walks out of the bank. Then turn on **Maximum Value to Erase** and set the limit below that stack's total value. The listed item must **still** be flagged and still sell, while a gray stack worth more than the same limit is skipped, because the cap deliberately does not apply to a list the player built. Last, add that same item to this character's **Ignore List** as well: the tooltip must flip to `Protected by your Ignore List.` and the item must be spared everywhere, even though it now sits on both lists. Failure is the cap suppressing a listed item, or the Erase List winning over the Ignore List.

### Old saved data

**15.** Upgrade over the previous release rather than installing clean, then log in. Your settings and both Ignore Lists must be exactly as you left them, your Erase Lists must hold their seeded pair without duplicating it, and no red Lua error may appear. `/reload` and check again. Failure is anything reverting to a default, or an error at login. This release removes the last of the old per-character saved table, so this is the run that proves nothing went with it.

When steps 1 to 15 pass on both flavors, this release's changes are verified, so proceed to `4 - Pre-Launch Review Prompt.md`.

## Core checks

**16.** Log in with the add-on freshly enabled. Exactly one branded line must print, naming a version and pointing at Options > AddOns > Magic Eraser. On an unpackaged development copy the version reads `Dev`, which is correct; a packaged release must read a real version number. Then `/reload`. Failure is no message, a doubled message, a literal `%s` where the version belongs, or any Lua error on either load.

**17.** Type `/eraser`. The settings must appear **docked inside the Blizzard Options window**, with Magic Eraser selected in the category list on the left. Close it and hold Shift while Middle-Clicking the mini-map button: the same docked page must open. Close it again, open the Blizzard Options window yourself and pick **Magic Eraser** out of the category list. All three routes must land on the same docked page, its children must be listed as **Ignore List**, **Erase List**, **Profiles**, **Diagnostic Tools** in that order, and under the **/Commands** header `/eraser` must be listed in blue followed by **Opens the Options Interface for this add-on.** Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame. **TBC Anniversary is the flavor that historically breaks this**, so a run on Classic Era alone has not finished this step.

**18.** Get into combat and type `/eraser`. One line must read `Magic Eraser // As a safety precaution, the Options Interface cannot be opened during combat.` and the panel must **not** open. Shift + Middle-Click the mini-map button while still in combat: same line, same refusal. Ask three or four more times each way, and the line must print **every** time. Then let combat end without touching anything: the panel must not open by itself. Failure is the panel opening, silence after the first refusal, or a red `ADDON_ACTION_BLOCKED` error naming Magic Eraser.

**19.** Hover the mini-map button with junk in your bags. The tooltip must read, top to bottom: the add-on name with the version on the right; **Lowest Value Item** with the item's icon, link and value; **Left-Click / Erase**; **Right-Click / Ignore**; **Auto-Vend** showing Enabled or Disabled, with its description and **Shift + Right-Click / Toggle**; **Clutter Report** with a bag-slot count, an item count and a total; the **Ignore List** with **Middle-Click / Clear Ignore List** below it, if you have anything ignored; and last, **Magic Eraser Options** with **Shift + Middle-Click**. The button's icon must match the item named under Lowest Value Item. Failure is a missing block, a block out of that order, an empty line where a value belongs, or an icon that does not match.

**20.** Work through the clicks and confirm each does what the tooltip beside it says. Left-Click erases the named item, plays a sound, and refreshes the tooltip to the next item **while you are still hovering**. Right-Click adds the named item to this character's Ignore List, and it appears in the tooltip's Ignore List block. Middle-Click empties that block. Shift + Right-Click flips the Auto-Vend line between Enabled and Disabled live, and **Enable Auto-Vend** in the Options Interface must be flipped to match. Failure is any click doing something other than its label, the two Auto-Vend readings disagreeing, or a tooltip that catches up only after you move the mouse away and back.

**21.** With several flagged items of different values in your bags, confirm the candidate really is the cheapest, comparing whole stacks rather than single items: twenty grays at 1 copper is worth 20 copper and outranks a single 5 copper item. Then make two flagged items worth the same and check the tie-break, which runs Erase List items first, then completed quest items, then gray trash, then consumables and curated whites together. Failure is a more valuable stack being offered first, or a tie broken the other way.

**22.** Check the outgrown-consumable boundary, on one character you can level or on three at the right levels: *Refreshing Spring Water* is flagged from level 5, *Ice Cold Milk* from 15, *Melon Juice* from 25, and none of the three one level below that. Then carry a drink one level short of qualifying and **level up**: the candidate must update on the level-up itself, with you touching nothing. Failure is a boundary landing somewhere else, or having to move an item before the add-on notices.

**23.** Confirm the never-touched set, one item at a time: white trade goods such as *Linen Cloth*, anything green or better, your equipped gear, a quest item for a quest you have not finished, and a gray a vendor will not buy. Pick a trade good that is **not** on your Erase List for this one, since the seeded fishing reagents are white trade goods the add-on is now supposed to take. None may be flagged, none may show a Magic Eraser line on its tooltip, and none may sell at a merchant. Failure here is the most dangerous kind of bug this add-on can have.

**24.** Right-Click an item to ignore it, then confirm it is skipped everywhere: it never becomes the candidate, Auto-Vend leaves it alone at a merchant, and Bank Retrieval leaves it in the bank. Repeat from a second character with that item on the **Global** list and that character's own list empty. Failure is a protected item being erased, sold or retrieved on either list.

**25.** Sell a batch at a merchant with **Enable Auto-Vend Messages** on and the mode set to **Line Item**. Each sale prints one line reading `Sold [item], worth [price].` with a working, quality-colored item link you can click. Switch to **Summary Only**, sell another batch and close the merchant window: one line must read `Sold N items (M bag slots), worth X.` Then open a bank holding flagged junk: one line must read `Pulled N items (M bag slots) out of your bank, worth X.`, and retrieval must stop before filling you up, leaving the same free-slot cushion you set for Bag-Space Warnings. Every one of these must read as a complete sentence. Failure is a broken or half-rendered link, a stray `%s`, a sentence that stops partway, or a bank that fills you to your last slot.

**26.** Open **Diagnostic Tools**. On a fresh login **Enable Diagnostic Tools** must be **off**, with only the warning paragraph and that toggle visible. Turn it on and click **Test WoW API Endpoints**. Every line must read PASS, except inside the three modern and legacy pairs, where at least one half must pass and a FAIL on the other half is the report working rather than a defect. Note which half passed for each pair, on each flavor. Then `/reload` and reopen the panel: the toggle must be back **off**. Failure is the toggle surviving a reload, both halves of any pair reading FAIL, or a FAIL on any line outside those pairs.

**27.** Optional, on a non-English client: open the Options Interface, hover the mini-map button, and erase and sell one item. Every string must render as real words in that language, with no raw keys such as `TAB_IGNORE_LIST` showing through, and every number and item name must land inside its sentence rather than leaving a bare `%s` or `%d` behind. Failure is a raw key, a stray placeholder, or a sentence assembled in the wrong order.

When every step passes on both Classic Era and TBC Anniversary, manual testing is complete, so proceed to `4 - Pre-Launch Review Prompt.md`.
