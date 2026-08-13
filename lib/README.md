# `lib/` — the Beta KiCad library

**Do not move or rename this directory.** All three projects resolve it as a
relative path from their own location:

```
${KIPRJMOD}/../lib/btp.pretty     # footprints
${KIPRJMOD}/../lib/btp.kicad_sym  # symbols
```

`${KIPRJMOD}` is KiCad's variable for "this project's directory", so
`brother-card/fp-lib-table` reaches up one level and back down into `lib/`. Move
`lib/`, rename a card folder, or flatten the tree, and every board opens with
missing footprints.

## Why this exists

When these cards were designed, the `btp` library was registered in KiCad's
**global** library table, living at
`~/Documents/KiCad/9.0/{footprints/btp.pretty, symbols/btp.kicad_sym}` on one
laptop. The projects referenced `btp:` nicknames but shipped no copy of the
library, so the boards were unopenable by anyone else on earth. Vendoring it here
and pointing each project's own `fp-lib-table` at the vendored copy is the single
change that turned this from a personal folder into an archive.

> **If you are working on the original laptop**, you may still have a *global*
> `btp` entry pointing at `~/Documents/KiCad/.../btp.pretty`. Two libraries with
> the same nickname is a conflict. Remove the global entry
> (*Preferences ▸ Manage Footprint Libraries ▸ Global*) so the project-local one
> wins, and the repo becomes the single source of truth.

## Contents

### `btp.kicad_sym`

| Symbol | Notes |
|---|---|
| `NT3H2111W0FHKH` | NXP NTAG I²C *plus*. Used by the fabricated brother card. Originally pulled from SnapEDA — the symbol still carries its SnapEDA metadata properties. |

### `btp.pretty`

Artwork footprints were produced with KiCad's **Bitmap to Component** converter
(*Tools ▸ Generate Bitmap Component*) from PNG source art, which flattens an image
into silkscreen polygons. That's why they're measured in polygon count.

| Footprint | Polys | What it is | Used by |
|---|---|---|---|
| `btp-dragon-footprint` | 35 | Beta crest + dragon | brother v2 (**edited in place — board copy is authoritative**), brother v1 |
| `map` | 4 | Back Bay map: dome, Mass Ave, Charles, Bay State, Beacon | brother v2, brother v1, PNM |
| `btp-text-only-lg` | 27 | `BETA THETA PI / MEN OF PRINCIPLE` wordmark, no shield | matches the stale-linked `LOGO` footprint embedded in brother v2 |
| `btp-text-footprint-lg` | 29 | Wordmark **with** shield, large | brother v1 |
| `btp-text-footprint` | 29 | Wordmark with shield, smaller | — |
| `doodles` | 162 | The doodle border: gamepads, gears, card hand, books, handshake, dome, figures | brother v1 only — **never fabricated** |
| `corner-circuits` | 5 | Decorative circuit-trace corner flourishes | — (unused) |
| `COIL_GENERATOR` | 0 | The 6-turn spiral NFC antenna: 12 arcs + 2 lines on `F.Cu`, 0.3 mm wide, 39.6 mm OD, plus an SMD pad (outer end) and a 0.3 mm PTH pad (inner end, crosses over on `B.Cu`) | brother v2 |
| `nfc-chip` | 0 | Hand-drawn XQFN8: 8 SMD pads, 0.5 mm pitch, 0.71 × 0.22 mm, no exposed thermal pad | brother v2 |

`corner-circuits` and `btp-text-footprint` are unused by any board — available if a
future design wants them.

## Two footprints are *not* here

Two footprints exist only inside `brother-card/PCB_Business_Card.kicad_pcb` (and one
inside the PNM board), because they were placed before ever being saved to a
library:

- the wordmark, whose stale library link is the bare name `LOGO`
- a single-pad unnamed footprint anchoring the coil crossover

They fabricate correctly — KiCad stores complete footprint geometry in the board
file — but they can't be *updated from library*, and deleting one loses it. The
wordmark's twin is `btp-text-only-lg` above; the crossover pad would have to be
redrawn.

## Editing artwork

To change a graphic: edit the source PNG, re-run *Bitmap to Component*, save the
result into `btp.pretty`, then in Pcbnew place the new footprint and delete the old.
Because these are polygons and not text or vectors, **you cannot edit the art in
KiCad** — always go back to the image.

Bitmap-to-component output is resolution-dependent. Start from the highest-resolution
art you have; a low-DPI source produces visibly stair-stepped silkscreen.
