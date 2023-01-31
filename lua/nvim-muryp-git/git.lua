local M = {}
local gitCommitCmd = " && cd $(git rev-parse --show-toplevel) && git add . && git commit"
M.gitCommit = function()
  vim.cmd('term ' .. "cd %:p:h" .. gitCommitCmd)
end
M.addSsh = function()
  local SshPath = require('nvim-muryp-git').setup.SSH_PATH
  local SSH_PATH = ''
  for _, PATH in pairs(SshPath) do
    SSH_PATH = SSH_PATH .. ' ' .. PATH
  end
  vim.cmd("!cd %:h && eval \"$(ssh-agent -s)\" && ssh-add " .. SSH_PATH)
end
M.gitPush = function()
  vim.cmd("!git push --all")
end

M.pull = function()
  vim.cmd('git pull')
end

M.maps = function()
  local key = vim.keymap.set
  key('n', '<leader>gs', ':Telescope git_status<CR>')
  key('n', '<leader>gc', ':Telescope git_branches<CR>')
  key('n', '<leader>gf', ':Telescope git_flow<CR>')
  key('n', '<leader>gi', ':Telescope git_issue<CR>')
  key('n', '<leader>gi', ':Telescope git_issue_history<CR>')
  key('n', '<leader>ga', ':term gh issue create<CR>')
  key('n', '<leader>gv', M.gitCommit)
  key('n', '<leader>gp', function()
    M.addSsh()
    M.gitPush()
  end)
end

return M
