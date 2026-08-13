# Programming the brother card

The rush link is **not printed on the board.** It lives in the NFC chip's EEPROM,
written after assembly with a phone. That's the good part: the same physical card works
for any year, because you reprogram it instead of reordering it.

**The 2025 tags were not locked read-only**, so every existing brother card can be
rewritten. Only the brother card has a chip — the PNM card is silkscreen only.

## Do this first: point the tags at a redirect you control

**Don't write a destination URL onto the chips. Write a permanent short link that
redirects.**

The 2025 cards were programmed with a URL that has since gone stale — the chapter
website changed and that link is no longer meaningful. The cards themselves are fine;
they just point somewhere that no longer matters. That is a completely avoidable
problem, and it will recur every time the site changes.

Instead, pick a stable path you own — something like `beta.mit.edu/rush` or
`beta.mit.edu/r` — and have it 302-redirect to wherever this year's rush content lives.
Then:

- Cards get programmed **once, ever.** Future years change the redirect target on the
  website and touch no hardware at all.
- A card printed in 2025 keeps working in 2030.
- You can repoint mid-rush if a link breaks, with cards already in people's pockets.
- You get click analytics for free, if the web host offers them.

The chapter has decided to move to this approach. Whoever sets it up should record the
chosen URL here:

```
Permanent redirect URL written to the tags:  <FILL IN ONCE CHOSEN>
Redirect currently points to:                <FILL IN>
```

## What's inside

`U2` is an **NXP NT3H2111W0FHKH** — NTAG I²C *plus*, 1 kB EEPROM, XQFN8 package
(JLCPCB `C710403`). For programming purposes it behaves as a standard **NFC Forum
Type 2 tag**, so any generic NDEF writer works. Its I²C pins are unconnected on this
board; everything happens over RF.

The payload is a single **NDEF URI record**.

Keep the URL short. NDEF URI records use a prefix byte for common schemes
(`https://www.`, `https://`, …), so a short path costs very few bytes — irrelevant
against 1 kB, but short URLs also read faster and are easier to eyeball when verifying a
batch.

## Writing a tag

### Android — the path known to work

Any of these write NDEF to Type 2 tags:

- **NFC TagWriter by NXP** — the vendor app, used for the 2025 cards
- **NFC Tools** (wakdev)
- **NFC TagInfo by NXP** — read-only; use it to *verify*

With TagWriter:

1. *Write tags ▸ New dataset ▸ Link*
2. Enter the URL, choose `https://`
3. *Save & Write*, then hold the card to the back of the phone

**`D1` lighting up means the coil is coupling.** If the LED lights but nothing writes,
the problem is the app or aim, not the antenna.

### iPhone

The 2025 recollection was that iPhone "didn't work," and the most likely reason is
simply that **NFC TagWriter by NXP is Android-only** — it isn't in the App Store, so
there was nothing to try.

iPhones *can* write NDEF tags — iPhone 7 and newer, iOS 13+, via a Core NFC app like
**NFC Tools** (wakdev) or **NFC21 Tools**. Two things trip people up:

- Writing must be driven from inside such an app. iOS's built-in background tag reading
  only *reads*.
- **The iPhone's NFC antenna is at the top edge of the back, not the centre.** Aiming at
  the middle of the phone just fails. This alone explains a lot of "iPhone doesn't work."

**Use an Android phone if you have one** — it's the known-good path and TagWriter gives
clearer errors.

## Don't lock the tags

TagWriter and similar apps offer to make a tag **read-only** by setting the NTAG's lock
bytes. This is **irreversible in hardware**: a locked card can never be rewritten by
anyone, ever.

The 2025 run was left **unlocked**, which is correct and worth continuing. The whole
reusability story — and the redirect strategy above — depends on tags staying writable.
The only argument for locking is stopping a PNM from rewriting a card they were handed,
which isn't a real concern here.

## Verifying a batch

Before handing cards out, check each one with **NFC TagInfo** or NFC Tools:

1. Tap the card
2. Confirm the NDEF record shows the right URL
3. Confirm the tag still reads as writable

Do this per card, not per batch. The realistic failure mode is a single bad joint on one
XQFN8, and a card that reads on the bench is a card that works in someone's hand.

## If cards read at short range

Range depends on how close the antenna's resonance sits to 13.56 MHz.
[`nfc-theory.md`](./nfc-theory.md) covers the measurement in depth — sweeping the antenna
with a network analyzer and adjusting `C2`.

For the 2025 cards `C2` was **2.0 pF** (`0603CG2R0C500NT`), confirmed from the JLCPCB
parts list, and that worked. Upstream's 3.9 pF figure was for *their* board geometry.
Don't change `C2` speculatively — measure first.
