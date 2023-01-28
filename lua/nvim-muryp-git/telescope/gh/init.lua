-- gh issue list
local picker  = require "nvim-muryp-git.utils.picker"
local ghIssue = require('nvim-muryp-git.telescope.gh.ghIssue')
local M       = {}

M.getListIssue = function()
  local list_issue = {}
  local getIssue = vim.api.nvim_command_output("echo system('gh issue list')")
  for word in string.gmatch(getIssue, "[^\r\n]+") do
    table.insert(list_issue, word)
  end

  local function callback(selection)
    local getIssueNumber = selection[1]:gsub("\t.*", "")
    ghIssue(getIssueNumber)
  end

  picker({
    opts = list_issue,
    callBack = callback,
    isPreview = true,
    title = 'choose your issue'
  })
end

M.getListIssueHistory = function()
  -- use regex for open issue file and auto
end

return M
