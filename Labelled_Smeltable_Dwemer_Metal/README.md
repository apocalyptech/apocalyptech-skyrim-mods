Labelled Smeltable Dwemer Metal (SkyPatcher)
============================================

This is a [SkyPatcher](https://www.nexusmods.com/skyrimspecialedition/mods/106659)-based
mod which adds a "(Smeltable)" suffix to all smeltable Dwemer metal
clutter, for ease of identification.  It's a bit silly since it
was awfully easy to know what's smeltable and what isn't, but this
can make the clutter-collection process that much more mindless!

Note that by default this *includes* "Dwemer Scrap Metal," which is
*not* smeltable in the vanilla game.  [USSEP](https://www.nexusmods.com/skyrimspecialedition/mods/266)
makes it smeltable, though (using the logic that if "Bent Dwemer
Scrap Metal" is smeltable then the non-bent version should be, too).
If you're not using USSEP (or something else which makes that item
smeltable), simply open up `Labelled_Smeltable_Dwemer_Metal.ini` 
in a text editor and comment out that line, using a semicolon as
the first character, a la:

    ; Not in vanilla, but fixed by USSEP
    ;filterByMiscs=Skyrim.esm|000C886A:fullName=~Dwemer Scrap Metal (Smeltable)~

Installation
============

Ensure that SkyPatcher is installed, and then copy `Labelled_Smeltable_Dwemer_Metal.ini`
into Skyrim's `Data/SKSE/Plugins/SkyPatcher/misc` directory.

Other Mods
==========

[Smeltable Dwarven Metal Edit](https://www.nexusmods.com/skyrimspecialedition/mods/74076)
appears to do much the same thing, though it also adjusts the weight
of the items, whereas this mod only alters the name.  It adds a prefix
to the names as opposed to this mod's suffix.  It's a more traditional
ESP-based mod instead of SkyPatcher.

License
=======

This mod is licensed under [CC0 1.0 (Public Domain)](https://creativecommons.org/public-domain/cc0/)
([`LICENSE.txt`](LICENSE.txt)).  Do with it what you will!

Changelog
=========

**v1.1.0** - *April 24, 2026*
 - Initial version (and uploaded to Nexus)

