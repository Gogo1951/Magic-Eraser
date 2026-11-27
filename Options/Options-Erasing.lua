local _, ns = ...
local L = ns.L

local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Erasing Panel
--------------------------------------------------------------------------------

local ERASING_SECTIONS = {
	"BuildEraserOptions",
	"BuildManualDeleteOptions",
	"BuildEraseConfirmOptions",
}

function ns.BuildErasingOptions()
	local args = {
		descIntro = Kit.Desc(L["TAB_ERASING_DESCRIPTION"], 1),
		spacerRestore = Kit.Spacer(1.5),
		descRestore = Kit.Desc(L["TAB_ERASING_RESTORE_NOTE"], 2),
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
