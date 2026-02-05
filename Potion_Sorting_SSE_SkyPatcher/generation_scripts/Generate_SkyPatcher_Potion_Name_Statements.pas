{
  vim: set expandtab tabstop=2 shiftwidth=2:

  Generate SkyPatcher Potion Name Statements v1.0.0
  =================================================

  This is an xEdit/SSEEdit script used to dump SkyPatcher statements to
  set potion/poison names to versions which describe exactly what they
  do in the name, and also allow for more convenient sorting in your
  inventory.  For instance:

  - "Potion of Vigorous Healing" becomes "Potion: Heal (+100)"
  - "Solution of Strength" becomes "Potion: Carry Weight (+40/300s)"
  - "Virulent Paralysis Poison" becomes "Poison: Paralysis (10s)"
  - "Potion of Larceny" becomes "Potion: Lockpicking (+15/60s) + Pickpocket (+15/60s)"

  The main drawback to the mod is that this does *not* affect player-created
  potions at all.  Any potion you make with alchemy will continue to have
  whatever name the game decided for it.  I'm guessing that altering those
  names would require a "real" mod (as opposed to just SkyPatcher stuff).
  I did find one which does it, though I haven't tried it yet:
  https://www.nexusmods.com/skyrimspecialedition/mods/22953

  The script will automatically copy the relevant statements into your
  clipboard for easy pasting into an INI file.

  As with any other xEdit script, this can be run against entire mods,
  subsets of mods (for instance just an `Ingestable` grouping), or even
  individual potion/poison entries.

  Credits
  =======

  Author: Apocalyptech / https://apocalyptech.com/contact.php

  The script uses a snippet taken from xEdit/TES5Edit's `Copy FormID to clipboard.pas`
  script, at: https://github.com/TES5Edit/TES5Edit/blob/dev-4.1.6/Build/Edit%20Scripts/Copy%20FormID%20to%20clipboard.pas

  The script was inspired by `xEdit scripts - Convert FormID Lists to
  Skypatcher` by Vaillp, at: https://www.nexusmods.com/skyrimspecialedition/mods/129316

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
begin
  statements := TStringList.Create;
  Result := 0;
end;

// Called for every record selected in xEdit
function Process(e: IInterface): integer;
var
  editorID: string;
  potionName: string;
  foundKeyword: boolean;
  kwd: IwbElement;
  i: integer;
  keywordID: integer;
  potionType: string;

  effects: IwbElement;
  effectReprs: TStringList;
  effect: IwbElement;
  effectBase: IwbElement;
  effectName: string;
  position: integer;

  effectData: IwbElement;
  magnitude: integer;
  duration: integer;
  effectParts: TStringList;

  newName: string;
  fileObj: IwbFile;
  fileName: string;
  localFormID: string;
  formID: string;

begin

  // If we were worried about efficiency, we'd make an effort to cache a
  // bunch of the lookups that we're likely to encounter a bunch of times,
  // and our postprocessing on the effect names, etc.  In practice it's
  // just not worth the bother, though.

  Result := 0;

  // Only process ALCH forms
  if Signature(e) <> 'ALCH' then Exit;

  // Make sure to use the "best" version of this form
  e := WinningOverride(e);

  // Check to make sure we're not DefaultPotion or DefaultPoison
  editorID := GetEditValue(ElementBySignature(e, 'EDID'));
  if (editorID = 'DefaultPotion') or (editorID = 'DefaultPoison') then Exit;

  // Grab the name and skip a few which we *don't* want to touch
  potionName := GetEditValue(ElementBySignature(e, 'FULL'));
  if potionName = 'The White Phial (Full)' then Exit;
  if potionName = 'Netch Poison' then Exit;
  if potionName = 'Soul Husk Extract' then Exit;
  if potionName = 'Lotus Extract' then Exit;
  if potionName = 'Ice Wraith Bane' then Exit;
  if potionName = 'Nightshade Extract' then Exit;

  // Check to see if this form has either of these two keywords:
  //  - VendorItemPotion (0x8CDEC)
  //  - VendorItemPoison (0x8CDED)
  foundKeyword := False;
  kwd := ElementBySignature(e, 'KWDA');
  if Assigned(kwd) then
  begin
    for i := 0 to ElementCount(kwd) - 1 do
    begin
      keywordID := GetNativeValue(ElementByIndex(kwd, i));
      if keywordID = $8CDEC then
      begin
        potionType := 'Potion';
        foundKeyword := True;
        Break;
      end
      else if keywordID = $8CDED then
      begin
        potionType := 'Poison';
        foundKeyword := True;
        Break;
      end;
    end;
  end;

  // If we didn't find a keyword we like, exit
  if not foundKeyword then Exit;

  // And also, only proceed if we have effects to process.  Not sure how these are
  // stored, really -- they don't seem to have a Signature of any sort.  Still,
  // ElementByName() gets them based on the name shown in the xEdit tree, so eh.
  effects := ElementByName(e, 'Effects');
  if (not Assigned(effects)) or (ElementCount(effects) = 0) then Exit;

  // If we got here, we've got something to report.  Output the original name
  // in a comment.
  statements.Add('; ' + potionName);

  // Loop through the effects we have
  effectReprs := TStringList.Create;
  for i := 0 to ElementCount(effects) - 1 do
  begin
    effect := ElementByIndex(effects, i);
    effectBase := LinksTo(ElementBySignature(effect, 'EFID'));
    effectName := GetEditValue(ElementBySignature(effectBase, 'FULL'));

    // Some hardcoded transformations.  First, axe "Fortify" prefix
    if StartsText('Fortify ', effectName) then
    begin
      effectName := Copy(effectName, 9, Length(effectName)-8);
    end;

    // Restore Health -> Heal
    if effectName = 'Restore Health' then effectName := 'Heal';

    // Regenerate X -> X Regen
    if StartsText('Regenerate ', effectName) then
    begin
      effectName := Copy(effectName, 12, Length(effectName)-11) + ' Regen';
    end;

    // Damage -> Dmg (in prefix)
    if StartsText('Damage ', effectName) then
    begin
      effectName := 'Dmg ' + Copy(effectName, 8, Length(effectName)-7);
    end;

    // ' Damage ' -> ' Dmg ' (in the middle)
    // I'm aware I should just do a more "generic" version combining this and the
    // previous one.  Eh.
    position := Pos(' Damage ', effectName);
    if position > 0 then
    begin
      effectName := Copy(effectName, 0, position-1) + ' Dmg ' + Copy(effectName, position+8, Length(effectName)-position-7);
    end;

    // Grab the actual effect data.  There is also an "Area" attribute
    // on these, but no data we touch actually uses it.
    effectData := ElementBySignature(effect, 'EFIT');
    magnitude := GetNativeValue(ElementByName(effectData, 'Magnitude'));
    duration := GetNativeValue(ElementByName(effectData, 'Duration'));

    // Create a useful string from the effect data
    effectParts := TStringList.Create;
    effectParts.Delimiter := '/';
    if magnitude > 0 then effectParts.Add('+' + IntToStr(magnitude));
    if duration > 0 then effectParts.Add(IntToStr(duration) + 's');
    effectReprs.Add(effectName + ' (' + effectParts.DelimitedText + ')');
    effectParts.Free;

  end;

  // Combine all our effect reprs
  newName := potionType + ': ';
  for i := 0 to effectReprs.Count - 1 do
  begin
    if i <> 0 then newName := newName + ' + ';
    newName := newName + effectReprs[i];
  end;
  effectReprs.Free;

  // Get the master file where this form is defined
  fileObj := GetFile(MasterOrSelf(e));
  fileName := GetFileName(fileObj);

  // Get the Form ID
  // This taken from Vaillp's script at https://www.nexusmods.com/skyrimspecialedition/mods/129316
  // - For ESP/ESM IDs, we strip off the first two hex digits
  // - For ESL IDs, we strip off the first five
  localFormID := IntToHex(FixedFormID(e), 8);
  if (GetElementNativeValues(ElementByIndex(fileObj, 0), 'Record Header\Record Flags\ESL') = true) then
  begin
    formID := copy(localFormID, 6, 3)
  end
  else
  begin
    formID := copy(localFormID, 3, 6);
  end;

  // Add this entry
  statements.Add('filterByAlchs=' + fileName + '|' + formID + ':fullName=~' + newName + '~');

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
  potionCountStr: string;
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
    potionCountStr := IntToStr(statements.Count/2);

    // Output to console as well
    AddMessage(''
      + '=====================================' + eol
      + eol
      + 'SkyPatcher Potion Name Statements (total: ' + potionCountStr + ')' + eol
      + eol
      + output
      + eol
      + '(' + potionCountStr + ' statement' + plural + ' also copied to clipboard)' + eol
      + eol
      + '====================================='
      );

  end
  else
  begin

    // Consolation message when there are no potions found
    AddMessage(''
      + '=====================================' + eol
      + eol
      + 'No potions found in selected records' + eol
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
