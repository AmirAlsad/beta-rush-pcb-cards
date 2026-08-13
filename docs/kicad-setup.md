# Opening these projects, years later

## The short version

```sh
git clone <this repo>
cd RushCards
```

Then in KiCad: **File ▸ Open Project** → `brother-card/PCB_Business_Card.kicad_pro`
(or `pnm-card/PNM_Rush_Card.kicad_pro`).

That's it. There is no build step, no dependency to install, and no environment
variable to set. If footprints are missing, something moved — read on.

## What these were built with

| | |
|---|---|
| KiCad | **9.0.2** (both cards, all fab exports) |
| OS at design time | macOS |
| Stock libraries | KiCad's bundled `Capacitor_SMD`, `Resistor_SMD`, `LED_SMD`, `Device`, `Connector` |
| Custom library | `lib/` in this repo — see [`../lib/README.md`](../lib/README.md) |

## Opening in a newer KiCad

KiCad will offer to migrate the file format on first open. **Let it, but do it on a
branch**, because a migration rewrites every source file and produces an enormous
diff that buries any real change you make afterward.

```sh
git switch -c kicad-10-migration
# open, let KiCad migrate, save, then:
git add -A && git commit -m "Migrate brother-card + pnm-card to KiCad 10 format"
```

Two things behave differently after a migration:

1. **Regenerated gerbers will not be byte-identical to `fab/`.** This was measured,
   not guessed: replotting the brother card in KiCad 10.0.5 produced different zone
   fill and teardrop geometry from the KiCad 9.0.2 release set. Neither is "wrong",
   but this artwork leans on copper zone fills, so the archived gerbers are the
   record of what physically exists. See [`reordering.md`](./reordering.md).
2. **DRC results shift between versions.** The counts documented in each card's
   README were measured with KiCad 10.0.5. Expect different numbers on a different
   version. What matters is that they're all artwork artifacts — each card README
   explains its own list.

## If footprints or symbols come up missing

Almost always one of these three:

**1. `lib/` moved.** Projects resolve it as `${KIPRJMOD}/../lib/btp.pretty` — a
relative hop from the project folder up one level into `lib/`. If you copied
`brother-card/` somewhere on its own, that hop breaks. Copy the whole repo, or fix
the project's `fp-lib-table`.

**2. You have a conflicting *global* `btp` library.** Anyone who worked on the
original machine has `btp` registered globally at
`~/Documents/KiCad/9.0/footprints/btp.pretty`. Two libraries sharing one nickname is
a conflict. Delete the global entry in
*Preferences ▸ Manage Footprint Libraries ▸ Global* so the project-local one wins.

**3. It's one of the known stale links, and it's fine.** These are expected and do
not need fixing:

| Where | Stale reference | Status |
|---|---|---|
| brother v2, PNM | footprint `LOGO` (no library prefix) | Geometry is stored in the `.kicad_pcb` and fabricates correctly. Twin available as `btp:btp-text-only-lg`. |
| brother v2 | an unnamed single-pad footprint | The coil crossover anchor. Stored in the board. Don't delete. |
| brother **v1** | symbol lib `NT3H1101W0FTTJ`, footprint `COIL_GENERATOR` (no prefix) | Pointed at `C:/Users/rahim/Downloads/...` on upstream's Windows machine. Symbol definitions are cached in the `.kicad_sch`, so it opens; you just can't update from library. v1 was never fabricated. |

KiCad caches complete symbol and footprint definitions inside `.kicad_sch` and
`.kicad_pcb`. A missing *library* does not mean missing *geometry* — it only means
you can't push or pull updates for that part.

## What's deliberately not in git

Per [`../.gitignore`](../.gitignore):

- `fp-info-cache` — multi-MB, regenerated on open
- `*.kicad_prl` — per-user GUI state (zoom, visible layers, open tabs); pure diff noise
- `*-backups/` — KiCad's own timestamped project zips. **These still exist on the
  original machine's disk** (~16 MB across the three projects); they're just kept out
  of git, since git history covers the same ground. They contain snapshots from
  2024-03 through 2025-07 including one discarded 2025-07-31 autosave.

## Regenerating the renders

The board images in `renders/` were produced with KiCad's CLI, not by hand:

```sh
export PATH="/Applications/KiCad/KiCad.app/Contents/MacOS:$PATH"

kicad-cli pcb render --side top --width 2400 --height 1400 --quality high \
  -o docs/renders/brother-card-front.png brother-card/PCB_Business_Card.kicad_pcb
```

`--side bottom` for the back. Same command shape for `pnm-card` (that one was
rendered at `2400 × 1500` to suit its taller outline).

`kicad-cli` is also how the DRC numbers in each README were measured:

```sh
kicad-cli pcb drc --format json -o /tmp/drc.json brother-card/PCB_Business_Card.kicad_pcb
```
