Fix USSEP Book Bounds (SkyPatcher)
==================================

This is a [SkyPatcher](https://www.nexusmods.com/skyrimspecialedition/mods/106659)-based
mod to fix the Object Bounds of three specific books whose bounds had been
improperly set by previous versions of the [Unofficial Skyrim Special Edition Patch (USSEP)](https://www.nexusmods.com/skyrimspecialedition/mods/266)
mod.  Specifically:

- The Book of Daedra (`Book2CommonBookofDaedra`)
- The Real Barenziah, Vol. 2 (`Book2CommonRealBarenziahV2`)
- The Wolf Queen, Vol. 4 (`Book0WolfQueenV4`)
- Immortal Blood (`Book0ImmortalBlood`)
- Totems of Hircine (`CR12TotemsOfHircineAbbr`)

Those incorrect USSEP bounds end up causing problems when using the
[Unlimited Bookshelves](https://www.nexusmods.com/skyrimspecialedition/mods/2885)
mod, because that mod uses the object bounds to know how many books can
be placed on a shelf, and where to place them.  With the USSEP-defined
bounds on those three books, there would be large empty spaces around the
books in question.

Those bounds were fixed in USSEP version v4.3.7, released 2026-02-15.  As of
early March 2026, though, a mod that I use
([Book Covers Skyrim - USSEP Update](https://www.nexusmods.com/skyrimspecialedition/mods/50615))
has not yet been updated to include the patched data from the new USSEP version,
so I'm keeping this SkyPatcher mod around until that is.

License
=======

This mod is licensed under [CC0 1.0 (Public Domain)](https://creativecommons.org/public-domain/cc0/)
([`LICENSE.txt`](LICENSE.txt)).  Do with it what you will!

Changelog
=========

**v1.1.0** - *March 13, 2026*
 - Updated with a couple more books that USSEP fixed in their v4.3.7 update
   on February 15, which have not yet been updated in the Book Covers Skyrim
   USSEP Patch mod that I'm using.

**v1.0.0** - *February 2, 2026*
 - Initial version

