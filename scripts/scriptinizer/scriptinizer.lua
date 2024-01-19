local util = require("myutils")

-- add new scripts here to ahve them available for selection
local scriptMap = {
	cheatsheet = "~/.dotfiles/scripts/cheatsht/tmux-cht.sh",
}

-- create a string of script names that gets piped to fzf for selecting
local names = ""
for key, _ in pairs(scriptMap) do
	local name = string.format("%s\n", key)
	names = names .. name
end
names = util.trim(names)

-- get selected cmd
local cmd = string.format('echo "%s" | fzf-tmux -p --reverse --prompt="Scriptinizer > "', names)
local selection = util.exec(cmd)
selection = selection:gsub("%s+", "")

-- execute cmd associated w/ selected script name
if selection ~= nil then
	local runCmd = scriptMap[selection]
	util.exec(runCmd)
end
