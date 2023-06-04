Language : English | [Indonesia](./README-ID.md)

[![License: Apache](https://img.shields.io/badge/License-Apache-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![Neovim version](https://img.shields.io/badge/Neovim-0.8.x-green.svg)
![Lua version](https://img.shields.io/badge/Lua-5.4-yellow.svg)
[![Repo Size](https://img.shields.io/github/repo-size/muryp/nvim-muryp-git)](https://github.com/muryp/nvim-muryp-git)
[![Downloads](https://img.shields.io/github/downloads/muryp/nvim-muryp-git/total)](https://github.com/muryp/nvim-muryp-git/releases)
[![Latest Release](https://img.shields.io/github/release/muryp/nvim-muryp-git)](https://github.com/muryp/nvim-muryp-git/releases/latest)
[![Last Commit](https://img.shields.io/github/last-commit/muryp/nvim-muryp-git)](https://github.com/muryp/nvim-muryp-git/commits/master)
[![Open Issues](https://img.shields.io/github/issues/muryp/nvim-muryp-git)](https://github.com/muryp/nvim-muryp-git/issues)
# Plugin Nvim MuryP Git
easy use git and git issue in nvim, with telescope.
## feature
- shortcut : git commit, push, ssh add, pull
- gh issue : CRUD
## requirement
- gh cli : use for issue
- whichkey : for mapping
- git
- nvim 0.8+
- telescope : for list option
## install
- packer
```lua
use {
  'muryp/nvim-muryp-git',
  after = 'telescope.nvim',
  config = function()
    require('nvim-muryp-git').setup()
  end
}

```
## default setup
```lua
local MAPS = {
  name = "GIT",
  b = { ':Telescope git_branches<CR>', "BRANCH" },
  f = { ':Telescope git_flow<CR>', "FLOW" },
  i = {
    c = { ':Telescope git_issue_cache<CR>', "LIST_ISSUE_ON_CACHE" },
    i = { ':Telescope git_issue<CR>', "EDIT_ISSUE" },
    o = { IMPORT_GH_MAPS .. ".addIssue", "ADD_ISSUE_TO_CHACE" },
    a = { ':term gh issue create<CR>', "ADD_ISSUE" },
    p = { IMPORT_GH_MAPS .. ".push()<CR>", "PUSH_INTO_GH" },
    e = { IMPORT_GH_MAPS .. ".edit()<CR>", "EDIT" },
    u = { IMPORT_GH_MAPS .. ".update()<CR>", "UPDATE_LOCAL" },
    d = { IMPORT_GH_MAPS .. ".delete()<CR>", "DELETE" },
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
    a = { function ()
      vim.cmd(':term ' .. M.SSH_CMD() .. ' && git push --all<CR>')
    end, "PUSH ALL WITH SSH" },
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
    a = { function ()
      vim.cmd(':term ' .. M.SSH_CMD() .. ' && git pull --all<CR>')
    end, "PULL ALL WITH SSH" },
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
require('nvim-muryp-git').setup {
  {
    mapping = function()
      mapping({ g = MAPS }, { prefix = "<leader>", noremap = true })
    end,
    SSH_PATH = { '$HOME/.ssh/github' },
    ---@return string DIR_ISSUE location of dir cache
    CACHE_DIR = function()
      local GET_GIT_DIR = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), '\n', '')
      local DIR_ISSUE   = GET_GIT_DIR .. '/.git/muryp/gh_issue/'
      return DIR_ISSUE
    end,
    DEFAULT_REMOTE = 'origin',

  }
}
```

## how use it
### git
use `<leader>g` then will show what can do (wichkey required) :
- `<leader>ga` : add gh issue
- `<leader>gb` : branch
- `<leader>gc` : commit
- `<leader>ge` : push
- `<leader>gf` : gitflow
- `<leader>gh` : history gh issue
- `<leader>gi` : gh issue (online)
- `<leader>gpp` : git add all, commit, ssh, pull, and push to remote
- `<leader>gps` : git ssh, pull, and push to remote
- `<leader>gpa` : git push all to remote
- `<leader>gPP` : pull request
- `<leader>gPA` : pull request --all
- `<leader>gs` : status/list uncommited
- `<leader>gv` : add and commit
- `<leader>gop` : git add all, commit, ssh, pull, and push to remote with opts remote name
- `<leader>goP` : git pull with opts remote name

### github issue
- use `<leader>gi` to get list issue (online)
or
- use `<leader>gh` to get list issue (offline)
- after choose issue, press `<leader><leader>g` then will show what we can do

## Api
- git cmd main
```lua
M.gitMainCmd({
  add = true,          -- use git add . ? => boolean|nil
  commit = true,       -- use commit? => boolean|nil
  ssh = true,          -- use ssh? => boolean|nil
  pull = true,         -- use pull? => boolean|nil
  pull_quest = true,   -- ask use pull => boolean|nil
  push = true,         -- push => boolean|nil
  remote_quest = true, -- custom remote => boolean|nil
  remote = true,       -- default remote => string
})
```
- edit in cli
```lua
require('nvim-muryp-git.gh.cmd').edit()
```
- open in browser
```lua
require('nvim-muryp-git.gh.cmd').open()
```
- update local file
```lua
require('nvim-muryp-git.gh.cmd').push()
```
- delete issue
> warning: this really delete issue on github
```lua
require('nvim-muryp-git.gh.cmd').delete()
```
- update local file with number
```lua
require('nvim-muryp-git.gh.cmd').addIssue()
```
- list remote
```lua
---@param selection string|string[] user select
local callback = function(selection)
  ---... cmd want to exec
end
require('nvim-muryp-git.git.telescope.git').listRemote(callback)
```

## Telescope Register
- `Telescope git_flow` : checkout and merge
- `Telescope git_issue` : get list issue online and create chachce then open
- `Telescope git_issue` : get list issue online and create chachce then open
- `Telescope git_pull` : pull request from remote
- `Telescope git_commit_ssh_push` : commit ssh push with option remote

## Lisensi
The `nvim-muryp-git` plugin is distributed under the **Apache License 2.0**. Please refer to the `LICENSE` file for more information about this license.

## Contributing
We greatly appreciate contributions from anyone can produce **issue** or **maintaine code** to help this repo. Please read `CONTRIBUTE.md` for more info.
