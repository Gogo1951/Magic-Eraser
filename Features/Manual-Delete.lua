local _, ns = ...

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local ipairs, select = ipairs, select

local SELL_PRICE_INDEX = 11

--------------------------------------------------------------------------------
-- Manual Delete Assistance
--------------------------------------------------------------------------------

--[[
    This has nothing to do with the eraser. It is the client's own confirmation,
    raised when the player drags an item out of their bags by hand, and the two
    dialogs below are the ones that make them type a word to dismiss it.

    UIParent's DELETE_ITEM_CONFIRM handler raises DELETE_GOOD_ITEM for rare and
    better, heirlooms excepted, and the plain Yes/No DELETE_ITEM for everything
    else, identically on Classic Era and TBC Anniversary. Only the good-item pair
    carries an edit box, which is the whole reason this file answers the two
    differently: one can be typed into, the other can only be clicked.

    The eraser's own deletes never come through here. ns:PerformErase calls
    DeleteCursorItem only inside the player's own input (a mini-map click, a
    press of the key binding, or the Yes on the eraser's confirmation dialog),
    so the client never asks -- which is exactly why the eraser carries its
    own confirmation instead, and also the clue to the constraint below.
]]
local FILL_DIALOGS = { "DELETE_GOOD_ITEM", "DELETE_GOOD_QUEST_ITEM" }

--[[
    The "type DELETE into the field to confirm" half of DELETE_GOOD_ITEM, as a
    Lua pattern, ready to be cut out of a dialog that no longer has a field.

    Taken from the client's own string rather than written out, so it matches the
    player's locale, and split on the line break the same way Leatrix Plus splits
    it. Every non-word character is escaped because the line is used as a pattern
    and carries quotes and a full stop, either of which would otherwise match more
    than itself. A client that ever stops shipping the two-line form leaves this
    nil and the text is simply left alone.
]]
local TYPE_IT_OUT_LINE
do
	local instruction = DELETE_GOOD_ITEM and DELETE_GOOD_ITEM:gsub("[\r\n]", "\1"):match("\1+(.+)$")
	if instruction and instruction ~= "" then
		TYPE_IT_OUT_LINE = (instruction:gsub("(%W)", "%%%1"))
	end
end

--[[
    Whether the item on the cursor is one the player asked us to handle. The wide
    setting takes everything and needs no lookup. The narrow one -- the default,
    because it is the conservative half -- takes only an item no vendor will buy,
    which is the set with no disposal route other than deleting it. Anything with
    a sale price is left alone entirely, prompt and all.

    Sale price is the whole gate, deliberately, and bound-ness is not part of it.
    The items this exists for are armor tokens, which are tradable and so are not
    bound until the moment they are used, meaning a soulbound test would fail on
    exactly the case the setting is for. Worth nothing to a vendor is the honest
    signal on its own.

    Price is a property of the item rather than of the copy on the cursor, so the
    item id GetCursorInfo hands back answers it without having to find the bag
    slot the item came from. An uncached item answers nil, which is not zero and
    so does not qualify: an item we cannot price keeps the protection the game
    gave it rather than losing it to a failed lookup.
]]
local function CursorItemQualifies()
	if not ns.db.global.manualDeleteNoValueOnly then
		return true
	end

	local cursorType, cursorItemId = GetCursorInfo()
	if cursorType ~= "item" or not cursorItemId then
		return false
	end

	return select(SELL_PRICE_INDEX, GetItemInfo(cursorItemId)) == 0
end

--[[
    Turn a type-it-out dialog into the plain Yes/No it may as well be: no field,
    no instruction about a field, an accept button the player can press, and a
    box that fits what is left. Leatrix Plus and Easy Delete Confirm both take the
    field away rather than filling it, and this follows them.

    Every change here lasts exactly one showing. The next StaticPopup_Show runs
    editBox:SetShown(dialogInfo.hasEditBox) and re-formats the text from
    dialogInfo, so a dialog we never touch is untouched, and the one we do touch
    is rebuilt from scratch the next time it opens.

    What it deliberately does not do is press the button -- see
    ns:OnDeleteItemConfirm for why nothing may.
]]
local function ClearDialog(dialog, editBox)
	--[[
	    Enable the accept button outright rather than typing the word and letting
	    the dialog's own EditBoxOnTextChanged notice. Filling the box was tried
	    first and does not enable anything -- the box empties and the button stays
	    greyed, leaving an item that cannot be deleted at all -- because this
	    client's edit box is the SetSecureText/ClearText widget, not a plain one,
	    and its OnTextChanged does not fire for text set from code. Leatrix Plus
	    enables the button directly for the same reason. The text goes in anyway,
	    so the dialog's own state agrees with its button rather than contradicting
	    it if anything re-reads it.
	]]
	editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	editBox:Hide()

	local button = dialog.GetButton1 and dialog:GetButton1()
	if button then
		button:Enable()
	end

	--[[
	    Drop the "type DELETE to confirm" instruction, which is now describing a
	    field that is not there. TYPE_IT_OUT_LINE comes from the client's own
	    DELETE_GOOD_ITEM, so it matches whatever the player's locale prints, and a
	    nil one simply leaves the text alone.
	]]
	local fontString = dialog.GetTextFontString and dialog:GetTextFontString()
	local text = TYPE_IT_OUT_LINE and fontString and fontString.GetText and fontString:GetText()
	if text then
		fontString:SetText((text:gsub(TYPE_IT_OUT_LINE, ""):gsub("%s+$", "")))
	end

	--[[
	    Let the dialog measure itself again now that a line and a field have left
	    it, rather than subtracting a guessed number of pixels. Resize only
	    recomputes widths and the fixed height; it never re-shows the edit box.
	]]
	if dialog.Resize then
		dialog:Resize()
	end
end

--[[
    Find the open dialog and clear it, if the item on the cursor is in scope.

    The scope is re-checked here rather than trusted from the handler, because
    this runs a frame later and the cursor may have moved on. Only one dialog can
    be up for a given delete, so the first match returns.
]]
local function FillDeletePrompt()
	if not (ns.db and DELETE_ITEM_CONFIRM_STRING) then
		return
	end

	if not CursorItemQualifies() then
		return
	end

	for _, which in ipairs(FILL_DIALOGS) do
		local dialog = StaticPopup_FindVisible(which)
		local editBox = dialog and dialog.GetEditBox and dialog:GetEditBox()
		if editBox then
			ClearDialog(dialog, editBox)
			return
		end
	end
end

--[[
    The client has decided a delete needs confirming, and typing into its dialog
    is the whole of what an add-on may do about it.

    THE PROMPT ITSELF CANNOT BE REMOVED, and it is worth writing down why, because
    it looks like an oversight and is not. DeleteCursorItem requires a hardware
    event and allows one item per event, so no add-on can answer a delete dialog
    on the player's behalf: their click on Yes is the event that makes the delete
    legal. Both routes were tried against a live client and both were refused, a
    deferred DeleteCursorItem and a synchronous one, and the same wall is
    documented by every add-on that solves this problem -- Leatrix Plus, Easy
    Delete Confirm, and NoDeleteConfirm, whose author states outright that it
    "cannot bypass Blizzard's protections". All of them remove the typing and stop
    there. So does this.

    Answering the dialog is worse than useless, not merely ineffective. An earlier
    build called StaticPopup_OnClick from a timer: the delete was silently dropped
    while the dialog, which is not protected, hid itself anyway, leaving the item
    alive and no longer deletable because its prompt was gone. Never reach for
    StaticPopup_OnClick, the accept button, or OnAccept.

    That leaves the plain Yes/No pair with nothing to do -- no edit box to empty,
    no click to save -- which is why FILL_DIALOGS lists only the two that ask for
    a word.

    The fill is deferred a frame because it needs the dialog to exist. Blizzard's
    handler and ours answer the same event with no ordering between them, so the
    next frame is the earliest the dialog is guaranteed to be up.
]]
function ns:OnDeleteItemConfirm()
	if not (ns.db and ns.db.global.manualDeleteAutoFillEnabled) then
		return
	end

	C_Timer.After(0, FillDeletePrompt)
end
