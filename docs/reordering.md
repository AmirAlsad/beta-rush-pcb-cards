# Getting more cards made

## The one rule

**Order from the `fab/` folders, not from a fresh KiCad export.**

Every card directory contains the exact gerber package that was sent to the fab:

| Card | Order this |
|---|---|
| Brother card | [`../brother-card/fab/2025-07-30_release/`](../brother-card/fab/2025-07-30_release/) |
| PNM card | [`../pnm-card/fab/2025-07-30_release/`](../pnm-card/fab/2025-07-30_release/) |

Zip the folder's contents, upload, done. These files produced physical cards that
worked, which is a stronger guarantee than any DRC pass.

### Why not just re-export?

Because it was checked, and it isn't identical. Replotting the brother card from
unmodified source in KiCad 10.0.5 produced **different zone fill and teardrop
geometry** than the KiCad 9.0.2 release set. Neither output is wrong — the fill
algorithm changed between versions. But this artwork *is* copper zones (that's the
two-tone effect), so a re-plot is a new design that happens to look similar, not the
same design. Reordering from `fab/` removes that whole class of surprise.

Re-export only when you've actually changed the design — and then treat the result
as a new revision with a new dated folder.

## Ordering specification

Upstream's original card was ordered from **PCBWay** with the spec below. It's a
sensible default and any vendor (PCBWay, JLCPCB, OSH Park) can quote from it:

| Option | Value |
|---|---|
| Layers | 2 |
| Material | FR-4, TG130–140 |
| Thickness | **1.6 mm** |
| Min track / spacing | 5/5 mil |
| Solder mask | **Green** |
| Silkscreen | **White** |
| Surface finish | HASL with lead |
| Via process | Tenting vias |
| Finished copper | 1 oz |
| Remove product number | No |

> **TODO — the actual 2025 order details aren't recorded.** Vendor, quantity, unit
> cost, turnaround, and whether assembly was ordered or done by hand are not
> recoverable from any file in this archive. See
> [`OPEN-QUESTIONS.md`](./OPEN-QUESTIONS.md). Filling this in is the single most
> useful thing a future year could add — "what did 200 of these cost and how long
> did they take" is exactly what the next person needs.

### Card-specific notes that affect your quote

**Brother card** — 88.9 × 50.8 mm, rectangular with rounded corners. Straightforward.
Order **green mask, white silkscreen, and one mask colour only**: the olive/green
two-tone is bare copper zones under a single mask, not a second mask colour. Asking
for two-colour mask would cost real money and change nothing.

**PNM card** — 89.98 × 54.97 mm with an **octagonal outline** (chamfered corners).
This is the one thing likely to go wrong. A rectangle can be sheared or V-scored;
this profile must be **routed**. Confirm explicitly that the vendor is routing the
outline from `Edge.Cuts` and hasn't substituted a rectangle. Some cheap-tier services
restrict non-rectangular outlines or surcharge them.

**Both cards** carry heavy silkscreen with thin strokes. KiCad flags this
(`text_thickness`: 5 findings on the brother card, 21 on the PNM card) because strokes
fall below the 0.15 mm design rule. The 2025 boards printed legibly anyway, but if you
switch vendors, ask their **minimum silkscreen line width** and compare before
committing to a large run.

## Assembly

Only the brother card has parts — five of them:

| Ref | Part | Notes |
|---|---|---|
| `U2` | NXP `NT3H2111W0FHKH` | XQFN8, 1.6 × 1.6 mm, 0.5 mm pitch. **The hard part.** |
| `C1` | 220 nF, 0603 | |
| `C2` | Tuning cap, 0603 | **Value is a bring-up decision — see below** |
| `R1` | 65 Ω, 0603 | 64.9 Ω 1% is the standard value |
| `D1` | Red LED, 0603 | |

Upstream's exact part numbers are listed at the end of
[`nfc-theory.md`](./nfc-theory.md), though upstream used a green LED and the
TSSOP-8 version of the IC.

**About `C2`.** The schematic says `2p`, upstream's bring-up settled on `3.9 pF`, and
upstream's BOM lists `1.5 pF`. Buy a small assortment (1.5, 2, 3.3, 3.9, 5.6 pF) and
tune on a real board — sweep the antenna and pick the value whose dip sits closest to
13.56 MHz. If you have no test gear, `3.9 pF` is the value that was *measured* to give
13.555 MHz on this antenna geometry, so it's the best blind guess. A wrong value
shortens read range rather than breaking the card.

**Hand vs. machine.** The XQFN8 is small for hand assembly — hot air with generous
flux, or paste plus a hotplate. For a large batch, either pay for assembly, or look at
[`../brother-card-v1/`](../brother-card-v1/), which used a pin-compatible **TSSOP-8**
version of the same NTAG family that is far friendlier to an iron. Reverting the
package is a legitimate design choice for a hand-assembled run.

## After assembly

Every card needs its NFC tag written before it's handed out —
[`programming-the-tag.md`](./programming-the-tag.md). Budget time for this: it's about
15 seconds per card with an Android phone, but it's per-card, and it's the step
that's easy to forget until the night before.
