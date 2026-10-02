# Magic Eraser

Erase junk and free up bag space instantly. Clear completed quest items, outgrown consumables, vendor trash, and grays with a click of the mini-map button. A curated junk list keeps what you need safe, while Auto-Vend sells the rest at your next merchant.

**TL;DR**: For anyone whose bags are always full. It spots the junk, erases it a click at a time, or sells it the next time you chat with a merchant. What you need stays, what you don't gets tossed. Marie Kondo would be so proud!

## Features

🧹 **One-Click Cleanup** // The mini-map button shows the cheapest junk in your bags and tallies the rest. Left-click to erase it, or bind a key and skip the click entirely.

💰 **Auto-Vend & Bank Retrieval** // Flagged junk sells itself when you open a merchant, while junk hiding in your bank comes back to your bags to go along with it.

🔔 **Smart Alerts** // Chat tells you when a quest item becomes safe to erase, while a tooltip line marks anything Magic Eraser is ready to remove.

✍️ **Manual Delete Assistance** // No more typing DELETE. Deleting a Rare or better item that no vendor will buy now asks for a simple Yes or No, with an option to apply the same treatment to every item.

🦺 **Safety First** // Never touches anything green or better, white trade goods, or quest items you still need unless you explicitly list them. Your Protect List protects anything you name.

## Setup

1. Install the add-on, ideally using [CurseForge](https://www.curseforge.com/wow/addons/magic-eraser) or [Wago](https://addons.wago.io/addons/magic-eraser).
2. Log in. The mini-map button shows the icon of the lowest-value junk currently in your bags.
3. Left-click to erase it, right-click to spare it, or Shift + Middle-Click to open the Options Interface.
4. Auto-Vend and Bank Retrieval are on out of the box, so the rest sells itself at the next merchant and junk in your bank comes home to be dealt with.
5. _"But wait, there's more... bag space!"_

## How It Works

### What Gets Erased

Five kinds of clutter are in scope, plus anything on your Erase List. The quest, food and ammo lists behind them are hand-curated, and white gear and grays go by rule.

| Clutter | When it goes |
| --- | --- |
| Completed quest items | Once you've handed in the last quest that needs the item. |
| Dead-end quest starters | The moment it drops, when the quest is closed to your race or class. A Paladin-only Tome of Divinity in a Rogue's bags is fair game right away. |
| Outgrown food and drink | Ten levels past the point you could first use it. Starter bread and water go at level 5 rather than squatting in your bags until 11. |
| Outgrown arrows and bullets | The moment you can use a better kind sold by vendors: Rough Arrows at 10 when Sharp Arrows unlock, Sharp Arrows at 25 for Razor Arrows, and so on. The best vendor ammo for your level is never touched. |
| Vendor-quality whites and gray trash | White weapons and armor, plus any gray, whenever a vendor will buy it. Profession tools, shirts, formal wear and whites a quest still needs are left alone. |

- The cheapest stack goes first. When two are worth the same, priority breaks the tie: your Erase List first, then quest items, then gray trash, then food, ammo and gear.
- Each kind above can be set to **Erase**, **Erase, Ask First** or **Keep** on the Erasing page. Keep takes that kind out of the junk pile everywhere: never erased, sold or pulled from the bank.
- Anything on your Protect List is skipped everywhere, and nothing is erased while you're in combat.
- Your Erase List flags what the built-in lists and rules never will, whatever it's worth. Shiny Fish Scales and Fish Oil are junk to everyone except a Shaman, so every non-Shaman starts with both already listed and a Shaman starts with neither.

### Mini-Map Button

| Action | Effect |
| --- | --- |
| Left-Click | Erase the lowest-value flagged item. |
| Right-Click | Add the flagged item to this character's Protect List. |
| Middle-Click | Clear this character's Protect List. |
| Shift + Right-Click | Toggle Auto-Vend on or off. |
| Shift + Middle-Click | Open the Options Interface. |

- Hover the button to see the item you're about to erase and what it's worth, whether Auto-Vend is on, a Clutter Report totalling the bag slots and gold still sitting in the trash pile, and everything you've told it to spare on this character.

### Key Bindings

Set these under Key Bindings in the game menu, in the Magic Eraser section.

| Binding | Effect |
| --- | --- |
| Erase Lowest-Value Item | Erase the lowest-value flagged item, exactly as a left-click does. |
| Add Hovered Item to Protect List | Protect the item under your mouse on this character. |
| Add Hovered Item to Erase List | Flag the item under your mouse as junk on this character, whatever it's worth. |

- Use the erase key at your own risk: the button shows you what's next before you click, a key doesn't, and a stray keypress erases just as surely as a deliberate one.
- The two list keys work on anything you can hover: your bags, the bank, a merchant, the loot window. Chat confirms every press, and the item's tooltip in your bags updates while you're still hovering it.
- Neither list key takes anything off a list, so a second press just tells you the item's already there. Protecting an item takes it off this character's Erase List, and an item on your Protect List stays protected until you remove it in the Options Interface.

### Auto-Vend & Bank Retrieval

Both are on by default, both use the eraser's own junk rules, and both leave your Protect List alone.

- Auto-Vend sells every flagged item a vendor will buy the moment the merchant window opens, cheapest first. If a fight breaks out mid-sale, it waits for combat to end.
- Quest items have no sale value, so they're left for the eraser.
- Bank Retrieval pulls flagged items out of your bank when you open it, most valuable first, and never more than your free bag slots can hold.
- A chat line sums up each visit: what sold or came home, how many bag slots it touched, and what it was worth.

### Options

Find the Options Interface at **Options > AddOns > Magic Eraser**, or just type `/eraser`.

- **General** // The welcome message and mini-map button, a switch for every feature, and your key bindings, with each one's key or Not Bound.
- **Erasing** // What counts as junk (**Erase**, **Erase, Ask First** or **Keep** for each kind), a maximum value to erase, and Manual Delete Assistance.
- **Merchant & Bank** // Auto-Vend and its chat report, and Bank Retrieval.
- **Alerts & Tooltips** // Tooltip warnings, quest item alerts, and a bag-space countdown as your last free slots fill.
- **Protect List** and **Erase List** // One pane per character, plus an All Characters list that applies everywhere. Pick an item straight from your bags, or add one by item ID.
- **Your Current Bags** // The next item up with Erase and Protect buttons, the Clutter Report, and the queue behind it. Below that, everything you carry, sorted by name with its type, and an Erase and a Protect checkbox on each row.
- **Profiles** // Every character shares the **Default** profile, so a setting changed once applies everywhere. Make a new profile only for a one-off, such as a bank alt with Auto-Vend off. Each character's own Protect List and Erase List stay with it whatever profile it's on.
- **Diagnostic Tools** // Reports to paste into a bug report. Off until you switch it on, and it never runs on its own.

<img width="800" src="https://github.com/user-attachments/assets/303e0441-0002-4714-ba65-076bfa394e54" />

## Testing & Localization Status

🔴 World of Warcraft // 12.1.0

🔴 Mists of Pandaria Classic // 5.5.4

🟢 Burning Crusade Anniversary // 2.5.6

🟢 World of Warcraft: Forever // 1.60.1

🟡 World of Warcraft: Season of Discovery // 1.15.9

🟢 World of Warcraft: Classic // 1.15.9

**Available Locales** // enUS, deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, zhTW

## Get Involved

❤️ **You can help make this better!** Feedback, code contributions, testing, and localization assistance are always appreciated. If you'd like to get involved, please reach out.

* [GitHub](https://github.com/Gogo1951/Magic-Eraser)
* [Discord](https://discord.gg/eh8hKq992Q)

## Related Add-ons

### 🟢 Pairs With

* plusmouse's [Baganator](https://www.curseforge.com/wow/addons/baganator)
* jaliborc's [Bagnon](https://www.curseforge.com/wow/addons/bagnon)
* Gogo1951's [Connoisseur & Restocker](https://www.curseforge.com/wow/addons/consumable-connoisseur)
* Gogo1951's [Open Sesame](https://www.curseforge.com/wow/addons/open-sesame)
* Gogo1951's [Play It Forward](https://www.curseforge.com/wow/addons/play-it-forward)

### 🟡 Overlaps

* IceDNicco's [Auto Sell Grey](https://www.curseforge.com/wow/addons/auto-sell-grey)
* Xibate's [Easy Delete](https://www.curseforge.com/wow/addons/easy-delete)
* Leatrix's [Leatrix Plus](https://www.curseforge.com/wow/addons/leatrix-plus)
* Gogo1951's [Play It Forward](https://www.curseforge.com/wow/addons/play-it-forward)
* Sapu94's [TradeSkillMaster](https://www.curseforge.com/wow/addons/tradeskill-master)

### 🔴 Alternatives

* moody's [Dejunk (Sell & Destroy Junk)](https://www.curseforge.com/wow/addons/dejunk)
* Kemayo's [DropTheCheapestThing](https://www.curseforge.com/wow/addons/dropthecheapestthing)
* Cartas's [Peddler (Junk seller)](https://www.curseforge.com/wow/addons/peddler)
* jaliborc's [Scrap (Junk Seller)](https://www.curseforge.com/wow/addons/scrap)
* typicalzergling's [Vendor](https://www.curseforge.com/wow/addons/vendor)
