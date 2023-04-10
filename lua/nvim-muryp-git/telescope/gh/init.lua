-- gh issue list
local picker          = require "nvim-muryp-git.utils.picker"
local ghIssue         = require('nvim-muryp-git.telescope.gh.ghIssue')
local M               = {}

---issue list get from online
M.getListIssue        = function()
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
M.getListIssueHistory = function()
  local GET_GIT_DIR = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), '\n', '')
  local DIR_ISSUE   = GET_GIT_DIR .. '/.git/muryp/'
  require('telescope.builtin').find_files({
    prompt_title = 'Find History Issue', -- Judul pada prompt
    title        = 'My List History Issue',       -- Judul pada pratinjau
    cwd          = DIR_ISSUE,
    -- Konfigurasi atau opsi lainnya
  })
end

return M
