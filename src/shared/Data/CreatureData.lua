--[[
  Dirtstorm XT™ — ThrillVerse Creature Definitions
  Creatures are hidden around the arena for discovery gameplay.
  All creatures are free to discover. No purchase or trading.
]]

local CreatureData = {}

CreatureData.Species = {
	{
		id      = "mudcrawler",
		name    = "Mudcrawler",
		desc    = "A dirt-loving critter that burrows under the track.",
		icon    = "🐛",
		color   = Color3.fromRGB(124, 81, 48),
		size    = Vector3.new(3, 2, 5),
		rarity  = "common",
		habitat = "track",
		idle    = "burrow",   -- animation style
	},
	{
		id      = "sparkfin",
		name    = "Sparkfin",
		desc    = "An electric creature that leaps over barriers.",
		icon    = "⚡",
		color   = Color3.fromRGB(45, 226, 219),
		size    = Vector3.new(2, 3, 4),
		rarity  = "common",
		habitat = "barriers",
		idle    = "hop",
	},
	{
		id      = "boulderback",
		name    = "Boulderback",
		desc    = "A gentle giant that sleeps near ramps.",
		icon    = "🪨",
		color   = Color3.fromRGB(100, 100, 110),
		size    = Vector3.new(5, 4, 6),
		rarity  = "uncommon",
		habitat = "ramps",
		idle    = "snore",
	},
	{
		id      = "dustwhirl",
		name    = "Dustwhirl",
		desc    = "A tiny tornado creature that spins across the infield.",
		icon    = "🌪️",
		color   = Color3.fromRGB(210, 190, 160),
		size    = Vector3.new(3, 5, 3),
		rarity  = "uncommon",
		habitat = "infield",
		idle    = "spin",
	},
	{
		id      = "thrillmaw",
		name    = "Thrillmaw",
		desc    = "A rare creature that only appears during active races.",
		icon    = "🐲",
		color   = Color3.fromRGB(220, 43, 48),
		size    = Vector3.new(4, 4, 7),
		rarity  = "rare",
		habitat = "racing",
		idle    = "prowl",
	},
	{
		id      = "goldwing",
		name    = "Goldwing",
		desc    = "A legendary winged creature drawn to star earners.",
		icon    = "✨",
		color   = Color3.fromRGB(245, 179, 24),
		size    = Vector3.new(6, 5, 4),
		rarity  = "legendary",
		habitat = "sky",
		idle    = "glide",
	},
}

CreatureData.ByID = {}
for _, c in ipairs(CreatureData.Species) do
	CreatureData.ByID[c.id] = c
end

CreatureData.SpawnRules = {
	common    = { maxActive = 3, respawnTime = 30 },
	uncommon  = { maxActive = 2, respawnTime = 60 },
	rare      = { maxActive = 1, respawnTime = 120 },
	legendary = { maxActive = 1, respawnTime = 300 },
}

return CreatureData
