local picker = require "nvim-muryp-git.utils.picker"
local cmdGit = require('nvim-muryp-git.git')
local M = {}

---@return nil gitSshPush git commit, pull, push with opts remote
M.push = function()
  local LIST_REMOTE = vim.fn.systemlist("git remote") --- @type string[]
  local function callback(selection)
    cmdGit.gitSshPush(selection)
  end
  picker({
    opts = LIST_REMOTE,
    callBack = callback,
    title = "choose remote want to push"
  })
end

---@return nil gitPull git pull with opts remote
M.pull = function()
  local LIST_REMOTE = vim.fn.systemlist("git remote") --- @type string[]
  local function callback(selection)
    cmdGit.pull(selection)
  end
  picker({
    opts = LIST_REMOTE,
    callBack = callback,
    title = "choose remote want to pull"
  })
end
return M
