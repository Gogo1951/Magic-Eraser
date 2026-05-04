# Magic Eraser

Keep your bags clean — one click on the minimap button erases the lowest-value junk in your inventory.

<img width="360" alt="Magic Eraser minimap button and tooltip" src="https://github.com/user-attachments/assets/55412aca-a905-4b17-838f-857606c5a3dc" />

## What It Does

Bag space is a chronic problem in Classic WoW. Old quest items hang around. Low-level food piles up. Vendor-trash whites and gray junk fill every empty slot. Magic Eraser deletes the lowest-value of those — and only those — with a single click.

The trash list is hand-curated. Every entry has been reviewed by humans before it ships. No heuristics, no name matching, no surprise deletions of items that look like junk but aren't.

When you visit a merchant, Auto-Vend sells the rest for you automatically.

## Quick Start

1. Install from [CurseForge](https://www.curseforge.com/wow/addons/magic-eraser) or [GitHub](https://github.com/Gogo1951/Magic-Eraser).
2. Log in. The minimap button shows the icon of the lowest-value junk currently in your bags.
3. Left-click to erase it. Right-click to ignore it instead. Shift+Right-click to toggle Auto-Vend.
4. Done — your bags stay clean on their own. (=

## Smart Scanning

Magic Eraser scans your bags and finds the lowest-value match from four categories:

- **Completed quest items** that are no longer needed.
- **Outgrown consumables** — food and drink with a required level at least ten below your own.
- **Vendor-quality white equipment** from the curated trash list.
- **Gray trash** with a sell price.

The minimap icon updates live to show what would be erased next.

**Shamans** never lose Fish Oil or Shiny Fish Scales — class-specific reagents are always excluded.

## Auto-Vend

When you open a merchant with Auto-Vend enabled, every flagged item in your bags is sold automatically. Each sale prints to chat with the item link and price. Toggle Auto-Vend with Shift+Right-click on the minimap button or from the options panel.

## Ignore List

Right-click the minimap button to protect the currently-flagged item from being erased. The list is per-character, so your alts each manage their own. Middle-click the minimap button to clear the entire list.

## Quest Alerts

When you turn in a quest, Magic Eraser checks your bags and prints a chat alert for any quest item that's now safe to erase.

## Settings

The options panel lives at **Options > AddOns > Magic Eraser**.

- **Enable Welcome Message** — toggles the login chat message. On by default.
- **Auto-Vend** — toggles automatic vending at merchants. Off by default.
- **Reset Ignore List** — clears the per-character Ignore List.
- **Reset All Magic Eraser Settings** — clears the Ignore List and disables Auto-Vend.

## Minimap Button

| Action            | Effect                                      |
| ----------------- | ------------------------------------------- |
| Left-click        | Erase the lowest-value flagged item.        |
| Right-click       | Toggle the flagged item on the Ignore List. |
| Middle-click      | Clear the entire Ignore List.               |
| Shift+Right-click | Toggle Auto-Vend on or off.                 |

The button's icon updates to show the next candidate for erasure.

## How It Works

After every bag update, Magic Eraser walks each slot and ranks every flagged item by sell value. When two items tie on value, category priority breaks the tie:

1. Completed quest items
2. Gray trash
3. Consumables and equipment

The lowest-value, highest-priority match becomes the next candidate. Items on the Ignore List and class-specific reagents are skipped. No "Are you sure?" dialogs — one click, one erase.

Localized for enUS, deDE, esES, esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, and zhTW.

## Saved Variables

Magic Eraser persists state in two SavedVariables. `MagicEraserDB` is account-wide and stores the minimap button position and the welcome-message toggle. `MagicEraserCharDB` is per-character and holds the Ignore List and the Auto-Vend toggle.

## Testing Status

🟢 World of Warcraft Classic Era

🟢 Burning Crusade Classic Anniversary

🔴 Mists of Pandaria Classic

🔴 Retail

Please reach out if you would like to be involved with testing!

## Links

* [CurseForge](https://www.curseforge.com/wow/addons/magic-eraser)
* [GitHub](https://github.com/Gogo1951/Magic-Eraser)
* [Discord](https://discord.gg/eh8hKq992Q)
