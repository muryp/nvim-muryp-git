# Plugin Nvim MuryP Git
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

