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
| Stackup in the file | 2 layer FR4, 1.6 mm, 35 µm (1 oz) copper |
| **As actually ordered** | **1 mm thick, blue mask, white silkscreen** — 50 pcs, assembled by JLCPCB |
| Fab package | [`fab/2025-07-30_release/`](./fab/2025-07-30_release/) — byte-identical to what JLCPCB received |
| Order record | [`../docs/order-history.md`](../docs/order-history.md) |

> **The file says 1.6 mm; the cards are 1 mm.** Thickness is an order-page setting that
> isn't stored in the gerbers, so nothing reconciles this automatically. Likewise the mask
> is **blue**, which KiCad doesn't record either — the renders on this page were generated
> with the as-ordered colour injected ([`../tools/render-boards.sh`](../tools/render-boards.sh)).

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

Schematic values on the left, the parts **actually fitted** by JLCPCB on the right.

| Ref | Schematic | Part ordered | JLCPCB code | Purpose |
|---|---|---|---|---|
| `U2` | `NT3H2111W0FHKH` | **NT3H2111W0FHKH** — XQFN8, 1.6 × 1.6 mm, 0.5 mm pitch | `C710403` | NXP NTAG I²C *plus* — the tag IC |
| `ANT1` | `COIL_GENERATOR` | *copper on the board, not a placed part* | — | 6-turn spiral antenna |
| `C1` | `220n` | **CL10B224KA8NNNC** — 220 nF 0603 X7R | `C21120` | Holds the harvested rail up during RF communication |
| `C2` | `2p` | **0603CG2R0C500NT** — **2.0 pF** 0603 C0G 50 V | `C1650` | Antenna tuning capacitor |
| `R1` | `65` | **0603WAF649JT5E** — **64.9 Ω** 1% 0603 | `C23224` | LED current limit: (3.3 V − 2 V) / 20 mA |
| `D1` | `RED` | **LTST-C190KRKT** — red 0603 | `C94869` | Energy-harvest indicator |

`U2`'s `SDA`, `SCL`, and `FD` pins are deliberately left unconnected — the I²C side
of the NTAG is unused here. The card is a pure NFC-Forum Type 2 tag.

> **`C2` is 2.0 pF — this used to be the one uncertain number, and it is now settled.**
> Upstream's write-up quotes **3.9 pF** as their measured optimum and lists **1.5 pF** in
> their parts list, so for a while three values were in play. JLCPCB's parts list for this
> order resolves it: the Beta cards were built with **2.0 pF**, matching the schematic's
> `2p`, and they worked. Upstream's figures were for *their* board geometry.
>
> Reorder with 2.0 pF. If you ever want to chase more read range you can sweep it on
> hardware — [`../docs/nfc-theory.md`](../docs/nfc-theory.md) walks the measurement — but
> don't change it speculatively. Upstream showed the card still reads even with a badly
> mistuned 15 pF cap, just at shorter range, so this parameter trades range rather than
> breaking function.

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

- **The two-tone card is copper, not two mask colours.** The card was ordered in
  **blue**, and the lighter blue-violet half is bare copper under that single mask.
  Ordering "two-colour solder mask" would be a waste of money — one colour is all this
  needs.
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
| [`fab/2025-07-30_placement/`](./fab/2025-07-30_placement/) | Placement CSVs plus a Numbers spreadsheet used while reconciling the assembly. |
| [`fab/jlcpcb-assembly/`](./fab/jlcpcb-assembly/) | The JLCPCB-format **BOM and CPL** used to order assembly. Upload these with the release gerbers to get populated boards. |

**The release set has been byte-compared against the files JLCPCB actually received**
and is identical, so reordering from it reproduces the 2025 cards exactly. The gerbers
report `88.95 × 50.85 mm` (outline centreline plus line width) and were plotted with a
`0.1524 mm` minimum feature. Their timestamps read `18:41 UTC+03:00` — the laptop's clock
was on a +03:00 timezone, so that's `11:41` Boston time, not evening.

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

**The 50 cards were machine-assembled by JLCPCB**, top side, high-temp paste — not
hand-soldered. Which is fortunate, because the IC is the awkward part: **XQFN8,
1.6 × 1.6 mm, 0.5 mm pitch, 0.71 × 0.22 mm pads, no exposed thermal pad.**

Two consequences of ordering assembly, both covered in
[`../docs/order-history.md`](../docs/order-history.md):

- **JLCPCB adds two 10 mm edge rails** to carry fiducials and its SMT tracking QR code,
  which is why the order dimension reads 88.9 × **70.8** mm rather than 88.9 × 50.8 mm.
  The rails are V-scored off, and the QR marks go with them, so the card faces stay clean.
- **Depaneling was not paid for in 2025**, so the cards arrived with rails attached and
  someone snapped all 50 off by hand. Tick that box next time.

If you ever do assemble by hand, [`../brother-card-v1/`](../brother-card-v1/) used a
pin-compatible **TSSOP-8** version of the same NTAG family — 0.65 mm pitch and gull-wing
leads — which is far friendlier to an iron.

`D1` is the bring-up test: hold the card to a phone with NFC on, and the LED should
light. If it lights but the phone shows nothing, the coil is fine and the problem is
the tag's contents — go to
[`../docs/programming-the-tag.md`](../docs/programming-the-tag.md).
