--[[
  Dirtstorm XT™ — Truck Part Definitions
  Every truck part is defined here for consistent server/client rendering.
  All parts are FREE cosmetic customizations.
]]

local TruckData = {}

-- Base chassis blueprint
TruckData.Chassis = {
	size     = Vector3.new(8, 2, 13),
	material = Enum.Material.Metal,
}

-- Part offsets relative to chassis pivot
TruckData.Parts = {
	Cab = {
		size   = Vector3.new(7, 3, 5),
		offset = CFrame.new(0, 2, 2),
		color  = Color3.fromRGB(18, 28, 44),
	},
	Stripe = {
		size   = Vector3.new(6, 0.12, 3),
		offset = CFrame.new(0, 1.06, -3),
		color  = Color3.fromRGB(245, 179, 24),
	},
	Bed = {
		size   = Vector3.new(7, 1.5, 5),
		offset = CFrame.new(0, 1.5, -4),
		color  = Color3.fromRGB(30, 35, 48),
	},
	Bumper = {
		size   = Vector3.new(8.2, 1, 1),
		offset = CFrame.new(0, 0.5, 6.5),
		color  = Color3.fromRGB(80, 80, 85),
	},
}

-- Wheel positions (symmetric)
TruckData.WheelPositions = {
	{ x = -4.5, z = -4 },
	{ x =  4.5, z = -4 },
	{ x = -4.5, z =  4 },
	{ x =  4.5, z =  4 },
}

TruckData.Wheel = {
	size     = Vector3.new(4, 2, 4),
	yOffset  = -0.35,
	color    = Color3.fromRGB(21, 22, 26),
	shape    = Enum.PartType.Cylinder,
	rotation = CFrame.Angles(0, 0, math.pi / 2),
}

-- Seat
TruckData.Seat = {
	size   = Vector3.new(4, 1, 4),
	offset = CFrame.new(0, 1.6, 0),
}

-- Accessory attachment points
TruckData.AccessorySlots = {
	RoofLight = { offset = CFrame.new(0, 4, 2),    size = Vector3.new(5, 0.6, 1.2), color = Color3.fromRGB(255, 255, 200) },
	Spoiler   = { offset = CFrame.new(0, 3.5, -5),  size = Vector3.new(6, 0.3, 2),   color = Color3.fromRGB(220, 43, 48) },
	Exhaust   = { offset = CFrame.new(-3.5, 2, -5), size = Vector3.new(1, 3, 1),      color = Color3.fromRGB(60, 60, 65) },
	FlagPole  = { offset = CFrame.new(3.5, 2, -5),  size = Vector3.new(0.3, 5, 0.3),  color = Color3.fromRGB(180, 180, 180) },
	BullBar   = { offset = CFrame.new(0, 1, 7),     size = Vector3.new(7, 2.5, 0.8),  color = Color3.fromRGB(100, 100, 105) },
	MudFlaps  = { offset = CFrame.new(0, 0, -5.5),  size = Vector3.new(7, 1.5, 0.2),  color = Color3.fromRGB(30, 30, 35) },
	RollCage  = { offset = CFrame.new(0, 3, 1),     size = Vector3.new(7.5, 0.4, 6),  color = Color3.fromRGB(180, 180, 185) },
	Antennae  = { offset = CFrame.new(2, 4.5, 2),   size = Vector3.new(0.2, 3, 0.2),  color = Color3.fromRGB(200, 200, 205) },
}

return TruckData
