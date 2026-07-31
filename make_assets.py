"""
Generate icon.png (48x48) and banner.png (256x128) for the 3DS CIA/SMDH.

Sources (all from data/TITLE/):
  res51.png  - palace scene artwork
  res54.png  - "PRINCE OF PERSIA" logo

Run: python make_assets.py
Outputs: icon.png, banner.png  (in the repo root)
"""

from PIL import Image

DATA = "data/TITLE"
palace = Image.open(f"{DATA}/res51.png").convert("RGBA")
logo   = Image.open(f"{DATA}/res54.png").convert("RGBA")

# ---------------------------------------------------------------------------
# BANNER  256 x 128  — depth composite
#   Back:  transparent (home menu background shows through)
#   Mid:   palace scene + decorative border, inset so edges are transparent
#   Front: oversized logo bleeding beyond the frame edges
# ---------------------------------------------------------------------------
from PIL import ImageEnhance
bw, bh = 256, 128

border_raw = Image.open(f"{DATA}/res41.png").convert("RGBA")

# Make near-black pixels in the border transparent so the palace shows through
new_data = [
    (0, 0, 0, 0) if (p[0] < 18 and p[1] < 18 and p[2] < 18) else p
    for p in border_raw.getdata()
]
border_raw.putdata(new_data)

# --- Step 1: composite palace + border at native 320x200, as the game shows it ---
src_w, src_h = palace.size   # 320 x 200
scene = palace.copy()
scene.paste(border_scaled_native := border_raw.resize((src_w, src_h), Image.LANCZOS), (0, 0), border_raw.resize((src_w, src_h), Image.LANCZOS))

# --- Step 2: scale uniformly to fit banner height exactly (no distortion, no crop) ---
# scale = 128/200 = 0.64  →  320*0.64 = 205 wide, 200*0.64 = 128 tall
scale = bh / src_h
fw = int(src_w * scale)   # 205
fh = bh                   # 128
scene_scaled = scene.resize((fw, fh), Image.LANCZOS)
scene_scaled = ImageEnhance.Brightness(scene_scaled).enhance(0.82)

# Centre horizontally — transparent sides let the home menu show through
fx = (bw - fw) // 2   # ~25px each side
banner = Image.new("RGBA", (bw, bh), (0, 0, 0, 0))
banner.paste(scene_scaled, (fx, 0))

# --- Step 3: logo wider than the scene, bleeds over both sides ---
logo_target_w = int(bw * 0.97)   # 248 — wider than the 205px scene
logo_h = int(logo.height * (logo_target_w / logo.width))
logo_scaled = logo.resize((logo_target_w, logo_h), Image.LANCZOS)
lx = (bw - logo_target_w) // 2
ly = fh - logo_h - 4   # sits across the bottom edge of the scene
banner.paste(logo_scaled, (lx, ly), logo_scaled)

banner.save("banner.png")
print(f"banner.png saved  ({bw}x{bh})  frame={fw}x{fh} logo={logo_target_w}x{logo_h}")

# ---------------------------------------------------------------------------
# ICON  48 x 48  — prince sprite on a deep purple background
# ---------------------------------------------------------------------------
prince = Image.open("data/KID/res436.png").convert("RGBA").transpose(Image.FLIP_LEFT_RIGHT)

# Deep dungeon purple background
bg = Image.new("RGBA", (48, 48), (48, 20, 72, 255))

# Scale to fill most of the 48x48 box, constrained on both axes
pw2, ph2 = prince.size
max_dim = 42
scale2 = min(max_dim / pw2, max_dim / ph2)
target_w = max(1, int(pw2 * scale2))
target_h = max(1, int(ph2 * scale2))
prince_scaled = prince.resize((target_w, target_h), Image.NEAREST)

# Centre in the box
px = (48 - target_w) // 2
py = (48 - target_h) // 2
bg.paste(prince_scaled, (px, py), prince_scaled)
bg.save("icon.png")
print(f"icon.png saved    (48x48)  [prince sprite {pw2}x{ph2} -> {target_w}x{target_h}]")
