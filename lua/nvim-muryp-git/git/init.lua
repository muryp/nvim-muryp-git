local M = {}
---@class optsGitMainCmd : {ssh?:boolean,add?:boolean,commit?:boolean,pull?:boolean,push?:boolean,pull_quest?:boolean,remote_quest?:boolean,remote?:string} opts what todo

---@return string
M.SSH_CMD = function()
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
---@param opts optsGitMainCmd is return string or vim cmd
---@return function : return cmd git ?add, ?commit, ?pull, ?push with ?ssh
M.gitMainCmd = function(opts)
  return cekConflick(function()
    local isCommited = vim.fn.system('[[ $(git status --porcelain) ]] && echo true')
    local CMD = ''
    if isCommited ~= '' and opts.commit == true then
      if opts.add == true then
        CMD = CMD .. 'git add . && '
      end
      CMD = CMD .. 'git commit && '
    end
    local SSH_CMD = ''
    if opts.ssh == true then
      SSH_CMD = M.SSH_CMD() .. ' && '
    end
    local REMOTE = require('nvim-muryp-git').Setup.DEFAULT_REMOTE
    if opts.remote ~= nil then
      REMOTE = opts.remote
    end
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
      vim.cmd('term ' .. SSH_CMD .. 'git pull ' .. TARGET_HOST)
    end
    cekConflick(function()
      if opts.push == true then
        CMD = CMD .. 'git push ' .. TARGET_HOST
      end
      if CMD ~= '' then
        vim.cmd('term ' .. SSH_CMD .. CMD)
      end
    end)
  end)
end

return M
