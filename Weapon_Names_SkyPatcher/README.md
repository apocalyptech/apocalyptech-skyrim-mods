Weapon Name Statements (SkyPatcher)
===================================

This isn't actually a mod in any usual sense of the world, and this
directory doesn't actually even contain a generated set of
[SkyPatcher](https://www.nexusmods.com/skyrimspecialedition/mods/106659)
statements.

Rather, this is an [xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit)
script which generates a bunch of SkyPatcher statements to set the
name of all weapons found in the currently-loaded mod set, suffixed by
an asterisk.  I use this generated file to keep track of weapons that
I've "collected" in a playthrough, so I can attempt to "catch 'em all,"
so to speak.  I basically manually edit the file as weapons are put
into storage.  (Technically I actually end up copying the statements
into a separate file which grows over time, rather than editing the
generated version directly, but methods could certainly vary.)

Note that in order to be usable a little more easily (ie: alphabetized
by weapon name), you'd want to sort the file after generation.  Since
I run Linux, I tend to pipe it through the GNU `sort` utility, using:

    sort -k2 -t~

The file will also contain duplicates -- one for each time a mod
overrides a weapon form.  After sorting, I'll also run it through
the GNU `uniq` utility to get rid of those.

The script will copy its output to the clipboard, so once it's
been run, you can paste it into a SkyPatcher `.ini` file for
use in your game.  

The script can be run "against" any target you want in xEdit;
it loops through all loaded files and investigates all WEAP forms
to construct the statements, rather than operating against the
selected forms/group-of-forms.  So you'd be best off running
against a single form instead of a group of forms, so that
xEdit doesn't waste time doing its own object looping in addition
to what the script itself does.

Running the Script
==================

1. Copy `Generate_SkyPatcher_Weapon_Name_Statements.pas` into your SSEEdit
   `Edit Scripts` directory
2. Launch SSEEdit
3. Right click on basically anything (though maybe choose just a single Form somewhere),
   select "Apply Script," and choose the script from the dropdown.  That'll generate a
   bunch of output on the SSEEdit console and also copy it to your clipboard.  Paste it
   into a file with a `.ini` extension and place it in Skyrim's
   `Data/SKSE/Plugins/SkyPatcher/weapon` directory.

That's it!  As I say, personally on this last playthrough I
actually saved it as a filename that *did not* have an `.ini`
extension, and copied the relevant lines over to a file which
*does* have the `.ini` extension, to be picked up by the game,
as I added gear to my collection.  But as I said above: methods
could definitely vary!

Credits
=======

- [xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit)'s
  [`Copy FormID to clipboard.pas`](https://github.com/TES5Edit/TES5Edit/blob/dev-4.1.6/Build/Edit%20Scripts/Copy%20FormID%20to%20clipboard.pas)
  script was used to allow our data extraction to copy directly into the
  clipboard.

License
========

The script is licensed under the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/),
since it uses a snippet from one of the example scripts provided
by xEdit.  ([`LICENSE.txt`](LICENSE.txt))

Changelog
=========

**v1.0.0** - *April 26, 2026*
 - Initial version

