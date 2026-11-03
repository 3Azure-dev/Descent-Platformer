# DESCENT — Game Design Document (v2.0)

> The ceiling is the only enemy. Down is the only escape.

| Genre | Platform | Session | Rating |
|---|---|---|---|
| Hypercasual Endless | Mobile (Android / iOS) | 1–5 minutes | E for Everyone |

## 01 · Overview
DESCENT is a hypercasual endless mobile game. A square character stands on a platform rising toward a spike-lined ceiling. The player slides left or right to reposition, steps off the edge, and falls to the next procedurally generated platform below. Score grows with each successful landing. Die once — start over.

**The inversion:** most games punish falling. DESCENT requires it. Falling is survival. The threat is always above.

Three worlds. Each has three platform types and its own aesthetic and audio identity. One ability chosen before each run. Zero tutorials — the first few platforms do the teaching.

## 02 · Controls
| Input | Action |
|---|---|
| Slide finger left / right | Move character — works on ground and mid-air |
| Walk off platform edge | Begin falling — no jump button needed |
| Land on platform | Automatic on contact |

**Death:** touch a ceiling spike, land on a spike platform, or fall into the void (miss all platforms).

No tutorial screen. The first 6 platforms are always wide and standard. The game teaches itself through play.

## 03 · Worlds & Platforms
Each world has three platform types. The default is the safe baseline — appears most often, no risk. The other two are special and increase in frequency with difficulty. Lethal platforms never exceed 15% of spawns at any difficulty.

### World 01 — The Ruins (unlocked by default)
Ancient stone temple. Warm amber, deep shadow, stalactite ceiling spikes.

| Platform | Role | Behavior |
|---|---|---|
| Stone Slab | Default | Safe, static, standard width. |
| Conveyor | Special | Auto-slides the player left or right at a fixed speed on landing. Direction shown by carved arrow runes. Player must counter-slide or use the momentum. |
| Spiked | Lethal | Spikes on top. Instant death on contact. Always high-contrast red — readable at any speed, in any world. |

### World 02 — The Forge (unlock at score 50)
Underground foundry. Dark steel, hot orange glow, hydraulic piston ceiling spikes with a 0.5s visible charge-up before extending.

| Platform | Role | Behavior |
|---|---|---|
| Metal Grating | Default | Safe, static. |
| Bomb | Timed | Safe to land on. A visible fuse countdown (~1.5s) starts on contact. Player must move off before it explodes — standing on it during the explosion is instant death. Audio tick + fuse animation. |
| Bounce | Risk / Reward | Launches the player upward on landing, adding hang time. Near the ceiling, a bounce can kill. Score bonus for surviving one close to the spikes. |

### World 03 — The Void (unlock at score 150)
Digital corruption. Pure black, neon cyan and magenta geometry, glitch-column ceiling spikes on a visible 2s flicker cycle.

| Platform | Role | Behavior |
|---|---|---|
| Data Shard | Default | Tilts toward the side the player stands on if they stay there ~1s. Leans and creaks before tipping — a clear grace window. A tilt arrow on the surface signals this. |
| Narrow | Precision | Much thinner than standard. Needs an accurate mid-air approach. +3 score on a clean landing. |
| Speed | Pressure | Rises noticeably faster than the ceiling the moment the player lands. Forces an immediate exit decision. |

## 04 · Abilities
Before each run the player picks one ability. Using it costs score points, deducted immediately. One choice, one tool per run.

| Ability | Cost | Effect |
|---|---|---|
| Emergency Platform | 5 | While falling, instantly spawns a standard platform below the player. Reactive — a panic button for missed landings. |
| Dead Stop | 4 | On landing, kills all bounce momentum. Player lands flat with zero recoil. Counters Bounce platforms and edge landings. |
| Guide Ramp | 6 | Attaches a 45° ramp to one side of the next platform, funneling an off-center approach onto it. Proactive — used before a difficult drop. |

**Balance note:** Emergency Platform and Guide Ramp both solve the same fear — missing a platform. The difference is timing: Emergency is reactive (mid-fall), Guide Ramp is proactive (planned ahead). The ability select screen copy should make this a playstyle choice, not just "pick the cheaper one".

## 05 · Difficulty Curve
Three variables scale continuously: platform speed, platform width, and special platform spawn rate. No hard phases — pressure builds in steps the player feels but can't consciously measure.

| Score | Speed | Width | Special % |
|---|---|---|---|
| 0–15 | Slow | Wide | 0% |
| 16–50 | Moderate | Standard | 10% |
| 51–100 | Fast | Standard–Narrow | 25% |
| 101–150 | Very fast | Narrow | 40% |
| 150+ | Extreme | Narrow / Mixed | 55% |

## 06 · Scoring
| Action | Score |
|---|---|
| Land on default platform | +1 |
| Land on Narrow platform (Void) | +3 |
| Escape Bomb before explosion | +2 |
| Survive Bounce near ceiling | +2 |
| Near-miss with ceiling spike | +1 |
| 5-platform clean streak | ×1.5 multiplier |
| 10-platform clean streak | ×2.0 multiplier |

The streak multiplier resets on a Conveyor landing or ability use — passive survival shouldn't multiply the same as active precision play.

## 07 · Audio
Five tracks. Music changes act as a passive danger warning — no HUD meter needed.

| # | Track | Style | When |
|---|---|---|---|
| 01 | Rising Stone | Tribal percussion, low strings. Slow and atmospheric. | World 01 |
| 02 | Iron Rain | Industrial rhythm, heavy bass pulses. | World 02 |
| 03 | Signal Lost | High-BPM synthwave. Mastery music. | World 03 |
| 04 | The Chase | Faster, stripped remix of the current world track. | Score 120+ |
| 05 | Last Breath | Tense, distorted. Most players hear it for a few seconds before dying. | Ceiling critical |

## 08 · UI / UX
| Screen | Contents |
|---|---|
| Main Menu | Title · Play · Map select (locked maps greyed) · Personal best. Live gameplay loop in the background. |
| Ability Select | Three cards. Tap one. No stat breakdowns — the description is enough. |
| In-Game HUD | Score top-center. Pause icon top-right. Nothing else. |
| Death Screen | "COLLAPSE" · Final score · Personal best · Retry / Menu. 0.5s character shatter on death, then cut immediately. |

**Retry speed is a mechanic.** Death to back-in-game in 2 taps, under 1 second. Every extra second on the death screen is a second the player might put their phone down.
