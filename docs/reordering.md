# Getting more cards made

The 2025 run is fully documented in [`order-history.md`](./order-history.md) — vendor,
prices, quantities, dates, the real part numbers, and the gotchas. This page is the
short operational version.

## The one rule

**Order from the `fab/` folders, not from a fresh KiCad export.**

| Card | Upload this |
|---|---|
| Brother card | [`../brother-card/fab/2025-07-30_release/`](../brother-card/fab/2025-07-30_release/) |
| PNM card | [`../pnm-card/fab/2025-07-30_release/`](../pnm-card/fab/2025-07-30_release/) |

Those folders were **byte-compared against the files JLCPCB actually received** in 2025
and are identical. Uploading them reproduces the 2025 cards exactly.

Re-exporting from source is not equivalent: replotting the unmodified brother card in
KiCad 10.0.5 produces different zone-fill and teardrop geometry than the KiCad 9.0.2
release set. The fill algorithm changed between versions, and this artwork *is* copper
zones. Re-export only when you've genuinely changed the design — then write it to a new
dated folder and treat it as a new revision.

## What the 2025 run cost

| Product | Qty | PCB cost |
|---|---|---|
| Brother card (blue, assembled) | 50 | $23.70 |
| PNM card (green, bare) | 350 | $86.10 |

**$109.80 in PCB cost for 400 cards.** The **assembly charge and component cost for the
50 brother cards were not captured** in the salvaged records — budget for those
separately. Four of the five parts are JLCPCB "Extended" parts, which carry a per-part
feeder setup fee; that's a fixed cost, so it stings much less at higher quantities.

Fabrication took **3 days** (brother, including assembly) and **5 days** (PNM). Order to
rush was 24 days. Three weeks is comfortable; two is tight but doable.

## Settings to select — including three that are easy to get wrong

Vendor: **JLCPCB**, order `10486412A` in 2025.

| Setting | Brother card | PNM card |
|---|---|---|
| Layers | 2 | 2 |
| Material | FR-4 | FR-4 TG135 |
| **Thickness** | **1 mm** ⚠️ | **1 mm** ⚠️ |
| **Solder mask** | **Blue** ⚠️ | **Green** ⚠️ |
| Silkscreen | White, ink-jet | White, ink-jet |
| Outer copper | 1 oz | 1 oz |
| Surface finish | HASL (lead-free when assembled) | HASL with lead |
| Via covering | Tented | Tented |
| Electrical test | Flying probe, random | Flying probe, random |

### ⚠️ 1. Thickness: set 1 mm, don't accept the default

**Every KiCad file in this repo says 1.6 mm. Both cards were ordered at 1 mm.** Thickness
is an order-page dropdown that isn't carried in the gerbers, so nothing will warn you.
1 mm is the right choice for a card people put in a wallet — 1.6 mm feels like a circuit
board. Accept the default and you'll get visibly chunkier cards than the 2025 run.

### ⚠️ 2. Colours: the cards are not both green

**Brother card = blue mask. PNM card = green mask.** Both white silkscreen. One mask
colour each — the two-tone effect on each card is **bare copper under a single mask**, so
never order "two-colour mask". On the blue card, the copper half reads blue-violet.

### ⚠️ 3. PNM card: confirm the outline is routed

The PNM card's outline is an **octagon** (chamfered corners), which must be **routed**, not
sheared or V-scored. JLCPCB handled it correctly in 2025 — its production set for that
card has no V-cut layer at all. Some cheap tiers restrict or surcharge non-rectangular
outlines, so confirm it's priced as a routed profile rather than silently squared off.

## Ordering assembly for the brother card

The 2025 brother cards were **machine-assembled by JLCPCB**, top side only, 50 units.
Upload with the gerbers:

- [`../brother-card/fab/jlcpcb-assembly/jlcpcb-bom.csv`](../brother-card/fab/jlcpcb-assembly/jlcpcb-bom.csv)
- [`../brother-card/fab/jlcpcb-assembly/jlcpcb-cpl.csv`](../brother-card/fab/jlcpcb-assembly/jlcpcb-cpl.csv)

Both are already in JLCPCB's column format. See that folder's
[README](../brother-card/fab/jlcpcb-assembly/) for the catalogue codes worth pasting in.

### The bill of materials, as actually ordered

| Ref | Part | JLCPCB code |
|---|---|---|
| `U2` | NT3H2111W0FHKH — NTAG I²C plus, XQFN8 | `C710403` |
| `C1` | CL10B224KA8NNNC — 220 nF 0603 X7R | `C21120` (Basic) |
| `C2` | 0603CG2R0C500NT — **2.0 pF** 0603 C0G 50 V | `C1650` |
| `R1` | 0603WAF649JT5E — **64.9 Ω** 1% 0603 | `C23224` |
| `D1` | LTST-C190KRKT — red 0603 | `C94869` |

**`C2` is settled: 2.0 pF.** Earlier docs in this repo flagged it as uncertain because
upstream used 3.9 pF and listed 1.5 pF. Those were upstream's board. The Beta cards
shipped with 2.0 pF and worked — reorder with it.

### Pay for depaneling

JLCPCB adds **two 10 mm edge rails** to the brother card for assembly (which is why the
order dimension reads 88.9 × 70.8 mm instead of 88.9 × 50.8 mm), carrying the fiducials
and SMT tracking QR code. In 2025, **"Depanel boards & edge rail before delivery" was set
to No**, so 50 cards arrived with rails attached and someone snapped each one off along a
V-score, with "Deburring/Edge rounding" also off.

**Tick depaneling next time.** It's cheap, and it's the difference between a clean card
and two rough edges on something you hand to strangers. The QR/tracking marks live on the
rails, so they disappear with them — a good property to keep if you change the panel.

### Consider removing the order number

Both products were ordered with **Mark on PCB: Order Number**. On the brother card that
folded into the marks on the rails, so the card faces stayed clean. **The PNM card has no
rails, so it likely carries a small JLCPCB order number on a face.** If that bothers you,
choose "Remove order number" (small surcharge) or specify a location.

### Hand assembly, if you ever need it

Not necessary — JLCPCB assembles these fine — but if you ever do it yourself, the XQFN8
is 1.6 × 1.6 mm at 0.5 mm pitch with no exposed pad: hot air and generous flux, or paste
and a hotplate. [`../brother-card-v1/`](../brother-card-v1/) used a pin-compatible
**TSSOP-8** version of the same NTAG family that is far friendlier to an iron.

## After assembly

Every brother card needs its NFC tag written before it goes out —
[`programming-the-tag.md`](./programming-the-tag.md). ~15 seconds per card with an Android
phone, but it's per card, and it's the step people forget until the night before.

The 2025 tags were **not** locked read-only, so existing cards can be rewritten rather
than reordered. Consider pointing the tags at a **redirect you control** so future years
need no reprogramming at all — see
[`next-year-checklist.md`](./next-year-checklist.md).
