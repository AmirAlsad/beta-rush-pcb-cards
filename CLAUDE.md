# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this repo is

A hardware archive, not a software project. It holds the KiCad sources, vendored
library, and as-manufactured gerbers for two PCB cards made for MIT Beta Theta Pi's
rush week (Aug 30 – Sep 6, 2025):

- **`brother-card/`** — a working NFC tag card (v2, **fabricated**). Tap to phone →
  opens the chapter's rush link.
- **`brother-card-v1/`** — an earlier iteration, **never fabricated**. Kept for
  reference; has 1 unconnected item and an intentionally unfinished netlist.
- **`pnm-card/`** — silkscreen-only schedule card (**fabricated**). No components, no
  nets, empty schematic.
- **`lib/`** — `btp.pretty` + `btp.kicad_sym`, vendored. Shared by all three projects.
- **`docs/`** — written documentation plus inherited upstream reference material.

There is **no build, no test suite, and no dependency install.** Do not invent one.
Verification here means opening a board in KiCad, running DRC, or rendering an image.

## Non-negotiables

**Never move, rename, or reorganize `lib/`.** All three projects resolve it as
`${KIPRJMOD}/../lib/btp.pretty` — a relative hop out of the project folder. Breaking
that relative path makes every board open with missing footprints, which is the exact
failure this archive was created to fix. Same applies to renaming the card
directories.

**Never overwrite or "clean up" anything under a `fab/` folder.** Those gerbers are the
record of physical objects that exist in the world. A new export goes in a **new dated
folder** (`fab/YYYY-MM-DD_release/`).

**Never regenerate gerbers to replace an existing release set.** Replotting unmodified
source in a newer KiCad yields different zone-fill and teardrop geometry (measured:
KiCad 9.0.2 vs 10.0.5 on the brother card). The artwork depends on zone fills, so a
re-plot is a new revision, not a reproduction.

**Do not "fix" the DRC violations.** Each card's README enumerates them with reasons.
They are artifacts of the artwork technique and the cards work:
- The coil is **netless graphic arcs** intentionally touching `ANT1`'s pads → DRC
  reports `shorting_items` / `clearance` / `solder_mask_bridge`. That contact *is* the
  connection. Rerouting it would break the antenna.
- Decorative copper zones have no net on purpose → `isolated_copper`.
- Silkscreen strokes are below the 0.15 mm rule → `text_thickness`. The fab printed
  them fine.

If a clean DRC is genuinely wanted, add exclusions — don't change geometry.

**Two footprints have no working library link, by history, and that's fine.** The
wordmark (stale bare name `LOGO`) and an unnamed single-pad coil-crossover anchor exist
only inside the `.kicad_pcb`. They fabricate correctly; they just can't be *updated
from library*. Deleting one loses it. The wordmark's twin is `btp:btp-text-only-lg`.

## Working with KiCad from the CLI

`kicad-cli` is not on `PATH` by default on macOS:

```sh
export PATH="/Applications/KiCad/KiCad.app/Contents/MacOS:$PATH"
```

```sh
# Render a board (this is how docs/renders/*.png were made)
kicad-cli pcb render --side top --width 2400 --height 1400 --quality high \
  -o docs/renders/brother-card-front.png brother-card/PCB_Business_Card.kicad_pcb

# DRC — takes a minute or two per board; use a generous timeout
kicad-cli pcb drc --format json -o /tmp/drc.json brother-card/PCB_Business_Card.kicad_pcb

# Gerbers — ONLY into a new dated folder, never over an existing release
kicad-cli pcb export gerbers \
  --layers F.Cu,B.Cu,F.Paste,B.Paste,F.Silkscreen,B.Silkscreen,F.Mask,B.Mask,Edge.Cuts \
  -o <new-dated-folder> <board>
```

Note the installed KiCad may be newer than the 9.0.2 these were authored in. Headless
runs also report stock libraries (`Capacitor_SMD`, `Resistor_SMD`, `LED_SMD`) as
unconfigured — that's a CLI artifact, not a repo problem. `btp` resolving correctly is
the signal that matters.

## Reading board files without KiCad

`.kicad_pcb` / `.kicad_sch` are s-expression text. Grep and small Python scripts get
you a long way, and this is usually faster than opening the GUI:

```sh
grep -oE '\(footprint "[^"]*"' brother-card/PCB_Business_Card.kicad_pcb | sort | uniq -c
grep -oE '\(lib_id "[^"]*"'    brother-card/PCB_Business_Card.kicad_sch | sort -u
```

Board text lives in `gr_text` objects with embedded `\n`; artwork lives as `fp_poly`
inside footprints (bitmap-converted, so **not editable in KiCad** — always go back to
the source PNG and re-run *Bitmap to Component*).

## Editing conventions

- **The PNM card is edited board-only.** Its schematic is intentionally empty; there is
  no netlist to sync. Don't try to make it a "proper" schematic-driven project.
- **Commit before ordering.** The commit matching an order is what makes a reorder
  possible years later.
- **KiCad version migrations go on their own branch.** A migration rewrites every
  source file and will bury real changes in the diff.
- **Preserve the 2025 typo in `pnm-card`.** The board reads "Saturday, August 31" for
  what was a Sunday. It shipped that way; the archive matches the artifact. It's called
  out in the READMEs and in `next-year-checklist.md` as a thing to fix when *retyping*
  for a new year — not something to silently correct in place.

## Facts that are not in this repo

`docs/OPEN-QUESTIONS.md` tracks what couldn't be recovered from the files — most
importantly **the rush URL written to the NFC chips**, the fab vendor/quantity/cost,
and whether the tags were locked read-only. Entries there carry a best inference and
its basis. **Don't present those inferences as established fact**, and if you learn a
real answer, write it into the relevant doc and delete the entry.

There are **no photographs of either finished Beta card** anywhere in this repo. Every
photo under `docs/images/` is upstream's card. Images of the Beta cards under
`docs/renders/` are CLI renders, not photos — describe them as such.

## Attribution

`brother-card/` is a fork of
[Raziz1/PCB_Business_Card](https://github.com/Raziz1/PCB_Business_Card) by **Rahim
Aziz** (at commit `fe6c083`). The antenna design, matching-network derivation, LTSpice
and MATLAB simulations, and hardware characterization are **his work**, inherited
unchanged and preserved verbatim in `docs/nfc-theory.md`. Beta's original contributions
are the artwork, the `btp` library, the IC package swap, and the entire PNM card.

Upstream has **no license file** — keep attribution intact and prominent in anything
you write, and see `docs/OPEN-QUESTIONS.md` §9 before extracting more of upstream's
material into new files.
