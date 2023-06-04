local picker = require "nvim-muryp-git.utils.picker"
local cmdGit = require('nvim-muryp-git.git')
local M = {}

---@return nil gitPull git pull with opts remote
M.listRemote = function(callback)
  local LIST_REMOTE = vim.fn.systemlist("git remote") --- @type string[]
  picker({
    opts = LIST_REMOTE,
    callBack = callback,
    title = "choose remote want to pull"
  })
end

---@param selection string|string[] user select
---@param cmd function arg selection => string
---@return nil callback exec callback with selection in first arg
local isMultiSelect = function(selection, cmd)
  if type(selection) == 'table' then
    for _, v in pairs(selection) do
      cmd(v)
    end
  else
    cmd(selection)
  end
end

---@return nil gitSshPush git commit, pull, push with opts remote
M.push = function()
  ---defind callback/after enter
  ---@param selection string|string[] user select
  local callback = function(selection)
  ---defind cmd to exec
  ---@param remote string user select
    local cmd = function(remote)
      cmdGit.gitMainCmd({
        add = true,
        commit = true,
        ssh = true,
        remote = remote,
        pull_quest = true,
        push = true,
      })
    end
    isMultiSelect(selection, cmd)
  end
  M.listRemote(callback)
end

---@return nil gitPull git pull with opts remote
M.pull = function()
  local function callback(selection)
    local cmd = function(remote)
      cmdGit.gitMainCmd({
        ssh = true,
        remote = remote,
        pull = true,
      })
    end
    isMultiSelect(selection, cmd)
  end
  M.listRemote(callback)
end
return M
