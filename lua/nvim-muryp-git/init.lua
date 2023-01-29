local M = {}
M.gh = {
  issue = function()
    require('nvim-muryp-git.telescope.gh').getListIssue()
  end
}
M.git = {
  flow = function()
    require('nvim-muryp-git.telescope.gitFlow')
  end,
  commit = function()

  end,
  push = function()

  end,
  conflicMerge = function()

  end
}
M.workSpace = function()
  require('nvim-muryp-git.telescope.workspace')
end

M.setup = {
  -- mapping
  -- opts :
  -- tmux/float/split/full terminal (nvim)
  -- ssh dir
}

return M
