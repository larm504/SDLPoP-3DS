# Prince of Persia - Nintendo 3DS Port

Nintendo 3DS homebrew port of [SDLPoP](https://github.com/NagyD/SDLPoP), the open-source Prince of Persia engine. Tested on real O3DS hardware.

---

## Install

### CIA (Home Menu) - recommended

Scan with **FBI -> Remote Install -> Scan QR Code:**

<p align="center">
  <img src="assets/qr.png" width="220" alt="QR code for FBI install">
</p>

Or download `prince.cia` from the [latest release](../../releases/latest) and install manually through FBI.

### 3DSX (Homebrew Launcher)

Download `prince.3dsx` from the [latest release](../../releases/latest) and copy it to `/3ds/SDLPoP/prince.3dsx` on your SD card.

Game data is bundled in the file, no extra files needed. Save files go to `sdmc:/SDLPoP/` automatically.

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

The bottom screen shows a controls reference and live game status (level, HP, time).

---

## Known Issues

- **Startup lag:** Takes 10-20 seconds to load on O3DS before the title screen appears. Runs fine once it's loaded.
- **No music:** Turned off to stop gameplay lag on O3DS. Sound effects work fine.
- **HOME button:** Pressing HOME mid-game won't suspend to the Home Menu. Pause with Y or Start first.
- **Title screen:** Press X to start. If it doesn't respond right away, the game is still loading, just wait a bit.
- **N3DS CIA:** Some N3DS users report the CIA installs but doesn't appear on the Home Menu. The 3DSX works fine on N3DS as a workaround while this gets sorted.

---

## Building

Requires [devkitPro](https://devkitpro.org) with devkitARM and these packages:

```
dkp-pacman -S devkitARM 3ds-sdl 3ds-sdl_image 3ds-sdl_mixer libctru citro3d
```

```bash
make        # builds prince.3dsx
make cia    # also builds prince.cia (requires bannertool and makerom in PATH)
```

All 3DS changes are behind `#ifdef __3DS__` so the upstream PC build still works fine.

---

## Credits

- Original SDLPoP by [NagyD](https://github.com/NagyD/SDLPoP) and contributors (see [README-upstream.md](README-upstream.md))
- 3DS port by [larm504](https://github.com/larm504)

## License

GPLv3, same as upstream SDLPoP. See [LICENSE](LICENSE).
