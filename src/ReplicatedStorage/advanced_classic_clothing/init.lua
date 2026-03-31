local _SPRITEMAP = { -- enter a custom spritemap script here
	["R6"] = script.Spritemaps.SpritemapR6_Blocky,				-- blocky R6
	["R15"] = script.Spritemaps.SpritemapR15,					-- generic R15
	["R15_dogu15"] = script.Spritemaps.SpritemapR15_dogu15, 	-- R15 dogu15 rig, see 1.31 minor update.
	["Robloxian2.0"] = script.Spritemaps.SpritemapR15_Robloxian20,
	["ManRig"] = script.Spritemaps.SpritemapR15_ManRig,
}
-- i might turn this into a type l8tr
local textureProperties = {
	OffsetStudsU = "OffsetStudsU",
	OffsetStudsV = "OffsetStudsV",
	StudsPerTileU = "StudsPerTileU",
	StudsPerTileV = "StudsPerTileV",
	ZIndex = "ZIndex",
	Color3 = "Color3",
	Transparency = "Transparency",
	ColorMap = "ColorMap",
	Texture = "ColorMap",
	Face = "Face"
}

local _debug = true --									<-- set to true to enable debug prints
local _r6_unified_acc = false	--						<-- [V1.4 EXPERIMENTAL] R6 ACC will use the same fake blocky rig for use by ACC in the server and client boundaries
--															False (recommended) ACC uses it's own rig in their own server/client boundary.

local _spritesheet = require(script.spritesheet_applicator)			-- the spritesheet applicator
local face_side = require(script.spritesheet_applicator.faceSide)	-- get the 2d plane size from a 3d object from zindex
local r6Fix = require(script.r6Fix)									-- creates a fake R6 rig used only for Advanced Classic Clothing
local _R6_STORE = {}
local serverClient = "Server"

if game:GetService("RunService"):IsClient() then
	serverClient = "Client"
else
	serverClient = "Server"
end

local output = function(t)
	if _debug == true then
		local m = debug.traceback(t)
		print(m)
	end
end


local layered_clothing = {}
layered_clothing.Texture = table.clone(textureProperties)
local PRIVATE = {}

layered_clothing.__index = layered_clothing


local RES_SCALE = 1				-- advanced (default 1, don't change) - Change resolution scale

r6Fix.setUnified(_r6_unified_acc)

-- Change the rig colour (to match or update) the rig colours for the fake R6 rig.
function R6_ChangeBodyColour(fakeRig,humanoid : Humanoid)
	local humanoid_description = humanoid:FindFirstChildWhichIsA("HumanoidDescription")
	if humanoid_description then
		local sourceTarget = {
			["Torso"] = "TorsoColor",
			["Left Arm"] = "LeftArmColor",
			["Right Arm"] = "RightArmColor",
			["Left Leg"] = "LeftLegColor",
			["Right Leg"] = "RightLegColor"
		}
		
		for source,HDAttribute in sourceTarget do
			local bodyPart = fakeRig:FindFirstChild(source)
			if bodyPart then
				local bodyColour = humanoid_description[HDAttribute]
				bodyPart.Color = bodyColour
			end
		end
	end
end

layered_clothing.new = function(name : string,imageId,humanoidModel : Model,clothingType : string,optional_spriteMap)
	if humanoidModel then
		clothingType = string.lower(clothingType)
		
		local humanoid = humanoidModel:FindFirstChildWhichIsA("Humanoid")
		if not humanoid then
			error("No humanoid found in model")
		end
		
		local _spritemap = _SPRITEMAP[humanoid.RigType.Name]
		
		local targetSpriteSheet
		if optional_spriteMap then
			if type(optional_spriteMap) == "string" then
				_spritemap = _SPRITEMAP[optional_spriteMap]
			elseif typeof(optional_spriteMap) == "Instance" then
				if optional_spriteMap.ClassName == "ModuleScript" then
					_spritemap = optional_spriteMap
				else
					error("The sprite map is not a valid Modulescript")
				end
			end
		end

		if _spritemap then
			targetSpriteSheet = require(_spritemap)
		else
			error("Unable to find spritesheet name " .. humanoid.RigType.Name .. " Or string " .. optional_spriteMap .. " Not found")
		end
		local imageSize = (targetSpriteSheet.IMAGE_SIZE or Vector2.new(585,559)) * RES_SCALE
		local clothingTexture = _spritesheet.loadImage(
			{
				imageId = imageId,
				imageSizePx = imageSize
			}
		)
		
		local _ac = {}
		setmetatable(_ac,layered_clothing)
		PRIVATE[tostring(_ac)] = {}
		PRIVATE[tostring(_ac)].Humanoid = humanoid
		PRIVATE[tostring(_ac)].Character = humanoidModel
		_ac._image_assets = {}
		_ac._image_assets_from_body_part = {}
		_ac._clothingType = clothingType
		_ac._objectChangedSizeEvents = {}
		_ac._spritesheet_loadermap = clothingTexture
		
		local clothing_assembly = targetSpriteSheet.clothing()[clothingType] -- the clothing type, pants or shirt and any predefined by the spritesheet data e.g. gloves or shoes
		
		if clothing_assembly == nil then
			error("Cannot find clothing type " .. clothingType .. ", Clothing type is not case sensitive")
		end
		
		if humanoid.RigType.Name == "R6" then
			local ACCRigPartCFrame = targetSpriteSheet.ACCRigPartCFrameR6()

			-- [V1.4] -- Create fake R6 blocky rig used only for ACC. For each R6 character, there can only be one fake R6 rig for use with ACC.

			local fakeR6 = r6Fix.new(humanoid,ACCRigPartCFrame)
			if fakeR6 then
				for _,partName in clothing_assembly do
					local targetPart = fakeR6:FindFirstChild(partName)
					if targetPart then
						local texture = Instance.new("Texture",targetPart)
						texture.Name = name .. _ac:getObjectId()
						texture.Texture = imageId
						_ac._image_assets_from_body_part[partName] = {texture}
						table.insert(_ac._image_assets,texture)
						
						local humanoidDescriptionChanged = humanoid.ApplyDescriptionFinished:Connect(function(description)
							R6_ChangeBodyColour(fakeR6,humanoid)
						end)
						
						table.insert(_ac._objectChangedSizeEvents,humanoidDescriptionChanged)
						
						local realPart = humanoidModel:FindFirstChild(partName)
						
						if realPart then
							local realPartChanged = realPart.Changed:Connect(function(property)
								local changed,_ = pcall(function()
									local value = realPart[property]
									targetPart[property] = value
								end)
							end)
						end
						R6_ChangeBodyColour(fakeR6,humanoid)
					end
				end
			end
		end
		
		if humanoid.RigType == Enum.HumanoidRigType.R15 then
			local ss_data = targetSpriteSheet.spritesheet() -- the spritesheet data containing the location and size of the images in pixels
			local ss_negate_offsets
			if targetSpriteSheet["jointsNegateOffsetR15"] and humanoid.RigType.Name == "R15" then
				ss_negate_offsets = targetSpriteSheet.jointsNegateOffsetR15()
			end
			for _,_bodyPartName in clothing_assembly do
				local body_part_data = ss_data[_bodyPartName]
				
				local sprite_offset_data		-- get the current offset from the select body part name
				local offsets_normalIds
				if ss_negate_offsets and ss_negate_offsets[_bodyPartName] then
					sprite_offset_data = ss_negate_offsets[_bodyPartName].offset
					offsets_normalIds = ss_negate_offsets[_bodyPartName].appliesToNormalId
				end
				local character_body_part = humanoidModel:FindFirstChild(_bodyPartName)
				if body_part_data and character_body_part then
					_ac._image_assets_from_body_part[_bodyPartName] = {}
					for _sidename,currentSpriteData in body_part_data do
						local normalid = currentSpriteData.normalid
						local offset = currentSpriteData.offset * RES_SCALE
						local size = currentSpriteData.size * RES_SCALE
						-- get target body size from the normalid
						
						local object_size_2d = face_side:get2dObjectSize(character_body_part,normalid) -- returns a 2d vector cross section for the current side of the body part
						
						local centreMeshImage = Vector2.zero
						if humanoid.RigType.Name == "R15" then
							centreMeshImage = object_size_2d / 2 -- for some reason the image appears centred if the part is a mesh so divide the 2d cross section by 2 to resolve -- this weird issue also showed up on the CRT model (the screen is curved) which is why the applicator has an offset parameter already
							
							-- [V1.1] Modify sprite image offset and size with negate offsets (remove streched image on R15 joints)
							
							if sprite_offset_data then
								local top = (sprite_offset_data[1] or 0) * RES_SCALE
								local bottom = (sprite_offset_data[2] or 0) * RES_SCALE
								local left = (sprite_offset_data[3] or 0) * RES_SCALE
								local right = (sprite_offset_data[4] or 0) * RES_SCALE
								if table.find(offsets_normalIds,normalid) then
									-- calculate top left sides
									offset = offset - Vector2.new(left,top)
									size = size + Vector2.new(left,top)
									--calculate bottom right sides
									size = size + Vector2.new(right,bottom)
								end
							end
						end
						
						if object_size_2d and offset and size then
							local offset_dictionary = 							{
								offsetStuds = centreMeshImage
							}
							
							local clothing_sprite = clothingTexture:getSpriteIcon(
								offset,
								size,
								object_size_2d,
								offset_dictionary
							)
							if clothing_sprite then
								clothing_sprite.Parent = character_body_part
								clothing_sprite.Face = normalid
								clothing_sprite.Name = _ac:getObjectId() .. "_" .. name .. "_" .. _sidename
								table.insert(_ac._image_assets,clothing_sprite) -- add image sprite to the list of all images.
								table.insert(_ac._image_assets_from_body_part[_bodyPartName],clothing_sprite)
								
								-- [V1.2] Update size of sprite image when character proportions changes.
								local sizePropertyChanged = character_body_part:GetPropertyChangedSignal("Size"):Connect(function()
									local newSize_2d = face_side:get2dObjectSize(character_body_part,normalid)
									if offset_dictionary.offsetStuds ~= Vector2.zero then
										offset_dictionary.offsetStuds = newSize_2d / 2
									end
									clothingTexture:UpdateSizeFromAttributes(clothing_sprite,offset,size,newSize_2d,offset_dictionary)
								end)

							end
						end
					end
				else
					output("Cannot find sprite sheet data for " .. _bodyPartName .. " Ignoring")
				end
			end
		end
		
		_ac.__clothingType = clothingType
		
		return _ac
	else
		error("No humanoidmodel specified")
	end
end


function layered_clothing:ChangeTextureProperty(property : string,value : any)
	for _,sprites in self._image_assets do
		if sprites:isA("Texture") then
			sprites[property] = value
		end
	end
end

function layered_clothing:ChangeTexturePropertyFromBodyPartName(bodyPartName : string,property : string, value : any)
	local textures = self:getClothingTexturesFromBodyPartName(bodyPartName)
	if textures then
		for _,sprites in textures do
			sprites[property] = value
		end
	end
end

function layered_clothing:ChangeZIndex(zindex : number)
	self:ChangeTextureProperty("ZIndex",zindex)
end

function layered_clothing:getClothingType()
	return self._clothingType
end

function layered_clothing:DestroyMethods()
	self._image_assets = nil
	self._image_assets_from_body_part = nil
	self._clothingType = nil
	self._spritesheet_loadermap = nil
	for _,changedSizeEvents in self._objectChangedSizeEvents do
		changedSizeEvents:Disconnect()
		changedSizeEvents = nil
	end
	table.clear(self)
	table.clear(PRIVATE[tostring(self)])
	PRIVATE[tostring(self)] = nil
	return nil
end

function layered_clothing:Destroy()
	local image_assets = self._image_assets
	self._spritesheet_loadermap:DestroyAllInstances()
	for _,createdTextures in self._image_assets do
		if createdTextures then
			createdTextures:Destroy()
		end
	end
	if r6Fix.DoesFakeRigContainsTexutures(PRIVATE[tostring(self)].Humanoid) == false then
		r6Fix.Destroy(PRIVATE[tostring(self)].Humanoid)
	end
	return self:DestroyMethods()
end

function layered_clothing:getAllClothingTextures()
	return table.clone(self._image_assets)
end

function layered_clothing:getClothingTexturesFromBodyPartName(bodyPartName : string)
	local image_assets = self._image_assets_from_body_part[bodyPartName]
	if image_assets then
		return image_assets
	end
end

function layered_clothing:getObjectId()
	return string.split(tostring(self),"table:")[2]
end

function layered_clothing:getSpriteMaps()
	return table.clone(_SPRITEMAP)
end

return layered_clothing