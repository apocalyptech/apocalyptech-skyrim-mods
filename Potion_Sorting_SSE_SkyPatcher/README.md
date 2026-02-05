Potion Sorting SSE (SkyPatcher)
===============================

This is a [SkyPatcher](https://www.nexusmods.com/skyrimspecialedition/mods/106659)-based
mod which normalizes vanilla-game potion and poison names to describe exactly what
they do, and also allow for more convenient sorting in your inventory.  For instance:

- "Potion of Vigorous Healing" becomes "Potion: Heal (+100)"
- "Solution of Strength" becomes "Potion: Carry Weight (+40/300s)"
- "Virulent Paralysis Poison" becomes "Poison: Paralysis (10s)"
- "Potion of Larceny" becomes "Potion: Lockpicking (+15/60s) + Pickpocket (+15/60s)"

The main drawback to the mod is that this does *not* affect player-created
potions at all.  Any potion you make with alchemy will continue to have
whatever name the game decided for it.  I'm guessing that altering those
names would require a "real" mod (as opposed to just SkyPatcher stuff).
I did find one which does it, though I haven't tried it yet:
<https://www.nexusmods.com/skyrimspecialedition/mods/22953>

The mod is generated entirely by code, inside
[xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit), and was generated using a
mod set which includes [Unofficial Skyrim Special Edition Patch (USSEP)](https://www.nexusmods.com/skyrimspecialedition/mods/266).
If USSEP tweaked any potion/poison effects, then the names might not be
accurate if you're not also using USSEP.

Some potion names that were left alone:

- The White Phial (Full)
- Netch Poison
- Soul Husk Extract
- Lotus Extract
- Ice Wraith Bane
- Nightshade Extract

Like other SkyPatcher mods, these changes are processed *after* all
`.esp`/`.esl` type mods have been loaded and processed, and *only* touches
the actual potion titles, so all other changes done to potions in other mods
will remain untouched.  It will conflict with any other SkyPatcher-based
mod which alters potion names (or any other runtime data-patching system
like it).  SkyPatcher loads the INI files alphabetically, so you can
influence which files "win" the conflict by renaming them to be later
in the file list.

Once nice side-effect of SkyPatcher is that they're pretty trivial to
edit.  If you mostly like the edits done in this mod but want to tweak
anything, simply open up the INI file in any text editor and modify
the names to suit.

I'm probably not super likely to post this to Nexus.  I feel like the fact
that it doesn't touch player-created potions is a pretty big gap.  It'd be
useful for players who aren't currently doing much alchemy, but I feel like
a *true* solution for it would be more akin to the other mod I found above.
So, this'll likely just remain on my github (where presumably nobody but
myself will ever see it! :).

Installation
============

Ensure that SkyPatcher is installed, and then copy `Potion_Sorting_SSE_SkyPatcher.ini`
into Skyrim's `Data/SKSE/Plugins/SkyPatcher/ingestables` directory.

Mod Generation
==============

See the [`generation_scripts`](generation_scripts/) directory for the
xEdit script used to generate the mod.  As mentioned above, the mod was
generated using a modset which includes USSEP.

Credits
=======

- [Vaillp](https://www.nexusmods.com/users/45911177)'s
  [xEdit scripts - Convert FormID Lists to Skypatcher](https://www.nexusmods.com/skyrimspecialedition/mods/129316)
  was quite useful for initially looking into how to extract book titles
  from game data in a useful SkyPatcher format
- [xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit)'s
  [`Copy FormID to clipboard.pas`](https://github.com/TES5Edit/TES5Edit/blob/dev-4.1.6/Build/Edit%20Scripts/Copy%20FormID%20to%20clipboard.pas)
  script was used to allow our data extraction to copy directly into the
  clipboard.

License
=======

- The mod itself is licensed under the [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)
  Creative Commons license.  ([`LICENSE-mod-CC-BY-SA40.txt`](LICENSE-mod-CC-BY-SA40.txt))
- The xEdit script is licensed under the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/),
  since it uses a snippet from one of the example scripts provided
  by xEdit.  ([`LICENSE-xEdit_Script-MPL2.txt`](LICENSE-xEdit_Script-MPL2.txt))

Changelog
=========

**v1.0.0** - *February 5, 2026*
 - Initial version

