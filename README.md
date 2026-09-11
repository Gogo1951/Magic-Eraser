# Magic Eraser

Erase junk and free up bag space instantly. Clear completed quest items, outgrown consumables, vendor trash, and grays with a click of the mini-map button. A curated junk list keeps what you need safe, while Auto-Vend sells the rest at your next merchant.

TL;DR: Keep what matters. Get rid of the rest. Magic Eraser knows what's worth keeping, what's outgrown, and what's safe to erase, so your bags stay clean without the busywork.

## Features

🧹 **One-Click Cleanup** // The mini-map button shows the cheapest junk in your bags and tallies the rest. Left-click to erase it, or bind a key and skip the click entirely.

💰 **Auto-Vend & Bank Retrieval** // Flagged junk sells itself when you open a merchant, while junk hiding in your bank comes back to your bags to go along with it.

🔔 **Smart Alerts** // Chat tells you when a quest item becomes safe to erase, while a tooltip line marks anything Magic Eraser is ready to remove.

✍️ **Manual Delete Assistance** // No more typing DELETE. Deleting a Rare or better item that no vendor will buy now asks for a simple Yes or No, with an option to apply the same treatment to every item.

🦺 **Safety First** // Never touches anything green or better, white trade goods, or quest items you still need unless you explicitly list them. Your Ignore List protects anything you name.

## Setup

1. Install the add-on, ideally using [CurseForge](https://www.curseforge.com/wow/addons/magic-eraser) or [Wago](https://addons.wago.io/addons/magic-eraser).
2. Log in. The mini-map button shows the icon of the lowest-value junk currently in your bags.
3. Left-click to erase it, right-click to spare it, or Shift+Middle-click to open the Options Interface.
4. Auto-Vend and Bank Retrieval are on out of the box, so the rest sells itself at the next merchant and junk in your bank comes home to be dealt with.
5. *"If it doesn't spark joy, it doesn't make the bags."*

## How It Works

### What Gets Erased

Only four kinds of clutter are ever in scope, and every list behind them is hand-curated:

- **Spent quest items** // Left over from a quest you have already handed in. Nothing is touched until the last quest that needs the item is complete.
- **Dead-end quest starters** // An item that starts a quest your race or class can never take is junk the moment it drops, so a Paladin-only Tome of Divinity in a Rogue's bags is fair game right away.
- **Outgrown food and drink** // Ten levels past the point you could first use it. Starter bread and water go at level 5 rather than squatting in your bags until 11.
- **Vendor-quality whites and gray trash** // Curated white gear, plus any gray with a sell price.

A few rules keep the pick predictable:

- The cheapest stack goes first. When two are worth the same, priority breaks the tie: your Erase List first, then quest items, then gray trash, then consumables and gear.
- Anything on your Ignore List is skipped everywhere, and nothing is erased while you're in combat.
- Your Erase List flags what the curated data never will, whatever it's worth. Shiny Fish Scales and Fish Oil are junk to everyone except a Shaman, so every non-Shaman starts with both already listed and a Shaman starts with neither.

### Mini-map Button

| Action             | Effect                                                   |
| ------------------ | -------------------------------------------------------- |
| Left-click         | Erase the lowest-value flagged item.                     |
| Right-click        | Toggle the flagged item on this character's Ignore List. |
| Middle-click       | Clear this character's Ignore List.                      |
| Shift+Right-click  | Toggle Auto-Vend on or off.                              |
| Shift+Middle-click | Open the Options Interface.                              |

Hover the button and the tooltip lays out the whole picture:

- The item you're about to erase and what it's worth.
- Whether Auto-Vend is on.
- A Clutter Report totalling the bag slots and gold still sitting in the trash pile.
- Everything you've told it to spare on this character.

### Key Bindings

**Erase Lowest-Value Item** lives under Key Bindings in the game menu, in the Magic Eraser section, and does exactly what Left-clicking the mini-map button does. Use it at your own risk: the button shows you what's next before you click, a key doesn't, and a stray keypress erases just as surely as a deliberate one.

### Auto-Vend & Bank Retrieval

Both are on by default, both use the eraser's own junk rules, and both leave your Ignore List alone.

- Auto-Vend sells every flagged item a vendor will buy the moment the merchant window opens, cheapest first. If a fight breaks out mid-sale, it waits for combat to end.
- Quest items have no sale value, so they're left for the eraser.
- Bank Retrieval pulls flagged items out of your bank when you open it, most valuable first, and never more than your free bag slots can hold.
- A chat line sums up each visit: what sold or came home, how many bag slots it touched, and what it was worth.

### Options

Find the Options Interface at **Options > AddOns > Magic Eraser**, or just type `/eraser`.

- **General** // The welcome message, the mini-map button, the key binding, and Auto-Vend, including whether it reports every sale or just a closing summary.
- **Safety Features** // How careful the add-on is: tooltip warnings, Bank Retrieval, Manual Delete Assistance, a confirmation prompt per junk type, a maximum value to erase, and a bag-space countdown.
- **Ignore List** and **Erase List** // One pane per character, plus a Global list that applies on every character.
- **Profiles** // Standard profile switching, copying, and reset.
- **Diagnostic Tools** // Reports to paste into a bug report. Off until you switch it on, and it never runs on its own.

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

🟢 Pairs With // Gogo1951's [Connoisseur & Restocker](https://www.curseforge.com/wow/addons/consumable-connoisseur)

🟢 Pairs With // Gogo1951's [Open Sesame](https://www.curseforge.com/wow/addons/open-sesame)

🟡 Some Overlap // Xibate's [Easy Delete](https://www.curseforge.com/wow/addons/easy-delete)

🟡 Some Overlap // bouzrogue's [Grey Handling](https://www.curseforge.com/wow/addons/greyhandling)

🟡 Some Overlap // Leatrix's [Leatrix Plus](https://www.curseforge.com/wow/addons/leatrix-plus)

🟡 Some Overlap // Gogo1951's [Play It Forward](https://www.curseforge.com/wow/addons/play-it-forward)

🟡 Some Overlap // Sapu94's [TradeSkillMaster](https://www.curseforge.com/wow/addons/tradeskill-master)

🔴 Direct Alternative // moody's [Dejunk (Sell & Destroy Junk)](https://www.curseforge.com/wow/addons/dejunk)

🔴 Direct Alternative // Kemayo's [DropTheCheapestThing](https://www.curseforge.com/wow/addons/dropthecheapestthing)

🔴 Direct Alternative // Cartas's [Peddler (Junk seller)](https://www.curseforge.com/wow/addons/peddler)

🔴 Direct Alternative // jaliborc's [Scrap (Junk Seller)](https://www.curseforge.com/wow/addons/scrap)

🔴 Direct Alternative // typicalzergling's [Vendor](https://www.curseforge.com/wow/addons/vendor)
