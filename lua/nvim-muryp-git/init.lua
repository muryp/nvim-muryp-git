local M = {}

M.git = require('nvim-muryp-git.git')
local Setup = {
  mapping = {
    issue = function()
      require('nvim-muryp-git.telescope.gh.ghIssue.maps').maps()
    end,
    git = function()
      require('nvim-muryp-git.git').maps()
    end,
  },
  SSH_PATH = { '$HOME/.ssh/github' }
}

---@param arg {mapping:{git:function,issue:function},SSH_PATH:string[]}
M.setup = function(arg)
  if arg.mapping ~= nil then
    if arg.mapping.git ~= nil then
      Setup.mapping.git = arg.mapping.git
    end
    if arg.mapping.issue ~= nil then
      Setup.mapping.issue = arg.mapping.issue
    end
  end
  if arg.SSH_PATH ~= nil then
    Setup.SSH_PATH = arg.SSH_PATH
  end
  Setup.mapping.git()
end

M.Setup = Setup

M.resgisterTelescope = function()
  ---add picker telescope
  local plug      = require('telescope.builtin')
  local gitFlow   = require('configs.file.telescope.extensi.gitFlow')
  local ghIssue   = require('nvim-muryp-git.telescope.gh').getListIssue
  local ghHistory = require('nvim-muryp-git.telescope.gh').getListIssueHistory

  plug.git_flow          = gitFlow
  plug.git_issue         = ghIssue
  plug.git_issue_history = ghHistory
end


return M
