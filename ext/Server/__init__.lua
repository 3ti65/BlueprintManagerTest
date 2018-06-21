class 'BlueprintManagerTestServer'

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

function BlueprintManagerTestServer:__init()
	print("Initializing BlueprintManagerTestServer")
	self:RegisterEvents()
end

function BlueprintManagerTestServer:RegisterEvents()
	Events:Subscribe('Player:Chat', self, self.OnChat)
	Events:Subscribe('BlueprintManager:SpawnBlueprint', self, self.OnSpawnBlueprint)
end

function BlueprintManagerTestServer:OnSpawnBlueprint(uniqueString, partitionGuid, blueprintPrimaryInstanceGuid, linearTransform, variationNameHash)
	print("--vvv--")
	print(uniqueString)
	print(partitionGuid)
	print(blueprintPrimaryInstanceGuid)
	print(tostring(linearTransform))
	print("--^^^--")
end

function BlueprintManagerTestServer:OnChat(player, recipientMask, message)
	NetEvents:BroadcastLocal('chat', player.id, recipientMask, message)

	if message == '' then
		return
	end

	local parts = message:split(' ')

	if parts[1] == 'spawnrp' then
		if parts[2] == 'server' then
			local trans = player.soldier.transform.trans
		
			local someTransform = LinearTransform(
				Vec3(1.0, 0.0, 0.0),
				Vec3(0.0, 1.0, 0.0),
				Vec3(0.0, 0.0, 1.0),
				Vec3(trans.x+0.5, trans.y , trans.z)
			)

			print('BlueprintManager:SpawnBlueprint')
			print(rallyPointId)
			print(vehicleShedPartitionGuid:ToString("D"))
			print(vehicleShedBlueprintInstanceGuid:ToString("D"))
			print(tostring(someTransform))
			Events:Dispatch('BlueprintManager:SpawnBlueprint', rallyPointId, vehicleShedPartitionGuid, vehicleShedBlueprintInstanceGuid, tostring(someTransform), nil)
		end
	end
	
	if parts[1] == 'delrp' then
		if parts[2] == 'server' then
			Events:Dispatch('BlueprintManager:DeleteBlueprint', rallyPointId)
		end
	end

	if parts[1] == 'moverp' then
		if parts[2] == 'server' then
			local trans = player.soldier.transform.trans
		
			local newTransform = LinearTransform(
				Vec3(1.0, 0.0, 0.0),
				Vec3(0.0, 1.0, 0.0),
				Vec3(0.0, 0.0, 1.0),
				Vec3(trans.x+3.5, trans.y , trans.z)
			)

			Events:Dispatch('BlueprintManager:MoveBlueprint', rallyPointId, tostring(newTransform))
		end
	end
end

BlueprintManagerTestServer()

