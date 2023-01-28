local picker = require "nvim-muryp-git.utils.picker"

return function()
  local list_branch_obj = {}
  local list_branch = vim.api.nvim_command_output('echo system("git branch")')
  local name_branch_now = vim.api.nvim_command_output('echo system("echo $(git symbolic-ref --short HEAD)")')
  local name_branch_now_convert = string.gsub(name_branch_now, "\n", "")

  for word in string.gmatch(list_branch, "%S+") do
    if word ~= "*" and word ~= name_branch_now_convert then
      table.insert(list_branch_obj, word)
    end
  end

  local function callback(selection)
    print(vim.inspect(vim.cmd('!git checkout ' .. selection[1])))
  end

  picker({
    opts = list_branch_obj,
    callBack = callback,
    title = "choose branch want to merge"
  })
end
