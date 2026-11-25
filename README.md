# DIRTSTORM XT™ — Design Your XT Truck & Race

**ThrillFusion Group™ — Born in Africa. Built for the World.**

> 8 drawing books × 24 challenges × 6 ThrillVerse creatures — all FREE.

## What is this?

Dirtstorm XT™ is a **free-to-play** Roblox arcade racing experience tied to an 8-book children's drawing collection. Players customize monster trucks, race through arena gates, discover ThrillVerse creatures, and complete drawing-book challenges — all without any purchases, gambling, or pay-to-win mechanics.

## v1.0 Features

### Arena
- Dirt oval track with barriers, infield grass, and arena signage
- **4 ramps** for jumps and stunts
- **6 sequential checkpoint gates** for lap racing
- **10 floating rings** for collection challenges
- **4 ThrillVerse portals** to discover
- **8 crush targets** (barrels) for destruction challenges

### Truck Customization (all FREE)
- **8 paint colors**: Blue, Red, Gold, Green, Purple, Orange, Black, White
- **8 decals**: Flames, Lightning, Skull, Stars, Checkerboard, ThrillVerse, Mudslinger, DirtDevil
- **8 accessories**: RoofLight, Spoiler, Exhaust, FlagPole, BullBar, MudFlaps, RollCage, Antennae

### Drawing-Book Challenges (24 total)
Each challenge corresponds to one of the 8 books. No book purchase required.

| Book | Title | Challenges |
|------|-------|------------|
| 1 | Monster Trucks | Big Air Jump, Mud Run, Crush Zone |
| 2 | Extreme Stunts | Barrel Roll Alley, Drift King, Hang Time |
| 3 | ThrillVerse Creatures | Creature Scout, Creature Snap, Full Codex |
| 4 | Design Your XT Truck | Fresh Paint, Sticker Bomb, Full Build |
| 5 | Heroes & Drivers | Triple Threat, Iron Driver, Speed Demon |
| 6 | Racing & Arenas | Gate Master, Clean Racer, Arena Explorer |
| 7 | Activities & Puzzles | Ring Runner, Maze Runner, Beat the Clock |
| 8 | ThrillVerse Worlds | Portal Jumper, Star Collector, ThrillVerse Champion |

### ThrillVerse Creatures (6 species)
| Creature | Rarity | Habitat |
|----------|--------|---------|
| Mudcrawler 🐛 | Common | Track |
| Sparkfin ⚡ | Common | Barriers |
| Boulderback 🪨 | Uncommon | Ramps |
| Dustwhirl 🌪️ | Uncommon | Infield |
| Thrillmaw 🐲 | Rare | Active races |
| Goldwing ✨ | Legendary | Sky |

### Multiplayer
- Per-player truck spawning and customization
- Shared arena with independent lap tracking
- Leaderboard: Laps, Stars, Best Lap time

## Project Structure (Rojo)

```
DirtstormXT/
├── default.project.json          ← Rojo project file
├── src/
│   ├── server/
│   │   └── DirtstormServer.server.lua    ← Arena builder, physics, challenges, creatures
│   ├── client/
│   │   └── DirtstormGarage.client.lua    ← Full UI: garage, challenges, codex, HUD
│   └── shared/
│       ├── GameConfig.lua                ← All tuning constants
│       └── Data/
│           ├── init.lua                  ← Barrel module
│           ├── ChallengeData.lua         ← 24 challenge definitions (8 books × 3)
│           ├── CreatureData.lua          ← 6 creature species + spawn rules
│           └── TruckData.lua             ← Truck parts, wheels, accessories
└── README.md
```

## Setup

### With Rojo (recommended)
1. Install [Rojo](https://rojo.space) and the Roblox Studio plugin.
2. Run `rojo serve` in this directory.
3. Connect from Roblox Studio.
4. Press Play.

### Manual (no Rojo)
1. Create a new **Baseplate** experience in Roblox Studio.
2. Under **ReplicatedStorage**, create a Folder named `Shared` and add all files from `src/shared/` as ModuleScripts (preserving folder structure for `Data/`).
3. Under **ServerScriptService**, insert a Script and paste `src/server/DirtstormServer.server.lua`.
4. Under **StarterPlayer > StarterPlayerScripts**, insert a LocalScript and paste `src/client/DirtstormGarage.client.lua`.
5. Press Play.

## Child Safety

- **All gameplay is FREE** — no in-app purchases, no premium currency, no loot boxes
- **No pay-to-win** — cosmetic customizations only, no competitive advantage
- **No data collection** — stars are session-only, no persistent player data stored
- **No external links** — no URLs, no social media, no ads
- **No trading** — items cannot be exchanged between players
- **No gambling mechanics** — all rewards are earned through play
- **No chat-driven interactions** — standard Roblox chat filters apply
- **Age-appropriate content** — monster trucks, creatures, and racing only

## Important Limitations

This is a **prototype** for Roblox Studio testing. Before publishing:

- [ ] Validate truck physics and seated movement in Studio
- [ ] Test mobile controls and UI scaling
- [ ] Test multiplayer spawning with 2+ players
- [ ] Complete Roblox moderation and policy review
- [ ] Accessibility testing (color contrast, control alternatives)
- [ ] Performance profiling for target device specs
- [ ] The truck uses simplified scripted movement — not production VehicleSeat physics
- [ ] Stars are session-only and not saved between sessions

## License

Original concept by ThrillFusion Group™. Not affiliated with Roblox Corporation.

---

*DIRTSTORM XT™ is a trademark of ThrillFusion Group™, a division of Kadaba Enterprise LLC.*
*XVERSE™, ThrillVerse™ are trademarks of ThrillFusion Group™.*
