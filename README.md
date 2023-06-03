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
    require('nvim-muryp-git').setup {
      -- mapping = {
        -- issue = function()
        --   add mapping issue in here
        -- end,
        -- git = function()
        --   add mapping git in here
        -- end,
      -- },
      SSH_PATH = { '~/ssh/github' },
      -- CACHE_DIR = function()
      --   return 'location/cache'
      -- end,
    }
  end
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
- git commit
```lua
---cmd add and commits
require('nvim-muryp-git.git').gitCommit()
```
- add ssh
```lua
---generate string cmd to add ssh
---@param FIRST_LETTER string FIRST_LETTER cmd
---@return string
require('nvim-muryp-git.git').addSsh(' && ')
```
- sshpush
```lua
---@param opts string | nil remote
---@return nil vim.cmd commit, pull, push with ssh,
require('nvim-muryp-git.git').gitSshPush()
```
- pull
```lua
---@param opts string | nil remote name
---@return nil vim.cmd pull with ssh,
require('nvim-muryp-git.git').pull()
```
- edit in cli
```lua
require('nvim-muryp-git.telescope.gh.ghIssue.maps').edit()
```
- open in browser
```lua
require('nvim-muryp-git.telescope.gh.ghIssue.maps').open()
```
- update local file
```lua
require('nvim-muryp-git.telescope.gh.ghIssue.maps').push()
```
- delete issue
> warning: this really delete issue on github
```lua
require('nvim-muryp-git.telescope.gh.ghIssue.maps').delete()
```
- update local file with number
```lua
require('nvim-muryp-git.telescope.gh.ghIssue.maps').addIssue()
```

## Telescope Register
- `Telescope git_flow` : checkout and merge
- `Telescope git_issue` : get list issue online and create chachce then open
- `Telescope git_issue` : get list issue online and create chachce then open

## Lisensi
The `nvim-muryp-git` plugin is distributed under the **Apache License 2.0**. Please refer to the `LICENSE` file for more information about this license.

## Contributing
We greatly appreciate contributions from anyone can produce **issue** or **maintaine code** to help this repo. Please read `CONTRIBUTE.md` for more info.
