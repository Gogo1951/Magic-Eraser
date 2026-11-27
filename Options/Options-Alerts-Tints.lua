local _, ns = ...
local L = ns.L

local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Alerts & Tints Panel
--------------------------------------------------------------------------------

-- Nothing here changes what gets erased.
local ALERTS_SECTIONS = {
	"BuildTintJunkOptions",
	"BuildQuestItemAlertsOptions",
	"BuildBagWarningsOptions",
	"BuildItemTooltipsOptions",
}

function ns.BuildAlertsTintsOptions()
	local args = {
		descIntro = Kit.Desc(L["TAB_ALERTS_DESCRIPTION"], 1),
	}

	for _, builder in ipairs(ALERTS_SECTIONS) do
		ns[builder](args)
	end

	return {
		type = "group",
		name = L["TAB_ALERTS"],
		args = args,
	}
end
