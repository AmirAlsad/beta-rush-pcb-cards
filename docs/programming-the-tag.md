# Programming the brother card

The rush link is **not printed on the board and not stored in this repo.** It lives
in the NFC chip's EEPROM, written after assembly with a phone. That's a feature: the
same physical card works for any year, because you reprogram it instead of
reordering it.

Only the **brother card** has a chip. The PNM card is silkscreen only.

## What's inside

`U2` is an **NXP NT3H2111W0FHKH** — NTAG I²C *plus*, 1 kB EEPROM, in an XQFN8
package. For programming purposes what matters is that it behaves as a standard
**NFC Forum Type 2 tag**, so any generic NDEF writer works. The I²C pins (`SDA`,
`SCL`, `FD`) are unconnected on this board — everything happens over RF.

The payload is a single **NDEF URI record** pointing at the chapter's rush link.

> ### ⚠️ TODO — the exact URL is not recorded anywhere
>
> The URL written to the 2025 cards is not in the KiCad files, the gerbers, or any
> file in this archive — it exists only in whatever was typed into the phone app at
> the time. Someone who knows it should fill it in here.
>
> ```
> URL written to the 2025 brother cards:  <FILL ME IN>
> ```
>
> The card's silkscreen points at `beta.mit.edu`, so the rush link is very likely a
> path under that domain. **Verify against a real card before assuming** — tap one
> with a phone and read what comes up. See
> [`OPEN-QUESTIONS.md`](./OPEN-QUESTIONS.md).

## Writing a tag

### Android (this is how the 2025 cards were done)

Use any of these from the Play Store — all write NDEF to Type 2 tags:

- **NFC TagWriter by NXP** — the vendor app, and the one upstream's project used
- **NFC Tools** (wakdev)
- **TagInfo by NXP** — read-only; use it to *verify* what a card contains

Flow, using TagWriter as the example:

1. *Write tags ▸ New dataset ▸ Link*
2. Enter the rush URL, choose `https://`
3. *Save & Write*, then hold the card to the back of the phone

The card should read at up to a few centimetres. **`D1` lighting up means the coil
is coupling** — if the LED lights but nothing is written, the problem is the app or
the tag's lock state, not the antenna.

### iPhone

The 2025 recollection is that this "didn't work on iPhone." The most likely
explanation is the app, not the hardware: **NFC TagWriter by NXP is Android-only** —
it isn't in the App Store at all, so there is nothing to try.

iPhones *can* write NDEF tags — iPhone 7 and newer, iOS 13+, using an app built on
Core NFC such as **NFC Tools** (wakdev) or **NFC21 Tools**. Caveats that make iOS
the less pleasant option:

- Writing has to be driven from inside such an app; iOS's built-in background tag
  reading only *reads*.
- The iPhone's NFC antenna is at the **top edge of the back**, not the centre. Aiming
  at the middle of the phone often just fails. This alone explains a lot of "iPhone
  doesn't work" reports.
- A tag already locked read-only cannot be rewritten from any phone, on any OS.

**Recommendation: use an Android phone.** It's the path that's known to have worked
for this exact card, and TagWriter gives clearer error messages.

## Do not lock the tags

TagWriter and similar apps offer to make a tag **read-only** (setting the NTAG's lock
bytes). This is **irreversible in hardware** — a locked card can never be rewritten
by anyone, and its rush URL is frozen forever.

Since the entire reason these cards are reusable across years is that the URL can be
rewritten, **leave them writable.** The only argument for locking is preventing a PNM
from rewriting a card they were handed, which is not a real threat model for a
fraternity rush card.

> **Unknown:** whether the 2025 cards were locked. If a card refuses to accept a new
> URL, that's your answer — and those specific cards are permanently stuck on the
> 2025 link. Test one before promising anyone a batch is reusable.

## Verifying a batch

Before handing out cards, check each one:

1. Open **NFC TagInfo** (NXP) or NFC Tools
2. Tap the card
3. Confirm the NDEF record shows the right URL, and that the tag reads as writable

Worth doing per-card rather than per-batch — the failure mode is usually a single
cold solder joint on the XQFN8, and a card that reads fine on the bench is a card
that will work in someone's hand.

## Further reading

[`nfc-theory.md`](./nfc-theory.md) covers the RF side in depth: why the coil is
tuned to 13.56 MHz, how resonance was measured with a network analyzer, and what a
badly tuned antenna looks like on a spectrum analyzer. Useful if cards read at
noticeably shorter range than expected.
