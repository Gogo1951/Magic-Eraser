local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Safety Panel
--------------------------------------------------------------------------------

--[[
    Everything that governs how careful Magic Eraser is: what it asks about
    before erasing, what it refuses to touch, what it tells you it is about to
    do, and how it handles the client's own delete prompt. The root panel keeps
    the add-on's own settings and Auto-Vend, so a player tuning caution has one
    place to look instead of a scroll.

    Composed the same way the General panel is, from the Options-{Feature-Name}
    fragments, so a section's settings still live beside the feature that owns
    them. Order on screen comes from the order numbers those fragments carry, in
    blocks of ten; this list records the intended sequence beside them so the two
    cannot silently disagree.

    Registered as a built table rather than a builder function (see
    Options/Options.lua): nothing here is drawn from a live list, so there is
    nothing to rebuild on every open.
]]
local SAFETY_SECTIONS = {
	-- { builder, first order, section }
	{ "BuildItemTooltipsOptions", 10, "Tooltip Warnings" },
	{ "BuildBankRetrievalOptions", 20, "Bank Retrieval" },
	{ "BuildManualDeleteOptions", 30, "Manual Delete Assistance" },
	{ "BuildEraserOptions", 40, "Mini-map Eraser Confirmation, then Maximum Value to Erase at 50" },
	{ "BuildBagWarningsOptions", 60, "Bag-Space Warnings" },
}

function ns.BuildSafetyOptions()
	--[[
	    The intro carries no trailing spacer of its own, unlike the two list
	    panels': every section here opens with one already, so a second would only
	    widen the gap under the paragraph.
	]]
	local args = {
		descIntro = ns.OptionsDesc(L["TAB_SAFETY_DESCRIPTION"], 1),
	}

	for _, entry in ipairs(SAFETY_SECTIONS) do
		ns[entry[1]](args)
	end

	return {
		type = "group",
		name = L["TAB_SAFETY"],
		args = args,
	}
end
