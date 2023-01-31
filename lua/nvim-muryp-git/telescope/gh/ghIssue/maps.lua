local M = {}
---@return {getFile:string,getCurrentFile:string,getIssue:number,gitRoot:string}
local getVar = function()
  local getFile        = vim.api.nvim_command_output('echo expand("%:p")') ---@type string
  local GET_CONTENT_FILE = vim.fn.system('cat ' .. getFile) ---@type string
  local _, _, getIssue = string.find(GET_CONTENT_FILE, "https://github.com/.*/.*/issues/(%d*)") ---@type nil,nil,string
  print(getIssue)
  local gitRoot        = vim.fn.system("git rev-parse --show-toplevel"):gsub('\n', '') ---@type string
  return { getFile = getFile, getCurrentFile = GET_CONTENT_FILE, getIssue = getIssue, gitRoot = gitRoot }
end
M.edit = function()
  local arg = getVar()
  vim.cmd('!' .. _G.TMUX_POPUP .. ' "cd ' .. arg.gitRoot .. ' && gh issue edit ' .. arg.getIssue .. '"')
end
M.open = function()
  vim.cmd('!gh issue view -w ' .. getVar().getIssue)
end
M.push = function()
  local variable       = getVar()
  local CURRENT_FILE = variable.getCurrentFile
  local ISSUE_NUMBER       = variable.getIssue
  local BODY_ISSUE        = CURRENT_FILE:gsub("<!--.*-->\n", ""):gsub("+++.*+++\n", ""):gsub("\n[^\n]*$", "")
  os.execute('gh issue edit ' .. ISSUE_NUMBER .. ' --body ' .. '"' .. BODY_ISSUE .. '"')
end
M.update = function()
  local ghIssue      = require('nvim-muryp-git.telescope.gh.ghIssue')
  local ISSUE_NUMBER = getVar().getIssue ---@type number
  print(ISSUE_NUMBER)
  ghIssue(ISSUE_NUMBER)
end
M.maps = function()
  local key     = vim.keymap.set ---@type Map
  local OPTION_MAPS    = { buffer = true }
  local LEADER_MAPS = "<leader><leader>"
  local IMPORT_THIS  = ":lua require('nvim-muryp-git.telescope.gh.ghIssue.maps')"
  key("n", LEADER_MAPS .. "p", IMPORT_THIS .. ".push()<CR>", OPTION_MAPS)
  key("n", LEADER_MAPS .. "e", IMPORT_THIS .. ".edit()<CR>", OPTION_MAPS)
  key("n", LEADER_MAPS .. "o", IMPORT_THIS .. ".open()<CR>", OPTION_MAPS)
  key("n", LEADER_MAPS .. "u", IMPORT_THIS .. ".update()<CR>", OPTION_MAPS)
end
return M
