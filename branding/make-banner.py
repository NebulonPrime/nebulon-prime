#!/usr/bin/env python3
"""Rebuild banner.svg (logo + name) from banner-source.svg and distributor-logo.svg.

1. Inline the current logo into banner-source.svg (so every SVG renderer can draw it).
2. With Inkscape, turn the text into outlines and trim the canvas to the drawing, so the
   banner centres correctly (boot splash) and doesn't depend on fonts at build time.

Needs Inkscape 1.x on PATH.
"""

import re
import subprocess
from pathlib import Path

here = Path(__file__).parent
logo = (here / "distributor-logo.svg").read_text(encoding="utf-8")
inner = re.search(r"<svg[^>]*>(.*)</svg>", logo, re.S).group(1)

source = here / "banner-source.svg"
text = source.read_text(encoding="utf-8")
text = re.sub(r'(<g transform="translate\(10 10\) scale\(0\.703125\)">).*?(</g>\n  <text)',
              lambda m: m.group(1) + inner + m.group(2), text, count=1, flags=re.S)
source.write_text(text, encoding="utf-8", newline="\n")

subprocess.run(
    ["inkscape", str(source), "--export-text-to-path", "--export-plain-svg",
     "--export-area-drawing", "--export-margin=4", "--export-filename", str(here / "banner.svg")],
    check=True,
)
