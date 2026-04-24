{
  vim: set expandtab tabstop=2 shiftwidth=2:

  Generate SkyPatcher Improved College of Winterhold Tome Vendors Stock v1.0.0
  ============================================================================

  Generates a set of SkyPatcher statements which make all available
  non-Master-level Spell Tomes guaranteed to be in the seller
  inventories of the associated teachers at the College of Winterhold. 
  The Master-level spell statements *are* created as well, but
  are commented out by default.

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
  alteration, conjuration, destruction, illusion, restoration: TStringList;
  alterationMaster, conjurationMaster, destructionMaster, illusionMaster, restorationMaster: TStringList;
  seenBooks: TStringList;

function ProcessBook(book: IwbElement; bookCompID: string): integer;
var
  i: integer;
  spell: IwbElement;
  effects: IwbElement;
  baseEffect: IwbElement;
  magicSkill: string;
  newSkillLevel: integer;
  minimumSkillLevel: integer;
  bookName: string;
  spellName: string;
  toLog: string;
begin

  Result := 0;

  // We have a new Spell Tome to process!  Take a look at its spell.
  spell := LinksTo(ElementByPath(book, 'DATA - Data\Spell'));
  spell := WinningOverride(spell);

  // Now we want the *first* MGEF in the Effects list; this is what will
  // tell us the school of the spell, and thus which container to put its
  // book.  One example of a spell with two MGEFs, each in a different
  // magic school: Paralyze (SPEL:0005AD5F).  I'm pretty sure that such a
  // thing is quite rare, but eh.  HOWEVER: we *do* need to loop over all
  // the effects anyway, to correctly interpret the minimum skill level.
  // The first effect will not always be the most expensive one.
  effects := ElementByName(spell, 'Effects');
  magicSkill := '';
  minimumSkillLevel := 0;
  for i := 0 to Pred(ElementCount(effects)) do
  begin
    baseEffect := LinksTo(ElementBySignature(ElementByIndex(effects, i), 'EFID'));
    baseEffect := WinningOverride(baseEffect);
    if magicSkill = '' then magicSkill := GetElementEditValues(baseEffect, 'Magic Effect Data\DATA - Data\Magic Skill');
    newSkillLevel := GetElementNativeValues(baseEffect, 'Magic Effect Data\DATA - Data\Minimum Skill Level');
    if newSkillLevel > minimumSkillLevel then minimumSkillLevel := newSkillLevel;
  end;

  // And now I think we're actually ready to report?  Grab the book name first
  bookName := GetEditValue(ElementBySignature(book, 'FULL'));

  // There is one example of a book which doesn't start with 'Spell Tome:', and
  // it's "Power of the Elements," which provides the spell Fire Storm (and is
  // the reward for the quest "Destruction Ritual Spell").  There is already an
  // ordinary Spell Tome for that spell, so we'll want to just omit that one
  // entirely.  For any other hypothetical tome which doesn't have the usual
  // prefix, I'm leaving some code in here to add in the spell name in
  // parentheses.  That could only really happen if this script is run with
  // mods which add more spells, though.
  if (copy(bookName, 1, 12) <> 'Spell Tome: ') then
  begin

    // Skip that redundant one.
    if (bookName = 'Power of the Elements') then Exit;

    // Append the spell name to anything else
    spellName := GetEditValue(ElementBySignature(spell, 'FULL'));
    bookName := bookName + ' (' + spellName + ')';
  end;

  // And here goes!  Construct the line that we'll pass to the later processing
  toLog := bookName + '|' + bookCompID;

  if minimumSkillLevel < 100 then
  begin
    if magicSkill = 'Alteration' then alteration.Add(toLog)
    else if magicSkill = 'Conjuration' then conjuration.Add(toLog)
    else if magicSkill = 'Destruction' then destruction.Add(toLog)
    else if magicSkill = 'Illusion' then illusion.Add(toLog)
    else if magicSkill = 'Restoration' then restoration.Add(toLog)
    else begin
      AddMessage('ERROR: Unknown Magic Skill (' + magicSkill + ') for spell: ' + Name(spell));
      Result := 1;
      Exit;
    end;
  end
  else
  begin
    if magicSkill = 'Alteration' then alterationMaster.Add(toLog)
    else if magicSkill = 'Conjuration' then conjurationMaster.Add(toLog)
    else if magicSkill = 'Destruction' then destructionMaster.Add(toLog)
    else if magicSkill = 'Illusion' then illusionMaster.Add(toLog)
    else if magicSkill = 'Restoration' then restorationMaster.Add(toLog)
    else begin
      AddMessage('ERROR: Unknown Magic Skill (' + magicSkill + ') for master spell: ' + Name(spell));
      Result := 1;
      Exit;
    end;
  end;

end;

function ProcessBookGroup(file: IwbFile; group: IwbGroupRecord): integer;
var
  i, k: integer;
  book: IwbElement;
  bookFile: IwbFile;
  bookFilename: string;
  bookCompID: string;
  foundBook: boolean;
begin

  for i := 0 to Pred(ElementCount(group)) do
  begin

    // First up: get our BOOK entry and make sure we're looking at the winning version
    book := WinningOverride(ElementByIndex(group, i));

    // Next: I strongly suspect this will all go a lot faster if I filter out
    // non-spell-tomes *first* instead of doing our duplicates-search first, since
    // I have yet to find a set/dict type thing which works in here.
    if (GetElementNativeValues(book, 'DATA - Data\Flags\Teaches Spell') <> True) then Continue;

    // *Now*, let's collect duplicate-detection info.
    bookFile := GetFile(MasterOrSelf(book));
    bookFilename := GetFileName(bookFile);
    if (GetElementNativeValues(ElementByIndex(bookFile, 0), 'Record Header\Record Flags\ESL') = true) then
    begin
      bookCompID := bookFilename + '|' + copy(IntToHex(FixedFormID(book), 8), 6, 3);
    end
    else
    begin
      bookCompID := bookFilename + '|' + copy(IntToHex(FixedFormID(book), 8), 3, 6);
    end;

    // ... and actually do the duplicate detection.  Once again, I'd *really* love some
    // kind of set/hash/dict/assoc-array/whatever rather than array looping.
    foundBook := False;
    for k := 0 to Pred(seenBooks.Count) do
    begin
      if (seenBooks[k] = bookCompID) then
      begin
        foundBook := True;
        Break;
      end;
    end;
    if foundBook then Continue;

    // If we got here, it's a new spell-teaching BOOK, so let's go ahead and process it!
    seenBooks.Add(bookCompID);
    ProcessBook(book, bookCompID);

  end;

  Result := 0;
end;

// Initialization
function Initialize: integer;
var
  i: integer;
  mainFile: IwbFile;
  mainFilename: string;
  bookGroup: IwbGroupRecord;
begin
  alteration := TStringList.Create;
  conjuration := TStringList.Create;
  destruction := TStringList.Create;
  illusion := TStringList.Create;
  restoration := TStringList.Create;

  alterationMaster := TStringList.Create;
  conjurationMaster := TStringList.Create;
  destructionMaster := TStringList.Create;
  illusionMaster := TStringList.Create;
  restorationMaster := TStringList.Create;

  seenBooks := TStringList.Create;

  // Loop through all files looking for BOOK Groups
  for i := 0 to Pred(FileCount) do
  begin
    mainFile := FileByIndex(i);
    bookGroup := GroupBySignature(mainFile, 'BOOK');
    if not Assigned(bookGroup) then Continue;

    ProcessBookGroup(mainFile, bookGroup);
  end;

  Result := 0;
end;

function OutputSchool(output: TStringList; books: TStringList; masterBooks: TStringList; header: string; container: string): integer;
var
  i: integer;
  dividerPos: integer;
begin

  Result := 0;

  output.Add(';;;');
  output.Add(';;; ' + header);
  output.Add(';;;');
  output.Add('');

  books.Sort;
  for i := 0 to Pred(books.Count) do
  begin
    dividerPos := Pos('|', books[i]);
    output.Add('; ' + copy(books[i], 1, dividerPos-1));
    output.Add('filterByContainers=' + container + ':addToContainers=' + copy(books[i], dividerPos+1, Length(books[i])-dividerPos) + '~2');
  end;

  masterBooks.Sort;
  for i := 0 to Pred(masterBooks.Count) do
  begin
    dividerPos := Pos('|', masterBooks[i]);
    output.Add('; ' + copy(masterBooks[i], 1, dividerPos-1) + ' (master spell, disabled by default)');
    output.Add(';filterByContainers=' + container + ':addToContainers=' + copy(masterBooks[i], dividerPos+1, Length(masterBooks[i])-dividerPos) + '~2');
  end;

  output.Add('');

end;

// Called after processing
function Finalize: integer;
var
  eol: string;
  statements: TStringList;
  output: string;
  i: integer;
  frm: TForm;
  ed: TEdit;
begin

  // DOS line endings
  eol := #13#10;

  // Concat all our data together
  statements := TSTringList.Create;
  OutputSchool(statements, alteration, alterationMaster, 'Alteration (Tolfdir)', 'Skyrim.esm|098BA4');
  OutputSchool(statements, conjuration, conjurationMaster, 'Conjuration (Phinis)', 'Skyrim.esm|098BA2');
  OutputSchool(statements, destruction, destructionMaster, 'Destruction (Faralda)', 'Skyrim.esm|098BA1');
  OutputSchool(statements, illusion, illusionMaster, 'Illusion (Drevis)', 'Skyrim.esm|098B9E');
  OutputSchool(statements, restoration, restorationMaster, 'Restoration (Colette)', 'Skyrim.esm|098BA3');

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


  alteration.Free;
  conjuration.Free;
  destruction.Free;
  illusion.Free;
  restoration.Free;
  alterationMaster.Free;
  conjurationMaster.Free;
  destructionMaster.Free;
  illusionMaster.Free;
  restorationMaster.Free;
  statements.Free;

  seenBooks.Free;

  Result := 0;
end;

end.
