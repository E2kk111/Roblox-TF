--[[
  Dirtstorm XT™ — Drawing-Book Challenge Definitions
  Each challenge corresponds to one of the 8 books in the collection.
  All challenges are FREE gameplay — no book purchase required.
]]

local ChallengeData = {}

ChallengeData.Books = {
	{
		id       = "monster_trucks",
		bookNum  = 1,
		title    = "Monster Trucks",
		desc     = "Master the biggest machines on dirt!",
		icon     = "🚛",
		challenges = {
			{ id = "mt_bigair",    name = "Big Air Jump",         type = "jump",     target = 3,  desc = "Hit 3 ramps and catch air" },
			{ id = "mt_mudrun",    name = "Mud Run",              type = "distance", target = 500, desc = "Drive 500 studs through mud" },
			{ id = "mt_crush",     name = "Crush Zone",           type = "collect",  target = 8,  desc = "Drive over 8 crush targets" },
		},
	},
	{
		id       = "extreme_stunts",
		bookNum  = 2,
		title    = "Extreme Stunts",
		desc     = "Pull off jaw-dropping tricks!",
		icon     = "🏁",
		challenges = {
			{ id = "es_barrel",    name = "Barrel Roll Alley",    type = "stunt",    target = 2,  desc = "Complete 2 barrel roll ramps" },
			{ id = "es_drift",     name = "Drift King",           type = "drift",    target = 150, desc = "Drift for 150 studs" },
			{ id = "es_hangtime",  name = "Hang Time",            type = "airtime",  target = 5,  desc = "Stay airborne for 5 seconds total" },
		},
	},
	{
		id       = "thrillverse_creatures",
		bookNum  = 3,
		title    = "ThrillVerse Creatures",
		desc     = "Discover creatures hidden around the arena!",
		icon     = "🦎",
		challenges = {
			{ id = "tc_find3",     name = "Creature Scout",       type = "discover", target = 3,  desc = "Find 3 hidden creatures" },
			{ id = "tc_photograph",name = "Creature Snap",        type = "proximity",target = 5,  desc = "Drive close to 5 creatures" },
			{ id = "tc_allkinds",  name = "Full Codex",           type = "discover", target = 6,  desc = "Discover all 6 creature types" },
		},
	},
	{
		id       = "design_your_truck",
		bookNum  = 4,
		title    = "Design Your XT Truck",
		desc     = "Make your truck YOUR creation!",
		icon     = "🎨",
		challenges = {
			{ id = "dy_paint",     name = "Fresh Paint",          type = "customize",target = 3,  desc = "Try 3 different paint colors" },
			{ id = "dy_decal",     name = "Sticker Bomb",         type = "customize",target = 2,  desc = "Apply 2 different decals" },
			{ id = "dy_fullbuild", name = "Full Build",           type = "customize",target = 5,  desc = "Change 5 total customizations" },
		},
	},
	{
		id       = "heroes_drivers",
		bookNum  = 5,
		title    = "Heroes & Drivers",
		desc     = "Prove you're a champion driver!",
		icon     = "🏆",
		challenges = {
			{ id = "hd_lap3",      name = "Triple Threat",       type = "laps",     target = 3,  desc = "Complete 3 laps" },
			{ id = "hd_lap10",     name = "Iron Driver",         type = "laps",     target = 10, desc = "Complete 10 laps" },
			{ id = "hd_fastest",   name = "Speed Demon",         type = "fastlap",  target = 1,  desc = "Set the fastest lap in the server" },
		},
	},
	{
		id       = "racing_arenas",
		bookNum  = 6,
		title    = "Racing & Arenas",
		desc     = "Conquer the arena and all its obstacles!",
		icon     = "🏟️",
		challenges = {
			{ id = "ra_allgates",  name = "Gate Master",         type = "gates",    target = 6,  desc = "Pass through all 6 gates in order" },
			{ id = "ra_noramp",    name = "Clean Racer",         type = "laps_no_ramp", target = 1, desc = "Complete a lap without hitting any ramps" },
			{ id = "ra_explore",   name = "Arena Explorer",      type = "zones",    target = 4,  desc = "Visit all 4 arena zones" },
		},
	},
	{
		id       = "activities_puzzles",
		bookNum  = 7,
		title    = "Activities & Puzzles",
		desc     = "Solve driving puzzles on the track!",
		icon     = "🧩",
		challenges = {
			{ id = "ap_rings",     name = "Ring Runner",         type = "collect",  target = 10, desc = "Drive through 10 floating rings" },
			{ id = "ap_maze",      name = "Maze Runner",         type = "complete", target = 1,  desc = "Navigate the obstacle maze" },
			{ id = "ap_timed",     name = "Beat the Clock",      type = "timed",    target = 45, desc = "Finish a lap in under 45 seconds" },
		},
	},
	{
		id       = "thrillverse_worlds",
		bookNum  = 8,
		title    = "ThrillVerse Worlds",
		desc     = "Unlock the secrets of the ThrillVerse!",
		icon     = "🌍",
		challenges = {
			{ id = "tw_portals",   name = "Portal Jumper",       type = "collect",  target = 4,  desc = "Drive through 4 ThrillVerse portals" },
			{ id = "tw_stars20",   name = "Star Collector",      type = "stars",    target = 20, desc = "Earn 20 stars total" },
			{ id = "tw_ultimate",  name = "ThrillVerse Champion",type = "complete", target = 8,  desc = "Complete a challenge from each book" },
		},
	},
}

-- Flatten for quick lookup
ChallengeData.ByID = {}
for _, book in ipairs(ChallengeData.Books) do
	for _, ch in ipairs(book.challenges) do
		ch.bookId = book.id
		ch.bookNum = book.bookNum
		ChallengeData.ByID[ch.id] = ch
	end
end

return ChallengeData
