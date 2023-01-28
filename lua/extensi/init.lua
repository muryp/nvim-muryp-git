local plug     = require('telescope.builtin')
local gitFlow  = require('configs.file.telescope.extensi.gitFlow')
local workspace = require('configs.file.telescope.extensi.workspace')
local gh       = require('configs.file.telescope.extensi.gh')

plug.git_flow = gitFlow
plug.work_space = workspace
plug.git_issue = gh
