# Magic Eraser

Delete junk and free up bag space instantly. Completed quest items, low-level consumables, vendor-quality whites, and gray trash go with one click of the mini-map button, and anything sellable auto-sells at the merchant. Never haul vendor trash again.

<img width="250" src="https://github.com/user-attachments/assets/d30470c9-4585-4288-aec3-b04e34b44afc" />

## Features

🧹 **One-Click Cleanup** // The mini-map button wears the icon of your lowest-value junk. Left-click and it's gone, with no "Are you sure?" dialog unless you ask for one.

🏦 **Bank Retrieval** // Open your bank and the junk you stashed in there walks itself back into your bags, ready to erase or sell.

📊 **Clutter Report** // Hover the button to see how many bag slots your junk is squatting on and exactly what the pile is worth.

🔔 **Quest Alerts** // Turn in a quest and get an instant heads-up about any quest item that's now safe to erase, plus the ones your race or class can never use.

🦺 **Safety First** // The trash list is hand-curated and human-reviewed: no name-matching, no heuristics, no surprise deletions. Your bag tooltips flag what's on the chopping block, and class reagents and Ignore List items are never touched.

## Setup

1. Install the add-on, ideally using [CurseForge](https://www.curseforge.com/wow/addons/magic-eraser) or [Wago](https://addons.wago.io/addons/magic-eraser).
2. Log in. The mini-map button shows the icon of the lowest-value junk currently in your bags.
3. Left-click to erase it, right-click to spare it, or Shift+Middle-click to open the Options Interface.
4. Auto-Vend and Bank Retrieval are on out of the box, so the rest pays for itself the next time you talk to a merchant.
5. *"Hasta la vista, vendor trash"*

## How It Works

### Smart Scanning

Magic Eraser watches your bags and picks out the lowest-value match from four categories: quest items you no longer need, outgrown food and drink (anything you passed the use level on ten levels ago, with starter food and drink going at level 5 instead of lingering), vendor-quality white gear from the curated list, and gray trash with a sell price. The mini-map icon updates live to show what's next on the chopping block.

A quest item counts as spent once you've handed the quest in. An item that *starts* a quest your character can never take is dead weight the moment it drops, so a Paladin-only Tome of Divinity sitting in a Rogue's bags is fair game right away.

When two items are worth the same, category priority breaks the tie: quest items first, then gray trash, then consumables and equipment. Anything on your Ignore List or flagged as a class-specific reagent is skipped, so Shamans never lose their Fish Oil or Shiny Fish Scales.

### Mini-map Button

| Action             | Effect                                                   |
| ------------------ | -------------------------------------------------------- |
| Left-click         | Erase the lowest-value flagged item.                     |
| Right-click        | Toggle the flagged item on this character's Ignore List. |
| Middle-click       | Clear this character's Ignore List.                      |
| Shift+Right-click  | Toggle Auto-Vend on or off.                              |
| Shift+Middle-click | Open the Options Interface.                              |

Hover the button and the tooltip lays out the whole picture: the item you're about to erase and what it's worth, whether Auto-Vend is on, everything you've told it to spare, and a Clutter Report totalling the bag slots and gold still sitting in the trash pile.

### Auto-Vend

Every flagged item sells automatically the moment you open a merchant, and it's on by default. Chat gives you one summary line as the window closes; switch to Line Item and every sale is announced as it happens, with that summary still landing at the end. Turn the messages off entirely if you'd rather it worked in silence. If you opened the merchant mid-fight, the sale waits politely until combat ends. Toggle the whole thing with Shift+Right-click on the mini-map button or from the Options Interface.

### Ignore List

Right-click the mini-map button to protect whatever item is currently flagged, and middle-click to wipe that list and start over. Anything on it is never erased and never sold.

There are two lists, and they stack. Each character keeps its own, and there's a Global list that protects an item on every character at once. Manage both from **Options > AddOns > Magic Eraser > Ignore List**, where you can add items by ID or by shift-clicking an item link straight from chat, promote a character's entry to Global, or remove anything you've changed your mind about.

### Options

Find the Options Interface at **Options > AddOns > Magic Eraser**, or just type `/eraser`. From there you can toggle the welcome message and the mini-map button, tune Auto-Vend and its chat output, cap the value of what gets erased, switch Bank Retrieval and bag tooltips on or off, set up confirmations and bag-space warnings, and manage profiles.

<img width="800" src="https://github.com/user-attachments/assets/303e0441-0002-4714-ba65-076bfa394e54" />

## Testing & Localization Status

🟢 World of Warcraft Classic (🟡 Season of Discovery) // WoW 1.15.9

🟢 Burning Crusade Anniversary // WoW 2.5.6

🔴 Mists of Pandaria Classic // WoW 5.5.4

🔴 World of Warcraft // WoW 12.1.0

**Localization Status** // Works with all Classic WoW Locales (enUS, deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW).

Please reach out if you would like to be involved!

## Links

- [GitHub](https://github.com/Gogo1951/Magic-Eraser)
- [Discord](https://discord.gg/eh8hKq992Q)

## Related Add-ons

🟢 Pairs With // Arkayenro's [ArkInventory](https://www.curseforge.com/wow/addons/ark-inventory)

🟢 Pairs With // plusmouse's [Baganator](https://www.curseforge.com/wow/addons/baganator)

🟢 Pairs With // jaliborc's [Bagnon](https://www.curseforge.com/wow/addons/bagnon)

🟢 Pairs With // Gogo1951's [Connoisseur](https://www.curseforge.com/wow/addons/consumable-connoisseur)

🟢 Pairs With // Gogo1951's [Open Sesame](https://www.curseforge.com/wow/addons/open-sesame)

🟡 Some Overlap // Kemayo's [BankStack](https://www.curseforge.com/wow/addons/bank-stack)

🟡 Some Overlap // Gogo1951's [Play It Forward](https://www.curseforge.com/wow/addons/play-it-forward)

🔴 Direct Alternative // moody's [Dejunk (Sell & Destroy Junk)](https://www.curseforge.com/wow/addons/dejunk)

🔴 Direct Alternative // Kemayo's [DropTheCheapestThing](https://www.curseforge.com/wow/addons/dropthecheapestthing)

🔴 Direct Alternative // jaliborc's [Scrap (Junk Seller)](https://www.curseforge.com/wow/addons/scrap)

🔴 Direct Alternative // Supernovadusts's [SellTrash](https://www.curseforge.com/wow/addons/selltrash)

🔴 Direct Alternative // typicalzergling's [Vendor](https://www.curseforge.com/wow/addons/vendor)
