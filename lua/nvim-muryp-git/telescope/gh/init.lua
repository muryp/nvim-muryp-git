-- gh issue list
local picker        = require "nvim-muryp-git.utils.picker"
local ghIssue       = require('nvim-muryp-git.telescope.gh.ghIssue').ghIssue
local cacheDir      = require('nvim-muryp-git').Setup.CACHE_DIR
local M             = {}

--- get issue list get from online
M.getListIssue      = function()
  local ListIssue = {}
  local ISSUE_LIST = vim.api.nvim_command_output("echo system('gh issue list')")
  for WORD in string.gmatch(ISSUE_LIST, "[^\r\n]+") do
    table.insert(ListIssue, WORD)
  end
  ---@param UserSelect string|string[]
  ---@return nil
  local function callBack(UserSelect)
    if type(UserSelect) == 'string' then
      local ISSUE_NUMBER = UserSelect:gsub("\t.*", "") ---@type number : single issue number
      ghIssue(ISSUE_NUMBER)
    else
      for _, USER_SELECT in pairs(UserSelect) do
        local ISSUE_NUMBER = USER_SELECT:gsub("\t.*", "") ---@type number : single issue number
        ghIssue(ISSUE_NUMBER)
      end
    end
  end

  picker({
    opts = ListIssue,
    callBack = callBack,
    PREVIEW_OPTS = 'GH_ISSUE',
    title = 'choose your issue'
  })
end

---issue list offline
M.getListIssueCache = function()
  local GET_DIR   = vim.fn.system("ls " .. cacheDir())
  local ListIssue = {}
  for FILE_NAME in string.gmatch(GET_DIR, "[^\r\n]+") do
    table.insert(ListIssue, FILE_NAME)
  end
  ---@param UserSelect string|string[]
  ---@return nil
  local callback = function(UserSelect)
    local defindMaps = require('nvim-muryp-git').Setup.mapping.issue
    if type(UserSelect) == 'string' then
      vim.cmd('e ' .. cacheDir() .. UserSelect)
      defindMaps()
      return
    end
    for _, value in pairs(UserSelect) do
      vim.cmd('e ' .. cacheDir() .. value)
      defindMaps()
    end
  end

  picker({
    opts = ListIssue,
    callBack = callback,
    PREVIEW_OPTS = 'FILE',
    title = 'choose your issue cache',
  })
end

return M
