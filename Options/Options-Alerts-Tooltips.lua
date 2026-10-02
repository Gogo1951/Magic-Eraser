local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Alerts & Tooltips Panel
--------------------------------------------------------------------------------

--[[
    What Magic Eraser tells the player on its own, none of which changes what
    gets erased: the bag tooltip line at 10, quest item alerts at 20, and the
    bag-space countdown at 30. Every one of them has its switch here and again
    in the root panel's Features section.

    Registered as a built table rather than a builder function (see
    Options/Options.lua): nothing here is drawn from a live list.
]]
local ALERTS_SECTIONS = {
	"BuildItemTooltipsOptions",
	"BuildQuestItemAlertsOptions",
	"BuildBagWarningsOptions",
}

function ns.BuildAlertsTooltipsOptions()
	local args = {
		descIntro = ns.OptionsDesc(L["TAB_ALERTS_DESCRIPTION"], 1),
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
