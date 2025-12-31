local fs = require "@lune/fs"
local process = require "@lune/process"
local stdio = require "@lune/stdio"

local liveSyncback = require "./liveSyncback"

local secretFileName = ".SECRET"
local robloxPlaceName = "BossFight.rbxl"

if not fs.isFile(secretFileName) then
	local gameId = stdio.prompt("text", "What is the Game Id?:")
	local placeId = stdio.prompt("text", "What is the Place Id?:")
	fs.writeFile(secretFileName, `GameId={gameId}\nPlaceId={placeId}`)
end

local configuration = fs.readFile(secretFileName)

local function findEnvironmentVariable(file_contents, variable_name)
	local _, endIndex = string.find(file_contents, `{variable_name}=`)
	local lineEndIndex = string.find(file_contents, "\n", endIndex)
	if not lineEndIndex then
		lineEndIndex = -1
	end
	local value = string.sub(configuration, endIndex + 1, lineEndIndex)
	if value == "" then
		error(`environment variable {variable_name} not configured in {secretFileName}`)
	end
	return value
end

function insert(str1: string, str2: string, pos: number)
	return str1:sub(1, pos) .. str2 .. str1:sub(pos + 1)
end

local placeId = tonumber(findEnvironmentVariable(configuration, "PlaceId"))
local gameId = tonumber(findEnvironmentVariable(configuration, "GameId"))

local baseProject = fs.readFile "base.project.json"
local startIndex = string.find(baseProject, '"tree"')

local newProject = insert(baseProject, `"placeId":{placeId},\n\t"gameId":{gameId},\n\t`, startIndex - 1)

fs.writeFile("default.project.json", newProject)

process.exec("rojo", { "build", "-o", robloxPlaceName })
process.create(if process.os == "windows" then "explorer" else "open", { robloxPlaceName })
process.create("rojo", { "serve", "default.project.json" })
liveSyncback()
