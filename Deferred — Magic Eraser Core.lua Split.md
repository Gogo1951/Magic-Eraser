# Deferred — Magic Eraser `Core.lua` Split

A parked, ready-to-run task. `Features/Core.lua` has grown large; this splits its two
biggest permanent chunks into their own feature files, leaving Core as the
state + saved-variable lifecycle + event dispatcher spine the Style Guide describes.
Run it when the maintainer decides Core is due for trimming — **not** as part of any
scheduled review pass. Era only; there is no other client to touch.

A matching `DESIGN NOTE` comment lives at the top of `Features/Core.lua`; delete it as
part of executing this split.

## Preconditions

- Do the `Core.lua` comment-cleanup pass first (it may shrink Core enough that only one
  extraction, or none, is needed — reassess after cleaning).
- This split is independent of the dated migration blocks in `ns:OnPlayerLogin`. Those
  stay in Core and self-remove by 2026-10-11; do not move them, and do not wait for them.

## Prompt

```
Split Magic Eraser Features/Core.lua into feature files. Work only in the _classic_era_
install. Change structure, not behavior. Rely on the Style Guide and README-Technical.md
already describing this architecture.

Create Features/Eraser.lua and move these out of Core.lua, in order, preserving comments:
the scan cache locals (cachedItem, isCacheValid, cachedReclaimSlots/Items/Value), the
retry machinery (MAX_SCAN_RETRIES, scanRetries, retryPending, inScanRetry), ns:InvalidateCache,
ScheduleScanRetry, ns:GetItemDeleteReason, isBetterDeletionCandidate, ns:FindItemToDelete,
ns:GetReclaimSummary, SAFETY_REASON_KEYS, ns:NeedsSafetyConfirm, the
StaticPopupDialogs["MAGICERASER_CONFIRM_ERASE"] registration, ns:PerformErase, ns:RunEraser.
Declare Eraser.lua's own upvalue locals at its top (GetContainerNumSlots, GetContainerItemInfo,
PickupContainerItem via C_Container; format/ipairs) like Auto-Vend.lua does.

Create Features/Bag-Warnings.lua and move: lastNudgeFree, CountFreeSlots, IsBagWindowOpen,
ns:CheckBagsFullNudge, and ns:OnMailClosed. Declare its own local GetContainerNumFreeSlots.
Because Core's ns:OnBagUpdateDelayed still gates the nudge on the bag window being closed,
expose IsBagWindowOpen as ns:IsBagWindowOpen so that handler can call it; update the call site.

Leave in Core.lua: locals it still uses, GetVersion/ns.Version, the ignore-list functions,
db init and all migrations in ns:OnPlayerLogin, ns:OnDatabaseReset, ns:OnProfileSwitched,
ns:OnPlayerLevelUp, ns:OnBagUpdateDelayed, ns:OnQuestTurnedIn, ns.EVENT_NAMES, EVENT_HANDLERS,
and the dispatcher frame + registration loop. Do not change the dispatcher — handlers resolve
by name at fire time, so moved handlers just need their file loaded after Core.

Wire both new files into MagicEraser.toc in the "# Magic Eraser" block, after Features/Core.lua
and before the Options files. Order within the feature files does not matter for dispatch, but
keep Core.lua first. Delete the DESIGN NOTE block at the top of Core.lua.

Update README-Technical.md: add both files to the File Map, and repoint any architecture prose
that says these live in Core.lua.

Verify: luac -p every moved/edited Lua file; grep to confirm no dangling references to moved
file-local symbols remain in Core.lua; then load the add-on in-game (Classic Era) and confirm
the minimap tooltip, an erase, and a bag-space warning all still work.
```

## Wiring gotchas (why the prompt is worded as it is)

- **File-local symbols travel with their callers.** `cachedItem`, `isCacheValid`, the reclaim
  totals, the retry flags, `isBetterDeletionCandidate`, `ScheduleScanRetry`, and
  `SAFETY_REASON_KEYS` are only read by functions moving to `Eraser.lua`, so they move as a unit
  and nothing in Core references them afterward. Confirm with a grep.
- **Each file declares its own `C_Container` upvalues.** Core caches `GetContainerNumSlots` /
  `GetContainerItemInfo` at its top; the moved scanners need their own copies (Auto-Vend already
  does this). Core still uses `GetContainerNumSlots` in `ns:OnQuestTurnedIn`, so keep its locals.
- **`IsBagWindowOpen` is the one cross-file call.** It currently gates `ns:OnBagUpdateDelayed`
  (stays in Core) but logically belongs with the warnings. Promote it to `ns:IsBagWindowOpen`
  so both `Core` (bag-update gate) and `Bag-Warnings` (its own use) can call it.
- **No dispatcher edits.** `ns.EVENT_NAMES` and `EVENT_HANDLERS` stay in Core. `OnMailClosed`
  moving to `Bag-Warnings.lua` is exactly the Auto-Vend pattern (`OnMerchantShow` etc. already
  live outside Core); it works because the handler is resolved as `ns[handlerName]` at fire time.
- **Load order.** Feature files must load after `Core.lua` (which defines the dispatcher and
  `ns.db` lifecycle) — the TOC already lists Core first; keep it there.
