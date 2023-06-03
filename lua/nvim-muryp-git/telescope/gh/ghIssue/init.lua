local getIssue = require "nvim-muryp-git.telescope.gh.ghIssue.getIssue"
local headerInfo = require "nvim-muryp-git.telescope.gh.ghIssue.headerInfo"
local M = {}

---@param ISSUE_NUMBER number: the index in line_manager
---@return string[]: {body, name file, dirloc}
M.getContent = function(ISSUE_NUMBER)
  local GET_GIT_DIR = vim.fn.system("git rev-parse --show-toplevel")
  vim.cmd('cd ' .. GET_GIT_DIR)
  local GET_DIR_ROOT_GIT = GET_GIT_DIR:gsub('\n', '')
  local DIR_LOC_HISTORY = GET_DIR_ROOT_GIT .. "/.git/muryp" ---@type string
  local GetIssueData = getIssue({ ISSUE_NUMBER = ISSUE_NUMBER })
  local HEADER_ISSUE_STR = headerInfo({ GetIssueData = GetIssueData })
  local FILE_NAME = "/gh_issue-" ..
      '-' ..
      ISSUE_NUMBER .. '-' .. string.gsub(GetIssueData.title, ' ', '_') .. '-' .. GetIssueData.state .. ".md"
  local FILE_RESULT = DIR_LOC_HISTORY .. FILE_NAME ---@type string
  local ISSUE_HEADER = '+++' .. HEADER_ISSUE_STR .. '+++\n' ---@type string
  local HELP_HEADER = require('nvim-muryp-git.telescope.gh.ghIssue.helper')
  local content = ISSUE_HEADER .. HELP_HEADER .. string.gsub(GetIssueData.body, "\r", "") ---@type string
  return { content, FILE_RESULT, DIR_LOC_HISTORY }
end
---@param ISSUE_NUMBER number: the index in line_manager
---create file and add maps
M.ghIssue = function(ISSUE_NUMBER)
  local content = M.getContent(ISSUE_NUMBER)
  os.execute("mkdir " .. content[3])
  os.execute('echo "' .. content[1] .. '" > ' .. content[2])
  vim.cmd('e ' .. content[2])
  require('nvim-muryp-git').Setup.mapping.issue()
end
return M
