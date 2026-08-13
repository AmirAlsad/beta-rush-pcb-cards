# Rush Cards — MIT Beta Theta Pi

Two PCB cards designed for **Beta Theta Pi, Beta Eta chapter (MIT)** rush week,
**August 30 – September 6, 2025**. They are circuit boards, not cardstock — the
whole point was that handing someone a PCB is memorable in a way a paper flyer
never is.

| | |
|---|---|
| **Brother card** | A working NFC tag. A brother taps it to a phone and the phone opens the chapter's rush link. Carried by brothers during rush. |
| **PNM card** | A silkscreen-only board printing the full week's event schedule, the house address, and the van-pickup number. Handed to PNMs (prospective new members). |

Designed in **KiCad 9.0.2**. Both boards were fabricated and used.

---

## The boards

### Brother card — front and back

<p align="center">
  <img src="./docs/renders/brother-card-front.png" width="85%" alt="Brother card front">
</p>

The left half is a 6-turn spiral NFC antenna in copper, with the Beta crest and
dragon sitting inside the coil. The right half carries the wordmark, the house
address, the tiny NFC circuit (`U2`, `C1`, `C2`, `R1`, `D1`), and a stylized map
of the walk from campus to 119 Bay State Rd — MIT's dome, Mass Ave, the Charles,
Bay State, Beacon.

<p align="center">
  <img src="./docs/renders/brother-card-back.png" width="85%" alt="Brother card back">
</p>

The back is nearly empty by design: two pads and one short trace that carry the
inner end of the coil back out from under itself. **The two-tone green/olive
split is not two solder-mask colors** — it is bare copper zones used as artwork,
so one mask color reads as two shades.

### PNM card — front and back

<p align="center">
  <img src="./docs/renders/pnm-card-front.png" width="90%" alt="PNM card front">
</p>
<p align="center">
  <img src="./docs/renders/pnm-card-back.png" width="90%" alt="PNM card back">
</p>

Silkscreen only — no components, no nets, nothing to solder. Note the
**octagonal outline**: the corners are clipped on `Edge.Cuts`, which means the
fab has to rout the profile rather than just shear a rectangle.

---

## Repo map

```
.
├── brother-card/        ← the NFC card that was fabricated (v2, 2025-07-30)
├── brother-card-v1/     ← earlier iteration, NEVER fabricated (2025-07-06)
├── pnm-card/            ← the schedule card that was fabricated (2025-07-30)
├── lib/                 ← btp.pretty + btp.kicad_sym  (MUST stay next to the projects)
└── docs/
    ├── nfc-theory.md          ← upstream's full antenna derivation, credited
    ├── programming-the-tag.md ← how to write the rush link onto a card
    ├── reordering.md          ← how to get more cards made
    ├── kicad-setup.md         ← opening these files years from now
    ├── next-year-checklist.md ← what to change to reuse these for a new rush
    ├── OPEN-QUESTIONS.md      ← facts that live only in Amir's head
    ├── renders/               ← generated board renders (+ upstream's Blender model)
    ├── images/                ← upstream's figures, referenced by nfc-theory.md
    ├── antenna-simulations/   ← upstream's LTSpice + MATLAB work
    └── reference/             ← NXP AN11276, ST AN2972, antenna calculators
```

Each card directory holds its own `README.md` with the real detail, the KiCad
source, and a `fab/` folder containing the exact gerbers that were sent out.

## Opening these in KiCad

```sh
git clone <this repo>
cd RushCards
open brother-card/PCB_Business_Card.kicad_pro   # macOS; or File ▸ Open Project
```

Two things to know before you do, both covered in
[`docs/kicad-setup.md`](./docs/kicad-setup.md):

1. **Don't move `lib/`.** Each project's `fp-lib-table` resolves the artwork
   library as `${KIPRJMOD}/../lib/btp.pretty`. That relative hop is the only
   reason the boards open with their footprints intact — the original design
   depended on a library registered *globally* on one laptop, which would have
   made this repo useless to anyone else. Vendoring it was the single most
   important fix made when archiving.
2. These were built in **KiCad 9.0.2**. A newer KiCad will offer to migrate the
   file format. Let it, but **save to a branch**, and treat `fab/` as the
   authoritative record of what was actually manufactured — see
   [`docs/reordering.md`](./docs/reordering.md).

## Lineage

The brother card is a fork of
**[Raziz1/PCB_Business_Card](https://github.com/Raziz1/PCB_Business_Card)** by
**Rahim Aziz** (forked at commit `fe6c083`). That project's contribution is the
part that is genuinely hard: deriving the antenna geometry from the NFC IC's
50 pF parallel capacitance, simulating it in LTSpice and MATLAB, and confirming
resonance at 13.56 MHz on a real board with a network analyzer. **All of that was
inherited unchanged** and is preserved verbatim in
[`docs/nfc-theory.md`](./docs/nfc-theory.md).

What Beta added: all of the artwork, the Beta symbol/footprint library, a swap to
a smaller NFC IC package with a hand-drawn footprint, and the PNM card (which is
entirely original — it shares nothing with upstream but the toolchain).

Upstream carries **no license file**, which is a loose end — see
[`docs/OPEN-QUESTIONS.md`](./docs/OPEN-QUESTIONS.md).

## Reusing these next year

Start at [`docs/next-year-checklist.md`](./docs/next-year-checklist.md). The
short version: the PNM card needs its dates and events retyped every year and
nothing else; the brother card is year-independent and can be reordered as-is,
because the rush link is written to the chip rather than printed on the board.

One thing worth knowing before you reprint the PNM card verbatim: it says
**"Saturday, August 31"**, but August 31, 2025 was a **Sunday**. The typo shipped
on the physical cards. It is preserved in the source so the archive matches the
artifact — fix it when you retype the dates.
