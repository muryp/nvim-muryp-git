local picker = require "nvim-muryp-git.utils.picker"

return function()
  local ListBranch = {} ---@type string[]
  local LIST_BRANCH = vim.api.nvim_command_output('echo system("git branch")') ---@type string
  local NAME_CURRENT_BRANCH = vim.api.nvim_command_output('echo system("echo $(git symbolic-ref --short HEAD)")') ---@type string
  local BRANCH_DEL_ENTER = string.gsub(NAME_CURRENT_BRANCH, "\n", "")
  ---check is not current branch and *
  for BRANCH in string.gmatch(LIST_BRANCH, "%S+") do
    if BRANCH ~= "*" and BRANCH ~= BRANCH_DEL_ENTER then
      table.insert(ListBranch, BRANCH)
    end
  end

  local function callback(selection)
    print(vim.inspect(vim.cmd('!git checkout ' .. selection)))
  end

  picker({
    opts = ListBranch,
    callBack = callback,
    title = "choose branch want to merge"
  })
end
