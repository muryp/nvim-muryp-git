local mapping = require('nvim-muryp-git.utils.mapping')

local M = {}
local gitCommitCmd = " && cd $(git rev-parse --show-toplevel) && git add . && git commit"
M.gitCommit = function()
  vim.cmd('term ' .. "cd %:p:h" .. gitCommitCmd)
end
M.addSsh = function()
  local SshPath = require('nvim-muryp-git').Setup.SSH_PATH
  local SSH_PATH = ''
  for _, PATH in pairs(SshPath) do
    SSH_PATH = SSH_PATH .. PATH .. ' '
  end
  local CMD = [[eval "$(ssh-agent -s)" && ssh-add ]] .. SSH_PATH
  return CMD
end
M.gitPush = function()
  ---@type string
  local PATH_NOW = vim.fn.expand('%:h')
  local result = ''
  if PATH_NOW ~= '' then
    ---@type string
    result = 'cd ' .. PATH_NOW
  end
  ---@type string
  result = result .. " && git push --all"
  return result
end
M.gitSshPush = function()
  vim.cmd('term ' .. M.addSsh() .. M.gitPush())
end

M.pull = function()
  vim.cmd('term git pull')
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
    p = { function()
      M.gitSshPush()
    end, "SSH+PUSH" },
    e = { ':term git push --all<CR>', "PUSH" },
    P = { M.pull, "PULL" },
  }
  mapping({ g = MAPS }, { prefix = "<leader>", noremap = true })
end

return M
