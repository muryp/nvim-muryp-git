local ghIssue = require('nvim-muryp-git.gh').ghIssue

local M       = {}
---@return {getFile:string,getIssue:number,gitRoot:string}
local getVar  = function()
  local getFile          = vim.api.nvim_command_output('echo expand("%:p")') ---@type string
  local GET_CONTENT_FILE = vim.fn.system('cat ' .. getFile) ---@type string
  local _, _, getIssue   = string.find(GET_CONTENT_FILE, "https://github.com/.*/.*/issues/(%d*)") ---@type nil,nil,string
  local gitRoot          = vim.fn.system("git rev-parse --show-toplevel"):gsub('\n', '') ---@type string
  if getIssue == '' then
    return vim.api.nvim_err_writeln("ERR: isssue number not found. Be sure you're in correct file. This cmd only work in issue file patern." )
  end
  return { getFile = getFile, getIssue = getIssue, gitRoot = gitRoot }
end
M.edit        = function()
  local arg = getVar()
  if arg == nil then
    return
  end
  vim.cmd('term cd ' .. arg.gitRoot .. ' && gh issue edit ' .. arg.getIssue)
end
M.open        = function()
  if getVar() == nil then
    return
  end
  vim.cmd('!gh issue view -w ' .. getVar().getIssue)
end
M.push        = function()
  if getVar() == nil then
    return
  end
  local VAR          = getVar()
  local CURRENT_FILE = VAR.getFile
  local REGEX        = [[ | sed -z 's/<!--.*-->//g' | sed -e '/^+++/,/^+++/d']]
  local BODY_ISSUE   = [[cat ]] .. CURRENT_FILE .. REGEX
  local ISSUE_NUMBER = VAR.getIssue
  local PUSH_INTO_GH = vim.fn.system('gh issue edit ' .. ISSUE_NUMBER .. ' --body ' .. '"$(' .. BODY_ISSUE .. ')"') ---@type string
  if string.find(PUSH_INTO_GH, "error") then
    vim.api.nvim_err_writeln(PUSH_INTO_GH)
    return
  end
  print('succes push : ' .. PUSH_INTO_GH)
end
M.update      = function()
  if getVar() == nil then
    return
  end
  local ISSUE_NUMBER = getVar().getIssue ---@type number
  ghIssue(ISSUE_NUMBER)
end
M.delete      = function()
  if getVar() == nil then
    return
  end
  local ISSUE_NUMBER = getVar().getIssue ---@type number
  vim.cmd('term gh issue delete ' .. ISSUE_NUMBER .. ' && rm %')
  vim.cmd('bd')
end
M.addIssue    = function()
  local NUMBER_ISSUE = vim.fn.input('number issue ? ') ---@type number
  if NUMBER_ISSUE == '' or NUMBER_ISSUE == nil then
    return print('type number please...')
  end
  ghIssue(NUMBER_ISSUE)
end
return M