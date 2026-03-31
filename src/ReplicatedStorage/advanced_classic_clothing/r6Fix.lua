--[[
The goal for 1.4 was to bring support for meshed R6 rigs. It went so well that that I SCRAPPED IT!!!!
Turns out that some of the ROBLOX R6 meshes has their own UV mapping for Textures, which messes up ACC's own
UP mapping which results to messy rigs. in the devforum, I stated that meshed R6 is entirely unsupported.

Thankfully, better blocky R6 support is added in, which uses some community-sourced MeshParts with fully
functional UV mapping which means ACC is not needed at all! ACC is now used to manage Texture objects, change
texture properties, transparency and stuff like that.

From V1.4 onwards, the SpritemapR6_Blocky spritemap is entirely removed.
]]

local runservice = game:GetService("RunService")

local _R6_UNIFIED = false -- controlled by a setting where ACC would use one rig for both client and server.

function getRunInfo(isClient)
	if _R6_UNIFIED == true then
		return ""
	end
	isClient = isClient or runservice:IsClient()
	if isClient then
		return "Client"
	else
		return "Server"
	end
end


-- i went to the toolbox, searched up "r6 blocky mesh" and found these meshes from @gleb_zototar. These
-- are actually intended for R6 poses, it is completely UV mapped which means that there is no need for ACC to do the spritemapping.
local BlockyRig = {
	["LeftArm"] = "rbxassetid://82557091159947",
	["RightArm"] = "rbxassetid://131826949635623",
	["LeftLeg"] = "rbxassetid://109302786609504",
	["RightLeg"] = "rbxassetid://93063343924594",
	["Torso"] = "rbxassetid://76316612146587"
}

local r6_parts = {
	"LeftArm",
	"RightArm",
	"LeftLeg",
	"RightLeg",
	"Torso"
}

local r6_partNames = {
	["LeftArm"] = "Left Arm",
	["RightArm"] = "Right Arm",
	["LeftLeg"] = "Left Leg",
	["RightLeg"] = "Right Leg",
	["Torso"] = "Torso"
}

function createFakePart(fakePartName : string, meshId : string,character : Model, fakePartsFolder : Folder,fakeRigAlignment)
	local realPart = character:FindFirstChild(r6_partNames[fakePartName])
	local realName = r6_partNames[fakePartName]
	if not realPart then -- classic brickbattling may result to character losing their limbs
		warn("Cannot find part " .. r6_partNames[fakePartName])
		return
	else
		local fakePart = Instance.new("Part",fakePartsFolder)
		fakePart.Name = r6_partNames[fakePartName]
		fakePart.Size = realPart.Size
		fakePart.CanCollide = false
		fakePart.Transparency = realPart.Transparency
		realPart.Transparency = 1
		
		local specialMesh = Instance.new("SpecialMesh",fakePart)
		specialMesh.MeshId = meshId

		local attachment0, attachment1 = Instance.new("Attachment",realPart),Instance.new("Attachment",fakePart)
		attachment0.Name = "fakePartAttachment0"
		attachment1.Name = "fakePartAttachment1"
		
		local alignment = fakeRigAlignment[realName] or CFrame.new(0,0,0)
		
		local rigidConstraint = Instance.new("RigidConstraint",fakePart)
		rigidConstraint.Attachment0 = attachment0
		rigidConstraint.Attachment1 = attachment1
		
		rigidConstraint.Attachment0.CFrame = alignment
		
		return fakePart
	end
end

-- threshold 0  = Absolutely no R6 meshes, higher = lower detection threshold.
function containsMeshedRigs(character : Model,threshold : number)
	threshold = threshold or 0
	local found = table.clone(r6_partNames)
	local count = 0
	for _,characterMesh in pairs(character:GetChildren()) do
		if characterMesh:IsA("CharacterMesh") then
			local meshId = characterMesh.MeshId
			if meshId then
				local isAdornee = found[characterMesh.BodyPart.Name]
				if isAdornee then
					found[characterMesh.BodyPart.Name] = nil
					count +=1
				end
			end
		end
	end
	if count <= threshold then
		return false
	end
	return true
end

function queryCharacterMesh(character : Model,fakePartsFolder : Folder,fakeRigAlignment)
	local found = table.clone(r6_parts)

	for _,characterMesh in pairs(character:GetChildren()) do
		if characterMesh:IsA("CharacterMesh") then
			local meshId = characterMesh.MeshContent
			local bodyPartAdornee = characterMesh.BodyPart
			
			local duplicate = table.find(found,bodyPartAdornee.Name)
			
			if (meshId and bodyPartAdornee) and not(bodyPartAdornee == Enum.BodyPart.Head) and duplicate then
				warn("ACC WARNING: Found unsupported meshed rig for body part " .. bodyPartAdornee.Name)
				table.remove(found,duplicate)
			end
		end
	end
	
	for _,bodyPartName in found do
		local meshId = BlockyRig[bodyPartName]
		local fakePart = createFakePart(bodyPartName,meshId,character,fakePartsFolder,fakeRigAlignment)
	end
end

function BuildR6FakeParts(humanoid : Humanoid,fakeRigAlignment)
	local character = humanoid.Parent
	local fakePartsFolder = Instance.new("Folder",character)
	fakePartsFolder.Name = "FakeR6" .. getRunInfo()
	queryCharacterMesh(character,fakePartsFolder,fakeRigAlignment)
	return fakePartsFolder
end

function FindFakeRig(humanoid : Humanoid)
	local character = humanoid.Parent
	return character:FindFirstChild("FakeR6" .. getRunInfo())
end

function containsTextures(humanoid : Humanoid)
	local fakeRig = FindFakeRig(humanoid)
	local found = false
	if fakeRig then
		for _,partName in r6_partNames do
			local target = fakeRig:FindFirstChild(partName)
			if target and target:IsA("BasePart") then
				if found == false and target:FindFirstChildWhichIsA("Texture") then
					found = true
				end
			end
		end
	end
	return found
end

function DestroyFakeR6(humanoid : Humanoid)
	local fakeRig = FindFakeRig(humanoid)
	for _,partName in r6_partNames do
		local fakeBodyPartFound = fakeRig:FindFirstChild(partName)
		local realBodyPartFound = humanoid.Parent:FindFirstChild(partName)
		if fakeBodyPartFound and realBodyPartFound then
			realBodyPartFound.Transparency = fakeBodyPartFound.Transparency
			realBodyPartFound.Color = fakeBodyPartFound.Color
		end
		if fakeBodyPartFound then
			fakeBodyPartFound:Destroy()
		end
	end
	fakeRig:Destroy()
end

function setUnified(unified)
	if _R6_UNIFIED == false then
		_R6_UNIFIED = unified
	end
end

local r6Fix = {}
r6Fix.__index = r6Fix
-- Creates a new FakeR6 rig if it is not found, If it is already created (or R6Unified is false) then it returns an already existing rig.
r6Fix.new = function(humanoid : Humanoid,fakeRigAlignment)
	if not(humanoid.RigType == Enum.HumanoidRigType.R6 and humanoid.Parent:IsA("Model")) then
		error("This is not a valid R6 Model")
	end
	local fakePartsFolder = FindFakeRig(humanoid)
	if not fakePartsFolder then
		fakePartsFolder = BuildR6FakeParts(humanoid,fakeRigAlignment)
	end
	return fakePartsFolder
end

--[[
Detects all valid R6 CharacterMesh rigs and returns true if no CharacterMeshes are found within the threashold value.
threshold 0 = All limbs are not meshed and all are the Blocky rig.
threshold 6 = All limbs are meshed rigs.
threshold 2 = If there is only one meshed limb detected, it is not considered a meshed rig.
]]
r6Fix.containsMeshedRigs = containsMeshedRigs

-- Returns the fake rig if found, else returns nil,
r6Fix.FindFakeRig = FindFakeRig

-- Permanently sets unified mode on
r6Fix.setUnified = setUnified

-- Returns true if fake rig still contains texutres (from residual/old ACC instances or recently created ones.)
r6Fix.DoesFakeRigContainsTexutures = containsTextures

-- If exists, destroy the fake R6 rig.
r6Fix.Destroy = DestroyFakeR6

return r6Fix
 