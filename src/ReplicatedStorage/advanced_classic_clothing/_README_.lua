--[[

###########     ########
############    ########
   ##    ####   ## 
   ##    #####  ########
   ##    ## ### ########
   ##    ##  #####
   ##    ##   ##########
   ##    ##    #########

BETTER 2D CLOTHING (a.k.a B2C), formally Advanced Classic Clothing

for complete documentation see devforum link below:
devforum.roblox.com/t/advanced-classic-clothing-v12-layerable-2d-clothing-for-r6-and-r15/3914685?u=thenextelectron

If you are updating ACC from an older version, You must transfer your spritemap data modulescripts to this
newer version.

    @@@@ WARNING: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 	If you are using ACC's properties that starts with an underscore (such as acc._spritesheet_loadermap), They
 	will be made PRIVATE and inaccessable in the next version of ACC. I am currently in the process of making
 	things private (for security) which should be take effect in the next update of ACC.
 	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Updates:

17.3.26 [V1.4] "Death of Classic clothing" DMY

 - Fixed R6 Blocky rig: NO MORE SHARP EDGES!!!!
 
   The removal of those "sharp edges" also means the UV calculations are no longer needed, User @gleb_zototar has provided
   the complete R6 rig with proper UV mapping without the need of a Humanoid.
   
 - Added Texture table which just contains the names of the properties for the Texture class. (acc.Texture : {propertyName : string})
   
 - Added r6Fix (Fake R6) This is a fake R6 rig which is used only for ACC. This is where R6 blocky rigs store all layered clothing.
   This uses the alformentioned R6 parts provided by @gleb_zototar
   
   This FakeR6 rig replicates all it's properties from it's respective real R6 part in real time (as best as it can) which means that devs
   don't need to change nothing in their other scripts if they need to change the properties of the real R6 rig (e.g. Transparency/Body colours.)
   
   (experimental/may cause replication errors) Added an option for Unified FakeR6 which toggles ACC to use the same rig for both server and client (default OFF)
   
 - FULLY DEPRECATED AND REMOVED all support for R6 (meshed) rigs. They never worked anyway.
  
 - [Spritemaps] Added ACCRigPartCFrameR6(). This contains a table with the name of an R6 part and the CFrame, only used to rotate and offset the fake rig
   
 - REMOVED all spritemap data for R6 Blocky. If you want to have those old "sharp edges" again, revert back to 1.31 (the last)
   version with the legacy R6 spritemap (history on the Devforum). You can have 1.31 and any newer ACC version coexist thanks to the power of OOP.
   Attempting to use meshed R6 causes warnings and no visual change to the R6 character.
 
 - Moved this changelog to a new modulescript because it is now getting too long
 	
 - dedicated spritemaps for meshed R15 rigs are still in progre-- NOT! sorry was lazy and tried fixing R6 instead.
   (they should be completed soon)
   
3.3.26 [V1.31] DMY

 - Added SpritemapR15_dogu15 which is used only for the Dogu15 rig. User @Int_Illigence and @jonmxl showed overlapping textures, This is because of the
   default R15 containing JointsNegate offsets which do not exist in Dogu15.
   To use the Dogu15 rig, add "Spritemap_dogu15" as an extra parameter when initialising a new clothing asset. (optional_spriteMap)

7.2.26 [V1.3] DMY
 - Added function getObjectId(), returns the current class object memory location as a string, Not really useful now, implemented for possible future use.
 - Added function getSpriteMaps(), returns a clone of the _SPRITEMAP table
 - For the optional spritemap, You can now return the entire modulescript instead
 - Changed "spritesheet" to "spritemap", It is the modulescripts which positions the clothing textures.
 	- The core script may still have mentions for the old "spritesheet"
 - Spritemap modulescripts are stored on their own folder
(experimental) Adding dedicated spritemap profiles for Robloxian 2.0 and Man rig.
 - Added mentions for Adaptive R6
 - Moderate code adjustments

10.10.2025 [V1.2] DMY
The size and position of the sprites now change when the character's body proportions have changed.
Added IMAGE_SIZE in the spritesheet data moduescript, You can specify a custom resolution.
Added "ChangeTexturePropertyFromBodyPartName(bodyPartName,property,value)"
	gets all textures from body part and applies the property specified in the parameter.
Updated spritesheet_applicator to change sprite size and position, which is binded to the character size change
Added TNE logo

24.9.2025 hotfixes [V1.11] DMY
Tuned joints negates for R15 characters (jointsNegateOffsetR15)
Fixed the left sprite size for R15 UpperTorso, the sprite size was set to 128,96 instead of 64,96 by mistake

23.9.2025 [V1.1] DMY
Added jointsNegateOffsetR15 - remove the stretched part of the texture on R15 characters, see SpritesheetR15 for more info
	This now fixes the issue in the initial release where details on arms and legs are missing around the joints area
Added method "getClothingTexturesFromBodyPartName(bodyPartName)" which returns all sprite images for that body part
Updated module name require to "spritesheet_applicator" (hotfix, but the hot is silent)

R15				[✓]	   (recommended)	Use the generic SpritesheetR15 modulescript including meshed bundles*
"New R6"		[✓]						aka Adaptive R6, which uses R15 
R6 (blocky)		[✓]						Uses FakeR6 for layered/HQ clothing. (1.4+)
Custom			[~]						You are required to copy and edit an existing spritemap or write one from scratch for any non R15 rigs.
R6 (meshed)		[X]						Never displayed correctly in early releases, now no longer supported on ACC 1.4+

USAGE:

layered_clothing.new("your_clothing_name", "rbxassetid://1", game.workspace.humanoidModel, "Shirt")
					 Clothing name		   Image ID		     Character						Clothing type
					 
The clothing type (if using the default spritesheet data modulescripts) must be a "shirt" or "pants", It is not case sensitive
If you customised the spritesheet modulescript with a custom clothing type (i.e shoes) you can specify the clothing type to "shoes"

The last paramter after clothing type is an optional string to explicitly use another spritesheet modulescript.
					
	returns layered_clothing
	
*tested with Robloxian 2.0 bundle and one rtho UGC package
]]