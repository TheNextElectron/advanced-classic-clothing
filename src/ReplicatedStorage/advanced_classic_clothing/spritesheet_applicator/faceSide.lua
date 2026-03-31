local _faces = {
	[Enum.NormalId.Front.Name] = {"X","Y"},
	[Enum.NormalId.Back.Name] = {"X","Y"},
	[Enum.NormalId.Top.Name] = {"X","Z"},
	[Enum.NormalId.Bottom.Name] = {"X","Z"},
	[Enum.NormalId.Left.Name] = {"X","Y"},
	[Enum.NormalId.Right.Name] = {"X","Y"},
}


local module = {
}

function module:get2dObjectSize(object : BasePart,face : Enum.NormalId)
	if object then
		local nIdAxis = _faces[face.Name]
		if nIdAxis then
			local x = nIdAxis[1]
			local y = nIdAxis[2]
			local objectSize = object.Size

				
			return Vector2.new(objectSize[x],objectSize[y])
		else
			warn("axis not found")
		end
	end
end

return module
