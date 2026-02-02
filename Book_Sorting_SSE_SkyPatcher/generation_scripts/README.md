Book Sorting SSE (SkyPatcher) Generation Scripts
================================================

Generating this mod involves two steps:
1. Extract book title data using [xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit)
2. Process the extracted titles into an actual mod.

Preparation
===========

I've generated this mod with the following other mods installed:

1. [Unofficial Skyrim Special Edition Patch (USSEP)](https://www.nexusmods.com/skyrimspecialedition/mods/266)
2. [Book Covers Skyrim](https://www.nexusmods.com/skyrimspecialedition/mods/901)
3. [Book Covers Skyrim - USSEP Update](https://www.nexusmods.com/skyrimspecialedition/mods/50615)

Extracting the Data
===================

1. Copy `Generate_SkyPatcher_Book_Name_Statements.pas` into your SSEEdit `Edit
   Scripts` directory
2. Launch SSEEdit
3. Right click on `Book Covers Skyrim.esp` and run that script against it.
   That'll generate a bunch of output on the SSEEdit console and also copy it
   to your clipboard.  Paste it into a file (I used `Book_Sorting_SSE_SkyPatcher.source`).
4. After pasting, I rearranged the blocks so that the `Skyrim.esm`
   statements were on top and the other DLCs were at the bottom, and
   added a couple of semicolon-prefixed comments between them.  That
   doesn't really matter for functionality's sake, though
5. Right click on `ccBGSSSE025-AdvDSGS.esm` (the "Saints and Seducers"
   Creation Club mod included with SSE) and run the script against that.
   Copy that block into your file as well (optionally with a prefix).
6. Right click on `ccBGSSSE001-Fish.esm` (the Fishing Creation Club mod)
   and do the same.

At this point, you've got a `Book_Sorting_SSE_SkyPatcher.source` file
which contains SkyPatcher commands for essentially every book in the game,
using the titles which were normalized by both USSEP and Book Covers
Skyrim.  Turning it into the mod involves processing that file using a
postprocessing script.

Process the Data
================

`process_book_sorting_sse_skypatcher.py` is a Python script which takes that
source file and applies all of the changes that I want to see.  It's
a commandline script, so it needs to be run from a terminal or cmd.exe
or Powershell or whatever, not just double-clicked from an Explorer
window.  Running it with the `--help` argument will show the options:

    usage: process_book_sorting_sse_skypatcher.py [-h] [-s SOURCE] [-d DEST] [-f]
                                                  [-v VERSION]

    Normalize book titles in SkyPatcher statements

    options:
      -h, --help            show this help message and exit
      -s, --source SOURCE   Source file to process (default:
                            Book_Sorting_SSE_SkyPatcher.source)
      -d, --dest DEST       Destination file to write to (default: ../SKSE/Plugins/Sk
                            yPatcher/book/Book_Sorting_SSE_SkyPatcher.ini)
      -f, --force           Force overwrite, if the destination file already exists
                            (default: False)
      -v, --version VERSION
                            Adds a version header to the top of the generated file
                            (default: None)

Mostly it can be run without args to do its work, but for releasing the mod
I'll provide a version like so:

    $ ./process_book_sorting_sse_skypatcher.py -v 1.0.0

With the default arguments, that'll read from `Book_Sorting_SSE_SkyPatcher.source`
in the current directory, and write it out into
`../SKSE/Plugins/SkyPatcher/book/Book_Sorting_SSE_SkyPatcher.ini`.

Once it's done running, that should be it!

Licenses
========

- The xEdit script is licensed under the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/),
  since it uses a snippet from one of the example scripts provided
  by xEdit.  ([`LICENSE-xEdit_Script-MPL2.txt`](../LICENSE-xEdit_Script-MPL2.txt))
- The Python postprocessing script is licensed under the [3-Clause BSD License](https://opensource.org/license/bsd-3-clause).
  ([`LICENSE-postprocessing-3ClauseBSD.txt`](../LICENSE-postprocessing-3ClauseBSD.txt))

