# Order history — the 2025 run

Both cards were made by **JLCPCB** under a single order, **`10486412A`**, split into
two products:

| | Product | What | Qty | PCB cost |
|---|---|---|---|---|
| **P3** | `Success_P3` | Brother card, **blue**, **assembled by JLCPCB** | **50** | **$23.70** |
| **P4** | `Output Files_P4` | PNM card, **green**, bare board | **350** | **$86.10** |
| | | | | **≈ $400 paid in total** — see below |

> ### 💸 The real number is **≈ $400 all-in**, not $109.80
>
> The $109.80 above is **only the two PCB line items**. The actual amount paid for the
> whole order was **about $400**, and **delivery and import tariffs took a significant
> chunk of it.**
>
> | | |
> |---|---|
> | PCB line items (documented) | **$109.80** |
> | Assembly + components + shipping + tariffs | **≈ $290** |
> | **Total paid** | **≈ $400** |
>
> The split within that $290 is not recorded — only that shipping and tariffs were a
> large share of it. **Plan against $400, not $110.** The price JLCPCB quotes you on the
> order page is roughly a quarter of what leaves your account, because assembly, parts,
> freight, and US import duty on Chinese-manufactured goods all land afterward.
>
> Blended, that's **~$1 per card across 400 cards** — still cheap for what these are. But
> the 50 brother cards carry essentially all of the assembly and component cost, so their
> true unit cost is many times the PNM cards'.

Reconstructed from `docs/order-history/`: four screenshots of JLCPCB's order pages,
and JLCPCB's own internal CAM job records (`4te.json`) recovered from the production
file downloads.

## Timeline

| Date (2025) | Event |
|---|---|
| **Jul 30** | Gerbers plotted from KiCad 9.0.2 → `fab/2025-07-30_release/` in both cards |
| **Aug 6** | Order `10486412A` placed (JLCPCB accounting timestamp 16:15 UTC) |
| **Aug 9** | P3 brother cards finished — **3 days**, including assembly |
| **Aug 11** | P4 PNM cards finished — **5 days** |
| **Aug 30** | Rush week begins |

**Order to rush: 24 days.** Fabrication itself was only 3–5 days; the rest was
shipping, tag programming, and slack. If you're planning a reorder, three weeks is
comfortable and two is tight but feasible.

## Provenance: the repo's gerbers are exactly what JLCPCB received

Verified by byte-comparison against the gerber sets recovered from the order
downloads:

```
brother-card/fab/2025-07-30_release/  ==  JLCPCB's Success_P3 upload    (byte-identical)
pnm-card/fab/2025-07-30_release/      ==  JLCPCB's Output Files_P4 upload (byte-identical)
```

So reordering from those folders reproduces the 2025 cards exactly. This is not an
inference — the files were diffed.

## As-ordered specification

Both cards shared most settings. **Where the order differs from the KiCad file, the
order wins** — those rows are called out.

| Setting | Brother card (P3) | PNM card (P4) |
|---|---|---|
| Layers | 2 | 2 |
| Base material | FR-4 | FR-4, TG135 |
| **Thickness** | **1 mm** ⚠️ | **1 mm** ⚠️ |
| **Solder mask** | **Blue** ⚠️ | **Green** |
| Silkscreen | White | White |
| Silkscreen process | Ink-jet | Ink-jet |
| Outer copper | 1 oz | 1 oz |
| Surface finish | Lead-free HASL (see note) | HASL with lead |
| Via covering | Tented | Tented |
| Dimension as entered | 88.9 × 70.8 mm (**includes rails**) | 90 × 55 mm |
| Panel | 1 × 1, "single piece, please repeat the data" | Single PCB |
| Electrical test | Flying probe, random | Flying probe, random |
| Appearance | IPC Class 2 | IPC Class 2 |
| Outline tolerance | ±0.2 mm | ±0.2 mm |
| Mark on PCB | Order number | Order number |
| Build time quoted | 3–4 days | 5–6 days |

### ⚠️ 1 mm, not the 1.6 mm in the KiCad file

**Both cards were ordered at 1 mm thickness. Every KiCad file in this repo says
1.6 mm.** Nothing reconciles this automatically — thickness is an order-page dropdown
and is not carried in the gerbers.

1 mm is the right call for something people put in a wallet; 1.6 mm feels like a
circuit board rather than a card. **If you reorder and accept the default, you will
get noticeably chunkier cards than the 2025 run.** Set 1 mm explicitly.

### ⚠️ The brother card is blue, the PNM card is green

The renders in this repo were regenerated to match
([`../tools/render-boards.sh`](../tools/render-boards.sh) injects the as-ordered mask
colour, since KiCad doesn't store it). Upstream's card was green, and the docs
originally assumed the Beta cards were too — they aren't.

Remember the olive/lighter shade on each card is **bare copper under one mask
colour**, not a second mask. On the blue card the copper half reads blue-violet.

### Surface finish: the records disagree

The order page for P3 says **HASL with lead**; JLCPCB's internal CAM record for the
same product says **无铅喷锡 — lead-free HASL**. JLCPCB requires lead-free finish for
assembled boards, which is the likely explanation: the finish was changed when the
product went through SMT. P4 (bare board, no assembly) says leaded in both places.
Not worth chasing, but don't be surprised if a reorder quotes differently once
assembly is added.

## Assembly (brother card only)

**The brother cards were machine-assembled by JLCPCB.** They were not hand-soldered —
which retires the biggest worry about the XQFN8 package.

| Parameter | Value |
|---|---|
| PCBA type | Standard, **top side only** |
| Quantity | 50 |
| Solder paste | High temp |
| Edge rails / fiducials | **Added by JLCPCB** |
| Depanel before delivery | **No** — see below |
| Packaging | Antistatic bubble film |
| Board cleaning / conformal coating / function test | No |
| Photo confirmation | No |
| Assembly build time | 2–3 days |

### The 20 mm of edge rails, and why the dimension says 70.8 mm

The brother card is 88.9 × 50.8 mm, but the order reads 88.9 × **70.8** mm. That's not
a typo. JLCPCB's CAM record spells it out (translated from the Chinese order remark):

> *[System auto-appended: this order is SMT-assembled at JLCPCB. Please check the
> process edge and Mark point requirements; if absent, please add.] Due to SMT process
> requirements the size is now auto-padded to 7 cm — two 1.00 cm process edges must be
> added in the 5.08 cm direction. 【An SMT-specific QR code and human-readable code must
> be added on the process edge, 10 mm from the Mark point, parallel to the board edge,
> added on both sides. Note: this is the SMT-specific QR code.】*

So: 50.8 mm + 2 × 10 mm rails = 70.8 mm. The rails carry the fiducials and JLCPCB's
SMT tracking QR code, and they are **V-scored** off the card — `jlcpcb-cam-p3/vcut.gbr`
in this repo is JLCPCB's V-cut layer, and `qrt.gbr` / `qrb.gbr` are the QR codes.

**Two practical consequences:**

1. **"Depanel boards & edge rail before delivery: No"** — the 50 brother cards arrived
   with the rails still attached. Somebody had to snap 50 rails off along the V-score
   and live with the resulting edge. Combined with "Deburring/Edge rounding: No", those
   two long edges will not be as clean as the routed sides. **For a reorder, paying
   JLCPCB to depanel is worth it on a card you hand to strangers.**
2. The QR code and tracking marks land **on the rails**, so they're discarded with them
   and the card faces stay clean. Good outcome, and worth preserving — if you change the
   panel, check where the marks end up.

Note the PNM card has **no** `vcut` layer and no drill file in its production set,
confirming its octagonal outline was **routed**, as intended.

### Order-number marking

Both products were ordered with **Mark on PCB: Order Number**, meaning JLCPCB prints a
small order number somewhere on the board — JLCPCB chooses where. On the brother card
this was folded into the SMT marks on the rails. **On the PNM card there is likely a
small JLCPCB order number printed on a face**, since it has no rails to hide it on.

If a clean face matters for the PNM card, choose **"Remove order number"** (a small
surcharge) or **"Specify a location"** on the next order.

## The real bill of materials

JLCPCB's parts list from the assembly order — actual manufacturer part numbers and
JLCPCB catalogue codes. This is the authoritative BOM; it supersedes the generic
values in the schematic.

| Ref | Value | Manufacturer part | JLCPCB code | Library tier |
|---|---|---|---|---|
| `U2` | NTAG I²C plus | **NT3H2111W0FHKH** | `C710403` | Extended |
| `C1` | 220 nF 0603 | **CL10B224KA8NNNC** (Samsung, X7R) | `C21120` | **Basic** |
| `C2` | **2.0 pF** 0603 C0G 50 V | **0603CG2R0C500NT** | `C1650` | Extended |
| `R1` | **64.9 Ω** 1% 0603 | **0603WAF649JT5E** (Uniroyal) | `C23224` | Extended |
| `D1` | Red LED 0603 | **LTST-C190KRKT** (Lite-On) | `C94869` | Extended |

Four of the five are **Extended** parts, which at JLCPCB means a per-part feeder setup
fee on top of component cost. That's a fixed cost, so it hurts far less at larger
quantities — relevant if you're deciding between 50 and 200 cards.

### This settles the `C2` question

The tuning capacitor was **2.0 pF** (`0603CG2R0C500NT` — `2R0` = 2.0 pF, C0G, 50 V),
matching the `2p` in the schematic. Upstream's 3.9 pF and 1.5 pF figures were *their*
board, not this one. The Beta cards shipped with 2.0 pF and worked.

If you want to squeeze out more read range you could still sweep the value on hardware
(see [`nfc-theory.md`](./nfc-theory.md)), but **2.0 pF is now a known-good answer, not
a guess** — reorder with it.

## Files to re-upload for a reorder

| Upload this | For |
|---|---|
| `brother-card/fab/2025-07-30_release/` (zipped) | Brother card gerbers |
| `brother-card/fab/jlcpcb-assembly/jlcpcb-bom.csv` | JLCPCB-format BOM |
| `brother-card/fab/jlcpcb-assembly/jlcpcb-cpl.csv` | JLCPCB-format placement (CPL) |
| `pnm-card/fab/2025-07-30_release/` (zipped) | PNM card gerbers |

The BOM and CPL are in JLCPCB's expected column format and are ready to upload as-is.
The BOM's `JLCPCB Part #` column is blank — that's fine, JLCPCB matched the parts from
the manufacturer part numbers, but you can paste the `C…` codes from the table above to
remove any ambiguity.

Then set: **1 mm thickness**, **blue** (brother) / **green** (PNM), white silkscreen,
1 oz copper, tented vias, and **depaneling if you're ordering assembly.**

## What's archived here

```
docs/order-history/
├── jlcpcb-p3-brother-pcb-spec.png    order page: brother card, 50 pcs, $23.70, blue
├── jlcpcb-p4-pnm-pcb-spec.png        order page: PNM card, 350 pcs, $86.10, green
├── jlcpcb-p3-pcba-parameters.png     assembly options for the brother card
├── jlcpcb-p3-pcba-bom.png            the 5 parts with JLCPCB catalogue codes
├── jlcpcb-p3-cam-record.json         JLCPCB's internal CAM job record (brother)
├── jlcpcb-p4-cam-record.json         JLCPCB's internal CAM job record (PNM)
└── jlcpcb-cam-p3/                    JLCPCB's production layers for the brother panel
    ├── vcut.gbr                      V-score lines separating card from edge rails
    ├── qrt.gbr, qrb.gbr              SMT tracking QR codes (on the rails)
    ├── ko.gbr                        board outline as JLCPCB resolved it
    ├── drl.gbr                       drill
    └── ts.gbr, bs.gbr                solder mask
```

The two `*-cam-record.json` files contain **GBK-encoded Chinese strings** — they will
look like mojibake in a UTF-8 editor. To read them:

```sh
python3 -c "
import json,sys
d=json.loads(open(sys.argv[1],'rb').read().decode('utf-8','surrogateescape'))
fix=lambda v: v.encode('utf-8','surrogateescape').decode('gbk') if isinstance(v,str) else v
print(fix(d['orderRemark']))
" docs/order-history/jlcpcb-p3-cam-record.json
```

JLCPCB's bulkier CAM outputs (`.ddw`, `.tgz`, and its re-derived copper/silkscreen
gerbers, ~16 MB) were **not** kept: they're JLCPCB's regeneration of gerbers this repo
already holds byte-identically, so they add weight without adding information.
