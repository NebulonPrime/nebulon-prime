#!/usr/bin/env python3
"""Generate the default Nebulon Prime wallpaper as an SVG (deterministic, so rebuilds match).

Usage: python3 make-wallpaper.py > wallpaper.svg
"""

import random

W, H = 3840, 2160
rng = random.Random(4207)

# Soft nebula clouds: (cx, cy, rx, ry, colour, opacity)
clouds = [
    (2650, 900, 1500, 780, "#5b21b6", 0.85),
    (3100, 1250, 900, 520, "#db2777", 0.45),
    (2200, 1300, 1100, 420, "#0891b2", 0.50),
    (2850, 760, 520, 300, "#c084fc", 0.55),
    (1150, 1700, 1300, 520, "#1e1b4b", 0.90),
    (600, 400, 900, 500, "#312e81", 0.55),
    (2500, 1050, 260, 150, "#f0abfc", 0.40),
]

out = [
    f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
    "<defs>",
    '<radialGradient id="bg" cx="0.62" cy="0.42" r="0.9">'
    '<stop offset="0" stop-color="#1a1240"/><stop offset="0.6" stop-color="#0b0a20"/>'
    '<stop offset="1" stop-color="#05050f"/></radialGradient>',
]
# Clouds are radial gradients fading to transparent (smooth in every SVG renderer, unlike big blurs)
for i, c in enumerate(clouds):
    col, op = c[4], c[5]
    out.append(f'<radialGradient id="c{i}">'
               f'<stop offset="0" stop-color="{col}" stop-opacity="{op}"/>'
               f'<stop offset="0.35" stop-color="{col}" stop-opacity="{op * 0.7:.2f}"/>'
               f'<stop offset="0.7" stop-color="{col}" stop-opacity="{op * 0.25:.2f}"/>'
               f'<stop offset="1" stop-color="{col}" stop-opacity="0"/></radialGradient>')
out.append('<filter id="glow" x="-200%" y="-200%" width="500%" height="500%">'
           '<feGaussianBlur stdDeviation="6"/></filter>')
out.append("</defs>")
out.append(f'<rect width="{W}" height="{H}" fill="url(#bg)"/>')

for i, (cx, cy, rx, ry, col, op) in enumerate(clouds):
    out.append(f'<ellipse cx="{cx}" cy="{cy}" rx="{rx * 1.3:.0f}" ry="{ry * 1.3:.0f}" fill="url(#c{i})"/>')

# Faint orbit arc echoing the logo
out.append('<ellipse cx="2600" cy="1080" rx="1700" ry="430" fill="none" stroke="#a78bfa" '
           'stroke-width="3" opacity="0.18" transform="rotate(-18 2600 1080)"/>')

# Star field
for _ in range(900):
    x, y = rng.uniform(0, W), rng.uniform(0, H)
    r = rng.choice([0.8, 1.0, 1.2, 1.5, 1.8, 2.4])
    op = rng.uniform(0.35, 1.0)
    out.append(f'<circle cx="{x:.0f}" cy="{y:.0f}" r="{r}" fill="#ffffff" opacity="{op:.2f}"/>')

# A few bright stars with glow
for x, y in [(3020, 520), (1880, 760), (3420, 1580), (760, 1180), (2380, 1640)]:
    out.append(f'<circle cx="{x}" cy="{y}" r="14" fill="#c4b5fd" opacity="0.8" filter="url(#glow)"/>')
    out.append(f'<circle cx="{x}" cy="{y}" r="4" fill="#ffffff"/>')

out.append("</svg>")
print("\n".join(out))
