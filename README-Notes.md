# Magic Eraser // Notes

> The maintainer's settled rulings for Magic Eraser, kept so no review raises them again: exceptions to the Gogo1951 add-on Style Guide, and decisions it leaves open.

## Exceptions

### README TL;DR length

- **Departs from:** README Creation Rules, Sales-Pitch Summary, TL;DR line, "one or two short sentences."
- **Instead:** The README's TL;DR runs to four short sentences in the maintainer's own wording.
- **Why:** The TL;DR is the maintainer's hand-written voice, and its length is deliberate.

## Decisions

- The mini-map tooltip's Auto-Vend state words are "Enabled / Disabled".
- Manual Delete Assistance uses the four guarded StaticPopup dialog methods, which exist on both Classic Era and TBC Anniversary (tested working on both), with no legacy `_G[name .. "EditBox"]` fallback.
- The bag-item tooltip's `GetCarriedBagSlot` owner check in `Features/Item-Tooltips.lua` is settled: the line renders inside ArkInventory's bag window alongside TSM's tooltip block, so bag add-on compatibility isn't re-raised.
- The mini-map Middle-Click clears this character's Ignore List in one click, with no confirmation and no chat line.
- Bank Retrieval pulls from the character's own bank only, never the account-wide Warband bank tabs WoW Forever has.
- The root panel keeps the Welcome Message and Mini-map Button switches at the top, then a Features section with every feature's switch, then Key Bindings, then /Commands directly above Feedback & Support. The mini-map clicks are listed only in the button's own tooltip, never in the Options Interface. (Also a guide rule for every add-on.)
- Players see the Ignore List as the **Protect List**. Only display strings changed: the saved `ignoreList` tables, `ns:IsIgnored`, the `IgnoreList` registry key and the `MAGICERASER_ADD_TO_IGNORE_LIST` binding name keep their names, so nobody loses a list or a bound key.
- **Your Current Bags** is its own panel, directly under the Erase List.
- What Counts as Junk is one checkbox per kind, two to a line, and a single Erase Confirmation switch (off by default) in its own section at the bottom of the Erasing panel asks before every erase, Erase List included.
- The Protect List and Erase List panels keep their tree of scopes (All Characters, then one node per character), because players can have ten or more characters. Tabs don't scale to that.
- Declined: merging the Erase and Protect labels of the mini-map tooltip, the Your Current Bags buttons and its column headers into one key each; every place keeps its own key.
- The stock Profiles panel stays. Every character shares the Default profile, which holds every setting; a player who really needs something different makes a new profile by hand, for one-offs. Each character's own lists live in `char`, not the profile, and the All Characters lists and the mini-map position live in `global`, so neither ever changes with the profile.
- In the README's Related Add-ons, Play It Forward sits under Overlaps and ArkInventory under Pairs With.
- Declined: adding a quest starter found only in the wago.tools tables. One joins a flavor's list only once that client's Wowhead quest page confirms the quest is one-time, because a repeatable quest's starter must never be erased.
- Consumables and quest items carry no zone: zone-limited food such as the Arathi Basin and Warsong Gulch rations is outgrown by level like any other food, and a zone-limited quest item goes when its quest does, so where an item can be used never changes when it is junk.
