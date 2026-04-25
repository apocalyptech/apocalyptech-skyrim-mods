{
  vim: set expandtab tabstop=2 shiftwidth=2:

  Generate SkyPatcher Armor Name Statements v1.0.0
  =================================================

  Generates a collection of SkyPatcher statements to set the name of
  all player-acquireable armor in the currently-loaded files in xEdit.
  The generated list will end up having duplicates: one for each time
  a file overrides a record in another file.

  The script is basically used to create a "source" file which can
  then be used to programmatically generate actually-useful SkyPatcher
  mods for setting armor names.  The main intended purpose is to
  add number suffixes for groups of gear which have identical names,
  such as the eight "Clothes" entries.  Doing that actual processing
  without dict/hash/whatever data structures here in Pascal would be
  awful, though, so that's being offloaded to Python postprocessing.

  In addition to doing some basic checks to weed out gear which
  literally can't be acquired by the player, even with console commands,
  and weeding out any armor with a blank name, it additionally attempts
  to add an "(unobtainable)" suffix for any bit of gear which the player
  can't legitimately acquire in the game but which could be acquired
  via console commands.  I have no doubt that it's not 100% accurate
  with this, though it seems to do well enough.  These checks are based
  on what *references* the armor being looked-at.  I've decided on
  various references which *do not* seem to indicate player acquisition
  potential and am ignoring those.  If any references make it past this
  gauntlet of checks, then it's considered something which could lead to
  the player acquiring the gear, and so it makes it through.

  The script will copy its output to the clipboard, so once it's
  been run, you can paste it into a SkyPatcher .ini file for
  use in your game.  

  The script can be run "against" any target you want in xEdit;
  it loops through all loaded files and investigates all BOOK forms
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

  i, j, k: integer;

  mainFile: IwbFile;

  armorGroup: IwbGroupRecord;
  armor: IwbElement;
  armorName: string;

  foundOtherRefs: boolean;
  ref: IwbMainRecord;
  refSig: string;
  refFormID: integer;
  refFilename: string;

  fileObj: IwbFile;
  fileName: string;
  localFormID: string;
  formID: string;

begin

  statements := TStringList.Create;

  // Loop through all files looking for ARMO groups
  for i := 0 to Pred(FileCount) do
  begin
    mainFile := FileByIndex(i);
    armorGroup := GroupBySignature(mainFile, 'ARMO');
    if not Assigned(armorGroup) then Continue;

    for j := 0 to Pred(ElementCount(armorGroup)) do
    begin

      // First up: get our ARMO entry and make sure we're looking at the winning version
      armor := WinningOverride(ElementByIndex(armorGroup, j));

      // Skip forms which are marked as Non-Playable.  I feel like there should
      // be a better way to get to these flags, but this is what I've found out
      // how to work.  This is actually one of the *last* things I added in to
      // filter out unobtainable gear, but I suspect it's probably the most
      // effective.  I wonder how much of the processing below is actually
      // necessary now that I have this in here.  I *did* spot-check a few
      // items, though, and it looks like the processing below is still providing
      // value.
      if (GetElementNativeValues(armor, 'Record Header\Record Flags\Non-Playable') = true) then Continue;

      // Grab the name and skip any which don't actually have a name
      armorName := GetEditValue(ElementBySignature(armor, 'FULL'));
      if armorName = '' then Continue;

      // Check for "unobtainable" gear by looking at what references it.
      // I'm applying a couple of different criteria here
      //
      // A couple of things which are known to not get excluded properly:
      //    Steel Armor: Dawnguard.esm|014C05
      //      Character-specific but has a COBJ reference to allow the player to
      //      improve an NPC-specific armor set (which probably can't actually
      //      happen anyway).  For now letting it through but I suspect we should
      //      have a FormID blocklist to exclude this (and anything else like it)
      //    Vampire Boots: Dawnguard.esm|019AE1
      //      I suspect these are placed as a non-interactable object in a scene
      //      somewhere, via a REFR form.
      foundOtherRefs := false;
      for k := 0 to Pred(ReferencedByCount(armor)) do
      begin
        ref := ReferencedByIndex(armor, k);

        // Ignore a few specific types of references
        refSig := Signature(ref);
        if refSig = 'RACE' then Continue;
        if refSig = 'NPC_' then Continue;

        // *Technically* we may want to follow this along to see if it is
        // placing an NPC_ somewhere, since I suspect that's what we want
        // to block on.  Leaving it for now, but maybe something to look
        // into.  Specifically see Ancient Nord Helmet at:
        // 0001FD77, 0001FD7B, and 0001FD7C
        if refSig = 'ACHR' then Continue;

        // I'm *slightly* worried that this one will be too vague, but
        // I also don't see how it could provide an actual drop, so should
        // be okay.
        if refSig = 'INFO' then Continue;

        // If there's a reference from *another* ARMO object, this one might
        // just be a "template" which isn't actually used in-game.  See, for
        // instance, the two "Adept Hood" objects: 0010CEE6 and 0010DD3C
        if refSig = 'ARMO' then Continue;
        if refSig = 'FLST' then Continue;

        // Ignore references to some generic "All X" CONT objects
        refFormID := FixedFormID(ref);
        // All Clothing And Jewelry
        if refFormId = $C2CD8 then Continue;
        // All Standard Armor
        if refFormId = $C2CD6 then Continue;
        // All Dawnguard Weapons and Armor
        if refFormId = $200CAB5 then Continue;
        // All Dragonborn Armor (shouldn't this be $4026B63 ???)
        if refFormId = $2026B63 then Continue;

        // Omit references from Elysium Estate.  The way EE does some of its display
        // areas causes a few bits of armor to seem acquireable when they really
        // aren't.  (Though I'm curious exactly what EE is doing.  One difference is
        // that a "testing" Auriel's Shield form (020071E1) shows up as placed.
        // If we store Auriel's Shield and then get it back, are we getting this test
        // version instead?  The other reference to look into would be Ring of
        // Hircine (0002AC60).)
        refFilename := GetFileName(GetFile(ref));
        if refFilename = 'ElysiumEstate.esp' then Continue;
        // This mod adds some "Ragged Boots" which I don't think are acquireable
        if refFilename = 'TasteOfDeath_Addon_Boss.esp' then Continue;

        // If we got here, it's a reference I'm not excluding, so we're
        // assuming it's involved in a method where the player can get it.
        foundOtherRefs := true;
        Break;
      end;
      if not foundOtherRefs then armorName := armorName + ' (unobtainable)';

      // Get the Form ID and master file
      // This taken from Vaillp's script at https://www.nexusmods.com/skyrimspecialedition/mods/129316
      // - For ESP/ESM IDs, we strip off the first two hex digits
      // - For ESL IDs, we strip off the first five
      fileObj := GetFile(MasterOrSelf(armor));
      fileName := GetFileName(fileObj);
      localFormID := IntToHex(FixedFormID(armor), 8);
      if (GetElementNativeValues(ElementByIndex(fileObj, 0), 'Record Header\Record Flags\ESL') = true) then
      begin
        formID := copy(localFormID, 6, 3)
      end
      else
      begin
        formID := copy(localFormID, 3, 6);
      end;

      // Add this entry
      statements.Add('filterByArmors=' + fileName + '|' + formID + ':fullName=~' + armorName + '~');

    end;

  end;

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
  plural: string;
  armorCountStr: string;
begin

  // DOS line endings
  eol := #13#10;

  if statements.Count > 0 then
  begin

    // Construct our output
    output := '';
    for i := 0 to statements.Count - 1 do
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

    // Potion count shopkeeping
    if statements.Count = 1 then plural := ''
    else plural := 's';
    armorCountStr := IntToStr(statements.Count);

    // Output to console as well
    AddMessage(''
      + '=====================================' + eol
      + eol
      + 'SkyPatcher Armor Name Statements (total: ' + armorCountStr + ')' + eol
      + eol
      + output
      + eol
      + '(' + armorCountStr + ' statement' + plural + ' also copied to clipboard)' + eol
      + eol
      + '====================================='
      );

  end
  else
  begin

    // Consolation message when there is no armor found
    AddMessage(''
      + '=====================================' + eol
      + eol
      + 'No armor found in selected records' + eol
      + eol
      + '(nothing copied to clipboard)' + eol
      + eol
      + '====================================='
      );
    
  end;

  statements.Free;
  Result := 0;
end;

end.
