local mapping = require('nvim-muryp-git.utils.mapping')

local M = {}
---@return string
M.addSsh = function()
  local SshPath = require('nvim-muryp-git').Setup.SSH_PATH
  local SSH_PATH = ''
  for _, PATH in pairs(SshPath) do
    SSH_PATH = SSH_PATH .. PATH .. ' '
  end
  return [[eval "$(ssh-agent -s)" && ssh-add ]] .. SSH_PATH
end
---@param callback function callback if success
---@return function exec when not conflict
local cekConflick = function(callback)
  local isConflict = vim.fn.system('git diff --check')
  if isConflict == '' then
    return callback()
  else
    return vim.api.nvim_err_writeln(isConflict)
  end
end
---@param opts {ssh:boolean|nil,add:boolean|nil,commit:boolean|nil,pull:boolean|nil,push:boolean|nil,pull_quest:boolean|nil,remote_quest:boolean|nil} is return string or vim cmd
---@return function : return cmd git ?add, ?commit, ?pull, ?push with ?ssh
M.gitMainCmd = function(opts)
  return cekConflick(function()
    local isCommited = vim.fn.system('[[ $(git status --porcelain) ]] && echo true')
    local CMD = 'term '
    if isCommited ~= '' and opts.commit == true then
      if opts.add == true then
        CMD = CMD .. 'git add . && '
      end
      CMD = CMD .. 'git commit && '
    end
    if opts.ssh == true then
      CMD = CMD .. M.addSsh()
    end
    local REMOTE = require('nvim-muryp-git').Setup.DEFAULT_REMOTE
    if opts.remote_quest ~= nil then
      REMOTE = vim.fn.input('what repo ? ', REMOTE)
      if REMOTE == '' then
        return vim.api.nvim_err_writeln('ERR: please input remote name')
      end
    end
    local isPull = ''
    local TARGET_HOST = ''
    if opts.pull == true or opts.push == true then
      BRANCH = vim.fn.system('git symbolic-ref --short HEAD'):gsub('\n', ''):gsub('\r', '')
      TARGET_HOST = REMOTE .. ' ' .. BRANCH
    end
    if opts.pull_quest == true then
      isPull = vim.fn.input('Use PUll (y/n) ? ')
    end
    if opts.pull == true or isPull == 'y' or isPull == 'Y' then
      vim.cmd('!git pull ' .. TARGET_HOST)
    end
    cekConflick(function()
      if opts.push == true then
        CMD = CMD .. 'git push ' .. TARGET_HOST .. ' && '
      end
      vim.cmd(CMD)
    end)
  end)
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
    s = { ':Telescope git_status<CR>', "GIT_STATUS" },
    c = { ':term git commit<CR>', "COMMIT" },
    v = { function()
      M.gitMainCmd({
        add = true,
        commit = true,
      })
    end, "ADD_ALL+COMMIT" },
    p = {
      name = "PUSH",
      p = { function()
        M.gitMainCmd({
          add = true,
          commit = true,
          ssh = true,
          remote_quest = true,
          pull_quest = true,
          push = true,
        })
      end, "ADD+COMMIT+SSH+PULL+PUSH" },
      P = { function()
        M.gitMainCmd({
          remote_quest = true,
          push = true,
        })
      end, "PUSH" },
      a = { ':term ' .. M.addSsh() .. ' && git push --all<CR>', "PUSH ALL WITH SSH" },
      A = { ':term git push --all<CR>', "PUSH ALL" },
      s = { function()
        M.gitMainCmd({
          push = true,
          remote_quest = true,
          pull_quest = true,
        })
      end, "SSH+PULL+PUSH" },
      S = { function()
        M.gitMainCmd({
          push = true,
          remote_quest = true,
        })
      end, "SSH+PUSH" },
    },
    P = {
      name = "PULL",
      A = { ':term git pull --all<CR>', "PULL ALL" },
      a = { ':term ' .. M.addSsh() .. ' && git pull --all<CR>', "PULL ALL WITH SSH" },
      p = { function()
        M.gitMainCmd({
          remote_quest = true,
          pull = true,
        })
      end, "PULL THIS BRANCH" },
      P = { function()
        M.gitMainCmd({
          remote_quest = true,
          pull = true,
          ssh = true,
        })
      end, "PULL THIS BRANCH WITH SSH" },
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
