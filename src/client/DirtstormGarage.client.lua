--[[
  Dirtstorm XT™ v1.0 — Client UI
  ThrillFusion Group™ | Born in Africa. Built for the World.

  Full garage, race HUD, challenge tracker, creature codex, notifications.
  Everything is FREE. No purchase prompts or external links.
]]

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Shared data
local Shared       = ReplicatedStorage:WaitForChild("Shared")
local Data         = require(Shared.Data)
local Config       = Data.GameConfig
local ChallengeData= Data.ChallengeData
local CreatureData = Data.CreatureData

-- Remotes
local Remotes          = ReplicatedStorage:WaitForChild("DirtstormRemotes")
local CustomizeEvent   = Remotes:WaitForChild("Customize")
local DecalEvent       = Remotes:WaitForChild("SetDecal")
local AccessoryEvent   = Remotes:WaitForChild("ToggleAccessory")
local ChallengeUpdateEvt = Remotes:WaitForChild("ChallengeUpdate")
local CreatureFoundEvt = Remotes:WaitForChild("CreatureFound")
local NotifyEvt        = Remotes:WaitForChild("Notify")

--------------------------------------------------------------------------------
-- UI HELPERS
--------------------------------------------------------------------------------
local Brand = Config.Brand

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 10); c.Parent = parent
	return c
end

local function makeStroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(60, 60, 70)
	s.Thickness = thickness or 1
	s.Parent = parent
	return s
end

local function makeLabel(parent, text, pos, size, fontSize, color, font)
	local t = Instance.new("TextLabel")
	t.Size = size or UDim2.new(1, -16, 0, 24)
	t.Position = pos or UDim2.fromOffset(8, 0)
	t.BackgroundTransparency = 1
	t.Text = text
	t.TextColor3 = color or Color3.new(1, 1, 1)
	t.TextScaled = fontSize == nil
	if fontSize then t.TextSize = fontSize end
	t.Font = font or Enum.Font.GothamBold
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = parent
	return t
end

local function makeButton(parent, text, pos, size, bgColor, callback)
	local b = Instance.new("TextButton")
	b.Size = size or UDim2.fromOffset(100, 36)
	b.Position = pos
	b.Text = text
	b.TextScaled = true; b.Font = Enum.Font.GothamBold
	b.BackgroundColor3 = bgColor or Brand.PrimaryColor
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Parent = parent
	makeCorner(b, 7)
	if callback then b.Activated:Connect(callback) end
	return b
end

local function makePanel(parent, name, pos, size)
	local f = Instance.new("Frame")
	f.Name = name
	f.Size = size
	f.Position = pos
	f.BackgroundColor3 = Brand.PanelBg
	f.BorderSizePixel = 0
	f.Parent = parent
	makeCorner(f, 12)
	makeStroke(f, Color3.fromRGB(50, 55, 70), 1)
	return f
end

--------------------------------------------------------------------------------
-- MAIN SCREEN GUI
--------------------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "DirtstormXT"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

--------------------------------------------------------------------------------
-- TAB BAR (bottom center)
--------------------------------------------------------------------------------
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.fromOffset(400, 44)
tabBar.Position = UDim2.new(0.5, -200, 1, -52)
tabBar.BackgroundColor3 = Brand.DarkBg
tabBar.Parent = gui
makeCorner(tabBar, 10)
makeStroke(tabBar, Brand.PrimaryColor, 2)

local tabs = { "Garage", "Challenges", "Creatures", "Race" }
local tabPanels = {}
local activeTab = "Garage"

for i, tabName in ipairs(tabs) do
	local btn = Instance.new("TextButton")
	btn.Name = tabName
	btn.Size = UDim2.fromScale(1 / #tabs, 1)
	btn.Position = UDim2.fromScale((i - 1) / #tabs, 0)
	btn.BackgroundTransparency = 1
	btn.Text = tabName
	btn.TextScaled = true; btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = i == 1 and Brand.PrimaryColor or Color3.fromRGB(140, 140, 150)
	btn.Parent = tabBar

	btn.Activated:Connect(function()
		activeTab = tabName
		for _, child in ipairs(tabBar:GetChildren()) do
			if child:IsA("TextButton") then
				child.TextColor3 = child.Name == tabName and Brand.PrimaryColor or Color3.fromRGB(140, 140, 150)
			end
		end
		for name, panel in pairs(tabPanels) do
			panel.Visible = (name == tabName)
		end
	end)
end

--------------------------------------------------------------------------------
-- GARAGE PANEL
--------------------------------------------------------------------------------
local garagePanel = makePanel(gui, "Garage", UDim2.new(0, 12, 1, -330), UDim2.fromOffset(260, 270))
tabPanels["Garage"] = garagePanel

-- Title
makeLabel(garagePanel, "DIRTSTORM XT GARAGE", UDim2.fromOffset(10, 8),
	UDim2.new(1, -20, 0, 22), nil, Brand.PrimaryColor)
makeLabel(garagePanel, "All FREE — no purchases", UDim2.fromOffset(10, 32),
	UDim2.new(1, -20, 0, 16), nil, Color3.fromRGB(160, 160, 170), Enum.Font.Gotham)

-- Paint colors (2 columns × 4 rows)
local paintColors = {}
for name, _ in pairs(Config.PaintColors) do table.insert(paintColors, name) end
table.sort(paintColors) -- consistent order

for i, colorName in ipairs(paintColors) do
	local col = (i - 1) % 2
	local row = math.floor((i - 1) / 2)
	makeButton(garagePanel, colorName,
		UDim2.fromOffset(12 + col * 122, 56 + row * 38),
		UDim2.fromOffset(115, 32),
		Config.PaintColors[colorName],
		function() CustomizeEvent:FireServer(colorName) end)
end

-- Decals section header
makeLabel(garagePanel, "DECALS", UDim2.fromOffset(10, 215),
	UDim2.new(1, -20, 0, 16), nil, Brand.PrimaryColor, Enum.Font.GothamBold)

-- Decal buttons (scrollable row)
local decalScroll = Instance.new("ScrollingFrame")
decalScroll.Size = UDim2.new(1, -20, 0, 32)
decalScroll.Position = UDim2.fromOffset(10, 235)
decalScroll.BackgroundTransparency = 1
decalScroll.ScrollBarThickness = 3
decalScroll.CanvasSize = UDim2.fromOffset(#Config.Decals * 95, 0)
decalScroll.ScrollingDirection = Enum.ScrollingDirection.X
decalScroll.Parent = garagePanel

for i, decalName in ipairs(Config.Decals) do
	makeButton(decalScroll, decalName,
		UDim2.fromOffset((i - 1) * 93, 0),
		UDim2.fromOffset(88, 28),
		Color3.fromRGB(55, 60, 80),
		function() DecalEvent:FireServer(decalName) end)
end

--------------------------------------------------------------------------------
-- ACCESSORIES PANEL (attached to garage)
--------------------------------------------------------------------------------
local accPanel = makePanel(gui, "Accessories", UDim2.new(0, 12, 1, -600), UDim2.fromOffset(260, 260))
accPanel.Visible = true
tabPanels["Garage_Acc"] = accPanel -- always visible with garage

makeLabel(accPanel, "ACCESSORIES (tap to toggle)", UDim2.fromOffset(10, 8),
	UDim2.new(1, -20, 0, 20), nil, Brand.PrimaryColor)
makeLabel(accPanel, "All FREE cosmetic", UDim2.fromOffset(10, 28),
	UDim2.new(1, -20, 0, 14), nil, Color3.fromRGB(160, 160, 170), Enum.Font.Gotham)

local accNames = {}
for name, _ in pairs(Config.Accessories) do
	-- Config.Accessories is a list not a dict
end
-- Use the list directly
for i, accName in ipairs(Config.Accessories) do
	local col = (i - 1) % 2
	local row = math.floor((i - 1) / 2)
	makeButton(accPanel, accName,
		UDim2.fromOffset(12 + col * 122, 48 + row * 38),
		UDim2.fromOffset(115, 32),
		Color3.fromRGB(60, 65, 85),
		function() AccessoryEvent:FireServer(accName) end)
end

--------------------------------------------------------------------------------
-- CHALLENGES PANEL
--------------------------------------------------------------------------------
local challengePanel = makePanel(gui, "Challenges",
	UDim2.new(0, 12, 0.5, -200), UDim2.fromOffset(300, 400))
challengePanel.Visible = false
tabPanels["Challenges"] = challengePanel

makeLabel(challengePanel, "DRAWING BOOK CHALLENGES", UDim2.fromOffset(10, 8),
	UDim2.new(1, -20, 0, 22), nil, Brand.PrimaryColor)
makeLabel(challengePanel, "8 books × 3 challenges each — all FREE",
	UDim2.fromOffset(10, 32), UDim2.new(1, -20, 0, 14), nil, Color3.fromRGB(160, 160, 170), Enum.Font.Gotham)

local challengeScroll = Instance.new("ScrollingFrame")
challengeScroll.Size = UDim2.new(1, -20, 1, -55)
challengeScroll.Position = UDim2.fromOffset(10, 50)
challengeScroll.BackgroundTransparency = 1
challengeScroll.ScrollBarThickness = 4
challengeScroll.CanvasSize = UDim2.fromOffset(0, #ChallengeData.Books * 110)
challengeScroll.Parent = challengePanel

local challengeLabels = {}

for bi, book in ipairs(ChallengeData.Books) do
	local yBase = (bi - 1) * 108

	-- Book header
	makeLabel(challengeScroll, book.icon .. " Book " .. book.bookNum .. ": " .. book.title,
		UDim2.fromOffset(0, yBase), UDim2.new(1, 0, 0, 20), nil, Brand.PrimaryColor, Enum.Font.GothamBold)

	-- Individual challenges
	for ci, ch in ipairs(book.challenges) do
		local lbl = makeLabel(challengeScroll,
			"  ○  " .. ch.name .. " — " .. ch.desc,
			UDim2.fromOffset(4, yBase + 22 + (ci - 1) * 24),
			UDim2.new(1, -8, 0, 22), nil,
			Color3.fromRGB(180, 180, 190), Enum.Font.Gotham)
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		challengeLabels[ch.id] = lbl
	end
end

-- Listen for challenge completions
ChallengeUpdateEvt.OnClientEvent:Connect(function(challengeId, completed)
	local lbl = challengeLabels[challengeId]
	if lbl and completed then
		local ch = ChallengeData.ByID[challengeId]
		lbl.Text = "  ✓  " .. ch.name .. " — COMPLETE ⭐"
		lbl.TextColor3 = Brand.PrimaryColor
	end
end)

--------------------------------------------------------------------------------
-- CREATURE CODEX PANEL
--------------------------------------------------------------------------------
local creaturePanel = makePanel(gui, "Creatures",
	UDim2.new(1, -310, 0.5, -150), UDim2.fromOffset(290, 300))
creaturePanel.Visible = false
tabPanels["Creatures"] = creaturePanel

makeLabel(creaturePanel, "THRILLVERSE CREATURE CODEX", UDim2.fromOffset(10, 8),
	UDim2.new(1, -20, 0, 22), nil, Brand.PrimaryColor)
makeLabel(creaturePanel, "Drive close to discover!", UDim2.fromOffset(10, 32),
	UDim2.new(1, -20, 0, 14), nil, Color3.fromRGB(160, 160, 170), Enum.Font.Gotham)

local creatureLabels = {}
for i, species in ipairs(CreatureData.Species) do
	local lbl = makeLabel(creaturePanel,
		"  ?  " .. string.rep("?", #species.name) .. " [" .. species.rarity .. "]",
		UDim2.fromOffset(10, 50 + (i - 1) * 38),
		UDim2.new(1, -20, 0, 34), nil,
		Color3.fromRGB(100, 100, 110), Enum.Font.Gotham)
	creatureLabels[species.id] = lbl
end

CreatureFoundEvt.OnClientEvent:Connect(function(speciesId)
	local lbl = creatureLabels[speciesId]
	local species = CreatureData.ByID[speciesId]
	if lbl and species then
		lbl.Text = "  " .. species.icon .. "  " .. species.name .. " — " .. species.desc
		lbl.TextColor3 = species.color
	end
end)

--------------------------------------------------------------------------------
-- RACE HUD (top center — always visible during race)
--------------------------------------------------------------------------------
local racePanel = makePanel(gui, "Race", UDim2.new(0.5, -180, 0, 10), UDim2.fromOffset(360, 55))
racePanel.Visible = true
tabPanels["Race"] = racePanel

local raceInfo = makeLabel(racePanel, "DIRTSTORM XT — Race through all 6 gates!",
	UDim2.fromOffset(10, 5), UDim2.new(1, -20, 0, 18), nil, Brand.PrimaryColor, Enum.Font.GothamBold)

local raceStats = makeLabel(racePanel, "Laps: 0  |  Stars: 0  |  Best: --",
	UDim2.fromOffset(10, 28), UDim2.new(1, -20, 0, 18), nil,
	Color3.new(1, 1, 1), Enum.Font.Gotham)

-- Update race stats from leaderstats
task.spawn(function()
	local stats = player:WaitForChild("leaderstats")
	local laps = stats:WaitForChild("Laps")
	local stars = stats:WaitForChild("Stars")
	local bestLap = stats:WaitForChild("Best Lap")

	local function update()
		raceStats.Text = string.format("Laps: %d  |  Stars: %d  |  Best: %s",
			laps.Value, stars.Value, bestLap.Value)
	end

	laps.Changed:Connect(update)
	stars.Changed:Connect(update)
	bestLap.Changed:Connect(update)
	update()
end)

--------------------------------------------------------------------------------
-- NOTIFICATION TOAST (top-right, fades in/out)
--------------------------------------------------------------------------------
local toastQueue = {}
local toastActive = false

local toastFrame = makePanel(gui, "Toast", UDim2.new(1, -320, 0, 10), UDim2.fromOffset(300, 50))
toastFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
toastFrame.Visible = false
makeStroke(toastFrame, Brand.PrimaryColor, 2)

local toastLabel = makeLabel(toastFrame, "", UDim2.fromOffset(10, 5),
	UDim2.new(1, -20, 1, -10), nil, Brand.PrimaryColor, Enum.Font.GothamBold)
toastLabel.TextXAlignment = Enum.TextXAlignment.Center

local function showNextToast()
	if toastActive or #toastQueue == 0 then return end
	toastActive = true
	local msg = table.remove(toastQueue, 1)
	toastLabel.Text = msg
	toastFrame.Visible = true
	toastFrame.BackgroundTransparency = 0

	task.delay(3, function()
		local tween = TweenService:Create(toastFrame,
			TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundTransparency = 1 })
		tween:Play()
		tween.Completed:Connect(function()
			toastFrame.Visible = false
			toastFrame.BackgroundTransparency = 0
			toastActive = false
			showNextToast()
		end)
	end)
end

NotifyEvt.OnClientEvent:Connect(function(msg)
	table.insert(toastQueue, msg)
	showNextToast()
end)

--------------------------------------------------------------------------------
-- HELP TEXT
--------------------------------------------------------------------------------
local helpLabel = makeLabel(gui, "Race 6 gates = 1 ⭐  |  Discover creatures  |  Complete challenges  |  ALL FREE",
	UDim2.new(0.5, -250, 1, -18), UDim2.fromOffset(500, 16), nil,
	Color3.fromRGB(120, 120, 130), Enum.Font.Gotham)
helpLabel.TextXAlignment = Enum.TextXAlignment.Center

print("Dirtstorm XT v1.0 client UI loaded")
