# Prince of Persia — Nintendo 3DS Port

A Nintendo 3DS homebrew port of [SDLPoP](https://github.com/NagyD/SDLPoP), the open-source Prince of Persia engine. Hardware-tested and working on 2DS and O3DS.

---

## Install

### CIA — Home Menu (recommended)

Scan with **FBI → Remote Install → Scan QR Code:**

<p align="center">
  <img src="assets/qr.png" width="220" alt="QR code — scan with FBI to install">
</p>

Or download `prince.cia` from the [latest release](../../releases/latest) and install manually via FBI.

### 3DSX — Homebrew Launcher

Download `prince.3dsx` from the [latest release](../../releases/latest) and copy to `/3ds/SDLPoP/prince.3dsx` on your SD card.

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

- **Startup lag:** Loading takes 10–20 seconds on O3DS / 2DS. Performance is smooth once in-game.
- **No music:** Disabled to prevent gameplay lag on O3DS. Sound effects work fully.
- **HOME button:** Pressing HOME mid-game doesn't suspend to the Home Menu. Use Y or Start to pause first.
- **Title screen:** Press **X** to start. If input feels slow, the game is still loading — wait a moment.

---

## Building from Source

Requires [devkitPro](https://devkitpro.org) with devkitARM and the following packages:

```
dkp-pacman -S devkitARM 3ds-sdl 3ds-sdl_image 3ds-sdl_mixer libctru citro3d
```

```bash
make        # builds prince.3dsx
make cia    # also builds prince.cia (requires bannertool and makerom in PATH)
```

All 3DS-specific changes are isolated behind `#ifdef __3DS__` — the upstream PC build is unaffected.

---

## Credits

- Original SDLPoP by [NagyD](https://github.com/NagyD/SDLPoP) and contributors — see [README-upstream.md](README-upstream.md)
- Nintendo 3DS port by [larm504](https://github.com/larm504)

## License

GPLv3 — same as the upstream SDLPoP project. See [LICENSE](LICENSE).
