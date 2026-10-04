local _, ns = ...
local L = ns.L

local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Erasing Panel
--------------------------------------------------------------------------------

--[[
    What gets erased and how: which kinds of junk count; the most a stack may
    be worth; the game's own delete prompt for erasing by hand; and whether
    every erase asks first. Composed from Options-{Feature-Name} fragments the
    same way every panel is, so each section's settings still live beside the
    feature that owns them. Order on screen comes from the order numbers those
    fragments carry, in blocks of ten: the kind checkboxes and the value cap
    from Options-Eraser.lua at 10 and 30, Manual Delete Assistance at 40, then
    Erase Confirmation from Options-Eraser.lua at 50.

    Registered as a built table rather than a builder function (see
    Options/Options.lua): nothing here is drawn from a live list.
]]
local ERASING_SECTIONS = {
	"BuildEraserOptions",
	"BuildManualDeleteOptions",
	"BuildEraseConfirmOptions",
}

function ns.BuildErasingOptions()
	local args = {
		descIntro = ns.OptionsDesc(L["TAB_ERASING_DESCRIPTION"], 1),
		spacerRestore = ns.OptionsSpacer(1.5),
		descRestore = ns.OptionsDesc(GetColor("HELP") .. L["TAB_ERASING_RESTORE_NOTE"] .. "|r", 2),
	}

	for _, builder in ipairs(ERASING_SECTIONS) do
		ns[builder](args)
	end

	return {
		type = "group",
		name = L["TAB_ERASING"],
		args = args,
	}
end
