Book Sorting SSE (SkyPatcher)
=============================

This is a [SkyPatcher](https://www.nexusmods.com/skyrimspecialedition/mods/106659)-based
mod which normalizes book titles in Skyrim SE so that they are "properly"
alphabetized in your inventory (and on bookshelves) by moving any leading
article (the/a/an) to the end, and standardizes the volume/part/book suffix
labelling to be in parentheses (to match the style which IMO looks best for
multi-volume titles, after the article has been moved).

Some examples:

 - "The Real Barenziah, Vol. 2" becomes "Real Barenziah, The (Vol. 2)"
 - "An Explorer's Guide to Skyrim" becomes "Explorer's Guide to Skyrim, An"
 - "Journal - Arondil's, Part 1" becomes "Journal - Arondil's (Part 1)"

The book title normalization is based on the previous book title
normalizations done by the
[Unofficial Skyrim Special Edition Patch (USSEP)](https://www.nexusmods.com/skyrimspecialedition/mods/266),
and also [Book Covers Skyrim](https://www.nexusmods.com/skyrimspecialedition/mods/901)
(plus technically its [USSEP Update](https://www.nexusmods.com/skyrimspecialedition/mods/50615)
compatibility mod).

Some exceptions to the normalization process:

- The "2920" series titles have remained untouched, since they all have
  subtitles which would make the parenthetical volumes a bit weird-looking.
- "A Kiss, Sweet Mother" has been left alone because it'd look awkward
  with the article at the end.
- The quotes in the book '"Madmen" of the Reach' have been removed so that
  that book gets sorted properly among the *M*s instead of at the very
  beginning.
- Treasure Map roman numeral have been left as-is

Like other SkyPatcher mods, these changes are processed *after* all
`.esp`/`.esl` type mods have been loaded and processed, and *only* touches
the actual book titles, so all other changes done to books in other mods
will remain untouched.  It will conflict with any other SkyPatcher-based
mod which alters book titles (or any other runtime data-patching system
like it).  SkyPatcher loads the INI files alphabetically, so you can
influence which files "win" the conflict by renaming them to be later
in the file list.

Once nice side-effect of SkyPatcher is that they're pretty trivial to
edit.  If you mostly like the edits done in this mod but want to tweak
anything, simply open up the INI file in any text editor and modify
the titles to suit.

Installation
============

Ensure that SkyPatcher is installed, and then copy `Book_Sorting_SSE_SkyPatcher.ini`
into Skyrim's `Data/SKSE/Plugins/SkyPatcher/book` directory.

Mod Generation
==============

This mod is almost entirely generated via code -- an xEdit script to
extract the "vanilla" book titles into SkyPatcher format, and then a
Python script to apply our own styling to the titles.  See the
[`generation_scripts`](generation_scripts/) directory for more details on that.

Credits
=======

- [Book Sorting](https://www.nexusmods.com/skyrim/mods/9828) is obviously
  the primary inspiration for this mod, and I used to always use it prior
  to Special Edition.
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

**v1.0.0** - *February 2, 2026*
 - Initial version

