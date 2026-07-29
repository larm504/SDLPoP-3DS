# SDLPoP — Nintendo 3DS Port

A Nintendo 3DS homebrew port of [SDLPoP](https://github.com/NagyD/SDLPoP), the open-source Prince of Persia engine. Runs natively as a `.3dsx` using devkitPro and the SDL 1.2 portlibs.

All 3DS-specific changes are guarded with `#ifdef __3DS__` / `#ifndef __3DS__`, so the upstream PC/SDL2 build is fully unaffected.

## Status

| Area | Status |
|---|---|
| Graphics | Working (16-bit top screen, 320×200) |
| Sprite transparency | Fixed (SDL_SetColorKey wrapper) |
| Input | Implemented via libctru HID |
| Audio | SDL_OpenAudio + software MIDI renderer |
| Saves / high scores | Written to `sdmc:/SDLPoP/` |
| Lighting effects | Disabled (SDL2-only API) |
| Screenshots | Disabled (SDL2-only API) |

> Untested on real hardware — no 3DS available yet. Builds clean with zero errors.

## Requirements

- [devkitPro](https://devkitpro.org) with the following packages installed:
  - `devkitARM`
  - `3ds-sdl`
  - `3ds-sdl_image`
  - `3ds-sdl_mixer`
  - `libctru`
  - `citro3d`

Install via pacman:
```
pacman -S devkitARM 3ds-sdl 3ds-sdl_image 3ds-sdl_mixer libctru citro3d
```

## Building

From the devkitPro MSYS2 shell (Windows):
```
/c/devkitPro/msys2/usr/bin/bash -lc "cd '/c/Users/makam/SDLPoP' && make"
```

Or from within the devkitPro MSYS2 environment directly:
```
cd /path/to/SDLPoP-3DS
make
```

Output: `prince.3dsx` and `prince.elf` in the project root.

## Installing

1. Copy `prince.3dsx` and `prince.smdh` to your 3DS SD card at `/3ds/SDLPoP/`.
2. Launch via the Homebrew Launcher.

The game data is embedded in the `.3dsx` via romfs — no separate data files needed on the SD card.

Save files and logs are written to `sdmc:/SDLPoP/` automatically.

## Button Mapping

| 3DS Button | Action |
|---|---|
| D-pad / Circle Pad | Move / climb |
| A or R | Action (careful step, grab) |
| B | Also action |
| X | Confirm (menu) |
| Y or Select | Back / cancel (menu) |
| Start | Pause |
| L | Show time remaining |

## Debugging

On crash or unexpected behavior, check the log files written to the SD card:
- `sdmc:/SDLPoP/stdout.txt`
- `sdmc:/SDLPoP/stderr.txt`

## Credits

- Original SDLPoP by [NagyD](https://github.com/NagyD/SDLPoP) and contributors — see [README-upstream.md](README-upstream.md) for the full list
- 3DS port by [larsssmoatsss](https://github.com/larsssmoatsss)

## License

GPLv3 — same as the upstream SDLPoP project. See [LICENSE](LICENSE).
