{
  vim: set expandtab tabstop=2 shiftwidth=2:

  Generate SkyPatcher Book Name Statements v1.0.0
  ===============================================

  This is an xEdit/SSEEdit script used to dump SkyPatcher statements to
  set Book Titles, pre-filled with the "current" titles.  The resulting
  statements can then be easily edited by hand to whatever is desired,
  for an actual SkyPatcher mod.  The output should be sorted by master
  file and FormID.

  The script will automatically copy the relevant statements into your
  clipboard for easy pasting into an INI file.

  As with any other xEdit script, this can be run against entire mods,
  subsets of mods (for instance just a `Book` grouping), or even
  individual book entries.

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
  fileObj: IwbFile;
  fileName: string;
  localFormID: string;
  formID: string;
  nameElem: IwbElement;
begin

  // Only process BOOK forms
  if Signature(e) = 'BOOK' then
  begin

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

    // Get the Book Name
    nameElem := ElementByName(e, 'FULL - Name');

    // Add this entry
    statements.Add('filterByBooks=' + fileName + '|' + formID + ':fullName=~' + GetEditValue(nameElem) + '~');

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
  bookCountStr: string;
begin

  // DOS line endings
  eol := #13#10;

  if statements.Count > 0 then
  begin

    // Construct our output
    // When you have whole mods (or for instance the `Book` group) selected,
    // the order in which xEdit processes the records isn't always obvious.
    // For `Book Covers Skyrim.esp` they always get processed in reverse-FormID
    // order, for instance, but in `ccBGSSSE025-AdvDSGS.esm` they seem somewhat
    // random.  Selecting individual books will end up processing in FormID
    // order, but that's presumably because it's being told exactly what to
    // process instead of just looping through the data.  Anyway, I personally
    // would prefer to see these in the order they're presented by xEdit, so
    // I'm sorting them.  The basic alphanumeric sort works well enough!
    statements.CaseSensitive := false;
    statements.Sort;
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

    // Book count shopkeeping
    if statements.Count = 1 then plural := ''
    else plural := 's';
    bookCountStr := IntToStr(statements.Count);

    // Output to console as well
    AddMessage(''
      + '=====================================' + eol
      + eol
      + 'SkyPatcher Book Title Statements (total: ' + bookCountStr + ')' + eol
      + eol
      + output
      + eol
      + '(' + bookCountStr + ' statement' + plural + ' also copied to clipboard)' + eol
      + eol
      + '====================================='
      );

  end
  else
  begin

    // Consolation message when there are no books found
    AddMessage(''
      + '=====================================' + eol
      + eol
      + 'No books found in selected records' + eol
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
