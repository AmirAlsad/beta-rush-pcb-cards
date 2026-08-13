# JLCPCB assembly inputs

The two files JLCPCB needs to populate the brother card, in its expected column
format. Upload them alongside the gerbers in
[`../2025-07-30_release/`](../2025-07-30_release/) when ordering **PCBA**.

| File | JLCPCB calls it | Contents |
|---|---|---|
| `jlcpcb-bom.csv` | BOM | `Comment, Designator, Footprint, JLCPCB Part #` — the 5 placed parts |
| `jlcpcb-cpl.csv` | CPL / Pick-and-place | `Designator, Mid X, Mid Y, Layer, Rotation` |

These are the files used for the 2025 run (order `10486412A`, product P3, 50 units).

## Notes

**Only 5 parts are listed, and that's correct.** `ANT1` (the spiral antenna) is copper
on the board, not a component, so it must not appear in either file. Neither should the
unnamed single-pad footprint that anchors the coil crossover. If you regenerate these
from KiCad, delete those rows — leaving them in makes JLCPCB's parts matcher fail.

**The `JLCPCB Part #` column is empty.** JLCPCB matched the parts from the manufacturer
part numbers in the `Comment` field for the 2025 order, so blank worked. To remove any
ambiguity, paste in the catalogue codes:

| Designator | Comment as submitted | Actual part ordered | JLCPCB code |
|---|---|---|---|
| `U2` | `NT3H2111W0FHKH` | NT3H2111W0FHKH | `C710403` |
| `C1` | `220n` | CL10B224KA8NNNC | `C21120` |
| `C2` | `2p` | 0603CG2R0C500NT (2.0 pF C0G 50 V) | `C1650` |
| `R1` | `65` | 0603WAF649JT5E (64.9 Ω 1%) | `C23224` |
| `D1` | `RED` | LTST-C190KRKT | `C94869` |

Note how loose the `Comment` values were — `65`, `2p`, `RED` — and JLCPCB still resolved
them sensibly. Filling in the codes makes the order deterministic instead of relying on
that.

**Coordinates are absolute KiCad board coordinates with negative Y**, exactly as KiCad
exports them. JLCPCB accepts this; don't "fix" the signs.

Full context, including the edge rails JLCPCB adds for assembly and why depaneling is
worth paying for, is in [`../../../docs/order-history.md`](../../../docs/order-history.md).
