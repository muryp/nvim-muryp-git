local M = {}
local gitCommitCmd = " && cd $(git rev-parse --show-toplevel) && git add . && git commit"
M.gitCommit = function()
  vim.cmd('term ' .. "cd %:p:h" .. gitCommitCmd)
end

M.gitPushCommit = function()
  vim.cmd("!cd %:h && eval \"$(ssh-agent -s)\" && ssh-add ~/.ssh/github && git push --all")
end

return M
