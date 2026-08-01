# Magic Eraser

Clean up your bags instantly. Completed quest items, low-level consumables, vendor-quality whites, and gray trash are erased with each click of the mini-map button. When you visit a merchant, anything that can be is sold automatically.

<img width="360" src="https://github.com/user-attachments/assets/8d4393ce-2afd-47b2-a9bc-b67bc4c3b97e" />

## Features

🧹 **One-Click Cleanup** // The minimap button wears the icon of your lowest-value junk — left-click and it's gone, with no "Are you sure?" dialog unless you ask for one.

🏦 **Bank Retrieval** // Open your bank and the junk you stashed in there walks itself back into your bags, ready to erase or sell.

📊 **Clutter Report** // Hover the button to see how many bag slots your junk is squatting on and exactly what the pile is worth.

🔔 **Quest Alerts** // Turn in a quest and get an instant heads-up about any quest item that's now safe to erase.

🦺 **Safety First** // The trash list is hand-curated and human-reviewed — no name-matching, no heuristics, no surprise deletions. Your bag tooltips flag what's on the chopping block, and class reagents and Ignore List items are never touched.

## Setup

1. Install the add-on, ideally using [CurseForge](https://www.curseforge.com/wow/addons/magic-eraser) or [Wago](https://addons.wago.io/addons/magic-eraser).
2. Log in. The minimap button shows the icon of the lowest-value junk currently in your bags.
3. Left-click to erase it, right-click to spare it, or Shift+Middle-click to open the options panel.
4. Auto-Vend and Bank Retrieval are on out of the box, so the rest pays for itself the next time you talk to a merchant.
5. Done — your bags now keep themselves clean. *"Cleanest bags on the server!"*

## How It Works

### Smart Scanning

Magic Eraser watches your bags and picks out the lowest-value match from four categories: completed quest items you no longer need, outgrown food and drink (anything you passed the use level on ten levels ago — starter food and drink go at level 5 instead of lingering), vendor-quality white gear from the curated list, and gray trash with a sell price. The minimap icon updates live to show what's next on the chopping block.

When two items are worth the same, category priority breaks the tie — completed quest items first, then gray trash, then consumables and equipment. Anything on your Ignore List or flagged as a class-specific reagent is skipped, so Shamans never lose their Fish Oil or Shiny Fish Scales.

### Minimap Button

| Action             | Effect                                                    |
| ------------------ | --------------------------------------------------------- |
| Left-click         | Erase the lowest-value flagged item.                      |
| Right-click        | Toggle the flagged item on this character's Ignore List.  |
| Middle-click       | Clear this character's Ignore List.                       |
| Shift+Right-click  | Toggle Auto-Vend on or off.                               |
| Shift+Middle-click | Open the options panel.                                   |

Hover the button and the tooltip lays out the whole picture: the item you're about to erase and what it's worth, whether Auto-Vend is on, everything you've told it to spare, and a Clutter Report totalling the bag slots and gold still sitting in the trash pile.

<img width="360" src="https://github.com/user-attachments/assets/252363c9-2a5f-4874-b875-09cefd9a0dba" />

### Auto-Vend

Every flagged item sells automatically the moment you open a merchant, and it's on by default. Chat can report each sale with its item link and price, or stay quiet until the window closes and give you a single summary line — your pick. If you opened the merchant mid-fight, the sale waits politely until combat ends. Toggle the whole thing with Shift+Right-click on the minimap button or from the options panel.

### Bank Retrieval

Open your bank and Magic Eraser pulls every flagged item out of it and into your bags, then prints one line telling you what came back and what it's worth. It stops short of filling you up: retrieval leaves the same free-slot cushion you set for Bag-Space Warnings, so you always have room for the next drop. On by default, and a single toggle turns it off.

### Ignore List

Right-click the minimap button to protect whatever item is currently flagged, and middle-click to wipe that list and start over. Anything on it is never erased and never sold.

There are two lists, and they stack. Each character keeps its own, and there's a Global list that protects an item on every character at once. Manage both from **Options > AddOns > Magic Eraser > Ignore List** — add items by ID or by shift-clicking an item link straight from chat, promote a character's entry to Global, or remove anything you've changed your mind about.

<img width="360" src="https://github.com/user-attachments/assets/0e746c9a-a9f2-4761-ba43-dc13df016c8d" />

### Quest Alerts & Bag Tooltips

Hand in a quest and Magic Eraser re-checks your bags, then prints a chat alert for any quest item that's now safe to erase. Between turn-ins, hovering an item in your bags adds a line to its tooltip when Magic Eraser would erase it — or when your Ignore List is shielding it — so nothing ever goes without warning.

### Eraser Confirmations

Want a second look before anything disappears? Switch confirmations on in the options panel and pick which of the four categories should ask first. Off by default, because the whole point is one click.

### Bag-Space Warnings

Turn these on and chat counts down as your free bag slots drop toward the threshold you set — four slots left, three, two — so you know it's time to click the button before a drop goes to waste.

### Options

Find the panel at **Options > AddOns > Magic Eraser**, or just type `/eraser`. From there you can toggle the welcome message and the minimap button, tune Auto-Vend and its chat output, switch Bank Retrieval and bag tooltips on or off, set up confirmations and bag-space warnings, and manage profiles.

<img width="800" src="https://github.com/user-attachments/assets/45d78b67-4f45-4dd6-a4ef-0d017f560a20" />

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

🔴 Direct Alternative // Milestorme's [Auto Junk Destroyer](https://www.curseforge.com/wow/addons/auto-junk-destroyer)

🔴 Direct Alternative // IceDNicco's [Auto Sell Grey](https://www.curseforge.com/wow/addons/auto-sell-grey)

🔴 Direct Alternative // Terciob's [Auto Seller](https://www.curseforge.com/wow/addons/auto-seller)

🔴 Direct Alternative // moody's [Dejunk (Sell & Destroy Junk)](https://www.curseforge.com/wow/addons/dejunk)

🔴 Direct Alternative // Kemayo's [DropTheCheapestThing](https://www.curseforge.com/wow/addons/dropthecheapestthing)

🔴 Direct Alternative // Cartas's [Peddler (Junk seller)](https://www.curseforge.com/wow/addons/peddler)

🔴 Direct Alternative // Jaliborc's [Scrap (Junk Seller)](https://www.curseforge.com/wow/addons/scrap)

🔴 Direct Alternative // DooMRaptor's [Sell Grey Items](https://www.curseforge.com/wow/addons/sell-grey-items)

🔴 Direct Alternative // Supernovadusts's [SellTrash](https://www.curseforge.com/wow/addons/selltrash)

🔴 Direct Alternative // typicalzergling's [Vendor](https://www.curseforge.com/wow/addons/vendor)
