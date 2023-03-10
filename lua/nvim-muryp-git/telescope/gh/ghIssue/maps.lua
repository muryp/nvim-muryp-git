local M = {}
---@return {getFile:string,getCurrentFile:string,getIssue:number,gitRoot:string}
local getVar = function()
  local getFile          = vim.api.nvim_command_output('echo expand("%:p")') ---@type string
  local GET_CONTENT_FILE = vim.fn.system('cat ' .. getFile) ---@type string
  local _, _, getIssue   = string.find(GET_CONTENT_FILE, "https://github.com/.*/.*/issues/(%d*)") ---@type nil,nil,string
  local gitRoot          = vim.fn.system("git rev-parse --show-toplevel"):gsub('\n', '') ---@type string
  return { getFile = getFile, getCurrentFile = GET_CONTENT_FILE, getIssue = getIssue, gitRoot = gitRoot }
end
M.edit = function()
  local arg = getVar()
  vim.cmd('term cd ' .. arg.gitRoot .. ' && gh issue edit ' .. arg.getIssue)
end
M.open = function()
  vim.cmd('!gh issue view -w ' .. getVar().getIssue)
end
M.push = function()
  local VAR     = getVar()
  local CURRENT_FILE = VAR.getCurrentFile
  local ISSUE_NUMBER = VAR.getIssue
  local BODY_ISSUE   = CURRENT_FILE:gsub("<!--.*-->\n", ""):gsub("+++.*+++\n", ""):gsub("\n[^\n]*$", "")
  local OUTPUT       = vim.fn.system('gh issue edit ' .. ISSUE_NUMBER .. ' --body ' .. '"' .. BODY_ISSUE .. '"')
  print(OUTPUT)
end
M.update = function()
  local ghIssue      = require('nvim-muryp-git.telescope.gh.ghIssue')
  local ISSUE_NUMBER = getVar().getIssue ---@type number
  ghIssue(ISSUE_NUMBER)
end
M.delete = function()
  local ISSUE_NUMBER = getVar().getIssue ---@type number
  vim.cmd('!gh issue delete ' .. ISSUE_NUMBER)
  vim.cmd('!rm %')
  vim.cmd('bd')
end
M.maps = function()
  local wk          = require("which-key")
  local IMPORT_THIS = ":lua require('nvim-muryp-git.telescope.gh.ghIssue.maps')"
  wk.register({
    ["<leader>"] = {
      name = "ISSUE_CMD",
      p = { IMPORT_THIS .. ".push()<CR>", "UPDATE_GH", buffer = 1 },
      e = { IMPORT_THIS .. ".edit()<CR>", "EDIT", buffer = 1 },
      u = { IMPORT_THIS .. ".update()<CR>", "UPDATE_LOCAL", buffer = 1 },
      d = { IMPORT_THIS .. ".delete()<CR>", "DELETE", buffer = 1 },
    },
  }, { prefix = "<leader>" })
end
return M
