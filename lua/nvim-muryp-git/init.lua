local M = {}

M.git = require('nvim-muryp-git.git')

M.setup = {
  mapping = {
    issue = function()
      require('nvim-muryp-git.telescope.gh.ghIssue.maps').maps()
    end,
    git = function()
      require('nvim-muryp-git.git').maps()
    end,
  },
  SSH_PATH = { '~/ssh/github' }
}

---add picker telescope
local plug      = require('telescope.builtin')
local gitFlow   = require('configs.file.telescope.extensi.gitFlow')
local gh        = require('nvim-muryp-git.telescope.gh').getListIssue()
local ghHistory = require('nvim-muryp-git.telescope.gh').getListIssueHistory()


plug.git_flow          = gitFlow
plug.git_issue         = gh
plug.git_issue_history = ghHistory

return M
