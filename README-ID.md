Language : [English](./README.md) | Indonesia

[![License: Apache](https://img.shields.io/badge/License-Apache-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![Neovim version](https://img.shields.io/badge/Neovim-0.8.x-green.svg)
![Lua version](https://img.shields.io/badge/Lua-5.4-yellow.svg)
[![Repo Size](https://img.shields.io/github/repo-size/muryp/nvim-muryp-git)](https://github.com/muryp/nvim-muryp-git)
[![Downloads](https://img.shields.io/github/downloads/muryp/nvim-muryp-git/total)](https://github.com/muryp/nvim-muryp-git/releases)
[![Latest Release](https://img.shields.io/github/release/muryp/nvim-muryp-git)](https://github.com/muryp/nvim-muryp-git/releases/latest)
[![Last Commit](https://img.shields.io/github/last-commit/muryp/nvim-muryp-git)](https://github.com/muryp/nvim-muryp-git/commits/master)
[![Open Issues](https://img.shields.io/github/issues/muryp/nvim-muryp-git)](https://github.com/muryp/nvim-muryp-git/issues)
# Plugin Nvim MuryP Git
Plugin untuk memudahkan penggunaan git dan gh issue di nvim, dengan bantuan plugin `telescope`.
## feature
- shortcut : git commit, push, ssh add, pull
- gh issue : CRUD
## requirement
- gh cli : untuk mengambil dan memperbarui issue
- whichkey : bantuan keymap
- git
- nvim 0.8+
- telescope : untuk daftar isi/pencarian issue
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
Tekan `<leader>g` untuk melihat cmd apa saja (dibutuhkan plugin whichkey) :
- `<leader>ga` : menambahkan issue repo github
- `<leader>gb` : mengganti branch
- `<leader>gc` : commit
- `<leader>ge` : push
- `<leader>gf` : ganti branch lalu merge
- `<leader>gh` : mencari issue di history
- `<leader>gi` : mencari issue (online)
- `<leader>gp` : git add => commit=> ssh=> pull=> push to git
- `<leader>gP` : pull request
- `<leader>gs` : mencari file yang belum di commit
- `<leader>gv` : add and commit
### github issue
- pilih issue menggunakan `<leader><leader>gi` atau `<leader><leader>gh`
- setelah itu, tekan `<leader><leader>g` untuk menampilkan mapping (dibutuhkan plugin whichkey)

## Api
- git commit
```lua
require('nvim-muryp-git.git').gitCommit()
```
- add ssh
```lua
require('nvim-muryp-git.git').addSsh()
```
- sshpush
```lua
require('nvim-muryp-git.git').gitSshPush()
```
- pull
```lua
require('nvim-muryp-git.git').pull()
```
- edit
```lua
require('nvim-muryp-git.telescope.gh.ghIssue.maps').edit()
```
- open
```lua
require('nvim-muryp-git.telescope.gh.ghIssue.maps').open()
```
- update local from online
```lua
require('nvim-muryp-git.telescope.gh.ghIssue.maps').push()
```
- delete issue (cannnot undo)
```lua
require('nvim-muryp-git.telescope.gh.ghIssue.maps').delete()
```
## Lisensi
Plugin `nvim-muryp-git` didistribusikan dengan lisensi `Apache License 2.0`. Silakan merujuk ke berkas `LICENSE` untuk informasi lebih lanjut mengenai lisensi ini.

## Kontribusi
Kami mengharigai kontribusi anda baik berupa `issue` maupun `memperbaiki kode`. Silahkan baca berkas `CONTRIBUTE-ID.md` untuk informasi lebih lanjut.
