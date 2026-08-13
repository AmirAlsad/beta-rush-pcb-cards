# Open questions

What still isn't recorded anywhere. Most of the original list has been closed — the
resolved items are kept at the bottom so nobody re-investigates them.

If you close one, edit the answer into the relevant doc and move the entry down here.

---

## Still open

Only two, and neither blocks a reorder.

### 1. Which app programmed the tags, precisely

Known: it was an Android device, and iPhone reportedly didn't work.

**Best explanation for the iPhone failure:** NFC TagWriter by NXP is **Android-only** —
it isn't in the App Store, so there was nothing to install. A second likely factor is
that the iPhone's NFC antenna sits at the **top edge of the back**, so aiming at the
middle of the phone silently fails. iPhones (7+, iOS 13+) *can* write NDEF with a Core
NFC app like NFC Tools.

Low stakes — the Android path is documented and works. Worth a sentence if anyone
remembers the specific app.

→ [`programming-the-tag.md`](./programming-the-tag.md)

### 2. Upstream licensing

[Raziz1/PCB_Business_Card](https://github.com/Raziz1/PCB_Business_Card) has **no license
file**. This repo reproduces its `README.md` verbatim as [`nfc-theory.md`](./nfc-theory.md)
along with its figures, simulations, and reference documents, with attribution throughout.

Absent a license, upstream retains all rights by default. Attribution is the right thing
to do and normal fork etiquette, but it isn't the same as permission — and this repo is
public.

**Suggested fix:** open an issue or email Rahim Aziz asking him to add a license (MIT or
CC-BY would both suit), or for explicit permission to redistribute. One message, and the
ambiguity is gone. If he'd rather not, the fallback is stripping `nfc-theory.md` and the
inherited `images/` + `antenna-simulations/` assets down to links.

**Already handled:** Beta's own original work is MIT licensed, and [`../LICENSE`](../LICENSE)
states explicitly which files that does *not* cover — upstream's material, the NXP/ST
application notes, and the fraternity's insignia.

---

## Resolved

### ~~Photographs of the real cards~~ — none were ever taken

Confirmed: **no photographs of either finished Beta card exist.** This isn't a matter of
finding them; they were never shot. Not recoverable, and no further searching is warranted.

**Consequence:** the CLI renders in [`renders/`](./renders/) are the *only* visual record
of these cards. They're geometrically faithful and now in the correct as-ordered mask
colours, but they cannot show solder quality on the XQFN8, real silkscreen legibility at
1 mm, how the bare-copper artwork catches light, the snapped edge where the assembly rails
came off, or `D1` lit mid-tap.

**Action moved forward, not closed:** the next batch should be photographed on arrival.
[`next-year-checklist.md`](./next-year-checklist.md) has this as an explicit step — it's
the one thing this archive cannot reconstruct after the fact.

### ~~Assembly and component cost~~ — total known, breakdown isn't

**About $400 was paid for the whole order**, against $109.80 of documented PCB line items.
The remaining ≈$290 covers assembly, components, shipping, and **US import tariffs**, with
delivery and tariffs taking a significant share. The split among those four is not
recorded, and chasing it further isn't worth it.

The planning number — **budget 3–4× the PCB quote** — is what actually mattered, and it's
now in [`reordering.md`](./reordering.md) and
[`next-year-checklist.md`](./next-year-checklist.md).

### ~~The rush URL written to the NFC chips~~ — moot, and superseded

The 2025 tags were programmed with a URL that has since gone stale: the chapter website
changed and that link no longer points anywhere meaningful. Recovering the exact string
would be archaeology with no payoff.

**What replaced the question:** the chapter is moving to programming the tags with a
**permanent redirect it controls** (a stable `beta.mit.edu/rush`-style path) so that
future years change the redirect target on the website and never reprogram hardware.
That makes the historical URL irrelevant by design. See
[`programming-the-tag.md`](./programming-the-tag.md), which has a field to record the
redirect URL once chosen.

### ~~Were the tags locked read-only?~~ — No

Confirmed unlocked. Every surviving 2025 brother card can be rewritten, so the
"brother cards are year-independent" claim in
[`next-year-checklist.md`](./next-year-checklist.md) holds, and the redirect plan above is
viable on existing hardware.

### ~~Fab vendor, quantity, cost, turnaround~~ — JLCPCB, order `10486412A`

50 brother cards at $23.70 and 350 PNM cards at $86.10, **≈$400 paid in total**; ordered
Aug 6 2025, finished Aug 9 and Aug 11. Full record in
[`order-history.md`](./order-history.md), reconstructed from screenshots and JLCPCB's own
CAM job records.

Bonus discoveries from that record, all of which contradicted earlier assumptions:

- **Both cards are 1 mm thick**, not the 1.6 mm in the KiCad files.
- **The brother card is blue**, not green. The PNM card is green.
- JLCPCB adds **two 10 mm edge rails** to the brother card for assembly, V-scored off,
  and **depaneling was not paid for** — the cards arrived with rails attached.
- The repo's `fab/…_release/` folders are **byte-identical to what JLCPCB received**.

### ~~Hand-assembled or machine-assembled?~~ — Machine, by JLCPCB

Standard PCBA, top side, 50 units, high-temp paste, with JLCPCB-added edge rails and
fiducials. The earlier guess of hand-soldering (inferred from a placement spreadsheet) was
wrong. This also defuses the concern about the XQFN8's 0.5 mm pitch — a pick-and-place
doesn't care.

### ~~What `C2`, the tuning capacitor, actually was~~ — 2.0 pF

`0603CG2R0C500NT`, 2.0 pF C0G 50 V, JLCPCB `C1650`. This matches the `2p` in the
schematic. Upstream's 3.9 pF (measured) and 1.5 pF (parts list) figures were for *their*
board geometry. The Beta cards shipped with 2.0 pF and worked — reorder with it.

The full as-built BOM with manufacturer part numbers and JLCPCB catalogue codes is in
[`order-history.md`](./order-history.md) and
[`../brother-card/fab/jlcpcb-assembly/`](../brother-card/fab/jlcpcb-assembly/).

### ~~Solder mask and silkscreen colours~~ — Blue and green, both white silkscreen

Brother card **blue**, PNM card **green**, white silkscreen on both, ink-jet printed. The
renders in this repo now reflect this. Confirmed independently from the order pages and
JLCPCB's CAM records.

Unchanged and worth restating: the two-tone effect on each card is **bare copper under a
single mask colour**, not two mask colours.

### ~~Surface finish~~ — resolved as far as it matters

The order page for the brother card says HASL **with lead**; JLCPCB's CAM record for the
same product says **lead-free**. JLCPCB requires lead-free finish on assembled boards,
which is the likely explanation. The PNM card says leaded in both places. No action
needed, but don't be surprised if a reorder quotes differently once assembly is added.
