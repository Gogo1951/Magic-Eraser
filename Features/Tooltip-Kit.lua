local _, ns = ...

-- luacheck: read globals C_Container C_Item C_Secrets CreateFrame Enum GameTooltip GetItemQualityColor
-- luacheck: read globals hooksecurefunc InCombatLockdown IsLoggedIn issecretvalue NUM_BAG_SLOTS NUM_REAGENTBAG_SLOTS
-- luacheck: read globals TooltipDataProcessor UIParent

--[[
    Tooltip-Kit: every Gogo add-on's tooltip lines. The blocks an add-on adds
    to the game's own item, unit and spell tooltips, and the tooltips on its
    own widgets, drawn one way everywhere.

    Copied unchanged from Common-Core's addon-kits/Tooltip-Kit/ into
    Features/Tooltip-Kit.lua, after Features/Utilities.lua in the TOC, and
    checked byte for byte by CI. Never edit a copy: change Common-Core's and
    sync it (Common-Core/scripts/sync-addon-kits.sh).

    The kit knows nothing about the add-on. It reads only what every add-on
    already defines under one name: ns.PALETTE, and from ns.L the strings
    ADDON_SHORT_NAME, MENU_ON, MENU_OFF and MENU_MORE ("%d more").

    Spec: Common-Core/Add-on Guide/References/Design System/Tooltips/
    Tooltip-Kit.md.

    Blocks on the game's tooltips. The kit owns the hooks: the client's own
    route for each (TooltipDataProcessor where the tooltip runs on tooltip
    data, else HookScript after HasScript), installed at PLAYER_LOGIN, one
    block per add-on per tooltip show, and Show() after the lines go in.

      Tip.OnItem(fn(block, itemID, link, tooltip), opts)
                          opts.bagsOnly: only the player's carried bag slots
                          opts.tooltips: default { GameTooltip }
      Tip.OnUnit(fn(block, unit, tooltip), opts)
                          opts.notInCombat: nothing while in combat, the
                          default; false draws in combat too
                          opts.tooltips: default { GameTooltip }
      Tip.OnSpell(fn(block, spellID, tooltip), opts)
                          opts.tooltips: default { GameTooltip }
      Tip.Block(tooltip, opts) -> block, drawn on block:Done(), for the
                          add-on's own frames (opts.brand = false drops the
                          Short Name from the header)

    A block draws nothing until Done, and nothing at all with no rows: no
    spacer, no header. Every method returns the block.

      block:Header(title)                  Spacer, the title gold, the Short Name gray on the right
      block:Row(label, value)              Label white, value white on the right
      block:Item(itemIDOrLink, value)      The icon at line height and the name in its quality color
      block:Player(name, classFile, value) The name in its class color
      block:State(label, on)               On green or Off gray on the right
      block:Requirement(label, value, met) White, or red on both sides when met is false
      block:Line(text)                     A silver sentence that wraps
      block:List(rows, max)                Every row, or up to max, then "%d more" gray
      block:Total(label, value)            The bottom row, like a sum (Total … 25), whenever it's called
      block:Done() -> drawn                Draws the block and resizes the tooltip

    Tooltips on the add-on's own widgets. No brand.

      Tip.Help(owner, title, body, opts)   Gold title, white body, opts.helper (Tip.Helper),
                                           opts.hints, opts.anchor
      Tip.Thing(owner, linkOrSpellID, footer)
                                           The game's item or spell tooltip, then the footer:
                                           function(block), { title, lines } or a helper sentence
      Tip.Helper(tooltip, text)            A spacer, then the sentence silver, wrapped
      Tip.Hints(tooltip, hints)            A spacer, then each { action, click }: blue, gray
      Tip.Anchor(owner) -> point, relative The tooltip's corner and the owner's opposite one,
                                           away from the nearer edges, side to side and up and down
      Tip.Own(tooltip, owner, anchor)      SetOwner, placed by Tip.Anchor unless anchor is given

    Small helpers: Tip.Color(color, text), Tip.Count(number, word) ("7 Bag":
    the number white, the word gray) and Tip.Counts(pairs) ("7 Bag, 18 Bank").
]]

local Tip = {}
ns.TooltipKit = Tip

local format = string.format
local floor = math.floor

local INDENT = " " -- Every row under a header sits one step in, as the add-ons' blocks already do
local LIST_MAX = 8
local SPACER = " "

Tip.INDENT = INDENT
Tip.LIST_MAX = LIST_MAX

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

-- Style Guide → COLORS: the palette every add-on defines, for a key one leaves out.
local DEFAULT_PALETTE = {
	TITLE = "FFD100",
	INFO = "00BBFF",
	BODY = "FFFFFF",
	HELP = "CCCCCC",
	TEXT = "FFFFFF",
	ON = "33CC33",
	OFF = "CC3333",
	SEPARATOR = "AAAAAA",
	MUTED = "808080",
}

--[[
    Style Guide → COLORS: the same on every flavor, as Chat-Kit's. Never the
    game's RAID_CLASS_COLORS or C_ClassColor, which other add-ons can rewrite.
]]
local CLASS_COLORS = {
	DEATHKNIGHT = "C41E3A",
	DRUID = "FF7C0A",
	HUNTER = "AAD372",
	MAGE = "3FC7EB",
	PALADIN = "F48CBA",
	PRIEST = "FFFFFF",
	ROGUE = "FFF468",
	SHAMAN = "0070DD",
	WARLOCK = "8788EE",
	WARRIOR = "C69B6D",
}

-- A palette key or a six-digit hex, as a six-digit hex.
local function Hex(color)
	local palette = ns.PALETTE
	return (palette and palette[color]) or DEFAULT_PALETTE[color] or color
end

local function HexOf(r, g, b)
	return format("%02x%02x%02x", floor(r * 255 + 0.5), floor(g * 255 + 0.5), floor(b * 255 + 0.5))
end

local function RGB(hex)
	return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
end

-- Text in a palette key's or a hex's color. Text that already opens with a color keeps its own.
local function Color(color, text)
	text = tostring(text)
	if text:find("^|c") then
		return text
	end
	return "|cff" .. Hex(color) .. text .. "|r"
end
Tip.Color = Color

--[[
    A locale string, or the fallback. Read raw: AceLocale answers a missing key
    with the key's own name (and may store it so), which would draw
    ADDON_SHORT_NAME in game instead of the fallback.
]]
local function Text(key, fallback)
	local value = type(ns.L) == "table" and rawget(ns.L, key)
	if type(value) == "string" and value ~= "" and value ~= key then
		return value
	end
	return fallback
end

-- A class file's color as a hex, or nil for an unknown class.
local function ClassHex(classFile)
	return classFile and CLASS_COLORS[classFile] or nil
end

local function QualityHex(quality)
	if not quality then
		return nil
	end
	local get = (C_Item and C_Item.GetItemQualityColor) or GetItemQualityColor
	if get then
		local r, g, b = get(quality)
		if r then
			return HexOf(r, g, b)
		end
	end
end

-- "7 Bag": the number white, the word gray after it. With no word, the number alone.
function Tip.Count(number, word)
	local text = Color("TEXT", number)
	if word and word ~= "" then
		text = text .. Color("MUTED", " " .. word)
	end
	return text
end

-- "7 Bag, 18 Bank" from { { 7, "Bag" }, { 18, "Bank" } }, the commas gray with the words.
function Tip.Counts(list)
	local parts = {}
	for index, pair in ipairs(list) do
		parts[index] = Tip.Count(pair[1], pair[2])
	end
	return table.concat(parts, Color("MUTED", ", "))
end

--------------------------------------------------------------------------------
-- Items
--------------------------------------------------------------------------------

local function ItemIDFromLink(link)
	return type(link) == "string" and tonumber(link:match("item:(%d+)")) or nil
end

--[[
    An item's name, quality color and icon. An item the client hasn't cached
    yet shows its link's name, or its ID, in gray, and is asked for, so the
    next show has it.
]]
local function ItemLabel(item)
	local name, quality, icon
	if C_Item and C_Item.GetItemInfo then
		local _
		name, _, quality, _, _, _, _, _, _, icon = C_Item.GetItemInfo(item)
	end
	if not icon and C_Item and C_Item.GetItemInfoInstant then
		local _
		_, _, _, _, icon = C_Item.GetItemInfoInstant(item)
	end
	local hex = QualityHex(quality)
	if not name then
		local itemID = type(item) == "number" and item or ItemIDFromLink(item)
		if itemID and C_Item and C_Item.RequestLoadItemDataByID then
			C_Item.RequestLoadItemDataByID(itemID)
		end
		name = type(item) == "string" and item:match("%[(.-)%]") or tostring(itemID or item)
		hex = hex or Hex("MUTED")
	end
	local text = Color(hex or "BODY", name)
	if icon then
		text = "|T" .. icon .. ":0|t " .. text
	end
	return text
end

--------------------------------------------------------------------------------
-- Blocks
--------------------------------------------------------------------------------

local Block = {}
Block.__index = Block

--[[
    A block that draws onto tooltip when Done is called, and only if it holds a
    row. brand = false (the add-on's own widgets) leaves the Short Name off its
    header.
]]
function Tip.Block(tooltip, opts)
	return setmetatable({
		tooltip = tooltip,
		brand = not (opts and opts.brand == false),
		rows = {},
	}, Block)
end

local function Value(value)
	if value == nil then
		return nil
	end
	return Color("TEXT", value)
end

-- One row: its left side indented, its right side as given (nil for a line alone).
local function AddRow(block, left, right)
	block.rows[#block.rows + 1] = { left = INDENT .. left, right = right }
	return block
end

function Block:Header(title)
	self.title = title
	return self
end

function Block:Row(label, value)
	return AddRow(self, Color("BODY", label), Value(value))
end

function Block:Item(item, value)
	return AddRow(self, ItemLabel(item), Value(value))
end

function Block:Player(name, classFile, value)
	return AddRow(self, Color(ClassHex(classFile) or "BODY", name), Value(value))
end

-- On green in the add-on's MENU_ON; Off gray in its MENU_OFF, never red.
local function StateWord(on)
	if on then
		return Color("ON", Text("MENU_ON", "On"))
	end
	return Color("MUTED", Text("MENU_OFF", "Off"))
end

function Block:State(label, on)
	return AddRow(self, Color("BODY", label), StateWord(on))
end

-- Red only for a requirement the player is short of (met == false); met or unknown reads white.
function Block:Requirement(label, value, met)
	if met == false then
		return AddRow(self, Color("OFF", label), value ~= nil and Color("OFF", value) or nil)
	end
	return AddRow(self, Color("BODY", label), Value(value))
end

-- A sentence: silver, wrapping, not indented (a wrapped line's second line would lose the step).
function Block:Line(text)
	self.rows[#self.rows + 1] = { left = Color("HELP", text), wrap = true }
	return self
end

--[[
    Every row, or up to max when the add-on gives one, then "%d more" in gray.
    Each row is { label, value }, { label = , value = }, { item = , value = }
    or { name = , class = , value = }.
]]
function Block:List(rows, max)
	local count = #rows
	max = max or count
	for index = 1, math.min(count, max) do
		local row = rows[index]
		if row.item then
			self:Item(row.item, row.value)
		elseif row.class then
			self:Player(row.name, row.class, row.value)
		else
			self:Row(row.label or row[1], row.value or row[2])
		end
	end
	if count > max then
		AddRow(self, Color("MUTED", format(Text("MENU_MORE", "%d more"), count - max)))
	end
	return self
end

--[[
    The bottom row, like a sum: drawn last however early it's called. The label
    white on the left, the value white on the right (Total … 25), or a state
    word when value is true or false.
]]
function Block:Total(label, value)
	local right
	if type(value) == "boolean" then
		right = StateWord(value)
	else
		right = Value(value)
	end
	self.total = { left = INDENT .. Color("BODY", label), right = right }
	return self
end

-- True while the block holds a row: the hooks' and Thing's test for whether it will draw.
function Block:HasRows()
	return #self.rows > 0 or self.total ~= nil
end

local function AddLine(tooltip, text, color, wrap)
	local r, g, b = RGB(Hex(color))
	tooltip:AddLine(text, r, g, b, wrap)
end

local function AddDoubleLine(tooltip, left, right, leftColor, rightColor)
	local r, g, b = RGB(Hex(leftColor))
	local r2, g2, b2 = RGB(Hex(rightColor))
	tooltip:AddDoubleLine(left, right, r, g, b, r2, g2, b2)
end

--[[
    Draws the block once: a spacer (unless the tooltip is empty), the header,
    the rows, the total, then Show() so the tooltip grows to fit. A block with
    no rows draws nothing. True when it drew.
]]
function Block:Done()
	if self.done ~= nil then
		return self.done
	end
	self.done = false
	if not self:HasRows() then
		return false
	end
	local tooltip = self.tooltip
	if tooltip:NumLines() > 0 then
		AddLine(tooltip, SPACER, "TEXT")
	end
	if self.title then
		if self.brand then
			AddDoubleLine(
				tooltip,
				Color("TITLE", self.title),
				Color("MUTED", Text("ADDON_SHORT_NAME", "")),
				"TITLE",
				"MUTED"
			)
		else
			AddLine(tooltip, Color("TITLE", self.title), "TITLE")
		end
	end
	local rows = self.rows
	if self.total then
		rows[#rows + 1] = self.total
	end
	for _, row in ipairs(rows) do
		if row.right then
			AddDoubleLine(tooltip, row.left, row.right, "BODY", "TEXT")
		else
			AddLine(tooltip, row.left, row.wrap and "HELP" or "BODY", row.wrap)
		end
	end
	tooltip:Show()
	self.done = true
	return true
end

--------------------------------------------------------------------------------
-- Hooks
--------------------------------------------------------------------------------

local function IsSecret(value)
	return issecretvalue ~= nil and issecretvalue(value) and true or false
end

--[[
    Which registrations have drawn on each tooltip since it was last cleared:
    the game can fill one tooltip twice for one show (a recipe and what it
    makes), and the second block is the defect this stops. Cleared with the
    tooltip's lines and when it hides.
]]
local drawn = setmetatable({}, { __mode = "k" })
local watched = setmetatable({}, { __mode = "k" })

local function Clear(tooltip)
	drawn[tooltip] = nil
end

local function Watch(tooltip)
	if watched[tooltip] then
		return
	end
	watched[tooltip] = true
	for _, script in ipairs({ "OnTooltipCleared", "OnHide" }) do
		if tooltip.HasScript and tooltip:HasScript(script) then
			tooltip:HookScript(script, Clear)
		end
	end
end

local function Run(registration, tooltip, ...)
	local done = drawn[tooltip]
	if done and done[registration] then
		return
	end
	if tooltip.IsForbidden and tooltip:IsForbidden() then
		return
	end
	local block = Tip.Block(tooltip)
	registration.fn(block, ...)
	if block:Done() then
		done = done or {}
		done[registration] = true
		drawn[tooltip] = done
	end
end

--[[
    Whether the game fills its tooltips through TooltipDataProcessor, for the
    script the old route fires. The Classic clients ship TooltipDataProcessor
    but their GameTooltip never runs on it, and they still have the script
    (Water Dispenser's Item-Tooltips.lua and Play It Forward's
    Generosity-Tooltip.lua found this in game); the Retail engine (Forever)
    has dropped the script and runs on tooltip data.
]]
local function UsesTooltipData(script)
	return type(TooltipDataProcessor) == "table"
		and type(TooltipDataProcessor.AddTooltipPostCall) == "function"
		and Enum ~= nil
		and Enum.TooltipDataType ~= nil
		and not (GameTooltip.HasScript and GameTooltip:HasScript(script))
end

local function Wanted(registration)
	local list = registration.opts.tooltips or { GameTooltip }
	local wanted = {}
	for _, tooltip in ipairs(list) do
		wanted[tooltip] = true
		Watch(tooltip)
	end
	return wanted
end

local function LastCarriedBag()
	return (NUM_BAG_SLOTS or 4) + (NUM_REAGENTBAG_SLOTS or 0)
end

local function IsCarriedBag(bag)
	return type(bag) == "number" and bag >= 0 and bag <= LastCarriedBag()
end

-- Whether the tooltip's owner is a slot in the player's carried bags (the tooltip-data route's bag check).
local function OwnerInCarriedBag(tooltip)
	local owner = tooltip.GetOwner and tooltip:GetOwner()
	if not owner or type(owner.GetBagID) ~= "function" then
		return false
	end
	local ok, bag = pcall(owner.GetBagID, owner)
	return ok and IsCarriedBag(bag)
end

local function TooltipItemLink(tooltip)
	if tooltip.GetItem then
		local _, link = tooltip:GetItem()
		return link
	end
end

local function InstallItem(registration)
	local wanted = Wanted(registration)
	local bagsOnly = registration.opts.bagsOnly
	local function Fire(tooltip, itemID, link)
		if IsSecret(itemID) or IsSecret(link) then
			return
		end
		itemID = itemID or ItemIDFromLink(link)
		if itemID then
			Run(registration, tooltip, itemID, link, tooltip)
		end
	end

	if UsesTooltipData("OnTooltipSetItem") then
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
			if wanted[tooltip] and (not bagsOnly or OwnerInCarriedBag(tooltip)) then
				Fire(tooltip, data and data.id, TooltipItemLink(tooltip))
			end
		end)
	elseif bagsOnly then
		--[[
            The bag slot itself, not the shared script: bag-scoped by its own
            arguments, so it holds under replacement bag add-ons, and it runs
            after the slot's tooltip is built (Water Dispenser's route).
        ]]
		if wanted[GameTooltip] and GameTooltip.SetBagItem then
			hooksecurefunc(GameTooltip, "SetBagItem", function(tooltip, bag, slot)
				if IsCarriedBag(bag) then
					Fire(
						tooltip,
						C_Container.GetContainerItemID(bag, slot),
						C_Container.GetContainerItemLink(bag, slot)
					)
				end
			end)
		end
	else
		for tooltip in pairs(wanted) do
			if tooltip.HasScript and tooltip:HasScript("OnTooltipSetItem") then
				tooltip:HookScript("OnTooltipSetItem", function(self)
					Fire(self, nil, TooltipItemLink(self))
				end)
			end
		end
	end
end

local function InstallUnit(registration)
	local wanted = Wanted(registration)
	-- On unless the add-on asks otherwise: Forever's units turn secret in combat.
	local notInCombat = registration.opts.notInCombat ~= false
	local function Fire(tooltip)
		if not wanted[tooltip] then
			return
		end
		-- Before GetUnit: in combat on Forever, the unit it returns can be secret.
		if notInCombat and InCombatLockdown() then
			return
		end
		local _, unit = tooltip:GetUnit()
		if not unit or IsSecret(unit) then
			return
		end
		if C_Secrets and C_Secrets.ShouldUnitIdentityBeSecret and C_Secrets.ShouldUnitIdentityBeSecret(unit) then
			return
		end
		Run(registration, tooltip, unit, tooltip)
	end

	if UsesTooltipData("OnTooltipSetUnit") then
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, Fire)
	else
		for tooltip in pairs(wanted) do
			if tooltip.HasScript and tooltip:HasScript("OnTooltipSetUnit") then
				tooltip:HookScript("OnTooltipSetUnit", Fire)
			end
		end
	end
end

local function InstallSpell(registration)
	local wanted = Wanted(registration)
	local function Fire(tooltip, spellID)
		if wanted[tooltip] and spellID and not IsSecret(spellID) then
			Run(registration, tooltip, spellID, tooltip)
		end
	end

	if UsesTooltipData("OnTooltipSetSpell") then
		local SPELL = Enum.TooltipDataType.Spell
		TooltipDataProcessor.AddTooltipPostCall(SPELL, function(tooltip, data)
			Fire(tooltip, data and data.id)
		end)
		--[[
            An action bar slot holding a macro fills a Macro tooltip, not a
            Spell one; the spell it shows is its first line's tooltipID (Good
            to Go's ns.AddSpellTooltipPostCall). A macro showing an item, or
            nothing, is skipped.
        ]]
		local MACRO = Enum.TooltipDataType.Macro
		if MACRO then
			TooltipDataProcessor.AddTooltipPostCall(MACRO, function(tooltip, data)
				local lines = data and not IsSecret(data.lines) and data.lines
				local line = type(lines) == "table" and lines[1]
				if not line or IsSecret(line.tooltipType) or IsSecret(line.tooltipID) then
					return
				end
				if line.tooltipType == nil or line.tooltipType == SPELL then
					Fire(tooltip, line.tooltipID)
				end
			end)
		end
	else
		for tooltip in pairs(wanted) do
			if tooltip.HasScript and tooltip:HasScript("OnTooltipSetSpell") then
				tooltip:HookScript("OnTooltipSetSpell", function(self)
					local _, spellID = self:GetSpell()
					Fire(self, spellID)
				end)
			end
		end
	end
end

local INSTALL = { item = InstallItem, unit = InstallUnit, spell = InstallSpell }

--[[
    Hooks go in at PLAYER_LOGIN, behind every add-on that hooked while it
    loaded, so the block sits low in the tooltip; or right away once the player
    is in the world. A hook can't be removed, so each registration installs once.
]]
local loggedIn = IsLoggedIn ~= nil and IsLoggedIn() and true or false
local pending = {}

local function Register(kind, fn, opts)
	local registration = { kind = kind, fn = fn, opts = opts or {} }
	if loggedIn then
		INSTALL[kind](registration)
	else
		pending[#pending + 1] = registration
	end
	return registration
end

if not loggedIn then
	local events = CreateFrame("Frame")
	events:RegisterEvent("PLAYER_LOGIN")
	events:SetScript("OnEvent", function(self)
		self:UnregisterEvent("PLAYER_LOGIN")
		loggedIn = true
		for _, registration in ipairs(pending) do
			INSTALL[registration.kind](registration)
		end
		pending = {}
	end)
end

function Tip.OnItem(fn, opts)
	return Register("item", fn, opts)
end

function Tip.OnUnit(fn, opts)
	return Register("unit", fn, opts)
end

function Tip.OnSpell(fn, opts)
	return Register("spell", fn, opts)
end

--------------------------------------------------------------------------------
-- The Add-on's Own Widgets
--------------------------------------------------------------------------------

--[[
    Away from the screen's nearer edges, as a menu opens (Style Guide →
    MINIMAP MENU → Placement): right of an owner left of the middle, else
    left; above an owner in the bottom half, else below. Returns the tooltip's
    corner and the owner's opposite one, BOTTOMLEFT and TOPRIGHT by default.
]]
function Tip.Anchor(owner)
	local x, y
	if owner and owner.GetCenter then
		x, y = owner:GetCenter()
	end
	local middleX, middleY
	if UIParent and UIParent.GetCenter then
		middleX, middleY = UIParent:GetCenter()
	end
	local scale = owner and owner.GetEffectiveScale and owner:GetEffectiveScale() or 1
	local screenScale = UIParent and UIParent.GetEffectiveScale and UIParent:GetEffectiveScale() or 1
	local openLeft = x ~= nil and middleX ~= nil and x * scale >= middleX * screenScale
	local openDown = y ~= nil and middleY ~= nil and y * scale >= middleY * screenScale
	local vertical, opposite = "BOTTOM", "TOP"
	if openDown then
		vertical, opposite = "TOP", "BOTTOM"
	end
	if openLeft then
		return vertical .. "RIGHT", opposite .. "LEFT"
	end
	return vertical .. "LEFT", opposite .. "RIGHT"
end

-- The tooltip owned by owner and placed by Tip.Anchor; an anchor given (an ANCHOR_ name) is used as is.
function Tip.Own(tooltip, owner, anchor)
	if anchor then
		tooltip:SetOwner(owner, anchor)
		return tooltip
	end
	tooltip:SetOwner(owner, "ANCHOR_NONE")
	tooltip:ClearAllPoints()
	local point, relative = Tip.Anchor(owner)
	tooltip:SetPoint(point, owner, relative)
	return tooltip
end

-- Each { action, click } on its own line after one spacer: the action blue, the click gray, no gaps between.
function Tip.Hints(tooltip, hints)
	if not hints or #hints == 0 then
		return tooltip
	end
	if tooltip:NumLines() > 0 then
		AddLine(tooltip, SPACER, "TEXT")
	end
	for _, hint in ipairs(hints) do
		AddDoubleLine(tooltip, Color("INFO", hint[1]), Color("MUTED", hint[2]), "INFO", "MUTED")
	end
	tooltip:Show()
	return tooltip
end

-- A helper sentence is a new section: one spacer (unless the tooltip is empty), then the sentence silver, wrapped.
function Tip.Helper(tooltip, text)
	if not text or text == "" then
		return tooltip
	end
	if tooltip:NumLines() > 0 then
		AddLine(tooltip, SPACER, "TEXT")
	end
	AddLine(tooltip, Color("HELP", text), "HELP", true)
	tooltip:Show()
	return tooltip
end

--[[
    Help on a widget: the title gold, the body white right under it, then
    opts.helper (Tip.Helper, after a spacer) and opts.hints (Tip.Hints).
    opts.anchor (an ANCHOR_ name) overrides Tip.Anchor. Returns GameTooltip,
    shown.
]]
function Tip.Help(owner, title, body, opts)
	opts = opts or {}
	local tooltip = GameTooltip
	Tip.Own(tooltip, owner, opts.anchor)
	AddLine(tooltip, Color("TITLE", title), "TITLE")
	if body then
		AddLine(tooltip, Color("BODY", body), "BODY", true)
	end
	Tip.Helper(tooltip, opts.helper)
	Tip.Hints(tooltip, opts.hints)
	tooltip:Show()
	return tooltip
end

--[[
    The game's own tooltip for a thing, unchanged (a number is a spell ID, a
    string a link or "item:6948"), then the add-on's footer: a spacer, its
    title gold without the Short Name, its lines. footer is function(block),
    { title = , lines = { "a sentence", { label, value }, ... } }, or a string:
    a helper sentence (Tip.Helper). Returns GameTooltip, shown.
]]
function Tip.Thing(owner, thing, footer)
	local tooltip = GameTooltip
	Tip.Own(tooltip, owner)
	if type(thing) == "number" then
		tooltip:SetSpellByID(thing)
	elseif thing then
		tooltip:SetHyperlink(thing)
	end
	if type(footer) == "function" then
		local block = Tip.Block(tooltip, { brand = false })
		footer(block)
		block:Done()
	elseif type(footer) == "table" then
		local block = Tip.Block(tooltip, { brand = false }):Header(footer.title)
		for _, line in ipairs(footer.lines or {}) do
			if type(line) == "table" then
				block:Row(line.label or line[1], line.value or line[2])
			else
				block:Line(line)
			end
		end
		block:Done()
	elseif type(footer) == "string" then
		Tip.Helper(tooltip, footer)
	end
	tooltip:Show()
	return tooltip
end
