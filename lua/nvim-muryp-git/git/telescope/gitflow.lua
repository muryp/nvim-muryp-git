local picker = require "nvim-muryp-git.utils.picker"

return function()
  local ListBranch = {} ---@type string[]
  local NAME_CURRENT_BRANCH = vim.fn.system('echo $(git symbolic-ref --short HEAD)'):gsub('\n', ''):gsub('\r', '') ---@type string
  ListBranch = {}
  for branch in io.popen("git branch --list | grep -v $(git rev-parse --abbrev-ref HEAD)"):lines() do
    table.insert(ListBranch, branch)
  end
  local function callback(selection)
    vim.cmd('term git checkout ' .. selection .. ' && git merge ' .. NAME_CURRENT_BRANCH)
  end

  picker({
    opts = ListBranch,
    callBack = callback,
    title = "choose branch want to merge"
  })
end
