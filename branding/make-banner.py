#!/usr/bin/env python3
"""Rebuild banner.svg from distributor-logo.svg (the banner inlines the logo so every SVG renderer can draw it)."""

import re
from pathlib import Path

here = Path(__file__).parent
logo = (here / "distributor-logo.svg").read_text(encoding="utf-8")
inner = re.search(r"<svg[^>]*>(.*)</svg>", logo, re.S).group(1)
banner = (here / "banner.svg").read_text(encoding="utf-8")
banner = re.sub(r'(<g transform="translate\(10 10\) scale\(0\.703125\)">).*?(</g>\n  <text)',
                lambda m: m.group(1) + inner + m.group(2), banner, count=1, flags=re.S)
(here / "banner.svg").write_text(banner, encoding="utf-8", newline="\n")
