local getIssue = require "nvim-muryp-git.telescope.gh.ghIssue.getIssue"
local headerInfo = require "nvim-muryp-git.telescope.gh.ghIssue.headerInfo"

---@param ISSUE_NUMBER number: the index in line_manager
---create file and add maps
local ghIssue = function(ISSUE_NUMBER)
  local GET_GIT_DIR = vim.fn.system("git rev-parse --show-toplevel")
  vim.cmd('cd ' .. GET_GIT_DIR)
  local GET_DIR_ROOT_GIT = GET_GIT_DIR:gsub('\n', '')
  local DIR_LOC_HISTORY = GET_DIR_ROOT_GIT .. "/.git/muryp"
  local GetIssueData = getIssue({ ISSUE_NUMBER = ISSUE_NUMBER })
  local HEADER_ISSUE_STR = headerInfo({ GetIssueData = GetIssueData })
  local FILE_NAME = "/gh_issue-" ..
      '-' ..
      ISSUE_NUMBER .. '-' .. string.gsub(GetIssueData.title, ' ', '_') .. '-' .. GetIssueData.state .. ".md"
  local FILE_RESULT = DIR_LOC_HISTORY .. FILE_NAME
  local ISSUE_HEADER = '+++' .. HEADER_ISSUE_STR .. '+++\n'
  local HELP_HEADER = require('nvim-muryp-git.telescope.gh.ghIssue.helper')
  os.execute("mkdir " .. DIR_LOC_HISTORY)
  os.execute('echo "' .. ISSUE_HEADER .. HELP_HEADER .. GetIssueData.body .. '" > ' .. FILE_RESULT)
  vim.cmd('e ' .. FILE_RESULT)
  require('nvim-muryp-git').Setup.mapping.issue()
end
return ghIssue
