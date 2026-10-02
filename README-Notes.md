# Magic Eraser // Notes

> The maintainer's settled rulings for Magic Eraser, kept so no review raises them again: exceptions to the Gogo1951 add-on Style Guide, and decisions it leaves open.

## Exceptions

None.

## Decisions

- The mini-map tooltip's Auto-Vend state words are "Enabled / Disabled".
- Manual Delete Assistance uses the four guarded StaticPopup dialog methods, which exist on both Classic Era and TBC Anniversary (tested working on both), with no legacy `_G[name .. "EditBox"]` fallback.
- The bag-item tooltip's `GetCarriedBagSlot` owner check in `Features/Item-Tooltips.lua` is settled: the line renders inside ArkInventory's bag window alongside TSM's tooltip block, so bag add-on compatibility isn't re-raised.
- The mini-map Middle-Click clears this character's Ignore List in one click, with no confirmation and no chat line.
- Bank Retrieval pulls from the character's own bank only, never the account-wide Warband bank tabs WoW Forever has.
- The root panel keeps the Welcome Message and Mini-map Button switches at the top, then a Features section with every feature's switch, then Key Bindings, then /Commands directly above Feedback & Support. The mini-map clicks are listed only in the button's own tooltip, never in the Options Interface. (Also a guide rule for every add-on.)
- Players see the Ignore List as the **Protect List**. Only display strings changed: the saved `ignoreList` tables, `ns:IsIgnored`, the `IgnoreList` registry key and the `MAGICERASER_ADD_TO_IGNORE_LIST` binding name keep their names, so nobody loses a list or a bound key.
- **Your Current Bags** is its own panel, directly under the Erase List.
- The Protect List and Erase List panels keep their tree of scopes (All Characters, then one node per character), because players can have ten or more characters. Tabs don't scale to that.
- Declined: merging the Erase and Protect labels of the mini-map tooltip, the Your Current Bags buttons and its column headers into one key each; every place keeps its own key.
- The stock Profiles panel stays. Every character shares the Default profile, which holds every setting; a player who really needs something different makes a new profile by hand, for one-offs. Each character's own lists live in `char`, not the profile, and the All Characters lists and the mini-map position live in `global`, so neither ever changes with the profile.
