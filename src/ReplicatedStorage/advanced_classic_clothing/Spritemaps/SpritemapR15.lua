--[[

this modulescript contains offsets to the clothing images and their sizes.

]]

local spritesheet = {
	IMAGE_SIZE = Vector2.new(585,559)			-- [V1.2] Specify the size of the clothing image in pixels
												-- If blank or nil, ACC would just use the default size (585x559)
}
spritesheet.__index = spritesheet

--[[

below is an extremely long sheet containing each sprite info and location on where and which to place the image
of a clothing asset to a humanoid character

]]

local upper = Vector2.new(64,63) 	-- image size of the upper limbs (left, right, front, back)
local lower = Vector2.new(64,49) 	-- image size of the lower limbs (left, right, front, back)
local hand = Vector2.new(64,16) 	-- image size of hands and feet (left, right, front, back)
local square = Vector2.new(64,64) 	-- image size of shoulders, hands and feet (top, bottom)

local topOffset = Vector2.new(0,0)

local leftUpper = {
	["Front"] = {
		normalid = Enum.NormalId.Front,
		offset = Vector2.new(308,355),
		size = upper + topOffset
	},
	["Top"] = {
		normalid = Enum.NormalId.Top,
		offset = Vector2.new(308,289),
		size = square,
	},
	["Bottom"] = {
		normalid = Enum.NormalId.Bottom,
		offset = Vector2.new(308,417),
		size = Vector2.new(64,1)
	},
	["Right"] = {
		normalid = Enum.NormalId.Right,
		offset = Vector2.new(506,355) ,
		size = upper + topOffset
	},
	["Back"] = {
		normalid = Enum.NormalId.Back,
		offset = Vector2.new(440,355),
		size = upper + topOffset
	},
	["Left"] = {
		normalid = Enum.NormalId.Left,
		offset = Vector2.new(374,355),
		size = upper + topOffset
	},
}

local leftLower = {
	["Front"] = {
		normalid = Enum.NormalId.Front,
		offset = Vector2.new(308,418),
		size = lower,
	},
	["Right"] = {
		normalid = Enum.NormalId.Right,
		offset = Vector2.new(506,418),
		size = lower
	},
	["Back"] = {
		normalid = Enum.NormalId.Back,
		offset = Vector2.new(440,418),
		size = lower
	},
	["Left"] = {
		normalid = Enum.NormalId.Left,
		offset = Vector2.new(374,418),
		size = lower
	},
	["Top"] = {
		normalid = Enum.NormalId.Top,
		offset = Vector2.new(308,418),
		size = Vector2.new(64,1)
	},
	["Bottom"] = {
		normalid = Enum.NormalId.Bottom,
		offset = Vector2.new(308,463),
		size = Vector2.new(64,1)
	}
}

local lefthand_Foot = {
	["Front"] = {
		normalid = Enum.NormalId.Front,
		offset = Vector2.new(308,467),
		size = hand,
	},
	["Bottom"] = {
		normalid = Enum.NormalId.Bottom,
		offset = Vector2.new(308,485),
		size = square,
	},
	["Top"] = {
		normalid = Enum.NormalId.Top,
		offset = Vector2.new(308,467),
		size = Vector2.new(64,1),
	},
	["Right"] = {
		normalid = Enum.NormalId.Right,
		offset = Vector2.new(506,467),
		size = hand
	},
	["Back"] = {
		normalid = Enum.NormalId.Back,
		offset = Vector2.new(440,467),
		size = hand
	},
	["Left"] = {
		normalid = Enum.NormalId.Left,
		offset = Vector2.new(374,467),
		size = hand
	},
}

--############################################


local rightUpper = {
	["Front"] = {
		normalid = Enum.NormalId.Front,
		offset = Vector2.new(217,355),
		size = upper,
	},
	["Top"] = {
		normalid = Enum.NormalId.Top,
		offset = Vector2.new(217,289),
		size = square,
	},
	["Bottom"] = {
		normalid = Enum.NormalId.Bottom,
		offset = Vector2.new(217,417),
		size = Vector2.new(64,1)
	},
	["Right"] = {
		normalid = Enum.NormalId.Right,
		offset = Vector2.new(151,355),
		size = upper
	},
	["Back"] = {
		normalid = Enum.NormalId.Back,
		offset = Vector2.new(85,355),
		size = upper
	},
	["Left"] = {
		normalid = Enum.NormalId.Left,
		offset = Vector2.new(19,355),
		size = upper
	},
}

local rightLower = {
	["Front"] = {
		normalid = Enum.NormalId.Front,
		offset = Vector2.new(217,418),
		size = lower,
	},
	["Right"] = {
		normalid = Enum.NormalId.Right,
		offset = Vector2.new(151,418),
		size = lower
	},
	["Back"] = {
		normalid = Enum.NormalId.Back,
		offset = Vector2.new(85,418),
		size = lower
	},
	["Left"] = {
		normalid = Enum.NormalId.Left,
		offset = Vector2.new(19,418),
		size = lower
	},
	["Top"] = {
		normalid = Enum.NormalId.Top,
		offset = Vector2.new(308,418),
		size = Vector2.new(64,1)
	},
	["Bottom"] = {
		normalid = Enum.NormalId.Bottom,
		offset = Vector2.new(308,463),
		size = Vector2.new(64,1)
	}
}

local righthand_Foot = {
	["Front"] = {
		normalid = Enum.NormalId.Front,
		offset = Vector2.new(217,467),
		size = hand,
	},
	["Top"] = {
		normalid = Enum.NormalId.Top,
		offset = Vector2.new(217,467),
		size = Vector2.new(64,1)
	},
	["Bottom"] = {
		normalid = Enum.NormalId.Bottom,
		offset = Vector2.new(217,485),
		size = square,
	},
	["Right"] = {
		normalid = Enum.NormalId.Right,
		offset = Vector2.new(151,467),
		size = hand
	},
	["Back"] = {
		normalid = Enum.NormalId.Back,
		offset = Vector2.new(85,467),
		size = hand
	},
	["Left"] = {
		normalid = Enum.NormalId.Left,
		offset = Vector2.new(19,467),
		size = hand
	},
}

--[[

below returns a table which is used by the layered_2d_clothing module which applies the correct sprite to the given body
part and sides mentioned.


normalid = which side to display the sprite on the object (Enum.NormalId)
offset = where the sprite is located on the spritesheet image in pixels
size = the image size in pixels

The actual key that holds the variables above can actually be anything but it is recommended to leave them to defaults.

If you want to spend 8 hours and end up having no hair, You can specify custom datapoints for your spritesheet image here.
]]

spritesheet.spritesheet = function()
	return {
		["UpperTorso"] = {
			["Front"] = {
				normalid = Enum.NormalId.Front,
				offset = Vector2.new(231,74),
				size = Vector2.new(128,96),
			},
			["Top"] = {
				normalid = Enum.NormalId.Top,
				offset = Vector2.new(231,8),
				size = Vector2.new(128,64),
				
			},
			["Bottom"] = {
				normalid = Enum.NormalId.Bottom,
				offset = Vector2.new(231,169),
				size = Vector2.new(128,1),

			},
			["Right"] = {
				normalid = Enum.NormalId.Right,
				offset = Vector2.new(165,74),
				size = Vector2.new(64,96),
			},
			["Left"] = {
				normalid = Enum.NormalId.Left,
				offset = Vector2.new(361,74),
				size = Vector2.new(64,96),
			},
			["Back"] = {
				normalid = Enum.NormalId.Back,
				offset = Vector2.new(427,74),
				size = Vector2.new(128,96)
			},
		},
		["LowerTorso"] = {
			["Front"] = {
				normalid = Enum.NormalId.Front,
				offset = Vector2.new(231,170),
				size = Vector2.new(128,32)
			},
			["Right"] = {
				normalid = Enum.NormalId.Right,
				offset = Vector2.new(165,170),
				size = Vector2.new(64,32)
			},
			["Left"] = {
				normalid = Enum.NormalId.Left,
				offset = Vector2.new(361,170),
				size = Vector2.new(64,32)
			},
			["Back"] = {
				normalid = Enum.NormalId.Back,
				offset = Vector2.new(427,170),
				size = Vector2.new(128,32)
			},
			["Top"] = {
				normalid = Enum.NormalId.Top,
				offset = Vector2.new(231,170),
				size = Vector2.new(128,1)
			},
			["Bottom"] = {
				normalid = Enum.NormalId.Bottom,
				offset = Vector2.new(231,201),
				size = Vector2.new(128,1)
			},
		},
		["LeftUpperArm"] = leftUpper,
		["LeftLowerArm"] = leftLower,
		["LeftHand"] = lefthand_Foot,
		["LeftUpperLeg"] = leftUpper,
		["LeftLowerLeg"] = leftLower,
		["LeftFoot"] = lefthand_Foot,
		["RightUpperArm"] = rightUpper,
		["RightLowerArm"] = rightLower,
		["RightHand"] = righthand_Foot,
		["RightUpperLeg"] = rightUpper,
		["RightLowerLeg"] = rightLower,
		["RightFoot"] = righthand_Foot
	}
end

--[[

[V1.1] JointsNegateOffset adds an offset to the image in pixles which removes the stretched portion
over the joints on an R15 character.

e.g. The arms of an R15 character has parts of the mesh on the UpperArm and LowerArm where 
the joints are "covered" when the arms bend.

To remove the extra streched portion of the joint, extra pixels is added to the image sprite on
the bottom sprite

These offsets may be different on other R15 character meshes

Avaliable on the 1.1 version of this script, older version won't use JointsNegateOffsetR15

The offset format is :
{number, number, number, number} : Offset
 Top	 Bottom	 Left	 Right
 
 appliesToNormalId is self explanitory, which side of the body should it calculate offsets for the
 sprite

]]

local sides_normalIds = {Enum.NormalId.Front,Enum.NormalId.Back,Enum.NormalId.Left,Enum.NormalId.Right}

spritesheet.jointsNegateOffsetR15 = function()
	return {
		["LeftUpperArm"] = {
			["offset"] = {0,17,0,0},
			["appliesToNormalId"] = sides_normalIds
		},
		["LeftLowerArm"] = {
			["offset"] = {17,0,0,0},
			["appliesToNormalId"] = sides_normalIds
		},
		["RightUpperArm"] = {
			["offset"] = {0,17,0,0},
			["appliesToNormalId"] = sides_normalIds
		},
		["RightLowerArm"] = {
			["offset"] = {17,0,0,0},
			["appliesToNormalId"] = sides_normalIds
		},
		["LeftUpperLeg"] = {
			["offset"] = {0,14,0,0},
			["appliesToNormalId"] = sides_normalIds
			
		},
		["LeftLowerLeg"] = {
			["offset"] = {10,0,0,0},
			["appliesToNormalId"] = sides_normalIds
		},
		["RightUpperLeg"] = {
			["offset"] = {0,14,0,0},
			["appliesToNormalId"] = sides_normalIds

		},
		["RightLowerLeg"] = {
			["offset"] = {10,0,0,0},
			["appliesToNormalId"] = sides_normalIds
		}
	}
	
end

--[[

below is the clothing type which is specified when creating a new layered 2d clothing.
For example, the shirt clothing type is made up of the torso and arms.

When creating a custom clothing type, the key must be all lowercase

Custom clothing types are useful so the character model does not get spammed by
hundreds of transparent texture instances.

The easiest clothing type you can make right now is to create a new key called "belt"
then creating a table and put in a string named "LowerTorso".

]]

spritesheet.clothing = function()
	return {
		["shirt"] = {
			"UpperTorso",
			"LowerTorso",
			"LeftUpperArm",
			"LeftLowerArm",
			"LeftHand",
			"RightUpperArm",
			"RightLowerArm",
			"RightHand"
		},
		["pants"] = {
			"UpperTorso",
			"LowerTorso",
			"LeftUpperLeg",
			"LeftLowerLeg",
			"LeftFoot",
			"RightUpperLeg",
			"RightLowerLeg",
			"RightFoot"
		}
	}
end


return spritesheet

