Unique Armor Names SSE (SkyPatcher) Generation Scripts
======================================================

Generation of this mod involves two steps:

1. Export a list of [SkyPatcher](https://www.nexusmods.com/skyrimspecialedition/mods/106659)
   statements which set ARMO/armor form names, using an
   [xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit) script.
2. Take that "source" file and process it with the Python script to
   actually do the numbering.

Exporting the Data
==================

1. Copy `Generate_SkyPatcher_Armor_Name_Statements.pas` into your SSEEdit
   `Edit Scripts` directory
2. Launch SSEEdit
3. Right click on basically anything (though maybe choose just a single Form somewhere),
   select "Apply Script," and choose the script from the dropdown.  That'll generate a
   bunch of output on the SSEEdit console and also copy it to your clipboard.  Paste it
   into a file (I used `Unique_Armor_Names_SSE.source`).

At this point, you've got the "source" file, which if run with SkyPatcher would just
set the armor/clothing names to exactly what they already are.  There will be
duplicate lines in the file (one for every time a mod overrides an ARMO record
from another file), but that's fine.

Process the Data
================

`process_unique_armor_names_sse.py` is a Python script which takes that
source file and processes it into a useful mod.  It's a commandline script,
so it needs to be run from a terminal or cmd.exe or Powershell or whatever,
not just double-clicked from an Explorer window.  Running it with the
`--help` argument will show the options:

    usage: process_unique_armor_names_sse.py [-h] [-s SOURCE] [-d DEST] [-a] [-m] [-f]
                                             [-v VERSION]

    Generate a SkyPatcher mod to add a numeric "x of y" suffix to any armor/clothing with
    multiple of the same name

    options:
      -h, --help            show this help message and exit
      -s, --source SOURCE   Source file to process (default:
                            Unique_Armor_Names_SSE.source)
      -d, --dest DEST       Destination file to write to (default:
                            ../SKSE/Plugins/SkyPatcher/armor/Unique_Armor_Names_SSE.ini)
      -a, --all             Include *all* armor names, even if there aren't duplicates
                            (default: False)
      -m, --mark            Mark all armor names with an asterisk suffix at the end
                            (default: False)
      -f, --force           Force overwrite, if the destination file already exists
                            (default: False)
      -v, --version VERSION
                            Adds a version header to the top of the generated file
                            (default: None)

Mostly it can be run wihtout args to do its work, but for releasing the mod
I'll provide a version like so:

    $ ./process_unique_armor_names_sse.py -v 1.0.0

With the default arguments, that'll read from `Unique_Armor_Names_SSE.source` in
the current directory, and write it out into
`../SKSE/Plugins/SkyPatcher/armor/Unique_Armor_Names_SSE.ini`.

Once it's done running, that should be it!

Licenses
========

- The xEdit script is licensed under the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/),
  since it uses a snippet from one of the example scripts provided
  by xEdit.  ([`LICENSE-xEdit_Script-MPL2.txt`](../LICENSE-xEdit_Script-MPL2.txt))
- The Python postprocessing script is licensed under the [3-Clause BSD License](https://opensource.org/license/bsd-3-clause).
  ([`LICENSE-postprocessing-3ClauseBSD.txt`](../LICENSE-postprocessing-3ClauseBSD.txt))

