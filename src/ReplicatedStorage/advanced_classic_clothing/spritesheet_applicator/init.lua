--[[

###########     ########
############    ########
   ##    ####   ## 
   ##    #####  ########
   ##    ## ### ########
   ##    ##  #####
   ##    ##   ##########
   ##    ##    #########
  
	creates an image from a spritesheet where the image is contained in a texture
	When creating a new instance the exact image resolution must be entered in the parameters or else the spritesheet may look off

	Use Destroy() to remove the current instance without removing the sprite images.

]]

function value_switch(dictionary,original_key_name, alternate_value) -- same as local value = a or b without IndexError
	local f = nil
	local s,_ = pcall(function()
		f = dictionary[original_key_name]
	end)
	if s == false or f == nil then
		f = alternate_value
	end
	return f
end

local spritesheet_picker = {}
spritesheet_picker.__index = spritesheet_picker


spritesheet_picker.loadImage = function(data)
	
	local imageId = data.imageId
	local imageSizePx = data.imageSizePx
	
	local _spritesheet = {}
	setmetatable(_spritesheet,spritesheet_picker)
	_spritesheet._imageId = imageId
	_spritesheet._imageSize = imageSizePx
	_spritesheet._instance = Instance.new("Texture")
	_spritesheet._instance.Texture = imageId
	_spritesheet._instance.StudsPerTileU = _spritesheet._imageSize.X
	_spritesheet._instance.StudsPerTileV = _spritesheet._imageSize.Y
	_spritesheet._createdImages = {}
	return _spritesheet
end

function updateSpriteSize(currentSprite : Texture, imageSize : Vector2, start_pointPx : Vector2, sprite_sizePx : Vector2, object_size : Vector2, offsets)
	-- pixels bmp relative to object size in studs (2d plane) calculations
	
	-- for some reason it gives an error if there is a missing key which means it does not use the operator
	local studsPerTileOverrides = value_switch(offsets,"studsPerTileOverrides",Vector2.zero) --offsets["studsPerTileOverrides"] or Vector2.new(0,0) -- offsets
	local offsetStuds = value_switch(offsets,"offsetStuds",Vector2.zero)  --offsets["offsetStuds"] or Vector2.new(0,0)
	
	local cellSize_Px = (sprite_sizePx / object_size) / imageSize 					-- convert image size in pixels to studs
	local imageSize_studs = (object_size / cellSize_Px) / object_size

	local startPoint_studs = imageSize_studs * (start_pointPx / imageSize)			-- convert start point to studs
	
	-- offsets
	
	local imageSize_studs = imageSize_studs + studsPerTileOverrides					-- add in the offsets
	local startPoint_studs = startPoint_studs + offsetStuds							-- start point in studs offset
	
	currentSprite.StudsPerTileU = imageSize_studs.X
	currentSprite.StudsPerTileV = imageSize_studs.Y
	currentSprite.OffsetStudsU = startPoint_studs.X
	currentSprite.OffsetStudsV = startPoint_studs.Y
	
	return studsPerTileOverrides,offsetStuds
end

function updateSpriteAttribute(existingSprite : Texture,start_pointPx,sprite_sizePx,object_size,studsPerTileOffsets,offsetStuds)
	existingSprite:SetAttribute("SpriteStartPoint",start_pointPx)		-- start point in pixels
	existingSprite:SetAttribute("SpriteSizePixels",sprite_sizePx)		-- image size
	existingSprite:SetAttribute("objectSizeStuds",object_size)			-- object 2d plane size
	existingSprite:SetAttribute("Offset_studsPerTile",studsPerTileOffsets)						-- offsets
	existingSprite:SetAttribute("Offset_StartPointStuds",offsetStuds)
end

function spritesheet_picker:getSpriteIcon(start_pointPx : Vector2, sprite_sizePx : Vector2,object_size : Vector2,offsets)
	local sprite = Instance.fromExisting(self._instance) -- texture
	
	local studsPerTileOffsets, offsetStuds = updateSpriteSize(sprite,self._imageSize,start_pointPx,sprite_sizePx,object_size,offsets)
	updateSpriteAttribute(sprite,start_pointPx,sprite_sizePx,object_size,studsPerTileOffsets,offsetStuds)
	
	table.insert(self._createdImages,sprite)
	return sprite
end

function spritesheet_picker:UpdateSizeFromAttributes(existingSprite : Texture,start_pointPx : Vector2, sprite_sizePx : Vector2, object_size : Vector2, offsets)
	local istexturePartOfObject = table.find(self._createdImages,existingSprite) ~= nil
	if istexturePartOfObject then
		
		start_pointPx = start_pointPx or existingSprite:GetAttribute("SpriteSizePixels")		-- start point in pixels
		sprite_sizePx = sprite_sizePx or existingSprite:GetAttribute("SpriteSizePixels")		-- sprite size
		object_size = object_size or existingSprite:GetAttribute("objectSizeStuds")				-- object size 2d plane
		
		-- get offsets and convert it back to a keypair dictionary
		local offset_studsPerTile = offsets.studsPerTileOverrides or existingSprite:GetAttribute("Offset_studsPerTile")
		local offset_startPointStuds = offsets.offsetStuds or existingSprite:GetAttribute("Offset_StartPointStuds")
		
		local offset_dictionary = {
			studsPerTileOverrides = offset_studsPerTile,
			offsetStuds = offset_startPointStuds
		}
		-- recalculate the size, start point and offsets in the image 
		updateSpriteSize(existingSprite,self._imageSize,start_pointPx,sprite_sizePx,object_size,offset_dictionary)
		-- update current sprite attributes
		updateSpriteAttribute(existingSprite,start_pointPx,sprite_sizePx,object_size,offset_studsPerTile,offset_startPointStuds)
	else
		error("The texture is not part of the current spritesheet picker object!")
	end
end

function spritesheet_picker:Destroy()
	self._instance:Destroy()
	self = nil
	return nil
end

function spritesheet_picker:DestroyAllInstances()
	for _,createdImages in self._createdImages do
		if createdImages then
			createdImages:Destroy()
		end
	end
	self:Destroy()
end

return spritesheet_picker
