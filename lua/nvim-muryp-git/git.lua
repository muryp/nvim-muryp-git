local M = {}
local gitCommitCmd = " && cd $(git rev-parse --show-toplevel) && git add . && git commit"
M.gitCommit = function()
  vim.cmd('term ' .. "cd %:p:h" .. gitCommitCmd)
end
M.addSsh = function()
  local SshPath = require('nvim-muryp-git').Setup.SSH_PATH
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
  local wk = require("which-key")
  wk.register({
    g = {
      name = "GIT",
      b = { ':Telescope git_branches<CR>', "BRANCH" },
      f = { ':Telescope git_flow<CR>', "FLOW" },
      e = { ':Telescope git_issue<CR>', "EDIT_ISSUE" },
      h = { ':Telescope git_issue_history<CR>', "EDIT_ISSUE_HISTORY" },
      i = { ':Telescope git_issue<CR>', "EDIT_ISSUE" },
      s = { ':Telescope git_issue<CR>', "STATUS" },
      c = { ':!term git commit<CR>', "COMMIT" },
      a = { ':term gh issue create<CR>', "ADD_ISSUE" },
      v = { M.gitCommit, "ADD+COMMIT" },
      p = { function()
        M.addSsh()
        M.gitPush()
      end, "SSH+PUSH" },
      x = { ':term git push --all<CR>', "PUSH" },
      P = { M.pull, "PULL" },
    },
  }, { prefix = "<leader>" })
end

return M
