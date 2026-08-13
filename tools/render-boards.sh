#!/usr/bin/env bash
# Regenerate every board render in docs/renders/.
#
# Renders each card in the solder mask colour it was ACTUALLY ORDERED IN
# (brother card: blue, PNM card: green -- see docs/order-history.md), which
# KiCad does not store in the board file.
#
# It does that without touching the board files: each project is copied to a
# temp dir, a `(color ...)` field is injected into the copy's stackup, and the
# copy is rendered with --use-board-stackup-colors. The originals are the
# as-fabricated record and are never modified.
#
# Usage:   tools/render-boards.sh
# Needs:   KiCad installed (kicad-cli). ~90 s for all six renders.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$REPO/docs/renders"

# kicad-cli is not on PATH by default on macOS
if ! command -v kicad-cli >/dev/null 2>&1; then
  export PATH="/Applications/KiCad/KiCad.app/Contents/MacOS:$PATH"
fi
command -v kicad-cli >/dev/null 2>&1 || { echo "error: kicad-cli not found" >&2; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# stage_project <card-dir> <mask-colour|none>  ->  echoes path to the staged .kicad_pcb
stage_project() {
  local card="$1" colour="$2"
  local src="$REPO/$card" dst="$TMP/$card"
  mkdir -p "$dst"
  cp -R "$REPO/lib" "$TMP/lib" 2>/dev/null || true   # projects resolve ${KIPRJMOD}/../lib
  cp "$src"/*.kicad_pcb "$src"/*.kicad_sch "$src"/*.kicad_pro "$src"/fp-lib-table "$src"/sym-lib-table "$dst/"
  local board; board="$(ls "$dst"/*.kicad_pcb)"
  if [ "$colour" != "none" ]; then
    python3 - "$board" "$colour" <<'PY'
import sys
board, colour = sys.argv[1], sys.argv[2]
s = open(board).read()
for layer in ('Top Solder Mask', 'Bottom Solder Mask'):
    s = s.replace(f'(type "{layer}")', f'(type "{layer}")\n\t\t\t\t(color "{colour}")', 1)
open(board, 'w').write(s)
PY
  fi
  echo "$board"
}

render() {  # render <board> <side> <w> <h> <out> [extra kicad-cli args...]
  local board="$1" side="$2" w="$3" h="$4" out="$5"; shift 5
  echo "  -> $(basename "$out")"
  kicad-cli pcb render --side "$side" --width "$w" --height "$h" \
    --quality high --use-board-stackup-colors "$@" -o "$out" "$board" >/dev/null
}

mkdir -p "$OUT"

echo "brother card (as ordered: BLUE mask, white silkscreen)"
BROTHER="$(stage_project brother-card Blue)"
render "$BROTHER" top    2400 1400 "$OUT/brother-card-front.png"
render "$BROTHER" bottom 2400 1400 "$OUT/brother-card-back.png"

# Angled hero shot for the top of the README. Transparent background so it
# reads correctly on both GitHub light and dark themes ( --floor would paint a
# hard black backdrop ).
render "$BROTHER" top    2400 1500 "$OUT/brother-card-hero.png" \
  --perspective --rotate '-20,0,18' --background transparent

echo "PNM card (as ordered: GREEN mask, white silkscreen)"
PNM="$(stage_project pnm-card Green)"
render "$PNM" top    2400 1500 "$OUT/pnm-card-front.png"
render "$PNM" bottom  2400 1500 "$OUT/pnm-card-back.png"

# v1 was never fabricated, so it has no "as ordered" colour. Rendered in
# KiCad's default green purely so the artwork is visible.
echo "brother card v1 (never fabricated -- default green, colour is not meaningful)"
V1="$(stage_project brother-card-v1 none)"
render "$V1" top 2400 1400 "$OUT/brother-card-v1-front.png"

echo "done -> docs/renders/"
