Improved College of Winterhold Tome Vendors Stock (SkyPatcher)
==============================================================

This is a [SkyPatcher](https://www.nexusmods.com/skyrimspecialedition/mods/106659)-based
mod which ensures that all non-Master-level spell tomes are available
for sale by the associated teachers at the College of Winterhold.  The
statements adding the Master-level spells are included in the mod as well,
but commented out by default.  The mod ensures at least 2 of each tome,
though the usual inventory generation procedure will mean that various
tomes will have more than that available.

This mod really should be smarter than it is -- there are various
spells which are only meant to be unlocked after doing various quests,
etc, and the *intention* of the mod was not to provide early unlocks
for anything.  More I just didn't want to have to engage with RNG
repeatedly to acquire all the available spells for my character, so
I figured this would do the trick.  Anyway, c'est la vie!  I lack the
drive to do something "smarter" in the mod, at the moment.

The mod is generated entirely by code, inside
[xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit).

The script was run against a mod set which includes the usual stock
Skyrim content (Dawnguard, Dragonborn), the free/included-by-default
Special Edition Creation Club content (Saints & Seducers), and also
a couple of other mods of mine which add in a Tome.  One of the nice
things about SkyPatcher mods is that any invalid/missing references
just means that the statement is skipped, so none of those are actual
requirements.

I'm probably not super likely to post this to Nexus, primarily since it
doesn't lock tome addition behind the proper quest unlocks.

Installation
============

Ensure that SkyPatcher is installed, and then copy
`Improved_College_of_Winterhold_Tome_Vendors_Stock.ini` into Skyrim's
`Data/SKSE/Plugins/SkyPatcher/container` directory.

Mod Generation
==============

See the [`generation_scripts`](generation_scripts/) directory for the
xEdit script used to generate the mod.

Other Mods
==========

- The mod [College of Winterhold - (Books - Spell Tomes - Scrolls)](https://www.nexusmods.com/skyrimspecialedition/mods/129365)
  is a much more extensive version of this, which adds *all* relevant
  spell tomes to the College vendors, all "regular" books to Urag's
  inventory, and also adds some spell tomes to various other vendors
  scattered around Skyrim.

Credits
=======

- [xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit)'s
  [`Copy FormID to clipboard.pas`](https://github.com/TES5Edit/TES5Edit/blob/dev-4.1.6/Build/Edit%20Scripts/Copy%20FormID%20to%20clipboard.pas)
  script was used to allow our data extraction to copy directly into the
  clipboard.

License
=======

- The mod itself is licensed under the [CC0 1.0 (Public Domain)](https://creativecommons.org/public-domain/cc0/)
  license.  ([`LICENSE-mod-CC0.txt`](LICENSE-mod-CC0.txt))
- The xEdit script is licensed under the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/),
  since it uses a snippet from one of the example scripts provided
  by xEdit.  ([`LICENSE-xEdit_Script-MPL2.txt`](LICENSE-xEdit_Script-MPL2.txt))

Changelog
=========

**v1.0.0** - *April 24, 2026*
 - Initial version

