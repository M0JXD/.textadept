-- Copyright 2026 Jamie Drinkell. See LICENSE.

--- Generate documentation READMEs for submodules using LDoc.
-- Run this in any lua interpreter with LFS available.
-- @usage `textadept -L generate_docs.lua`

local lfs = require('lfs')

-- Directories not to generate docs for.
local exclude = {
	discord_rpc = true, textredux = true
}

local function get_directories(path)
	local dirs = {}
	-- Iterate through items in the directory
	for entry in lfs.dir(path) do
		-- Skip current (.) and parent (..) directory links
		if entry ~= "." and entry ~= ".." then
			local full_path = path .. "/" .. entry
			local attr = lfs.attributes(full_path)
			-- Filter out files, keeping only directories
			if attr and attr.mode == "directory" then table.insert(dirs, entry) end
		end
	end
	return dirs
end

local function get_module_title(file_path)
	local file = io.open(file_path, "r")
	if not file then return nil end

	for line in file:lines() do
		-- Matches --- or --! and captures everything after it
		local doc_content = line:match("^%s*%-%-%-[!]?%s*(.*)")
		if doc_content then
			file:close()
			return doc_content
		end
	end
	file:close()
	return nil
end

local fetch = OS ~= 'linux' and 'curl -s ' or 'wget -q '
local md_filter_url =
	'https://raw.githubusercontent.com/orbitalquark/textadept/refs/heads/default/scripts/markdowndoc.lua'

local function gen_ldoc_command(dir, title)
	return 'ldoc --filter markdowndoc.ldoc ' .. dir .. '/init.lua -- --title="' .. title ..
		'" --single > ' .. dir .. '/README.md'
end

os.execute(fetch .. md_filter_url .. ' > markdowndoc.lua')

local dirs = get_directories('../modules')

for _, dir_name in ipairs(dirs) do
	if not exclude[dir_name] then
		local dir = '../modules/' .. dir_name
		print('Generating documentation for ' .. dir_name .. '...')
		os.execute(gen_ldoc_command(dir, get_module_title(dir .. '/init.lua')))

		-- Remove trailing whitespace
		local file = io.open(dir .. '/init.lua')
		local txt = file:read('*all')
		file:close()
		txt = txt:gsub("^%s*(.-)%s*$", "%1") .. '\n'
		file = io.open(dir .. '/init.lua', 'w')
		file:write(txt)
		file:close()
	end
end

os.remove('markdowndoc.lua')
