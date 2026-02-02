Fix USSEP Book Bounds (SkyPatcher)
==================================

This is a [SkyPatcher](https://www.nexusmods.com/skyrimspecialedition/mods/106659)-based
mod to fix the Object Bounds of three specific books whose bounds had been
improperly set by the [Unofficial Skyrim Special Edition Patch (USSEP)](https://www.nexusmods.com/skyrimspecialedition/mods/266)
mod.  Specifically:

- The Book of Daedra (`Book2CommonBookofDaedra`)
- The Real Barenziah, Vol. 2 (`Book2CommonRealBarenziahV2`)
- The Wolf Queen, Vol. 4 (`Book0WolfQueenV4`)

The USSEP bounds end up causing problems when using the
[Unlimited Bookshelves](https://www.nexusmods.com/skyrimspecialedition/mods/2885)
mod, because that mod uses the object bounds to know how many books can
be placed on a shelf, and where to place them.  With the USSEP-defined
bounds on those three books, there would be large empty spaces around the
books in question.

Ths was reported over to USSEP in [bug #36209](https://afktrack.afkmods.com/index.php?a=issues&i=36209),
and it looks like it'll probably get fixed whenever the next USSEP release
happens (as of February 2, 2026, the latest USSEP version is 4.3.6c).

Until then, I wanted to have it fixed for my current playthrough, so I
put together this patch to do so.

Note that other mods such as
[Book Covers Skyrim - USSEP Update](https://www.nexusmods.com/skyrimspecialedition/mods/50615)
have incorporated the USSEP bounds changes into their mods as well, so once
USSEP fixes the bug, other mods may need updating as well.

License
=======

This mod is licensed under [CC0 1.0 (Public Domain)](https://creativecommons.org/public-domain/cc0/)
([`LICENSE.txt`](LICENSE.txt)).  Do with it what you will!

Changelog
=========

**v1.0.0** - *February 2, 2026*
 - Initial version

