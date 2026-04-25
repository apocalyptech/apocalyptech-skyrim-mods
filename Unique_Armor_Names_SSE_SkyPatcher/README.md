Improved College of Winterhold Tome Vendors Stock (SkyPatcher)
==============================================================

This is a [SkyPatcher](https://www.nexusmods.com/skyrimspecialedition/mods/106659)-based
mod which adds numeric suffixes to groups of armor/clothing which otherwise
have identical names, so that they're easily distinguishable in
inventory.  (And don't jump around in the list as they're sold or
moved around!)

For example, rather than having eight different items with the name
"Clothes," you'll have "Clothes: 1 of 8," "Clothes: 2 of 8," etc.

It's possible (or even quite probable) that this doesn't always get
things entirely right.  The generation code attempts to decide what
gear can be acquired legitimately by the player and then number based on
that, but I'm sure that there are edge cases in that processing.  In
my own testing, it seems pretty good, though.

My main unknowns after nearly a full Skyrim playthrough with this mod
enabled are a few bits of clothing which I haven't actually completed the
whole "sets" yet.  I suspect that most of these are a case of specific
NPCs wearing the gear I haven't found yet, which would need to be
pickpocketed (assuming the NPC allows that).  Specifically, the mod
might be over-numbering: Boots, College Boots, Fine Boots, Fine Clothes,
Merchant's Clothes, and Shoes.  I wouldn't be surprised if there were
other things not exactly right, too.

Installation
============

Ensure that SkyPatcher is installed, and then copy `Unique_Armor_Names_SSE.ini`
into Skyrim's `Data/SKSE/Plugins/SkyPatcher/armor` directory.

Mod Generation
==============

This mod is almost entirely generated via code -- an xEdit script to
extract the "vanilla" armor names into SkyPatcher format, and then a
Python script to apply the changes I want to make.  See the
[`generation_scripts`](generation_scripts/) directory for more details
on that.

Other Mods
==========

- There's a mod for Oldrim called [Alternate Clothing Names](https://www.nexusmods.com/skyrim/mods/16571)
  which adds more descriptive names in to various bits of clothing, rather
  than just numbering them.  There doesn't seem to be an SSE version of
  that mod, though, at least on Nexus.

Credits
=======

- [xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit)'s
  [`Copy FormID to clipboard.pas`](https://github.com/TES5Edit/TES5Edit/blob/dev-4.1.6/Build/Edit%20Scripts/Copy%20FormID%20to%20clipboard.pas)
  script was used to allow our data extraction to copy directly into the
  clipboard.

Licenses
========

Licensing for the mod is kind of stupidly complicated!  So it goes.

- The mod itself is licensed under the [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)
  Creative Commons license.  ([`LICENSE-mod-CC-BY-SA40.txt`](LICENSE-mod-CC-BY-SA40.txt))
- The xEdit script is licensed under the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/),
  since it uses a snippet from one of the example scripts provided
  by xEdit.  ([`LICENSE-xEdit_Script-MPL2.txt`](LICENSE-xEdit_Script-MPL2.txt))
- The Python postprocessing script is licensed under the [3-Clause BSD License](https://opensource.org/license/bsd-3-clause).
  ([`LICENSE-postprocessing-3ClauseBSD.txt`](LICENSE-postprocessing-3ClauseBSD.txt))

Changelog
=========

**v1.0.0** - *April 25, 2026*
 - Initial version

