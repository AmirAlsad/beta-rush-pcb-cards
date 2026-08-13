# Reusing these cards for a new rush

Read this first if you've inherited the repo and rush is coming.

## The important asymmetry

**The brother card is year-independent. The PNM card is not.**

Nothing on the brother card names a year, a date, or an event. The rush link lives in
the chip, not the silkscreen. So brother cards can be **reordered as-is and
reprogrammed**, or even reused physically if you still have them — just rewrite the
URL.

The PNM card prints the entire 2025 schedule. It needs the dates and events retyped
every single year. That's the annual work.

## If you're only doing the minimum

1. **Brother cards** — reorder from
   [`../brother-card/fab/2025-07-30_release/`](../brother-card/fab/2025-07-30_release/),
   assemble, then write the new rush URL to each
   ([`programming-the-tag.md`](./programming-the-tag.md)). No KiCad needed at all.
2. **PNM cards** — retype the schedule (below), re-export, order.

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

## Lead time, working backwards from rush

Rush 2025 started **Saturday, August 30**, and the gerbers went out **July 30** — a
**one-month** buffer covering fab, shipping, assembly, and tag programming. That's a
reasonable target. The steps that will bite you:

| Step | Notes |
|---|---|
| Finalise the schedule | The real blocker. You cannot print a card before events are locked. |
| Fab + ship | Days to weeks depending on vendor and tier. Cheap tiers are slow tiers. |
| Assembly | Brother card only. XQFN8 is slow by hand — see [`reordering.md`](./reordering.md). |
| Tag programming | ~15 s per card, but **per card**, with an Android phone. Easy to forget. |

## Ideas worth considering

- **Bring the doodle border back.** [`../brother-card-v1/`](../brother-card-v1/) had a
  doodle frame — gamepads, gears, a card hand, books, a handshake, the dome — that was
  cut before production. It's still in the library as `btp:doodles`, so restoring it is
  a copy-paste, not a redraw. It's the most charming artwork in this repo and it never
  got made.
- **Switch back to TSSOP-8** if you're hand-assembling a large batch. v1 used a
  pin-compatible TSSOP-8 NTAG; 0.65 mm pitch and gull-wing leads instead of a 1.6 mm
  QFN. See [`../brother-card-v1/README.md`](../brother-card-v1/README.md).
- **Put an NFC tag in the PNM card too.** It's currently a passive flyer. Adding the
  brother card's circuit would let a PNM tap their own card to reach the rush link —
  arguably higher value than a brother tapping *at* them. Costs five parts and
  assembly labour on the higher-volume card, so it's a real tradeoff.
- **Use a redirect, not a direct URL.** Program the tags with a short link you control
  (e.g. a `beta.mit.edu` path that redirects) rather than a deep link. Then next year's
  cards need no reprogramming at all — you just change where the redirect points. This
  is the single highest-leverage change available: it would make the brother cards
  genuinely permanent.
