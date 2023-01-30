local M = {}
local getVar = function()
  local getFile        = vim.api.nvim_command_output('echo expand("%:p")')
  local getCurrentFile = vim.fn.system('cat ' .. getFile)
  local _, _, getIssue = string.find(getCurrentFile, "https://github.com/.*/issues/(%d*)")
  local gitRoot        = vim.fn.system("git rev-parse --show-toplevel"):gsub('\n', '')
  return { getFile = getFile, getCurrentFile = getCurrentFile, getIssue = getIssue, gitRoot = gitRoot }
end
M.edit = function()
  local var = getVar()
  vim.cmd('!' .. _G.TMUX_POPUP .. ' "cd ' .. var.gitRoot .. ' && gh issue edit ' .. var.getIssue .. '"')
end
M.open = function()
  vim.cmd('!gh issue view -w ' .. getVar().getIssue)
end
M.push = function()
  local variable       = getVar()
  local getCurrentFile = variable.getCurrentFile
  local getIssue       = variable.getIssue
  local getBody        = getCurrentFile:gsub("<!--.*-->\n", ""):gsub("+++.*+++\n", ""):gsub("\n[^\n]*$", "")
  os.execute('gh issue edit ' .. getIssue .. ' --body ' .. '"' .. getBody .. '"')
end
M.maps = function()
  local key     = vim.keymap.set
  local opts    = { buffer = true }
  local keymaps = "<leader><leader>"
  local import  = ":lua require('nvim-muryp-git.telescope.gh.ghIssue.maps')"
  key("n", keymaps .. "p", import .. ".push()<CR>", opts)
  key("n", keymaps .. "e", import .. ".edit()<CR>", opts)
  key("n", keymaps .. "o", import .. ".open()<CR>", opts)
end
return M
