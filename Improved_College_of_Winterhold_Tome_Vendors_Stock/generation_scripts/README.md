Improved College of Winterhold Tome Vendors Stock (SkyPatcher) Generation Script
================================================================================

This is an [xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit) script which
generates a set of SkyPatcher statements which make all available
non-Master-level Spell Tomes guaranteed to be in the seller inventories of the
associated teachers at the College of Winterhold.  The Master-level spell
statements *are* created as well, but are commented out by default.

The script will copy its output to the clipboard, so once it's been run, you
can paste it into a SkyPatcher .ini file for use in your game.  

The script can be run "against" any target you want in xEdit; it loops through
all loaded files and investigates all BOOK forms to construct the statements,
rather than operating against the selected forms/group-of-forms.  So you'd be
best off running against a single form instead of a group of forms, so that
xEdit doesn't waste time doing its own object looping in addition to what the
script itself does.

Generation
==========

1. Copy `Generate_SkyPatcher_Improved_College_of_Winterhold_Tome_Vendors_Stock.pas`
   into your SSEEdit `Edit Scripts` directory
2. Launch SSEEdit
3. Right click on basically anything (though maybe choose just a single Form somewhere),
   select "Apply Script," and choose the script from the dropdown.  That'll generate a
   bunch of output on the SSEEdit console and also copy it to your clipboard.  Paste it
   into a file (I used `Improved_College_of_Winterhold_Tome_Vendors_Stock.ini`).

That's basically it!  I added a few comments to the top of the file, but
that otherwise does the trick.

License
=======

The xEdit script is licensed under the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/),
since it uses a snippet from one of the example scripts provided
by xEdit.  ([`LICENSE-xEdit_Script-MPL2.txt`](../LICENSE-xEdit_Script-MPL2.txt))

