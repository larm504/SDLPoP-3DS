# Prince of Persia — Nintendo 3DS Port

A Nintendo 3DS homebrew port of [SDLPoP](https://github.com/NagyD/SDLPoP), the open-source Prince of Persia engine. Hardware-tested and working on 2DS and O3DS.

---

## Download & Install

### CIA (recommended — installs to Home Menu)

> **QR code install coming soon.**

1. Download `prince.cia` from the [latest release](../../releases/latest).
2. Copy it to your SD card.
3. Open **FBI** → SD → select `prince.cia` → Install.
4. Launch **Prince of Persia** from the Home Menu.

### 3DSX (Homebrew Launcher)

1. Download `prince.3dsx` from the [latest release](../../releases/latest).
2. Copy it to `/3ds/SDLPoP/prince.3dsx` on your SD card.
3. Launch via the Homebrew Launcher.

No separate data files needed — game data is bundled inside both files.

Save files are written to `sdmc:/SDLPoP/` automatically.

---

## Controls

| 3DS Button | Action |
|---|---|
| D-pad | Move / climb |
| A or R | Action (careful step / grab ledge) |
| B or Up | Jump |
| X | Confirm |
| Y or Start | Pause |
| Select | Back / cancel |
| L | Show time remaining |

The bottom screen shows a live controls reference and game status (level, HP, time).

---

## Known Limitations

- **Startup lag:** Loading takes 10–20 seconds on O3DS / 2DS before the title screen appears. This is normal — the game data is large and the hardware is slow at decompressing it. Performance is smooth once the game starts.
- **No music:** Background music is disabled to prevent gameplay lag on O3DS hardware. Sound effects work fully.
- **HOME button:** Pressing HOME mid-game does not suspend to the Home Menu (a limitation of the SDL event loop). Use **Y or Start to pause first**, then power off or go home from there.
- **Title screen:** Press **X** to start a new game from the title screen. If the input feels unresponsive, the game is still loading — wait a moment and try again.

---

## Building from Source

Requires [devkitPro](https://devkitpro.org) with devkitARM and the following 3DS packages:

```
dkp-pacman -S devkitARM 3ds-sdl 3ds-sdl_image 3ds-sdl_mixer libctru citro3d
```

Clone the repo, then from the devkitPro MSYS2 shell:

```bash
make        # builds prince.3dsx + prince.elf
make cia    # also builds prince.cia (requires bannertool and makerom in PATH)
```

All 3DS-specific changes are isolated behind `#ifdef __3DS__` so the upstream PC build is unaffected.

---

## Credits

- Original SDLPoP by [NagyD](https://github.com/NagyD/SDLPoP) and contributors — see [README-upstream.md](README-upstream.md)
- Nintendo 3DS port by [larm504](https://github.com/larm504)

## License

GPLv3 — same as the upstream SDLPoP project. See [LICENSE](LICENSE).
