{
  vim: set expandtab tabstop=2 shiftwidth=2:

  Create Longer Potion Duration v1.0.0
  ====================================

  This is an xEdit/SSEEdit script which will generate a mod to increase various
  potion durations *without* altering the price of the potions.  This should
  apply to both crafted potions and the "vanilla" potions you find around Skyrim.

  By default, the script scales up duration by 20x, and affects Fortify Barter,
  Fortify Enchanting, and Fortify Smithing potions.  The default duration for all
  three while doing alchemy is 30 seconds, so a 20x increase will result in potions
  which remain active for ten minutes.  "Found" Enchanting potions in the world
  default to one minute, so this'll end up converting those to 20-minute potions.
  ("Found" Barter and Smithing potions are 30 seconds, like their alchemical
  counterparts.)

  Those values can be configured pretty easily in the `Initialize` function.  The
  `scale` variable is simple enough: just alter to suit.  The `modEffects` list is
  what determines which Magical Effects (MGEF) are buffed by the mod.  These are
  specified by their Form ID, so if you want to add in other MGEFs to the list, you'd
  need to look them up.  Since you're running xEdit anyway, that should be simple
  enough!  The FormID for Fortify Carry Weight is already there and commented-out;
  I'd felt that those potions were already sufficiently long and didn't need buffing.

  The generation script by nature will take into account the entire library of mods
  that xEdit has loaded in; it'll always grab the "winning" override from any of the
  forms that it edits.  So it'd be pretty trivial to generate "patch" mods based on
  any arbitrary mod collection.  Take care to not run the script with an already-
  generated mod from this script in the load order, since it'll end up multiplying
  based on the previously-generated mod values!

  Barter/Enchanting/Smiting were chosen in particular because given the way I hoard
  alchemy ingredients, those were the ones whose time restrictions felt like more
  annoyances than gameplay limitations.  I've basically always got an effectively
  infinite supply of those potions available, and I'm only using those potions in
  situations where there's literally no time constraints (like there might be
  during combat, for instance).  Having a tight 30-second timer on them just means 
  that I'm having to do more repetetive admin work while smithing/enchanting.  So
  buffing up the durations for those in particular is, for me, just a QoL thing.
  (I don't actually care about Barter myself; it's easy to be swimming in money
  in the game.  But that's got a similar niche so I figure it made sense to throw
  it in.)

  Credits
  =======

  This mod uses the technique laid out by Nexus user Prime406 in the Posts section
  of the "Longer potions Smithing Barter Enchanting Carryweight" mod.  Thanks to
  them for posting the info!

    https://next.nexusmods.com/profile/Prime406
    https://www.nexusmods.com/skyrimspecialedition/mods/2747?tab=posts&comment_id=110078108

  Other Mods
  ==========

  10 minutes Crafting Potion Duration - Skypatcher
  https://www.nexusmods.com/skyrimspecialedition/mods/168166

    Honestly I'm surprised I didn't look into SkyPatcher for this right off the bat!
    Anyway, this mod only affects Smithing + Enchanting (which are really the only
    two I actually care about anyway) but does *not* address the potion cost concern.
    I believe that a small additional INI file in the `magicEffect` dir would take
    care of that too, though (untested but I think it should work):

      ; Fortify Smithing
      filterByMgefs=Skyrim.esm|3EB1D:baseCost=0.027793
      ; Fortify Enchanting
      filterByMgefs=Skyrim.esm|3EB29:baseCost=0.022234

    Updates both crafted and "found" potions.

  Increased enchanting and smithing potion duration
  https://www.nexusmods.com/skyrimspecialedition/mods/1915
  Increased Enchanting and Smithing Potion Duration - Creation Club Patch
  https://www.nexusmods.com/skyrimspecialedition/mods/27107

    Only affects Smithing + Enchanting (which are really the only two I actually
    care about anyway), and attempts to constrain potion prices as well, though
    it doesn't do so accurately.  This also clobbers some edits from USSEP.
    Also only affects *crafted* potions; the ones you find out in the world are
    unaffected.

  Longer potions Smithing Barter Enchanting Carryweight
  https://www.nexusmods.com/skyrimspecialedition/mods/2747

    Updates both crafted and found potions, but does not make any effort to
    keep cost/value the same, so potion values will skyrocket.

  Potions Durations Tweaks
  https://www.nexusmods.com/skyrimspecialedition/mods/93293

    Affects practically *every* potion in the game, so quite a bit more than
    I'd want to use personally.  It looks like it's probably done the cost/value
    adjustments properly, though, so that potion costs remain the same.  Adjusts
    both crafted potions and ones found out in the world.

  Healing Over Time and Longer Lasting Potions
  https://www.nexusmods.com/skyrimspecialedition/mods/15370

    Rather tangential to my own purpose, really -- the main point of the mod is
    rather different.  This *does* increase the duration of "found" potions in
    the world, and seems to hardcode their value/cost.  The mod doesn't touch
    crafted potions at all, though.

  License
  =======

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

}
unit userscript;

var
  scale: integer;
  modEffects: TList;
  modEffectsDescr: string;

// Called before processing (using this for the main configurable vars in the script)
function Initialize: integer;
begin

  Result := 0;
  modEffects := TList.Create;

  //
  // CONFIGURATION SECTION
  // 
  // If you're making a custom version of this mod, `scale` and `modEffects` should be
  // the only vars you'd want to edit.
  //

  // How much to scale up the duration.
  // Smithing/Barter/Enchanting default is 30s
  // Enchanting ("found" potions only!) default is 60s
  // Carry Weight default is 300s (5min)
  scale := 20;

  // Alchemy effects to alter
  // Fortify Carry Weight
  //modEffects.Add($3EB01);
  // Fortify Smithing
  modEffects.Add($3EB1D);
  // Fortify Barter
  modEffects.Add($3EB23);
  // Fortify Enchanting
  modEffects.Add($3EB29);

  // String representation of the effects we're altering.  Only used in the mod's
  // "description" field, and would only be seen by folks poking around in xEdit
  modEffectsDescr := 'Barter, Enchanting, and Smithing';

end;

//
// MOD GENERATION SECTION
//
// Everything below this point should be ignorable unless you've found a bug somewhere
// and want to fix it, or have some extra features/functionality you want to add
// or change. :)
//
function Finalize: integer;
var
  skyrim: IwbFile;
  newFile: IwbFile;
  fileHeader: IwbElement;
  effectCostDivisor: double;
  
  modEffect: IwbMainRecord;
  i, j, k: integer;
  effectCost: variant;

  ref: IwbMainRecord;
  refFile: IwbFile;
  refFilename: string;
  refFormID: integer;
  compFormID: string;
  globalSeenRefs: TList;
  seenRefs: TList;
  seenRefFilenames: TStringList;
  seenRefComps: TStringList;
  foundRef: boolean;
  refSig: string;

  effects: IwbElement;
  effect: IwbElement;
  baseEffect: IwbElement;
  effectData: IwbElement;
  duration: integer;

begin

  // What to divide the effect Base Cost by, to ensure that the potion costs
  // remain unchanged even with the buffed duration.  Per the UESP wiki,
  // the cost formula is:
  //
  //    effect_base_cost * (Magnitude * Duration / 10) ^ 1.1
  //
  // ... so when scaling the effect cost down, we need to raise the scaling
  // value to the power of 1.1 to compensate for that exponent there.
  //
  // See:
  //    https://en.uesp.net/wiki/Skyrim_Mod:Mod_File_Format/ALCH
  //    https://en.uesp.net/wiki/Skyrim_Mod:Mod_File_Format/INGR
  effectCostDivisor := Power(scale, 1.1);

  // Create a new file -- *without* initial ESL flag, since that would force a .esl
  // extension which we don't want.
  newFile := AddNewFile(False);
  if not Assigned(newFile) then
  begin
    Result := 1;
    Exit;
  end;

  // Now set the ESL flag
  SetElementNativeValues(ElementByIndex(newFile, 0), 'Record Header\Record Flags\ESL', true);

  // Add in some stuff to the header
  fileHeader := ElementByIndex(newFile, 0);
  SetEditValue(ElementBySignature(fileHeader, 'CNAM'), 'Apocalyptech');
  SetEditValue(Add(fileHeader, 'SNAM', True), 'Increase duration of ' + modEffectsDescr + ' potions by ' + IntToStr(scale) + 'x without altering their cost');

  skyrim := FileByIndex(0);
  AddMasterIfMissing(newFile, 'Skyrim.esm');
  // Seems we need Update.esm as well -- Honestly not sure how to programmatically determine that, though.
  // The problem I ran into was Colovian Brandy (ALCH:00036D53).  ccQDRSSE001-SurvivalMode.esl adds in
  // a third Effect which references "Restore Hunger Very Small" (MGEF:01002EE1) which comes from
  // Update.esm.  c'est la vie; I'll just hardcode it.
  AddMasterIfMissing(newFile, 'Update.esm');

  // Process each of the effects we're buffing
  globalSeenRefs := TList.Create;
  for i := 0 to modEffects.Count-1 do
  begin

    // Grab the effect record (we're assuming it's defined in Skyrim.esm; anyone looking to
    // use this script to buff effects introduced by other mods would need to add in
    // some functionality to account for that)
    modEffect := RecordByFormID(skyrim, modEffects[i], True);
    modEffect := wbCopyElementToFile(WinningOverride(modEffect), newFile, False, True);

    // Reduce the Base Cost of the effect, to compensate for the increased duration
    effectCost := GetElementNativeValues(modEffect, 'Magic Effect Data\DATA - Data\Base Cost');
    SetElementNativeValues(modEffect, 'Magic Effect Data\DATA - Data\Base Cost', effectCost/effectCostDivisor);

    // Loop through references to find ALCH and INGR records which also need inclusion.
    // Note that we need to finish looping through these refs before we start constructing
    // our mod, since the reference list would otherwise start growing while we're in
    // the middle of iterating through it.  So we're storing various "seen" lists to keep
    // track of what we've found.  What I really wanted to do was store the reference itself
    // in a list, but I just couldn't get that data to store properly.  Could be a PEBKAC
    // thing, what with my lack of Pascal knowledge, of course.
    seenRefs := TList.Create;
    seenRefFilenames := TStringList.Create;
    seenRefComps := TStringList.Create;
    for j := 0 to ReferencedByCount(modEffect) - 1 do
    begin
      ref := ReferencedByIndex(modEffect, j);
      refFormID := FormID(ref);
      refFile := GetFile(MasterOrSelf(ref));
      refFilename := GetFileName(refFile);

      // I don't see a way around having to check for filename + "local" FormID,
      // and I don't see a way to do that without doing all this lame substring
      // stuff.  This pops up, for instance, in Fortify Smithing's refs, where
      // it references Gold Kanet (among others).  For ESL-defined references
      // like that, we get two separate FormIDs for each reference: one from
      // the Curios ESL and the other from USSEP.
      if (GetElementNativeValues(ElementByIndex(refFile, 0), 'Record Header\Record Flags\ESL') = true) then
      begin
        compFormID := copy(IntToHex(FixedFormID(ref), 8), 6, 3);
      end
      else
      begin
        compFormID := copy(IntToHex(FixedFormID(ref), 8), 3, 6);
      end;

      // Check to see if we've seen this FormID before.  The references will include one
      // element for every file the form is present in, and I don't want to process them
      // more than once.
      foundRef := False;
      for k := 0 to seenRefs.Count-1  do
      begin
        if (seenRefFilenames[k] = refFilename) and (seenRefComps[k] = compFormID) then
        begin
          foundRef := True;
          Break;
        end;
      end;
      if foundRef then Continue;

      // If we got here, we haven't seen the reference yet, so let's add it to our list
      // and process it
      seenRefs.Add(refFormID);
      seenRefFilenames.Add(refFilename);
      seenRefComps.Add(compFormID);
      AddMessage('Processing ref: ' + IntToHex(refFormID, 8) + ' (local: ' + compFormID + ') in ' + refFilename + ', seenRefs size: ' + IntToStr(seenRefs.Count));

    end;

    // We've now filtered through the references so we know what to check.  Do that!
    AddMessage('Okay, done with that.  Now to process these refs: ' + IntToStr(seenRefs.Count));
    for j := 0 to seenRefs.Count-1 do
    begin

      // What I really wanted to do in the previous loop was just, y'know, store the
      // actual reference in a list of some sort, rather than having to re-load them
      // by filename + formID.  I couldn't figure out a way to actually make that work,
      // though, so in the end I'm just loading by filename+formID.  One annoyance is
      // that I also couldn't figure out a way to just grab a file reference by name;
      // we're looping through every single time.
      refFormID := seenRefs[j];
      refFilename := seenRefFilenames[j];
      AddMessage(' - Looking up FormID ' + IntToHex(refFormID, 8) + ' in ' + refFilename);
      ref := Nil;
      for k := 0 to FileCount-1 do
      begin
        refFile := FileByIndex(k);
        if GetFileName(refFile) = refFilename then
        begin
          ref := RecordByFormID(refFile, refFormID, True);
          Break;
        end;
      end;
      if not Assigned(ref) then
      begin
        AddMessage('ERROR: Got a nil reference while looping?');
        Result := 1;
        Exit;
      end;

      // Only process ALCH and INGR references
      refSig := Signature(ref);
      if (refSig <> 'ALCH') and (refSig <> 'INGR') then Continue;

      // Grab the winning override
      ref := WinningOverride(ref);

      AddMessage(' - Iterating: ' + IntToStr(j) + ', formID: ' + IntToHex(FormID(ref), 8));

      // Check to see if this form is in our *global* seen refs.  Some ingredients
      // have multiple effects we care about, and we only want to copy the form over
      // once.
      foundRef := False;
      for k := 0 to globalSeenRefs.Count-1  do
      begin
        if globalSeenRefs[k] = refFormID then
        begin
          AddMessage('   - This ref has been processed by a previous effect');
          foundRef := True;
          Break;
        end;
      end;

      // If we didn't find it in our global list, do the copy and add it there!
      if not foundRef then
      begin

        AddMessage('   - Brand-new effect; copying');

        // Get the filename that we're basing our data on
        refFilename := GetFileName(GetFile(ref));
        AddMasterIfMissing(newFile, refFilename);

        // Also get the ref's master, since we apparently need that too
        refFilename := GetFileName(GetFile(MasterOrSelf(ref)));
        AddMasterIfMissing(newFile, refFilename);

        // Copy the form into our new mod
        ref := wbCopyElementToFile(ref, newFile, False, True);

        // Mark that we've seen this form
        globalSeenRefs.Add(refFormID);

      end;

      // Now increase the duration properly
      effects := ElementByName(ref, 'Effects');
      for k := 0 to ElementCount(effects) - 1 do
      begin
        effect := ElementByIndex(effects, k);
        baseEffect := ElementBySignature(effect, 'EFID');
        // This string comparison bugs the hell out of me but I was having a hell of a time
        // avoiding a "Type mismatch".  FormID() returns a 'cardinal', and I'm specifying
        // just a raw value in modEffects, but damned if I could figure out a way to cast
        // things properly.  In the end this is what I knew that happened to work, so eh.
        // Whatever, I'll cope!
        if IntToStr(FormID(LinksTo(baseEffect))) = IntToStr(modEffects[i]) then
        begin
          effectData := ElementBySignature(effect, 'EFIT');
          duration := GetNativeValue(ElementByName(effectData, 'Duration'));
          SetNativeValue(ElementByName(effectData, 'Duration'), duration*scale);
        end;

      end;

    end;
    seenRefs.Free;
    seenRefFilenames.Free;
    seenRefComps.Free;

  end;
  globalSeenRefs.Free;
  modEffects.Free;

  // Sort masters properly
  SortMasters(newFile);

  // Exit cleanly!
  Result := 0;
end;

end.
