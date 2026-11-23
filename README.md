# DIRTSTORM XT™ — Design Your XT Truck & Race

**ThrillFusion Group™ — Born in Africa. Built for the World.**

## v0.2 Roblox Studio setup
1. Create a new **Baseplate** experience in Roblox Studio.
2. Under **ServerScriptService**, insert a **Script** and paste `src/server/DirtstormServer.server.lua`.
3. Under **StarterPlayer > StarterPlayerScripts**, insert a **LocalScript** and paste `src/client/DirtstormGarage.client.lua`.
4. Press **Play**. Select a color in the garage panel, sit in your own XT truck, and drive with Roblox vehicle controls.
5. Cross four glowing checkpoints in sequence. One lap awards one free star.
6. Use Studio's **Test > Start** with multiple players to check multiplayer behavior.

## Implemented in source (not yet verified in Studio)
- Arena generated at server startup
- Per-player arcade truck models and vehicle seats
- Server-validated paint colors: blue, red, gold, green
- Four sequential checkpoints, lap count, free stars
- Client garage UI and basic leaderboard

## Child safety and book integration
All core play and garage colors are free. No book purchase, redemption code, external link, trading, gambling mechanic, or real-money purchase is required. Drawing books can optionally include creative prompts that correspond to the free garage and racing activities.

## Important limitations
This is a **prototype**, not a published or tested Roblox experience. Studio testing is required to validate seated movement, checkpoint geometry, collision behavior, multiplayer spawning, and mobile controls. Stars exist only for the current server session and are not saved. The current truck uses simple scripted movement rather than production vehicle physics. Do not market it as certified child-safe or production-ready until moderation, accessibility, platform policy, and age-suitability review are completed.

## Next QA checklist
- [ ] Server and client scripts load without errors in Studio Output
- [ ] Player can sit and drive their truck on desktop
- [ ] Garage colors update the correct player's truck
- [ ] Checkpoints count in the intended order
- [ ] A completed lap awards exactly one star
- [ ] Two players can race independently
- [ ] Mobile UI and controls tested
- [ ] Respawn/reset handling tested
- [ ] Child safety and Roblox policy review completed

Original concept; not affiliated with Roblox Corporation.
