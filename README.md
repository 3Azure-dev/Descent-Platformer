# DESCENT (Godot 4)

> The ceiling is the only enemy. Down is the only escape.

A hypercasual endless mobile game for Android, made in Godot 4.6.
You stand on a platform rising toward a spiked ceiling. Slide, step off the edge,
and fall to the next platform. Falling is survival.

📄 **[Read the Game Design Document](GDD.md)**

## Features
- 3 worlds, each with 3 platform types:
  - **The Ruins** — Stone Slab, Conveyor, Spiked
  - **The Forge** — Metal Grating, Bomb (timed fuse), Bounce
  - **The Void** — Data Shard (tilts), Narrow, Speed
- Procedural platform spawning
- 3 abilities, chosen before a run, paid for with score:
  Emergency Platform, Dead Stop, Guide Ramp
- Scoring with clean-streak multipliers (×1.5 at 5, ×2 at 10)
- World select, personal best, options (volume, touch sensitivity), pause menu
- Settings and high score saved between sessions
- Android build

## Built with
Godot 4.6, GDScript

## Controls
- **Mobile:** slide finger left / right · walk off the edge to fall · double-tap for ability
- **PC:** drag the mouse to move · click the ability button

## Screenshots
(coming soon)

## Credits
Made with my friend Bhargav. His original game was from a tutorial;
I rebuilt it in Godot from scratch, wrote the GDD, and designed and coded the new features.
Current art is placeholder — final 2D art is in progress.
