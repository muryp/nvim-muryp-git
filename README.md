# Plugin Nvim MuryP Git
## feature
- shortcut : git commit, push, ssh add, pull
- gh issue : CRUD

## install
- packer
```lua
use {
  'muryp/nvim-muryp-git',
  after = 'telescope.nvim',
  config = function()
    require('nvim-muryp-git').setup {
      SSH_PATH = {'~/ssh/github'},
    }
  end
}
```
