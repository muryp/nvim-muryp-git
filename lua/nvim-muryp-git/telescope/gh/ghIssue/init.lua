local getIssue = require "nvim-muryp-git.telescope.gh.ghIssue.getIssue"
local headerInfo = require "nvim-muryp-git.telescope.gh.ghIssue.headerInfo"
local M = {}

---@param ISSUE_NUMBER number: the index in line_manager
---@return string[]: {body, name file, dirloc}
M.getContent = function(ISSUE_NUMBER)
  local DIR_LOC_CACHE = require('nvim-muryp-git').Setup.CACHE_DIR()
  local GetIssueData = getIssue({ ISSUE_NUMBER = ISSUE_NUMBER })
  local HEADER_ISSUE_STR = headerInfo({ GetIssueData = GetIssueData })
  local FILE_NAME = "/" ..
      ISSUE_NUMBER .. '-' .. GetIssueData.title:gsub('/',' or ') .. '-' .. GetIssueData.state .. ".md"
  local FILE_RESULT = DIR_LOC_CACHE .. FILE_NAME:gsub(' ','_') ---@type string
  local ISSUE_HEADER = '+++' .. HEADER_ISSUE_STR .. '+++\n' ---@type string
  local HELP_HEADER = require('nvim-muryp-git.telescope.gh.ghIssue.helper')
  local content = ISSUE_HEADER .. HELP_HEADER .. string.gsub(GetIssueData.body, "\r", "") ---@type string
  return { content, FILE_RESULT, DIR_LOC_CACHE }
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
