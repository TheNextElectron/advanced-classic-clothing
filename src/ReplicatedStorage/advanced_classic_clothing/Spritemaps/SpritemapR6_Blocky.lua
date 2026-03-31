--[[

     @@@ MESHED R6 DEPRECIATION @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
     As of 1.4, Meshed rigs are no longer supported. The only R6 rig left supported is Blocky.
     Attempting to use this spritemap modulescript in older versions of ACC would result in an error,
     Trying to force this spritemap to a meshed R6 will not work and would cause an error.
	 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

]]

local spritesheet = {}

--[[

[V1.4] The fake R6 rig (ACC rig) is mainly used for the Blocky character. If you
want to change the orientation of any bodypart or displace them using CFrames,
you can edit the keys below.

The way the fake rigs are attached is by using RigidConstraints and the CFrame below
are applied on Attachment0 of the RigidConstraint

You can change the values below if something don't look right or create some of the
most cursed R6 rigs in ROBLOX.

]]
spritesheet.ACCRigPartCFrameR6 = function()
	return {
		["Torso"] = CFrame.Angles(0,math.rad(180),0),
		["Left Leg"] = CFrame.Angles(0,math.rad(180),0),
		["Right Leg"] = CFrame.Angles(0,math.rad(180),0),
		["Left Arm"] = CFrame.Angles(0,math.rad(180),0),
		["Right Arm"] = CFrame.Angles(0,math.rad(180),0),
	}
end

spritesheet.clothing = function()
	return {
		["shirt"] = {
			"Torso",
			"Left Arm",
			"Right Arm",
		},
		["pants"] = {
			"Torso",
			"Left Leg",
			"Right Leg",
		}
	}
end

return spritesheet

