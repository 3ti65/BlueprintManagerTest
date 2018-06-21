class 'BlueprintManagerTestClient'

function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

local rallyPointId = "rallyPointTest"
local radioBeaconPartitionGuid = Guid("8887c2ae-27c6-11e0-9123-987fba709e0e", "D")
local radioBeaconBlueprintInstanceGuid = Guid("AA301A25-7B1F-00F2-B999-F2CB464E3E6B", "D")

local vehicleShedPartitionGuid = Guid("083581b6-30c1-11de-82a0-cdc21cfbd6b2", "D")
local vehicleShedBlueprintInstanceGuid = Guid("083581b7-30c1-11de-82a0-cdc21cfbd6b2", "D")

function BlueprintManagerTestClient:__init()
	print("Initializing BlueprintManagerTestClient")
	self:RegisterEvents()
end

function BlueprintManagerTestClient:RegisterEvents()
	NetEvents:Subscribe('chat', self, self.OnChat)
end

function BlueprintManagerTestClient:OnChat(playerid, recipientMask, message)
	if message == '' then
		return
	end

	local parts = message:split(' ')

	local player = PlayerManager:GetLocalPlayer()

	if player.id ~= playerid then
		return
	end

	if parts[1] == 'spawnrp' then
		if parts[2] == 'client' then
			local trans = player.soldier.transform.trans
		
			local transform = LinearTransform(
				Vec3(1.0, 0.0, 0.0),
				Vec3(0.0, 1.0, 0.0),
				Vec3(0.0, 0.0, 1.0),
				Vec3(trans.x+0.5, trans.y , trans.z)
			)

			Events:Dispatch('BlueprintManager:SpawnBlueprintFromClient', rallyPointId, vehicleShedPartitionGuid, vehicleShedBlueprintInstanceGuid, tostring(transform), nil)
		end
	end
	
	if parts[1] == 'delrp' then
		if parts[2] == 'client' then
			Events:Dispatch('BlueprintManager:DeleteBlueprintFromClient', rallyPointId)
		end
	end

	if parts[1] == 'moverp' then
		if parts[2] == 'client' then
			local trans = player.soldier.transform.trans
		
			local newTransform = LinearTransform(
				Vec3(1.0, 0.0, 0.0),
				Vec3(0.0, 1.0, 0.0),
				Vec3(0.0, 0.0, 1.0),
				Vec3(trans.x+3.5, trans.y , trans.z)
			)

			Events:Dispatch('BlueprintManager:MoveBlueprintFromClient', rallyPointId, tostring(newTransform))
		end
	end
end

BlueprintManagerTestClient()

