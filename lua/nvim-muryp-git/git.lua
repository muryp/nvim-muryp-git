local mapping = require('nvim-muryp-git.utils.mapping')

local M = {}
---@return string : check is commit or conflict
local function checkCommitConflict()
  local isTroble = vim.fn.system(
    "[[ $(git status | grep \"conflict\") ]] && echo $([[ $(git status --porcelain) ]] && echo 'true' || echo 'no_commit...') || echo 'conflict...'")
  if isTroble == 'true\n' then
    return 'git add . && git commit'
  else
    return 'echo ' .. string.gsub(isTroble, '\n', '')
  end
end
---@return string : commit cmd
M.gitCommitCmd = function()
  return "cd %:p:h && cd $(git rev-parse --show-toplevel) && " .. checkCommitConflict()
end

M.gitCommit = function()
  vim.cmd('term ' .. M.gitCommitCmd())
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
  local BRANCH = vim.fn.system('git symbolic-ref --short HEAD')
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
  local DEFAULT_REMOTE
  if opts == nil then
    DEFAULT_REMOTE = 'origin'
  else
    DEFAULT_REMOTE = opts
  end
  return vim.cmd('term ' .. M.gitCommitCmd() .. M.addSsh(' && ') .. M.gitPush(DEFAULT_REMOTE))
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
    h = { ':Telescope git_issue_cache<CR>', "EDIT_ISSUE_ON_CACHE" },
    i = { ':Telescope git_issue<CR>', "EDIT_ISSUE" },
    s = { ':Telescope git_status<CR>', "STATUS" },
    c = { ':term git commit<CR>', "COMMIT" },
    a = { ':term gh issue create<CR>', "ADD_ISSUE" },
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
