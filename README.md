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
      SSH_PATH = { '~/ssh/github' }
    }
  end
}

```
## how use it
### git
use `<leader>g` then will show what can do with (wichkey required).
### github issue
- use `<leader>gi` to get list issue (online)
or
- use `<leader>gh` to get list issue (offline)
- after choose issue, press `<leader><leader>g` then will show what we can do

## Api
- git commit
- add ssh
- git push
- sshpush
- pull
- edit
- open
- update
- delete

## Lisensi
The nvim-muryp-telescope-bookmark plugin is distributed under the **Apache License 2.0**. Please refer to the `LICENSE` file for more information about this license.

## Contributing
We greatly appreciate contributions from anyone who wants to help improve this repo. Please see the `CONTRIBUTE.md` file for more information on how to contribute to this repo. Thank you for your contribution!
