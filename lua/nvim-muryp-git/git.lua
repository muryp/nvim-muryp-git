local mapping = require('nvim-muryp-git.utils.mapping')

local M = {}
---@param isGetString boolean is return string or vim cmd
---@return string|nil : return cmd or string
M.gitCommit = function(isGetString)
  local isConflict = vim.fn.system('git diff --check')
  if isConflict == '' then
    local CMD_GIT = 'term [[ $(git status --porcelain) ]] && git add . && git commit'
    if isGetString == true then
      return CMD_GIT
    end
    return vim.cmd(CMD_GIT)
  else
    vim.api.nvim_err_writeln(isConflict)
    return 'err'
  end
end
---@param FIRST_LETTER string FIRST_LETTER cmd
---@return string
M.addSsh = function(FIRST_LETTER)
  local SshPath = require('nvim-muryp-git').Setup.SSH_PATH
  local SSH_PATH = ''
  for _, PATH in pairs(SshPath) do
    SSH_PATH = SSH_PATH .. PATH .. ' '
  end
  return FIRST_LETTER .. [[eval "$(ssh-agent -s)" && ssh-add ]] .. SSH_PATH
end
---@param DEFAULT_REMOTE string
---@return string
M.gitPush = function(DEFAULT_REMOTE)
  local REMOTE = vim.fn.input('what repo ? ', DEFAULT_REMOTE)
  local PULL = vim.fn.input('Use PUll (y/n) ? ')
  local BRANCH = vim.fn.system('git symbolic-ref --short HEAD'):gsub('\n', ''):gsub('\r', '')
  local TARGET_HOST = REMOTE .. ' ' .. BRANCH
  local PUSH =
      ' [[ $(git diff --check) == "" ]] && git push ' ..
      TARGET_HOST .. ' || echo "\\033[31merror: you have conflict:\\n$(git diff --check)"'
  if PULL == 'y' or PULL == 'Y' then
    PULL = " && git pull " .. TARGET_HOST .. ' &&'
  else
    PULL = ' &&'
  end
  return PULL .. PUSH
end
---@param opts string | nil remote
---@return nil vim.cmd commit, pull, push with ssh,
M.gitSshPush = function(opts)
  local CMD_COMMIT = M.gitCommit(true)
  if CMD_COMMIT == 'err' then
    return
  end
  local DEFAULT_REMOTE
  if opts == nil then
    DEFAULT_REMOTE = 'origin'
  else
    DEFAULT_REMOTE = opts
  end
  return vim.cmd(CMD_COMMIT .. M.addSsh(' && ') .. M.gitPush(DEFAULT_REMOTE))
end
---@param opts string | nil remote name
---@return nil vim.cmd pull with ssh,
M.pull = function(opts)
  local DEFAULT_REMOTE
  if opts == nil then
    DEFAULT_REMOTE = 'origin'
  else
    DEFAULT_REMOTE = opts
  end
  local BRANCH = vim.fn.system('git symbolic-ref --short HEAD') ---@type string
  vim.cmd('term ' .. M.addSsh('') .. '&& git pull ' .. DEFAULT_REMOTE .. ' ' .. BRANCH)
end
---@return nil vim.cmd push single with ssh
M.singlePush = function()
  return vim.cmd(M.addSsh('term ') .. M.gitPush('origin'))
end

M.maps = function()
  local MAPS = {
    name = "GIT",
    b = { ':Telescope git_branches<CR>', "BRANCH" },
    f = { ':Telescope git_flow<CR>', "FLOW" },
    i = {
      c = { ':Telescope git_issue_cache<CR>', "EDIT_ISSUE_ON_CACHE" },
      i = { ':Telescope git_issue<CR>', "EDIT_ISSUE" },
      o = { require('nvim-muryp-git.telescope.gh.ghIssue.maps').addIssue, "ADD_ISSUE_TO_CHACE" },
      a = { ':term gh issue create<CR>', "ADD_ISSUE" },
    },
    a = { ':Telescope git_status<CR>', "LIST_ADD_TO_STAGGING" },
    c = { ':term git commit<CR>', "COMMIT" },
    v = { M.gitCommit, "ADD_ALL+COMMIT" },
    p = {
      name = "PUSH",
      p = { M.gitSshPush, "COMMIT+SSH+PULL+PUSH" },
      a = { ':term git push --all<CR>', "PUSH ALL" },
      s = { M.singlePush, "SSH+PULL+PUSH" },
    },
    P = {
      name = "PULL",
      A = { ':term git pull --all<CR>', "PULL ALL" },
      P = { M.pull, "pull" },
    },
    o = {
      name = "WITH TELESCOPE OPTS",
      p = { ':Telescope git_commit_ssh_push<CR>', "COMMIT+SSH+PULL+PUSH" },
      P = { ':Telescope git_pull<CR>', "PULL" },
    },
  }
  mapping({ g = MAPS }, { prefix = "<leader>", noremap = true })
end

return M
