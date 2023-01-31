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
    if type(selection) == 'string' then
      local getIssueNumber = selection:gsub("\t.*", "")
      ghIssue(getIssueNumber)
      return
    end
    for _, value in pairs(selection) do
      local getIssueNumber = value:gsub("\t.*", "")
      ghIssue(getIssueNumber)
    end
  end

  picker({
    opts = list_issue,
    callBack = callback,
    PREVIEW_OPTS = 'GH_ISSUE',
    title = 'choose your issue'
  })
end

M.getListIssueHistory = function()
  local GET_GIT_DIR = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), '\n', '')
  local DIR_ISSUE = GET_GIT_DIR .. '/.git/muryp/'
  local GET_DIR = vim.fn.system("ls " .. DIR_ISSUE)
  local LIST_ISSUE = {}
  for FILE_NAME in string.gmatch(GET_DIR, "[^\r\n]+") do
    table.insert(LIST_ISSUE, FILE_NAME)
  end
  local callback = function(selection)
    local GET_GIT_DIR = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), '\n', '')
    local DIR_ISSUE = GET_GIT_DIR .. '/.git/muryp/'
    if type(selection) == 'string' then
      vim.cmd('e ' .. DIR_ISSUE .. selection)
      require('nvim-muryp-git.telescope.gh.ghIssue.maps').maps()
      return
    end
    for _, value in pairs(selection) do
      vim.cmd('e ' .. DIR_ISSUE .. value)
      require('nvim-muryp-git.telescope.gh.ghIssue.maps').maps()
    end
  end

  picker({
    opts = LIST_ISSUE,
    callBack = callback,
    PREVIEW_OPTS = 'GH_LIST',
    title = 'choose your issue history',
    DIR_ISSUE = DIR_ISSUE
  })
end

return M
