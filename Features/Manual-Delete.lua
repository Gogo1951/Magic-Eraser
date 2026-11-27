local _, ns = ...

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local ipairs, select = ipairs, select
local GetItemInfo = C_Item.GetItemInfo

local SELL_PRICE_INDEX = 11

--------------------------------------------------------------------------------
-- Skip Typing DELETE
--------------------------------------------------------------------------------

-- The client's own delete prompt, never the eraser's. Only the good-item pair has an edit box.
local FILL_DIALOGS = { "DELETE_GOOD_ITEM", "DELETE_GOOD_QUEST_ITEM" }

-- From the client's own string, so it matches every locale; nil leaves the text alone.
local TYPE_IT_OUT_LINE
do
	local instruction = DELETE_GOOD_ITEM and DELETE_GOOD_ITEM:gsub("[\r\n]", "\1"):match("\1+(.+)$")
	if instruction and instruction ~= "" then
		TYPE_IT_OUT_LINE = (instruction:gsub("(%W)", "%%%1"))
	end
end

function ns:GetManualDeleteInstructionPattern()
	return TYPE_IT_OUT_LINE
end

--[[
    Sale price is the whole gate; bound-ness is ignored because armor tokens
    are tradable. An uncached item prices nil and keeps its prompt.
]]
local function CursorItemQualifies()
	if not ns.db.profile.manualDeleteNoValueOnly then
		return true
	end

	local cursorType, cursorItemId = GetCursorInfo()
	if cursorType ~= "item" or not cursorItemId then
		return false
	end

	return select(SELL_PRICE_INDEX, GetItemInfo(cursorItemId)) == 0
end

-- Lasts one showing: the next StaticPopup_Show rebuilds the dialog. Never presses the button.
local function ClearDialog(dialog, editBox)
	-- The secure edit box's OnTextChanged doesn't fire for code-set text, so enable the button outright.
	editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	editBox:Hide()

	local button = dialog.GetButton1 and dialog:GetButton1()
	if button then
		button:Enable()
	end

	local fontString = dialog.GetTextFontString and dialog:GetTextFontString()
	local text = TYPE_IT_OUT_LINE and fontString and fontString.GetText and fontString:GetText()
	if text then
		fontString:SetText((text:gsub(TYPE_IT_OUT_LINE, ""):gsub("%s+$", "")))
	end

	-- Resize never re-shows the edit box.
	if dialog.Resize then
		dialog:Resize()
	end
end

-- Scope re-checked: a frame later the cursor may have moved on.
local function FillDeletePrompt()
	if not (ns.db and DELETE_ITEM_CONFIRM_STRING) then
		return
	end

	if not CursorItemQualifies() then
		return
	end

	-- GetEditBox, GetButton1, GetTextFontString and Resize exist on Classic Era and TBC Anniversary alike, tested on both, so there is no _G[name .. "EditBox"] fallback.
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
    The prompt cannot be removed: DeleteCursorItem needs a hardware event, so
    the player's Yes makes the delete legal. Never call StaticPopup_OnClick,
    the accept button or OnAccept: the delete drops while the dialog hides,
    leaving the item undeletable. Deferred a frame: Blizzard's handler and
    ours fire in no fixed order.
]]
function ns:OnDeleteItemConfirm()
	if not (ns.db and ns.db.profile.manualDeleteAutoFillEnabled) then
		return
	end

	C_Timer.After(0, FillDeletePrompt)
end
