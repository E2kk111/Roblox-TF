--[[
  Dirtstorm XT™ — Game Configuration
  ThrillFusion Group™ | Born in Africa. Built for the World.
  All gameplay is FREE. No purchases, gambling, or pay-to-win.
]]

local GameConfig = {}

-- Arena dimensions
GameConfig.Arena = {
	Width       = 380,
	Depth       = 280,
	TrackWidth  = 270,
	TrackDepth  = 185,
	InfieldW    = 170,
	InfieldD    = 85,
	WallHeight  = 6,
}

-- Truck physics
GameConfig.Truck = {
	Acceleration  = 58,
	MaxSpeed      = 65,
	BrakeForce    = 2.8,
	TurnRate      = 1.5,
	DriftFactor   = 0.82,
	JumpForce     = 42,
	BaseHeight    = 3,
	SpawnSpacing  = 5,
}

-- Checkpoint / race system
GameConfig.Race = {
	GateCount        = 6,
	GateSize         = Vector3.new(16, 7, 16),
	GateTransparency = 0.78,
	LapCooldown      = 1.1,
	GateProximity    = 18,
	LapsPerStar      = 1,
}

-- Reward caps (child-safety: everything is free, stars are session-only)
GameConfig.Rewards = {
	MaxStarsPerSession    = 50,
	MaxLapsPerSession     = 100,
	ChallengeStarReward   = 2,
	CreatureDiscoverReward = 1,
}

-- Drawing-book challenge timer
GameConfig.Challenge = {
	RoundDuration     = 90,  -- seconds
	CooldownBetween   = 15,
	MaxActivePerArena = 1,
}

-- Colors available in the garage (all FREE)
GameConfig.PaintColors = {
	Blue   = Color3.fromRGB(25, 110, 245),
	Red    = Color3.fromRGB(220, 43, 48),
	Gold   = Color3.fromRGB(245, 179, 24),
	Green  = Color3.fromRGB(39, 176, 104),
	Purple = Color3.fromRGB(148, 55, 220),
	Orange = Color3.fromRGB(255, 128, 0),
	Black  = Color3.fromRGB(28, 28, 32),
	White  = Color3.fromRGB(240, 240, 245),
}

-- Decals (all FREE, cosmetic only, no advantage)
GameConfig.Decals = {
	"Flames", "Lightning", "Skull", "Stars",
	"Checkerboard", "ThrillVerse", "Mudslinger", "DirtDevil",
}

-- Accessories (all FREE, cosmetic only)
GameConfig.Accessories = {
	"RoofLight", "Spoiler", "Exhaust", "FlagPole",
	"BullBar", "MudFlaps", "RollCage", "Antennae",
}

-- Branding
GameConfig.Brand = {
	Title       = "DIRTSTORM XT",
	Subtitle    = "THRILLFUSION GROUP",
	PrimaryColor   = Color3.fromRGB(255, 194, 32),  -- gold
	SecondaryColor = Color3.fromRGB(220, 43, 48),    -- red
	DarkBg         = Color3.fromRGB(19, 19, 24),
	PanelBg        = Color3.fromRGB(20, 23, 31),
}

return GameConfig
