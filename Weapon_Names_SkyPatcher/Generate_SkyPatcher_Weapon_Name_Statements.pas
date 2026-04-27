{
  vim: set expandtab tabstop=2 shiftwidth=2:

  Generate SkyPatcher Weapon Name Statements v1.0.0
  =================================================

  This script generates a bunch of SkyPatcher statements which sets the
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
  been run, you can paste it into a SkyPatcher .ini file for
  use in your game.  

  The script can be run "against" any target you want in xEdit;
  it loops through all loaded files and investigates all WEAP forms
  to construct the statements, rather than operating against the
  selected forms/group-of-forms.  So you'd be best off running
  against a single form instead of a group of forms, so that
  xEdit doesn't waste time doing its own object looping in addition
  to what the script itself does.

  Credits
  =======

  Author: Apocalyptech / https://apocalyptech.com/contact.php

  The script uses a snippet taken from xEdit/TES5Edit's `Copy FormID to clipboard.pas`
  script, at: https://github.com/TES5Edit/TES5Edit/blob/dev-4.1.6/Build/Edit%20Scripts/Copy%20FormID%20to%20clipboard.pas

  License
  =======

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

}
unit userscript;

var
  statements: TStringList;

// Initialization
function Initialize: integer;
var
  seenWeaps: TStringList;
  i, j, k: integer;
  mainFile: IwbFile;
  mainFilename: string;
  weapGroup: IwbGroupRecord;
  weap: IwbElement;
  weapName: string;
  weapFile: IwbFile;
  weapFilename: string;
  weapCompID: string;
  foundWeap: boolean;
begin
  statements := TStringList.Create;
  seenWeaps := TStringList.Create;

  // Loop through all files looking for WEAP Groups
  for i := 0 to Pred(FileCount) do
  begin
    mainFile := FileByIndex(i);
    weapGroup := GroupBySignature(mainFile, 'WEAP');
    if not Assigned(weapGroup) then Continue;

    for j := 0 to Pred(ElementCount(weapGroup)) do
    begin

      // First up: get our WEAP entry and make sure we're looking at the winning version
      weap := WinningOverride(ElementByIndex(weapGroup, j));

      // Ignore anything with the Non-Playable flag (though the few things I checked in
      // the data which seemed like they should maybe have the flag didn't, so it's
      // possible this won't actually catch anything).
      if (GetElementNativeValues(weap, 'Record Header\Record Flags\Non-Playable') = true) then Continue;

      // Now, ignore any weapon with an empty name
      weapName := GetEditValue(ElementBySignature(weap, 'FULL'));
      if weapName = '' then Continue;

      // Also ignore any weapon with ' of ' in the name, unless it starts with 'Staff of'
      // (Actually, don't do that -- I want to be able to mark the variations as well)
      //if Pos('Staff of ', weapName) = 0 then
      //begin
      //  if Pos(' of ', weapName) <> 0 then Continue;
      //end;

      // Generate the weapon reference that we'll use for SkyPatcher
      weapFile := GetFile(MasterOrSelf(weap));
      weapFilename := GetFileName(weapFile);
      if (GetElementNativeValues(ElementByIndex(weapFile, 0), 'Record Header\Record Flags\ESL') = true) then
      begin
        weapCompID := weapFilename + '|' + copy(IntToHex(FixedFormID(weap), 8), 6, 3);
      end
      else
      begin
        weapCompID := weapFilename + '|' + copy(IntToHex(FixedFormID(weap), 8), 3, 6);
      end;

      // I would like to do duplicate detection here so that there's just one
      // line per weapon, but I still have yet to figure out any kind of
      // dict/hash/whatever data structure in xEdit's Pascal.  In the absence of
      // one of those, I just don't see a way around having to loop through an
      // array like this, and as you may expect it's just effing *slow*.  So, eh.
      // I'm just not doing it.  The resulting file will have to have duplicates
      // trimmed out after the fact.
      {
      foundWeap := False;
      for k := 0 to Pred(seenWeaps.Count) do
      begin
        if (seenWeaps[k] = weapCompID) then
        begin
          foundWeap := True;
          Break;
        end;
      end;
      if foundWeap then Continue;
      seenWeaps.Add(weapCompID);
      }

      // If we got here, report it!
      statements.Add('filterByWeapons=' + weapCompID + ':fullName=~' + weapName + '*~');

    end;
  end;

  seenWeaps.Free;
  Result := 0;
end;

// Called after processing
function Finalize: integer;
var
  eol: string;
  output: string;
  i: integer;
  frm: TForm;
  ed: TEdit;
begin

  // DOS line endings
  eol := #13#10;

  // Construct our output
  output := '';
  for i := 0 to Pred(statements.Count) do
  begin
    output := output + statements[i] + eol;
  end;

  // Copy to Clipboard
  // Snippet taken from xEdit's `Copy FormID to clipboard.pas`
  frm := TForm.Create(nil);
  ed := TEdit.Create(frm);
  try
    ed.Parent := frm;
    ed.Text := output;
    ed.SelectAll;
    ed.CopyToClipboard;
  finally
    frm.Free;
  end;

  // Output to console as well
  AddMessage(''
    + eol
    + 'Data:' + eol
    + '=====================================' + eol
    + eol
    + output
    + eol
    + '====================================='
    + eol
    + '(copied to clipboard!)' + eol
    );


  statements.Free;

  Result := 0;
end;

end.
