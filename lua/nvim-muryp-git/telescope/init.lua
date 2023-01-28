local plug      = require('telescope.builtin')
local gitFlow   = require('nvim-muryp-git.telescope.gitFlow')
local workspace = require('nvim-muryp-git.telescope.workspace')
local gh        = require('nvim-muryp-git.telescope.gh')

plug.git_flow = gitFlow
plug.work_space = workspace
plug.git_issue = gh
