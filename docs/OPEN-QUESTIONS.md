# Open questions

Facts that were not recoverable from any file in this archive. They exist only in
memory or in someone's order history. Each one is filled in with a **best inference
and its basis**, so the docs are usable now — but they should be confirmed and
corrected.

If you know an answer, edit it into the linked doc *and* delete the entry here.

---

## 1. The rush URL written to the NFC chips — **highest value**

**What's missing:** the exact URL written to the 2025 brother cards.

**Why it's not in the repo:** it was typed into a phone app after assembly. It's in
the chip's EEPROM, not in any design file.

**Best inference:** something under `beta.mit.edu`, which is the domain printed on
the card's silkscreen. Not verified.

**How to settle it in 30 seconds:** tap a surviving 2025 card with any phone and read
what comes up.

→ [`programming-the-tag.md`](./programming-the-tag.md)

---

## 2. Were the tags locked read-only?

**Why it matters:** locking an NTAG is **irreversible in hardware**. If the 2025 cards
were locked, they're permanently frozen on the 2025 URL and cannot be reused — which
undermines the "brother cards are year-independent" claim that
[`next-year-checklist.md`](./next-year-checklist.md) is built on.

**Best inference:** probably *not* locked — locking is an opt-in checkbox in NFC
TagWriter that you have to deliberately confirm.

**How to settle it:** try writing a new URL to an existing card. If it refuses, they
were locked.

→ [`programming-the-tag.md`](./programming-the-tag.md)

---

## 3. Which app actually programmed the cards, and the iPhone story

**What's known:** it was done on an Android device; iPhone reportedly didn't work.

**Best inference for the iPhone failure:** NFC TagWriter by NXP is **Android-only** —
it isn't in the App Store, so there was nothing to install. iPhones (7+, iOS 13+)
*can* write NDEF tags with a Core NFC app like NFC Tools. A second likely factor: the
iPhone's NFC antenna is at the **top edge of the back**, so aiming at the middle of
the phone silently fails.

**Worth confirming:** which specific app was used, and whether the iPhone attempt was
"app didn't exist" or "app existed and failed."

→ [`programming-the-tag.md`](./programming-the-tag.md)

---

## 4. Fab vendor, quantity, cost, and turnaround

**What's missing:** where the cards were ordered, how many, what they cost per unit,
and how long they took — for **both** cards.

**Best inference:** upstream used **PCBWay** via its KiCad plugin, and this project
inherited upstream's documented order spec, so PCBWay is the likely vendor. Unverified.

**Why it matters most of all:** "what did N of these cost and how long did they take"
is the first question any future rush chair will ask, and it's the one thing no amount
of file archaeology can recover.

**Where to look:** email order confirmations from around **July 30 – August 2025**.

→ [`reordering.md`](./reordering.md)

---

## 5. Were the brother cards hand-assembled or machine-assembled?

**Why it matters:** it determines whether a future year should keep the XQFN8 or revert
to v1's much easier TSSOP-8.

**Best inference:** hand-assembled — the `fab/2025-07-30_placement/` folder contains a
Numbers spreadsheet reconciling placement positions, which reads like someone working
through parts manually rather than handing a CPL file to an assembler.

→ [`reordering.md`](./reordering.md)

---

## 6. What `C2`, the tuning capacitor, actually was

**The problem:** three different values appear across the sources.

| Source | Value |
|---|---|
| This repo's schematic + BOM | `2p` |
| Upstream's measured bring-up | `3.9 pF` → 13.555 MHz |
| Upstream's final parts list | `1.5 pF` |

**Best inference:** `2p` in the schematic is a placeholder that was never updated, and
the physically-fitted part is unknown. `3.9 pF` is the only value with a measurement
behind it on this antenna geometry.

**How to settle it:** measure `C2` on a real card, or just retune on hardware next time.

→ [`../brother-card/README.md`](../brother-card/README.md), [`reordering.md`](./reordering.md)

---

## 7. Solder mask and silkscreen colours actually ordered

**Best inference:** green mask, white silkscreen — matching upstream's documented spec
and consistent with the renders.

**Not a guess:** the olive/green two-tone is definitely **bare copper zones under one
mask**, not two mask colours. That was read directly from the board file.

→ [`reordering.md`](./reordering.md)

---

## 8. Photographs of the real cards

**What's missing:** there is **not one photograph of either finished Beta card** in this
archive. Every photo in `images/` is upstream's green `Rahim Aziz` card, and the only
pictures of the Beta cards are CLI-generated renders in `renders/`.

**Why it matters:** renders don't show solder quality, real silkscreen legibility, how
the copper artwork catches light, or the LED lighting up. For a card whose whole point
was being a physical object, that's the biggest documentation gap after the URL.

**Ask for:** front and back of both cards, one with `D1` lit mid-read, and any photos
from rush week of cards being handed out.

---

## 9. Upstream licensing

**The situation:** [Raziz1/PCB_Business_Card](https://github.com/Raziz1/PCB_Business_Card)
has **no license file**. This repo reproduces its `README.md` verbatim as
[`nfc-theory.md`](./nfc-theory.md) along with its figures, simulations, and reference
documents, with attribution throughout.

**Why it's a loose end:** absent a license, upstream retains all rights by default.
Attribution is the right thing to do and normal fork etiquette, but it isn't the same
as permission. This repo is public.

**Suggested fix:** open an issue or email Rahim Aziz asking him to add a license (MIT
or CC-BY would both suit), or asking for explicit permission to redistribute. It costs
one message and removes the ambiguity. If he'd rather not, the fallback is to strip
`nfc-theory.md` and the inherited `images/` + `antenna-simulations/` assets down to
links.

**Partially resolved:** Beta's original work — the artwork, the `btp` library, the
board layouts, the PNM card, and this documentation — is now **MIT licensed**, and
[`../LICENSE`](../LICENSE) states explicitly which files that does *not* cover
(upstream's material, the vendor application notes, and the fraternity's insignia).
**Still open:** getting an actual grant from Rahim for the upstream material.
