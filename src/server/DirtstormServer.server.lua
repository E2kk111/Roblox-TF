--[[
  Dirtstorm XT™ v1.0 — Server Engine
  ThrillFusion Group™ | Born in Africa. Built for the World.

  FREE-TO-PLAY arcade racing with drawing-book challenges.
  No purchases, no pay-to-win, no data collection on children.
  Stars are session-only and cannot be traded.
]]

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local World          = game:GetService("Workspace")

-- Load shared config
local Shared       = ReplicatedStorage:WaitForChild("Shared")
local Data         = require(Shared.Data)
local Config       = Data.GameConfig
local TruckData    = Data.TruckData
local ChallengeData= Data.ChallengeData
local CreatureData = Data.CreatureData

--------------------------------------------------------------------------------
-- CLEANUP OLD INSTANCES
--------------------------------------------------------------------------------
local old = World:FindFirstChild("DirtstormXT")
if old then old:Destroy() end
local root = Instance.new("Folder"); root.Name = "DirtstormXT"; root.Parent = World

--------------------------------------------------------------------------------
-- REMOTE EVENTS
--------------------------------------------------------------------------------
local function getOrCreate(class, name, parent)
	local obj = parent:FindFirstChild(name)
	if not obj then
		obj = Instance.new(class)
		obj.Name = name
		obj.Parent = parent
	end
	return obj
end

local Remotes = Instance.new("Folder"); Remotes.Name = "DirtstormRemotes"; Remotes.Parent = ReplicatedStorage
local CustomizeEvent    = getOrCreate("RemoteEvent", "Customize", Remotes)
local DecalEvent        = getOrCreate("RemoteEvent", "SetDecal", Remotes)
local AccessoryEvent    = getOrCreate("RemoteEvent", "ToggleAccessory", Remotes)
local ChallengeStartEvt = getOrCreate("RemoteEvent", "ChallengeStart", Remotes)
local ChallengeUpdateEvt= getOrCreate("RemoteEvent", "ChallengeUpdate", Remotes)
local CreatureFoundEvt  = getOrCreate("RemoteEvent", "CreatureFound", Remotes)
local NotifyEvt         = getOrCreate("RemoteEvent", "Notify", Remotes)

--------------------------------------------------------------------------------
-- ARENA BUILDER
--------------------------------------------------------------------------------
local function block(name, size, cf, color, material, parent)
	local p = Instance.new("Part")
	p.Name = name; p.Size = size; p.CFrame = cf; p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = true; p.Parent = parent or root
	return p
end

-- Ground and track
block("Ground", Vector3.new(Config.Arena.Width, 2, Config.Arena.Depth),
	CFrame.new(0, -2, 0), Color3.fromRGB(60, 123, 74), Enum.Material.Grass)

block("Track", Vector3.new(Config.Arena.TrackWidth, 1, Config.Arena.TrackDepth),
	CFrame.new(0, -0.45, 0), Color3.fromRGB(124, 81, 48), Enum.Material.Ground)

block("Infield", Vector3.new(Config.Arena.InfieldW, 1.1, Config.Arena.InfieldD),
	CFrame.new(0, -0.35, 0), Color3.fromRGB(59, 120, 69), Enum.Material.Grass)

-- Barriers (walls)
local wallColor = Color3.fromRGB(248, 180, 28)
for _, z in ipairs({-94, 94}) do
	block("Barrier", Vector3.new(276, Config.Arena.WallHeight, 3), CFrame.new(0, 2, z), wallColor, Enum.Material.Metal)
end
for _, x in ipairs({-138, 138}) do
	block("Barrier", Vector3.new(3, Config.Arena.WallHeight, 191), CFrame.new(x, 2, 0), wallColor, Enum.Material.Metal)
end

-- Ramps (new in v1.0)
local rampColor = Color3.fromRGB(180, 100, 40)
local rampPositions = {
	{ pos = CFrame.new(-80, 0.5, 0) * CFrame.Angles(math.rad(-15), 0, 0), size = Vector3.new(14, 1, 20) },
	{ pos = CFrame.new(80, 0.5, 0) * CFrame.Angles(math.rad(-15), 0, 0), size = Vector3.new(14, 1, 20) },
	{ pos = CFrame.new(0, 0.5, -60) * CFrame.Angles(math.rad(-12), math.rad(45), 0), size = Vector3.new(12, 1, 18) },
	{ pos = CFrame.new(0, 0.5, 60) * CFrame.Angles(math.rad(-12), math.rad(-45), 0), size = Vector3.new(12, 1, 18) },
}
for i, ramp in ipairs(rampPositions) do
	local r = block("Ramp" .. i, ramp.size, ramp.pos, rampColor, Enum.Material.Wood)
	r.CanCollide = true
end

-- Crush targets (small destructible barrels)
local crushFolder = Instance.new("Folder"); crushFolder.Name = "CrushTargets"; crushFolder.Parent = root
local crushSpots = {
	Vector3.new(-50, 1.5, -30), Vector3.new(-30, 1.5, 50), Vector3.new(50, 1.5, 30),
	Vector3.new(30, 1.5, -50), Vector3.new(-70, 1.5, 0),   Vector3.new(70, 1.5, 0),
	Vector3.new(0, 1.5, -75),  Vector3.new(0, 1.5, 75),
}
for i, pos in ipairs(crushSpots) do
	local barrel = block("Barrel" .. i, Vector3.new(3, 3, 3), CFrame.new(pos),
		Color3.fromRGB(200, 60, 40), Enum.Material.Wood, crushFolder)
	barrel.Shape = Enum.PartType.Cylinder
	barrel.CanCollide = false
end

-- Floating rings (for Activities & Puzzles challenges)
local ringFolder = Instance.new("Folder"); ringFolder.Name = "Rings"; ringFolder.Parent = root
local ringPositions = {
	Vector3.new(-100, 8, -50), Vector3.new(-60, 10, -70), Vector3.new(-20, 7, -80),
	Vector3.new(20, 9, -70),   Vector3.new(60, 8, -50),   Vector3.new(100, 10, -30),
	Vector3.new(100, 7, 30),   Vector3.new(60, 9, 50),    Vector3.new(20, 8, 70),
	Vector3.new(-40, 10, 60),
}
for i, pos in ipairs(ringPositions) do
	local ring = block("Ring" .. i, Vector3.new(10, 10, 1), CFrame.new(pos),
		Color3.fromRGB(45, 226, 219), Enum.Material.Neon, ringFolder)
	ring.Transparency = 0.5
	ring.Shape = Enum.PartType.Cylinder
	ring.CanCollide = false
end

-- ThrillVerse portals
local portalFolder = Instance.new("Folder"); portalFolder.Name = "Portals"; portalFolder.Parent = root
local portalSpots = {
	{ pos = Vector3.new(-120, 6, -80), color = Color3.fromRGB(148, 55, 220) },
	{ pos = Vector3.new(120, 6, -80),  color = Color3.fromRGB(220, 43, 48) },
	{ pos = Vector3.new(120, 6, 80),   color = Color3.fromRGB(39, 176, 104) },
	{ pos = Vector3.new(-120, 6, 80),  color = Color3.fromRGB(245, 179, 24) },
}
for i, p in ipairs(portalSpots) do
	local portal = block("Portal" .. i, Vector3.new(12, 12, 2), CFrame.new(p.pos),
		p.color, Enum.Material.Neon, portalFolder)
	portal.Transparency = 0.6
	portal.CanCollide = false
end

-- Checkpoints / Gates (expanded to 6)
local gatePositions = {
	Vector3.new(-108, 2, -68), Vector3.new(0, 2, -80),
	Vector3.new(108, 2, -68),  Vector3.new(108, 2, 68),
	Vector3.new(0, 2, 80),     Vector3.new(-108, 2, 68),
}
for i, pos in ipairs(gatePositions) do
	local g = block("Gate" .. i, Config.Race.GateSize, CFrame.new(pos),
		Color3.fromRGB(45, 226, 219), Enum.Material.Neon)
	g.Transparency = Config.Race.GateTransparency
	g.CanCollide = false
end

-- Main arena sign
local sign = block("Sign", Vector3.new(58, 9, 2), CFrame.new(0, 15, -100),
	Config.Brand.DarkBg, Enum.Material.Metal)
local surface = Instance.new("SurfaceGui"); surface.Face = Enum.NormalId.Front; surface.Parent = sign
local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.fromScale(1, 0.6); titleLbl.Position = UDim2.fromScale(0, 0.05)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = Config.Brand.Title
titleLbl.TextScaled = true; titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextColor3 = Config.Brand.PrimaryColor; titleLbl.Parent = surface
local subLbl = Instance.new("TextLabel")
subLbl.Size = UDim2.fromScale(1, 0.3); subLbl.Position = UDim2.fromScale(0, 0.65)
subLbl.BackgroundTransparency = 1
subLbl.Text = Config.Brand.Subtitle
subLbl.TextScaled = true; subLbl.Font = Enum.Font.Gotham
subLbl.TextColor3 = Color3.new(1, 1, 1); subLbl.Parent = surface

--------------------------------------------------------------------------------
-- CREATURE SPAWNER
--------------------------------------------------------------------------------
local activeCreatures = {}

local creatureSpawnZones = {
	track    = { center = Vector3.new(0, 2, 0),     radius = 100 },
	barriers = { center = Vector3.new(0, 3, 0),     radius = 130 },
	ramps    = { center = Vector3.new(0, 4, 0),     radius = 80 },
	infield  = { center = Vector3.new(0, 2, 0),     radius = 40 },
	racing   = { center = Vector3.new(0, 3, 0),     radius = 110 },
	sky      = { center = Vector3.new(0, 25, 0),    radius = 100 },
}

local function spawnCreature(speciesData)
	local zone = creatureSpawnZones[speciesData.habitat]
	if not zone then return end

	local rules = CreatureData.SpawnRules[speciesData.rarity]
	local count = 0
	for _, ac in pairs(activeCreatures) do
		if ac.speciesId == speciesData.id then count += 1 end
	end
	if count >= rules.maxActive then return end

	local angle = math.random() * math.pi * 2
	local dist = math.random() * zone.radius * 0.8
	local pos = zone.center + Vector3.new(math.cos(angle) * dist, 0, math.sin(angle) * dist)

	local creature = block("Creature_" .. speciesData.id .. "_" .. math.random(10000),
		speciesData.size, CFrame.new(pos), speciesData.color, Enum.Material.Neon, root)
	creature.Transparency = 0.3
	creature.CanCollide = false
	creature:SetAttribute("SpeciesId", speciesData.id)
	creature:SetAttribute("SpawnTime", os.clock())

	activeCreatures[creature] = {
		speciesId = speciesData.id,
		part = creature,
		spawnTime = os.clock(),
	}
end

-- Initial creature spawn
task.defer(function()
	for _, species in ipairs(CreatureData.Species) do
		local rules = CreatureData.SpawnRules[species.rarity]
		for _ = 1, rules.maxActive do
			spawnCreature(species)
		end
	end
end)

-- Respawn timer
task.spawn(function()
	while true do
		task.wait(30)
		for _, species in ipairs(CreatureData.Species) do
			spawnCreature(species)
		end
	end
end)

--------------------------------------------------------------------------------
-- PLAYER STATE & TRUCK SPAWNER
--------------------------------------------------------------------------------
local states = {}

local function buildTruck(player, startCF)
	local model = Instance.new("Model")
	model.Name = "XT_" .. player.UserId
	model.Parent = root

	-- Chassis
	local base = block("Chassis", TruckData.Chassis.size, startCF,
		Config.PaintColors.Blue, TruckData.Chassis.material, model)
	base.CanCollide = false
	model.PrimaryPart = base

	-- Seat
	local seat = Instance.new("VehicleSeat")
	seat.Name = "Drive"
	seat.Size = TruckData.Seat.size
	seat.CFrame = startCF * TruckData.Seat.offset
	seat.Anchored = true; seat.CanCollide = false
	seat.Parent = model

	-- Parts
	for name, def in pairs(TruckData.Parts) do
		local p = block(name, def.size, model:GetPivot() * def.offset, def.color,
			Enum.Material.SmoothPlastic, model)
		p.CanCollide = false
	end

	-- Wheels
	for _, wp in ipairs(TruckData.WheelPositions) do
		local w = block("Wheel", TruckData.Wheel.size,
			model:GetPivot() * CFrame.new(wp.x, TruckData.Wheel.yOffset, wp.z) * TruckData.Wheel.rotation,
			TruckData.Wheel.color, Enum.Material.SmoothPlastic, model)
		w.Shape = TruckData.Wheel.shape
		w.CanCollide = false
	end

	return model, seat
end

local function spawnPlayer(player)
	local index = (player.UserId % 8)
	local start = CFrame.new(-117 + index * Config.Truck.SpawnSpacing, Config.Truck.BaseHeight, 69) *
		CFrame.Angles(0, math.pi, 0)

	local model, seat = buildTruck(player, start)

	states[player] = {
		model      = model,
		seat       = seat,
		cf         = start,
		speed      = 0,
		gate       = 1,
		lastGate   = 0,
		paint      = "Blue",
		decal      = nil,
		accessories= {},
		laps       = 0,
		stars      = 0,
		lapStart   = os.clock(),
		bestLap    = math.huge,
		distance   = 0,
		airtime    = 0,
		driftDist  = 0,
		customizations = 0,
		ringsHit   = {},
		portalsHit = {},
		crushCount = 0,
		creaturesFound = {},
		challengeProgress = {},
		zonesVisited = {},
	}
end

Players.PlayerAdded:Connect(function(player)
	local stats = Instance.new("Folder"); stats.Name = "leaderstats"; stats.Parent = player
	local laps  = Instance.new("IntValue"); laps.Name = "Laps"; laps.Parent = stats
	local stars = Instance.new("IntValue"); stars.Name = "Stars"; stars.Parent = stats
	local best  = Instance.new("StringValue"); best.Name = "Best Lap"; best.Value = "--"; best.Parent = stats

	spawnPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
	local s = states[player]
	if s then s.model:Destroy() end
	states[player] = nil
end)

--------------------------------------------------------------------------------
-- CUSTOMIZATION HANDLERS
--------------------------------------------------------------------------------
CustomizeEvent.OnServerEvent:Connect(function(player, colorName)
	if typeof(colorName) ~= "string" or not Config.PaintColors[colorName] then return end
	local s = states[player]; if not s then return end
	s.paint = colorName
	s.customizations += 1
	local chassis = s.model:FindFirstChild("Chassis")
	if chassis then chassis.Color = Config.PaintColors[colorName] end
end)

DecalEvent.OnServerEvent:Connect(function(player, decalName)
	if typeof(decalName) ~= "string" then return end
	local valid = false
	for _, d in ipairs(Config.Decals) do
		if d == decalName then valid = true; break end
	end
	if not valid then return end
	local s = states[player]; if not s then return end
	s.decal = decalName
	s.customizations += 1
	-- Visual decal applied client-side via stripe color change
	local stripe = s.model:FindFirstChild("Stripe")
	if stripe then
		-- Simple visual: shift stripe color based on decal
		local hash = 0
		for ci = 1, #decalName do hash += string.byte(decalName, ci) end
		stripe.Color = Color3.fromHSV((hash % 360) / 360, 0.8, 0.9)
	end
end)

AccessoryEvent.OnServerEvent:Connect(function(player, accName)
	if typeof(accName) ~= "string" then return end
	local slot = TruckData.AccessorySlots[accName]
	if not slot then return end
	local s = states[player]; if not s then return end

	-- Toggle: add or remove
	local existing = s.model:FindFirstChild("Acc_" .. accName)
	if existing then
		existing:Destroy()
		s.accessories[accName] = nil
	else
		local part = block("Acc_" .. accName, slot.size,
			s.model:GetPivot() * slot.offset, slot.color, Enum.Material.SmoothPlastic, s.model)
		part.CanCollide = false
		s.accessories[accName] = true
		s.customizations += 1
	end
end)

--------------------------------------------------------------------------------
-- CHALLENGE TRACKING
--------------------------------------------------------------------------------
local function checkChallengeProgress(player, s, challengeId, currentValue)
	local chDef = ChallengeData.ByID[challengeId]
	if not chDef then return end

	if s.challengeProgress[challengeId] then return end -- already completed

	if currentValue >= chDef.target then
		s.challengeProgress[challengeId] = true
		s.stars += Config.Rewards.ChallengeStarReward
		if s.stars <= Config.Rewards.MaxStarsPerSession then
			player.leaderstats.Stars.Value = s.stars
		end
		ChallengeUpdateEvt:FireClient(player, challengeId, true)
		NotifyEvt:FireClient(player, "Challenge Complete: " .. chDef.name .. " ⭐+" .. Config.Rewards.ChallengeStarReward)
	end
end

--------------------------------------------------------------------------------
-- MAIN PHYSICS LOOP
--------------------------------------------------------------------------------
RunService.Heartbeat:Connect(function(dt)
	dt = math.min(dt, 0.05)

	for player, s in pairs(states) do
		if not s.model.Parent then continue end

		local occupant = s.seat.Occupant
		local driving = occupant and Players:GetPlayerFromCharacter(occupant.Parent) == player
		local throttle = driving and s.seat.ThrottleFloat or 0
		local steer    = driving and s.seat.SteerFloat or 0

		-- Physics
		local accel = Config.Truck.Acceleration
		local brake = Config.Truck.BrakeForce
		s.speed += (throttle * accel - s.speed) * math.min(1, dt * brake)

		local turnRate = Config.Truck.TurnRate
		local turnScale = math.clamp(math.abs(s.speed) / 15, 0.15, 1)
		local turn = steer * dt * turnRate * turnScale

		local newCf = s.cf * CFrame.Angles(0, turn, 0)
		local moveVec = newCf.LookVector * s.speed * dt
		local pos = newCf.Position + moveVec
		pos = Vector3.new(
			math.clamp(pos.X, -130, 130),
			Config.Truck.BaseHeight,
			math.clamp(pos.Z, -88, 88)
		)
		s.cf = CFrame.new(pos) * newCf.Rotation
		s.model:PivotTo(s.cf)

		-- Distance tracking
		s.distance += moveVec.Magnitude

		-- Drift tracking (turning while moving)
		if math.abs(steer) > 0.5 and math.abs(s.speed) > 10 then
			s.driftDist += moveVec.Magnitude
		end

		-- Zone tracking
		if math.abs(pos.X) < 60 and math.abs(pos.Z) < 30 then
			s.zonesVisited["infield"] = true
		elseif pos.Z < -50 then
			s.zonesVisited["north"] = true
		elseif pos.Z > 50 then
			s.zonesVisited["south"] = true
		else
			s.zonesVisited["track"] = true
		end

		-- Gate / checkpoint system
		if driving and os.clock() - s.lastGate > Config.Race.LapCooldown then
			local gatePos = gatePositions[s.gate]
			if gatePos and (pos - gatePos).Magnitude < Config.Race.GateProximity then
				s.lastGate = os.clock()
				s.gate += 1
				if s.gate > Config.Race.GateCount then
					s.gate = 1
					s.laps += 1
					local lapTime = os.clock() - s.lapStart
					s.lapStart = os.clock()

					if lapTime < s.bestLap then
						s.bestLap = lapTime
						player.leaderstats["Best Lap"].Value = string.format("%.1fs", lapTime)
					end

					player.leaderstats.Laps.Value = s.laps
					if s.stars < Config.Rewards.MaxStarsPerSession then
						s.stars += Config.Rewards.LapsPerStar
						player.leaderstats.Stars.Value = s.stars
					end

					-- Check lap-based challenges
					checkChallengeProgress(player, s, "hd_lap3", s.laps)
					checkChallengeProgress(player, s, "hd_lap10", s.laps)
					checkChallengeProgress(player, s, "ap_timed", lapTime <= 45 and 1 or 0)
				end
				-- Check gate challenge
				checkChallengeProgress(player, s, "ra_allgates", s.gate - 1)
			end
		end

		-- Ring collection
		for _, ring in ipairs(ringFolder:GetChildren()) do
			if not s.ringsHit[ring.Name] and (pos - ring.Position).Magnitude < 12 then
				s.ringsHit[ring.Name] = true
				ring.Transparency = 0.9
				task.delay(10, function() ring.Transparency = 0.5 end)
				local ringCount = 0
				for _ in pairs(s.ringsHit) do ringCount += 1 end
				checkChallengeProgress(player, s, "ap_rings", ringCount)
			end
		end

		-- Portal collection
		for _, portal in ipairs(portalFolder:GetChildren()) do
			if not s.portalsHit[portal.Name] and (pos - portal.Position).Magnitude < 15 then
				s.portalsHit[portal.Name] = true
				NotifyEvt:FireClient(player, "ThrillVerse Portal activated!")
				local portalCount = 0
				for _ in pairs(s.portalsHit) do portalCount += 1 end
				checkChallengeProgress(player, s, "tw_portals", portalCount)
			end
		end

		-- Crush targets
		for _, barrel in ipairs(crushFolder:GetChildren()) do
			if barrel.Parent and (pos - barrel.Position).Magnitude < 6 then
				s.crushCount += 1
				barrel:Destroy()
				checkChallengeProgress(player, s, "mt_crush", s.crushCount)
			end
		end

		-- Creature proximity detection
		for creaturePart, cData in pairs(activeCreatures) do
			if creaturePart.Parent and (pos - creaturePart.Position).Magnitude < 15 then
				if not s.creaturesFound[cData.speciesId] then
					s.creaturesFound[cData.speciesId] = true
					s.stars += Config.Rewards.CreatureDiscoverReward
					if s.stars <= Config.Rewards.MaxStarsPerSession then
						player.leaderstats.Stars.Value = s.stars
					end
					CreatureFoundEvt:FireClient(player, cData.speciesId)
					NotifyEvt:FireClient(player, "Creature discovered: " .. CreatureData.ByID[cData.speciesId].name .. "!")

					local foundCount = 0
					for _ in pairs(s.creaturesFound) do foundCount += 1 end
					checkChallengeProgress(player, s, "tc_find3", foundCount)
					checkChallengeProgress(player, s, "tc_allkinds", foundCount)
				end
			end
		end

		-- Customization challenges
		checkChallengeProgress(player, s, "dy_fullbuild", s.customizations)

		-- Distance challenges
		checkChallengeProgress(player, s, "mt_mudrun", s.distance)

		-- Drift challenges
		checkChallengeProgress(player, s, "es_drift", s.driftDist)

		-- Zone challenge
		local zoneCount = 0
		for _ in pairs(s.zonesVisited) do zoneCount += 1 end
		checkChallengeProgress(player, s, "ra_explore", zoneCount)

		-- Star accumulation challenge
		checkChallengeProgress(player, s, "tw_stars20", s.stars)

		-- Ultimate challenge: one from each book
		local booksComplete = 0
		for _, book in ipairs(ChallengeData.Books) do
			for _, ch in ipairs(book.challenges) do
				if s.challengeProgress[ch.id] then
					booksComplete += 1
					break
				end
			end
		end
		checkChallengeProgress(player, s, "tw_ultimate", booksComplete)
	end
end)

--------------------------------------------------------------------------------
print("Dirtstorm XT v1.0 loaded | ThrillFusion Group")
print("  Arena: 6 gates, 4 ramps, 10 rings, 4 portals, 8 crush targets")
print("  Creatures: 6 species across 4 rarity tiers")
print("  Challenges: 24 challenges across 8 drawing books")
print("  Customization: 8 paints, 8 decals, 8 accessories")
print("  Child-safe: free-to-play, no purchases, session-only stars")
