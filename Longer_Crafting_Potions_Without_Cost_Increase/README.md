Longer Crafting Potions Without Cost Increase
=============================================

This is an [xEdit/SSEEdit](https://github.com/TES5Edit/TES5Edit) script which
will generate a mod to increase various potion durations *without* altering the
price of the potions.  This should apply to both crafted potions and the
"vanilla" potions you find around Skyrim.  At the moment there is *not* a
pre-generated `.esp` file stored here; I may put one together at some point.

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

Installation
============

As I mention above, I currently don't have a pre-generated `.esp` in here,
though I may generate some later.  The main problem is that I hate having to
deal with "patch" files in that ecosystem, and I'd feel compelled to generate
a few different variants.  (And then the "proper" way to package that up would
almost certainly be with [FOMOD](https://www.nexusmods.com/skyrimspecialedition/mods/141001)
definitions and such, and I'd sort of rather not bother trying to figure that
out properly.)  I *could* always just package up some different versions
separately, of course...

Mod Generation
==============

See the [`generation_scripts`](generation_scripts/) directory for the
xEdit script used to generate the mod.  Running it against your current
mod set would give you a version custom-built to whatever you happen to
be running!

Credits
=======

This mod uses the technique laid out by Nexus user
[Prime406](https://next.nexusmods.com/profile/Prime406) in the
[Posts section of the "Longer potions Smithing Barter Enchanting Carryweight" mod](https://www.nexusmods.com/skyrimspecialedition/mods/2747?tab=posts&comment_id=110078108).
Thanks to them for posting the info!

Other Mods
==========

There are some other mods which do similar things which I'd looked into
first; here's my notes on 'em!

### [10 minutes Crafting Potion Duration - Skypatcher](https://www.nexusmods.com/skyrimspecialedition/mods/168166)

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

### [Increased enchanting and smithing potion duration](https://www.nexusmods.com/skyrimspecialedition/mods/1915) + [Increased Enchanting and Smithing Potion Duration - Creation Club Patch](https://www.nexusmods.com/skyrimspecialedition/mods/27107)

Only affects Smithing + Enchanting (which are really the only two I actually
care about anyway), and attempts to constrain potion prices as well, though
it doesn't do so accurately.  This also clobbers some edits from USSEP.
Also only affects *crafted* potions; the ones you find out in the world are
unaffected.

### [Longer potions Smithing Barter Enchanting Carryweight](https://www.nexusmods.com/skyrimspecialedition/mods/2747)

Updates both crafted and found potions, but does not make any effort to
keep cost/value the same, so potion values will skyrocket.

### [Potions Durations Tweaks](https://www.nexusmods.com/skyrimspecialedition/mods/93293)

Affects practically *every* potion in the game, so quite a bit more than
I'd want to use personally.  It looks like it's probably done the cost/value
adjustments properly, though, so that potion costs remain the same.  Adjusts
both crafted potions and ones found out in the world.

### [Healing Over Time and Longer Lasting Potions](https://www.nexusmods.com/skyrimspecialedition/mods/15370)

Rather tangential to my own purpose, really -- the main point of the mod is
rather different.  This *does* increase the duration of "found" potions in
the world, and seems to hardcode their value/cost.  The mod doesn't touch
crafted potions at all, though.

License
=======

- The xEdit script is licensed under the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/):
  ([`LICENSE-xEdit_Script-MPL2.txt`](LICENSE-xEdit_Script-MPL2.txt))

Changelog
=========

**v1.0.0** - *March 2, 2026*
 - Initial version (just the generation script)

