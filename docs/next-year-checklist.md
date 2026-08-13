# Reusing these cards for a new rush

Read this first if you've inherited the repo and rush is coming.

## The important asymmetry

**The brother card is year-independent. The PNM card is not.**

Nothing on the brother card names a year, a date, or an event. The rush link lives in
the chip, not the silkscreen. So brother cards can be **reordered as-is and
reprogrammed** — and because the 2025 tags were left **unlocked**, any surviving 2025
cards can simply be rewritten instead of replaced.

The PNM card prints the entire 2025 schedule. It needs the dates and events retyped
every single year. That's the annual work.

## Do this once, and the brother cards stop needing work forever

**Set up a permanent redirect and program the tags with that**, instead of writing a
destination URL directly onto the chips.

The 2025 cards were programmed with a URL that has already gone stale — the chapter site
changed. Pick a stable path you own (`beta.mit.edu/rush`, say), point the tags at it, and
have it redirect to whatever this year's rush content is. Then future years change one
line on the website and touch zero hardware, and a card printed in 2025 still works in
2030.

The chapter has decided to go this way. Details and the field to record the chosen URL
are in [`programming-the-tag.md`](./programming-the-tag.md). **Doing this before the next
batch is programmed is the single highest-leverage thing on this page.**

## If you're only doing the minimum

1. **Brother cards** — reorder from
   [`../brother-card/fab/2025-07-30_release/`](../brother-card/fab/2025-07-30_release/)
   plus the two files in
   [`../brother-card/fab/jlcpcb-assembly/`](../brother-card/fab/jlcpcb-assembly/) for
   assembly, then write the redirect URL to each
   ([`programming-the-tag.md`](./programming-the-tag.md)). No KiCad needed at all.
   Remember: **1 mm thickness, blue mask** — see
   [`reordering.md`](./reordering.md).
2. **PNM cards** — retype the schedule (below), re-export, order. **1 mm, green mask.**
3. Or, if you have leftover 2025 brother cards: **just rewrite their tags.** No order at
   all.

## Updating the PNM card

Open `pnm-card/PNM_Rush_Card.kicad_pcb` in Pcbnew. Everything is text objects and
artwork footprints on the two silkscreen layers; there is no schematic to keep in sync
and no netlist to update. Work directly on the board.

What to change:

- [ ] **Day headings.** Eight of them: four on `F.SilkS`, four on `B.SilkS`.
- [ ] **Event lists.** One text object per day, with `\n` line breaks between events.
      Edit the whole block in one text-properties dialog.
- [ ] **The van pickup number** — currently `(617) 715-2762`. Confirm it's still the
      house line.
- [ ] **`beta.mit.edu`** if the chapter's web address ever changes.
- [ ] **Fix the 2025 typo, don't inherit it.** The 2025 card says
      **"Saturday, August 31"** for what was actually a **Sunday**. It's preserved in
      the source deliberately so the archive matches the physical card. Don't
      propagate it — and check every day-of-week against a real calendar, since this
      is exactly the mistake that survives proofreading.

Then:

- [ ] **Run DRC.** Expect only `text_thickness` warnings. If you get anything else,
      you moved something you didn't mean to.
- [ ] **Watch text size.** More events per day means smaller or thinner text, and the
      silkscreen strokes are already below KiCad's 0.15 mm minimum. Past a point the
      fab can't resolve them. If you're cramming, ask the vendor for their real
      minimum line width rather than guessing.
- [ ] **Render and read it.** Cheapest possible proofread:
      ```sh
      export PATH="/Applications/KiCad/KiCad.app/Contents/MacOS:$PATH"
      kicad-cli pcb render --side top    --width 2400 --height 1500 --quality high -o /tmp/front.png pnm-card/PNM_Rush_Card.kicad_pcb
      kicad-cli pcb render --side bottom --width 2400 --height 1500 --quality high -o /tmp/back.png  pnm-card/PNM_Rush_Card.kicad_pcb
      ```
      Have someone who *didn't* type the dates check them against a calendar.
- [ ] **Export gerbers to a new dated folder**, e.g.
      `pnm-card/fab/2026-08-01_release/`. Never overwrite `2025-07-30_release/` — it's
      the record of a physical object that exists.
- [ ] **Commit before ordering.** The commit that matches an order is what makes a
      reorder possible in three years.

## Lead time, from what actually happened in 2025

| Date (2025) | Event | Gap |
|---|---|---|
| Jul 30 | Gerbers plotted | |
| **Aug 6** | Order `10486412A` placed at JLCPCB | +7 days of sitting on it |
| Aug 9 | Brother cards finished (50, incl. assembly) | **3 days** |
| Aug 11 | PNM cards finished (350) | **5 days** |
| **Aug 30** | Rush week begins | ~3 weeks of slack |

**Order to rush: 24 days**, of which fabrication was only 3–5. Three weeks total is
comfortable; two is tight but feasible. Full detail in
[`order-history.md`](./order-history.md).

The steps that will actually bite you:

| Step | Notes |
|---|---|
| Finalise the schedule | The real blocker. You can't print a card before events are locked. |
| Fab + assembly | 3–5 days at JLCPCB in 2025. Cheap shipping tiers add much more than fab does. |
| **Depaneling** | If you skip paying for it, someone snaps 50 edge rails off by hand. Budget the hour, or tick the box. |
| Tag programming | ~15 s per card, but **per card**. Easy to forget until the night before — and unnecessary entirely if you set up the redirect above. |

## Ideas worth considering

- **Bring the doodle border back.** [`../brother-card-v1/`](../brother-card-v1/) had a
  doodle frame — gamepads, gears, a card hand, books, a handshake, the dome — that was
  cut before production. It's still in the library as `btp:doodles`, so restoring it is
  a copy-paste, not a redraw. It's the most charming artwork in this repo and it never
  got made.
- **Order more brother cards than you think you need.** Only 50 were made in 2025 versus
  350 PNM cards. The PCB cost was $23.70 — the real cost is assembly and the per-part
  feeder fees on four "Extended" parts, which are *fixed*, so the marginal cost per card
  drops fast with quantity. 50 → 200 costs far less than 4×.
- **Try one card with an exposed-copper finish.** The artwork is already copper-vs-mask;
  ordering a small batch with no mask over the crest half, or in ENIG so the copper reads
  gold, would look striking. Cheap experiment on a 50-piece run.
- **Put an NFC tag in the PNM card too.** It's currently a passive flyer. Adding the
  brother card's circuit would let a PNM tap their own card to reach the rush link —
  arguably higher value than a brother tapping *at* them. Costs five parts and
  assembly labour on the higher-volume card, so it's a real tradeoff.
- **Use a redirect, not a direct URL.** Program the tags with a short link you control
  (e.g. a `beta.mit.edu` path that redirects) rather than a deep link. Then next year's
  cards need no reprogramming at all — you just change where the redirect points. This
  is the single highest-leverage change available: it would make the brother cards
  genuinely permanent.
