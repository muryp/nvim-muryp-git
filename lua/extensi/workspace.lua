local picker   = require "configs.file.telescope.utils.picker"
local opts     = require "configs.file.telescope.configs.workspace"
local getNames = require "configs.file.telescope.utils.getNames"

return function()
  local names = getNames(opts.list)
  local function callback(selection)
    local opts_names = getNames(opts.option)
    picker({
      opts = opts_names,
      callBack = function(selection2)
        vim.cmd('cd ' .. opts.list[selection[1]])
        vim.cmd('execute "' .. opts.option[selection2[1]] .. '"')
      end,
      title = "choose what command do you want"
    })
  end

  picker({
    opts = names,
    callBack = callback,
    title = 'choose your path favorite'
  })
end
