local ghIssue = function(issue_number)
  vim.cmd('Cdg')
  local GET_DIR_ROOT_GIT = vim.fn.system("git rev-parse --show-toplevel"):gsub('\n', '')
  local DIR_LOC_HISTORY = GET_DIR_ROOT_GIT .. "/.git/muryp"
  local getDate = os.date():gsub(" ", ""):gsub(":", ""):gsub("%a", "")
  local filename = "/gh-issue-" .. issue_number .. ".md"
  local file = DIR_LOC_HISTORY .. filename
  local getIssue = vim.fn.system("gh issue view " .. issue_number)
  local _, _, replaceIssue = string.find(getIssue, "(number:\t%d+)")
  local delteNum = getIssue:gsub("number:.+%d\n--.", replaceIssue .. "\n-->")
  local newBody = "<!--\n" .. delteNum
  local helper = [[

<!--
maps :
- <leader><leader>p => push
- <leader><leader>e => edit header
- <leader><leader>o => open browser
-->
<!--
NOTE : puth text under comment(all comment eddit is no effect )
-->
]]

  os.execute("mkdir " .. DIR_LOC_HISTORY)
  os.execute('echo "' .. helper .. newBody .. '" > ' .. file)
  vim.cmd('e ' .. file)
  vim.cmd('g/^$/d')
  require('gh.utils.maps').maps()
end
return ghIssue
