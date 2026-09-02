# Magic Eraser

Erase junk and free up bag space instantly. Clear completed quest items, outgrown consumables, vendor trash, and grays with one click. A curated junk list keeps it safe, while Auto-Vend sells the rest at your next merchant.

**TL;DR:** Most junk cleaners delete grays. This goes further by clearing old quest items, outgrown consumables, and other curated clutter so your bags stay clean without the guesswork.

## Features

🧹 **One-Click Cleanup** // Erase the cheapest junk in your bags with a single click. The mini-map button always shows you what's next, with no confirmation unless you want one.

📜 **Completed Quest Items** // Finished a quest? Get rid of the item you no longer need. These forgotten quest items can clog your bags forever, and a curated list knows when they're safe to erase.

🔔 **Smart Junk Alerts** // A hand-curated list identifies clutter that's safe to erase: completed quest items, impossible quest starters, outgrown food and drink, vendor-quality whites, and gray trash. Tooltips tell you what's on the chopping block before anything goes.

💰 **Auto-Vend** // Flagged items are automatically sold the next time you visit a merchant. Erase what should disappear and sell what still has value, without sorting through your bags by hand.

🛡️ **Curated & Safe** // No name-matching, no guesswork, and no surprise deletions. Every trash list is human-reviewed, your Ignore List always wins, and nothing is erased during combat.

## Setup

1. Install the add-on, ideally using [CurseForge](https://www.curseforge.com/wow/addons/magic-eraser) or [Wago](https://addons.wago.io/addons/magic-eraser).
2. Log in. The mini-map button shows the icon of the lowest-value junk currently in your bags.
3. Left-click to erase it, right-click to spare it, or Shift+Middle-click to open the Options Interface.
4. Auto-Vend and Bank Retrieval are on out of the box, so the rest pays for itself the next time you talk to a merchant.
5. *"Cleanest bags on the server!"*

## How It Works

### What Gets Erased

Only four kinds of clutter are ever in scope, and every list behind them is hand-curated:

- **Spent quest items** // Left over from a quest you have already handed in.
- **Dead-end quest starters** // An item that starts a quest your race or class can never take is junk the moment it drops, so a Paladin-only Tome of Divinity in a Rogue's bags is fair game right away.
- **Outgrown food and drink** // Ten levels past the point you could first use it. Starter bread and water go at level 5 rather than squatting in your bags until 11.
- **Vendor-quality whites and gray trash** // Curated white gear, plus any gray with a sell price.

A few rules keep the pick predictable:

- The mini-map icon updates live to show what's next on the chopping block.
- When two items are worth the same, priority breaks the tie: your Erase List first, then quest items, then gray trash, then consumables and gear.
- Anything on your Ignore List is skipped entirely, and nothing is erased while you're in combat.
- Class reagents are handled by the Erase List rather than by a rule. Shiny Fish Scales and Fish Oil are junk to everyone except a Shaman, so every non-Shaman starts with both already listed and a Shaman starts with neither.

### Mini-map Button

| Action             | Effect                                                   |
| ------------------ | -------------------------------------------------------- |
| Left-click         | Erase the lowest-value flagged item.                     |
| Right-click        | Toggle the flagged item on this character's Ignore List. |
| Middle-click       | Clear this character's Ignore List.                      |
| Shift+Right-click  | Toggle Auto-Vend on or off.                              |
| Shift+Middle-click | Open the Options Interface.                              |

Hover the button and the tooltip lays out the whole picture: the item you're about to erase and what it's worth, whether Auto-Vend is on, a Clutter Report totalling the bag slots and gold still sitting in the trash pile, and everything you've told it to spare.

### Auto-Vend

Every flagged item sells automatically the moment you open a merchant, and it's on by default.

- One summary line lands in chat as the merchant window closes.
- Switch to Line Item and every sale is announced as it happens, with that summary still arriving at the end.
- Turn the messages off entirely if you'd rather it worked in silence.
- Open a merchant mid-fight and the sale waits politely until combat ends.
- Toggle the whole thing with Shift+Right-click on the mini-map button, or from the Options Interface.

### Your Two Lists

The Ignore List protects; the Erase List condemns. Both work the same way, and both stack: each character keeps its own, plus a Global list that applies everywhere at once.

- **Ignore List** // Never erased, never sold. Right-click the mini-map button to protect whatever is currently flagged, middle-click to wipe this character's list and start over.
- **Erase List** // Always erased and always sold, whatever it is worth and whatever category it does or does not fall into. This is for the junk only you know is junk: an alt's leftover mats, a quest reward you will never wear, reagents for a profession you dropped.
- **Managing them** // Add items by ID or by shift-clicking an item link straight from chat, and promote any character's entry to Global with one click.
- **Ignore always wins** // An item on both lists is left alone.
- **No cap on the Erase List** // Maximum Value to Erase does not apply to it, because you already said you wanted that one gone.
- **Restore Defaults** // The character you are playing gets a button that empties its Erase List and puts back the class reagents it started with. It asks first, because anything you added goes with it.

### Options

Find the Options Interface at **Options > AddOns > Magic Eraser**, or just type `/eraser`.

- **General** // The welcome message, the mini-map button, and every setting in the table below.
- **Ignore List** and **Erase List** // One pane per character, plus the Global list.
- **Profiles** // Standard profile switching, copying, and reset.
- **Diagnostic Tools** // Reports to paste into a bug report. Off until you switch it on, and it never runs on its own.

| Setting                 | Default | What it does                                                                                                                            |
| ----------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Auto-Vend               | On      | Sells flagged items at any merchant, with chat output as a summary line or line by line.                                               |
| Maximum Value to Erase  | Off     | Never erase a stack worth more than the cap you pick, from 1 to 21 gold. Auto-Vend, Bank Retrieval, and your Erase List ignore the cap. |
| Bank Retrieval          | On      | Pulls flagged items out of the bank into your free bag slots, leaving your Free-Slot Threshold untouched.                               |
| Item Tooltips           | On      | Adds a line to in-bag items Magic Eraser would erase, or that your Ignore List protects.                                                 |
| Bag-Space Warnings      | Off     | Counts down in chat as your free slots drop to the threshold you set, from 1 to 10.                                                     |
| Eraser Confirmations    | Off     | Asks before erasing the item types you check: quest items, consumables, whites, or grays.                                               |

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

🟡 Some Overlap // bouzrogue's [Grey Handling](https://www.curseforge.com/wow/addons/greyhandling)

🟡 Some Overlap // Leatrix's [Leatrix Plus](https://www.curseforge.com/wow/addons/leatrix-plus)

🟡 Some Overlap // Gogo1951's [Play It Forward](https://www.curseforge.com/wow/addons/play-it-forward)

🟡 Some Overlap // Stumper_Gaming's [QuickDelete](https://www.curseforge.com/wow/addons/quickdelete-hotkey-to-trash)

🔴 Direct Alternative // moody's [Dejunk (Sell & Destroy Junk)](https://www.curseforge.com/wow/addons/dejunk)

🔴 Direct Alternative // Kemayo's [DropTheCheapestThing](https://www.curseforge.com/wow/addons/dropthecheapestthing)

🔴 Direct Alternative // Cartas's [Peddler (Junk seller)](https://www.curseforge.com/wow/addons/peddler)

🔴 Direct Alternative // jaliborc's [Scrap (Junk Seller)](https://www.curseforge.com/wow/addons/scrap)

🔴 Direct Alternative // typicalzergling's [Vendor](https://www.curseforge.com/wow/addons/vendor)
