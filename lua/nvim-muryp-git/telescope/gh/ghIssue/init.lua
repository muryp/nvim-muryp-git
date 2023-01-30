local getIssue = require "nvim-muryp-git.telescope.gh.ghIssue.getIssue"
local headerInfo = require "nvim-muryp-git.telescope.gh.ghIssue.headerInfo"

---@param ISSUE_NUMBER number: the index in line_manager
---create file and add maps
local ghIssue = function(ISSUE_NUMBER)
  local GET_GIT_DIR = vim.fn.system("git rev-parse --show-toplevel")
  vim.cmd('cd ' .. GET_GIT_DIR)
  local GET_DIR_ROOT_GIT = GET_GIT_DIR:gsub('\n', '')
  local DIR_LOC_HISTORY = GET_DIR_ROOT_GIT .. "/.git/muryp"
  local GET_ISSUE_DATA_OBJ = getIssue({ ISSUE_NUMBER })
  local HEADER_ISSUE_STR = headerInfo({ GET_ISSUE_DATA_OBJ })
  local FILE_NAME = "/gh_issue-" ..
      '-' ..
      ISSUE_NUMBER .. '-' .. string.gsub(GET_ISSUE_DATA_OBJ.title, ' ', '_') .. '-' .. GET_ISSUE_DATA_OBJ.state .. ".md"
  local FILE_PWD = DIR_LOC_HISTORY .. FILE_NAME
  local ISSUE_GENERATE = '+++' .. HEADER_ISSUE_STR .. '+++\n'
  local HELP_HEADER = require('nvim-muryp-git.telescope.gh.ghIssue.helper')
  os.execute("mkdir " .. DIR_LOC_HISTORY)
  os.execute('echo "' .. ISSUE_GENERATE .. HELP_HEADER .. GET_ISSUE_DATA_OBJ.body .. '" > ' .. FILE_PWD)
  vim.cmd('e ' .. FILE_PWD)
  require('nvim-muryp-git.telescope.gh.ghIssue.maps').maps()
end
return ghIssue
