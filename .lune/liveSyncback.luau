local task = require "@lune/task"
local fs = require "@lune/fs"
local process = require "@lune/process"
--local DateTime = require "@lune/datetime"

local file = "BossFight.rbxl"

return function()
	local lastModified: DateTime = fs.metadata(file).modifiedAt

	local function onModified(modifiedTime: DateTime)
		--print(fs.readFile(file))

		local x = process.exec("rojo", { "syncback", "--input", file, "./syncback.project.json", "-y" })
		print(x)
		print(`synced back changes at {modifiedTime:formatLocalTime "%b %d %Y %T"}`)
	end

	onModified(lastModified)

	while true do
		local currModified = fs.metadata(file).modifiedAt
		if currModified ~= lastModified then
			lastModified = currModified
			onModified(currModified)
		end
		task.wait(1)
	end
end
