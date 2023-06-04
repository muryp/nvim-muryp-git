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
  SSH_PATH = { '$HOME/.ssh/github' },
  ---@return string DIR_ISSUE location of dir cache
  CACHE_DIR = function()
    local GET_GIT_DIR = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), '\n', '')
    local DIR_ISSUE   = GET_GIT_DIR .. '/.git/muryp/gh_issue/'
    return DIR_ISSUE
  end,
  DEFAULT_REMOTE = 'origin',

}

---@param arg {mapping:{git:function,issue:function},SSH_PATH:string[],CACHE_DIR:function,DEFAULT_REMOTE:string}
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
  if arg.CACHE_DIR ~= nil then
    Setup.CACHE_DIR = arg.CACHE_DIR
  end
  if arg.DEFAULT_REMOTE ~= nil then
    Setup.DEFAULT_REMOTE = arg.DEFAULT_REMOTE
  end
  Setup.mapping.git()
end

M.Setup = Setup

M.resgisterTelescope = function()
  ---add picker telescope
  local plug               = require('telescope.builtin')
  local gitFlow            = require('nvim-muryp-git.telescope.gitFlow')
  local ghIssue            = require('nvim-muryp-git.telescope.gh').getListIssue
  local ghCache            = require('nvim-muryp-git.telescope.gh').getListIssueCache
  local git                = require('nvim-muryp-git.telescope.git')

  plug.git_flow            = gitFlow
  plug.git_issue           = ghIssue
  plug.git_issue_cache     = ghCache
  plug.git_commit_ssh_push = git.push
  plug.git_pull            = git.pull
end


return M
