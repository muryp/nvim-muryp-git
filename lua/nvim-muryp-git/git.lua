local mapping = require('nvim-muryp-git.utils.mapping')

local M = {}
---@return string : check is commit or conflict
local function checkCommitConflict()
  local isTroble = vim.fn.system("[[ $(git diff --check) == '' ]] && echo $([[ $(git diff HEAD) != '' ]] && echo 'true' || echo 'false') || echo false")
  if isTroble == 'true\n' then
    return 'git add . && git commit'
  else
    return 'echo "commited..."'
  end
end
local gitCommitCmd =
    "cd %:p:h && cd $(git rev-parse --show-toplevel) && " .. checkCommitConflict()
M.gitCommit = function()
  vim.cmd('term ' .. gitCommitCmd)
end
M.addSsh = function()
  local SshPath = require('nvim-muryp-git').Setup.SSH_PATH
  local SSH_PATH = ''
  for _, PATH in pairs(SshPath) do
    SSH_PATH = SSH_PATH .. PATH .. ' '
  end
  ---@type string
  local CMD = [[ && eval "$(ssh-agent -s)" && ssh-add ]] .. SSH_PATH
  return CMD
end
---@return string
M.gitPush = function()
  local push =
  ' && [[ $(git diff --check) == "" ]] && git push --all || echo "\\033[31merror: you have conflict:\\n$(git diff --check)"'
  return " && git pull --all" .. push
end
M.gitSshPush = function()
  -- print('term ' .. gitCommitCmd .. M.addSsh() .. M.gitPush())
  vim.cmd('term ' .. gitCommitCmd .. M.addSsh() .. M.gitPush())
end

M.pull = function()
  vim.cmd('term git pull --all')
end

M.maps = function()
  local MAPS = {
    name = "GIT",
    b = { ':Telescope git_branches<CR>', "BRANCH" },
    f = { ':Telescope git_flow<CR>', "FLOW" },
    h = { ':Telescope git_issue_history<CR>', "EDIT_ISSUE_HISTORY" },
    i = { ':Telescope git_issue<CR>', "EDIT_ISSUE" },
    s = { ':Telescope git_status<CR>', "STATUS" },
    c = { ':term git commit<CR>', "COMMIT" },
    a = { ':term gh issue create<CR>', "ADD_ISSUE" },
    v = { M.gitCommit, "ADD+COMMIT" },
    p = { M.gitSshPush, "SSH+PUSH" },
    e = { ':term git push --all<CR>', "PUSH" },
    P = { M.pull, "PULL" },
  }
  mapping({ g = MAPS }, { prefix = "<leader>", noremap = true })
end

return M
