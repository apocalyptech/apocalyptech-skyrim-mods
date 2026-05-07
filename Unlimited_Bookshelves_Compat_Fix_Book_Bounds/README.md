Unlimited Bookshelves Compat - Fix Book Bounds (SkyPatcher)
===========================================================

This is a [SkyPatcher](https://www.nexusmods.com/skyrimspecialedition/mods/106659)-based
mod to fix the Object Bounds of various books whose bounds are
either missing or which have been improperly set by various mods
in the past.  Missing or incorrect object bounds on book objects can
cause weirdness while using the [Unlimited Bookshelves](https://www.nexusmods.com/skyrimspecialedition/mods/2885)
mod -- books can start clipping into each other or leaving large
empty spaces on the shelves, for instance.

Many of these bounds have been steadily getting fixed up by the
[Unofficial Skyrim Special Edition Patch (USSEP)](https://www.nexusmods.com/skyrimspecialedition/mods/266)
over time, but other book-related mods can be slower to update.
[Book Covers Skyrim](https://www.nexusmods.com/skyrimspecialedition/mods/901)
hasn't been updated since 2017, for instance.  Its [USSEP Update](https://www.nexusmods.com/skyrimspecialedition/mods/50615)
compatibility mod is updated more frequently, but can lag behind,
and not all of these fixes are appropriate for that mod anyway,
since not all these books are even touched by Book Covers Skyrim.
And, of course, many folks might not want to use USSEP anyway.

All of the fixes done by this mod have been reported to the
appropriate places (USSEP bugtracker, or the mods themselves), so
hopefully over time the need for this mod will shrink to zero.  In
the meantime, it should help beautify bookshelves for anyone using
Unlimited Bookshelves!

Base-game books fixed up by this mod:

- The Book of Daedra (`Book2CommonBookofDaedra`, fixed in USSEP v4.3.7, but broken as of [Book Covers Skyrim 4.2](https://www.nexusmods.com/skyrimspecialedition/mods/50615?tab=posts&comment_id=166735315))
- The Real Barenziah, Vol. 2 (`Book2CommonRealBarenziahV2`, fixed in USSEP v4.3.7, but broken as of [Book Covers Skyrim 4.2](https://www.nexusmods.com/skyrimspecialedition/mods/50615?tab=posts&comment_id=166735315))
- The Wolf Queen, Vol. 4 (`Book0WolfQueenV4`, fixed in USSEP v4.3.7, but broken as of [Book Covers Skyrim 4.2](https://www.nexusmods.com/skyrimspecialedition/mods/50615?tab=posts&comment_id=166735315))
- Immortal Blood (`Book0ImmortalBlood`, fixed in USSEP v4.3.7, but broken as of [Book Covers Skyrim 4.2](https://www.nexusmods.com/skyrimspecialedition/mods/50615?tab=posts&comment_id=166735315))
- Totems of Hircine (`CR12TotemsOfHircineAbbr`, fixed in USSEP v4.3.7)
- Tamrielic Lore: Revised (`Book3ValuableTamrielicLoreRevised`, reported to [USSEP](https://afktrack.afkmods.com/index.php?a=issues&i=36398) and likely to be fixed in v4.3.9)
- Three Thieves (`SkillSneak1`, reported to [Book Covers Skyrim](https://www.nexusmods.com/skyrimspecialedition/mods/901?tab=posts&comment_id=166774753))

Saints & Seducers Creation Club books fixed up by this mod:

- Heretical Thoughts (`ccBGSSSE025_HereticalThoughts_Book02`, fixed in USSEP v4.3.8)
- Spell Tome: Conjure Golden Saint Archer (`ccBGSSSE025_SpellTomeConjureGoldenSaintArcher`, fixed in USSEP v4.3.8)
- Spell Tome: Conjure Golden Saint Warrior (`ccBGSSSE025_SpellTomeConjureGoldenSaintWarrior`, fixed in USSEP v4.3.8)
- Spell Tome: Conjure Dark Seducer Archer (`ccBGSSSE025_SpellTomeConjureDarkSeducerArcher`, fixed in USSEP v4.3.8)
- Spell Tome: Conjure Dark Seducer Warrior (`ccBGSSSE025_SpellTomeConjureDarkSeducerWarrior`, fixed in USSEP v4.3.8)
- Spell Tome: Conjure Staada (`ccBGSSSE025_SpellTomeConjureStaada`, fixed in USSEP v4.3.8)

Dawnguard books fixed up by this mod:

- Spell Tome: Heal Undead (`DLC1SpellTomeHealUndead`, reported to [USSEP](https://afktrack.afkmods.com/index.php?a=issues&i=36495) and likely to be fixed in v4.3.9)

Books from other mods:
- Spell Tome: Summon Lenora (`DZ05_SpellTomeSummonLenora` - from [Lenora - CVR Custom Voiced Merchant Follower](https://www.nexusmods.com/skyrimspecialedition/mods/104446), fixed in v1.1.2)
- Spell Tome: I Need A Merchant (`DZ06_SummonAronelSpellTome` - from [Aronel - CVR Custom Voiced Follower And Merchant](https://www.nexusmods.com/skyrimspecialedition/mods/106001), fixed in v1.1.1)

One of the nice things about SkyPatcher-based mods is that none of those
are actual dependencies.  Any commands referencing mod content that's not
present in your game will just be ignored.  If anyone finds other books from
other mods which could use similar bounds tweaking, in lieu of updating the
mod itself (such as for abandoned mods, etc), let me know and it should be
easy enough to add them in here.

As of v1.2.0, this mod's also been uploaded to Nexus at
<https://www.nexusmods.com/skyrimspecialedition/mods/178309>.

Installation
============

Ensure that SkyPatcher is installed, and then copy `Unlimited_Bookshelves_Compat_Fix_Book_Bounds.ini`
into Skyrim's `Data/SKSE/Plugins/SkyPatcher/book` directory.

License
=======

This mod is licensed under [CC0 1.0 (Public Domain)](https://creativecommons.org/public-domain/cc0/)
([`LICENSE.txt`](LICENSE.txt)).  Do with it what you will!

Changelog
=========

**v1.2.0** - *April 24, 2026*
 - Renamed from "Fix USSEP Book Bounds" to "Unlimited Bookshelves Compat -
   Fix Book Bounds"
 - Added fixes for various Saints & Seducers books
   - Heretical Thoughts
   - Spell Tomes: Conjure Golden Saint Archer + Warrior, Conjure Dark
     Seducer Archer + Warrior, Conjure Staada
 - Added fix for Tamrielic Lore: Revised
 - Added fix for Dawnguard's Spell Tome: Heal Undead
 - Added fix for Three Thieves (broken by Book Covers Skyrim)
 - Added fix for the follower-summoning spells added by the merchant follower
   mods "Lenora - CVR Custom Voiced Merchant Follower" and "Aronel - CVR
   Custom Voiced Follower And Merchant"
 - Uploaded to Nexus

**v1.1.0** - *March 13, 2026*
 - Updated with a couple more books that USSEP fixed in their v4.3.7 update
   on February 15, which have not yet been updated in the Book Covers Skyrim
   USSEP Patch mod that I'm using.

**v1.0.0** - *February 2, 2026*
 - Initial version

