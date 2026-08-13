# Brother card (v2) — the NFC card that was fabricated

<p align="center">
  <img src="../docs/renders/brother-card-front.png" width="90%" alt="Brother card front">
</p>

A brother taps this card to a phone; the phone opens the chapter's rush link. No
battery, no app on the brother's side — the card is a passive NFC tag that
harvests power from the reader's field.

**This is the version that was manufactured and used during rush week 2025.** The
earlier iteration in [`../brother-card-v1/`](../brother-card-v1/) was never built.

| | |
|---|---|
| Source of record | `PCB_Business_Card.kicad_pcb`, last saved **2025-07-30** |
| Designed in | KiCad **9.0.2** |
| Outline | **88.9 × 50.8 mm** — exactly 3.5 × 2 in, a standard business-card footprint |
| Stackup | 2 layer FR4, 1.6 mm, 35 µm (1 oz) copper |
| Fab package | [`fab/2025-07-30_release/`](./fab/2025-07-30_release/) |

## How it works

A phone's NFC reader radiates a 13.56 MHz field. The spiral coil on the left half
of the card (`ANT1`) is an inductor tuned, together with the IC's internal 50 pF
and the tuning cap `C2`, to resonate at that frequency. At resonance the coil
couples strongly to the phone, and the induced current does two jobs: it powers
the tag IC, and it carries the load-modulated reply back to the phone.

The IC holds an **NDEF record containing the rush URL**. The phone reads it and
offers to open the link. Nothing is stored on the board itself — see
[`../docs/programming-the-tag.md`](../docs/programming-the-tag.md) for how the URL
gets written, which is what you'd redo for a new year.

`D1` is not part of the NFC path at all. It's an energy-harvesting indicator: when
the field is strong enough, the IC's `VCC` output drives the LED through `R1`, so
the card visibly lights up when it's being read. It's a party trick, and a genuinely
useful bring-up probe — if the LED lights, the coil is coupling.

## Bill of materials

| Ref | Value | Footprint | Purpose |
|---|---|---|---|
| `U2` | **NT3H2111W0FHKH** | `btp:nfc-chip` (XQFN8, 1.6 × 1.6 mm, 0.5 mm pitch) | NXP NTAG I²C *plus* — the tag IC |
| `ANT1` | `COIL_GENERATOR` | `btp:COIL_GENERATOR` | 6-turn spiral antenna |
| `C1` | 220 nF | 0603 | Holds the harvested rail up during RF communication |
| `C2` | **2 pF (nominal — see below)** | 0603 | Antenna tuning capacitor |
| `R1` | 65 Ω | 0603 | LED current limit: (3.3 V − 2 V) / 20 mA |
| `D1` | Red LED | 0603 | Energy-harvest indicator |

`U2`'s `SDA`, `SCL`, and `FD` pins are deliberately left unconnected — the I²C side
of the NTAG is unused here. The card is a pure NFC-Forum Type 2 tag.

> **The `C2` value is the one number not to trust.** The schematic says `2p`, but
> upstream's own bring-up landed on **3.9 pF** to pull resonance to 13.555 MHz, and
> upstream's final BOM lists a **1.5 pF** part. Three different numbers for the same
> component. Tuning capacitance depends on the real board's parasitics, so treat
> `2p` as a placeholder and **tune on hardware**: sweep the antenna with a network
> analyzer and pick the value that dips closest to 13.56 MHz.
> [`../docs/nfc-theory.md`](../docs/nfc-theory.md) walks the full measurement.
> Upstream also showed the card still reads with a badly-tuned 15 pF cap, just at
> shorter range — so a wrong value degrades rather than breaks it.

## The antenna

Inherited unchanged from upstream. Extracted from `lib/btp.pretty/COIL_GENERATOR.kicad_mod`:

| Parameter | Value |
|---|---|
| Turns | **6** |
| Outer / inner diameter | **39.6 mm** / 31.2 mm |
| Track width / gap | **0.3 mm** / 0.3 mm (0.6 mm pitch) |
| Layer | `F.Cu`, with the inner end crossing over on `B.Cu` |
| Crossover | 0.3 mm drill PTH |
| Calculated inductance | **2.576 µH** (upstream) |
| Modelled parasitics | R≈1.17 Ω, C≈2 pF (upstream) |
| Simulated resonance, untuned | 13.75 MHz (upstream) |
| Measured resonance, 3.9 pF tuning cap | **13.555 MHz** (upstream, network analyzer) |

The coil is drawn as **graphic arcs inside a footprint**, not as routed track. That
is why the inner end has to leave through a through-hole pad and return on the back
side, and it's why DRC complains (below). The derivation of these numbers — working
backwards from the IC's 50 pF to a target inductance, then to a geometry — is
upstream's work and is preserved in full in
[`../docs/nfc-theory.md`](../docs/nfc-theory.md).

## Artwork

The visual design is the part that is original to Beta. Three things worth knowing
if you edit it:

- **The two-tone card is copper, not two mask colors.** The olive/green split is
  bare copper zones under a single green mask. Ordering "two-color solder mask"
  would be a waste of money — one mask color is all this needs.
- **Artwork is polygons in footprints**, produced by KiCad's *Bitmap to Component*
  converter from PNG art, then placed like parts. `btp:btp-dragon-footprint` (crest
  + dragon, 35 polygons), `btp:map` (the Back Bay map, 4 polygons), and the
  `BETA THETA PI / MEN OF PRINCIPLE` wordmark (27 polygons).
- **Two footprints on this board have no working library link**, because they were
  placed before being saved to a library:
  - the wordmark, whose stale link is the bare name `LOGO`. Its geometric twin
    **is** in the repo as `btp:btp-text-only-lg` (also 27 polygons) — relinking is
    optional cosmetic cleanup.
  - a single-pad unnamed footprint that anchors the coil crossover.

  Both are fully stored inside the `.kicad_pcb`, so they render, plot, and fabricate
  correctly. They just can't be *updated from library*. **Don't delete them
  casually.**

## Fab packages

| Folder | What it is |
|---|---|
| [`fab/2025-07-30_release/`](./fab/2025-07-30_release/) | **The authoritative set.** 9 gerbers + 2 drill files + placement/BOM CSVs, plotted from KiCad 9.0.2. This is the geometry that became physical cards. |
| [`fab/2025-07-30_full-export/`](./fab/2025-07-30_full-export/) | An earlier export the same day, with `F.Fab`, courtyard, and margin layers included. Useful for reading, **not** for ordering — documentation layers are not manufacturing data. |
| [`fab/2025-07-30_placement/`](./fab/2025-07-30_placement/) | Placement CSVs plus a Numbers spreadsheet used to reconcile the assembly. |

The release gerbers report `88.95 × 50.85 mm` (outline centreline plus line width)
and were plotted with a `0.1524 mm` minimum feature. Their timestamps read
`18:41 UTC+03:00` — the laptop's clock was on a +03:00 timezone, so that's
`11:41` Boston time, not evening.

**Reorder from `fab/2025-07-30_release/`, not from a fresh plot.** Regenerating
gerbers in a newer KiCad produces subtly different zone fills and teardrop
geometry for the same source, and this artwork leans on zone fills.
[`../docs/reordering.md`](../docs/reordering.md) explains the tradeoff.

## Known DRC findings — all expected

KiCad 10 reports **19 violations, 0 unconnected items, 0 schematic-parity errors**.
Every violation is an artifact of the artwork technique, and the cards work:

| Finding | Why it's benign |
|---|---|
| 3 × `shorting_items`, 2 × `clearance`, 1 × `solder_mask_bridge` | The coil is netless graphic arcs that intentionally touch `ANT1`'s pads. DRC sees "no net" copper contacting `/NFC-A` and `/NFC-B` and calls it a short. It *is* the connection. |
| 2 × `isolated_copper` | The decorative copper zones have no net by design — that's the two-tone effect. |
| 5 × `text_thickness` | Silkscreen strokes thinner than the 0.15 mm rule. The fab rendered them fine. |
| 1 × `track_dangling` | A 3 × 10⁻⁵ mm stub — a rounding artifact, not a real track. |
| 1 × `lib_footprint_mismatch` | `btp-dragon-footprint` was tweaked in place after placement, so the board copy differs from `lib/`. **The board is authoritative.** |
| 4 × `lib_footprint_issues` | Stock KiCad libraries (`Capacitor_SMD`, `Resistor_SMD`, `LED_SMD`) not registered in a headless CLI run. They resolve in the GUI. **`btp` resolves correctly** — that was the point of vendoring it. |

Do not "fix" the shorting/clearance findings by rerouting the coil. If you need a
clean DRC, add exclusions.

## Assembly

Five parts, all 0603 except the IC. The IC is the hard one: **XQFN8, 1.6 × 1.6 mm,
0.5 mm pitch, 0.71 × 0.22 mm pads, no exposed thermal pad.** That is small for hand
work — hot air with plenty of flux, or paste and a hotplate. The v1 board used a
TSSOP-8 instead, which is dramatically easier to hand-solder; if a future year wants
to assemble these by hand at scale, reverting the package is a legitimate move.

`D1` is the bring-up test: hold the card to a phone with NFC on, and the LED should
light. If it lights but the phone shows nothing, the coil is fine and the problem is
the tag's contents — go to
[`../docs/programming-the-tag.md`](../docs/programming-the-tag.md).
