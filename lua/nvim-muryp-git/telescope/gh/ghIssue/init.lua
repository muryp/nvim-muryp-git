local ghIssue = function(issue_number)
  local GET_GIT_DIR = vim.fn.system("git rev-parse --show-toplevel")
  vim.cmd('cd ' .. GET_GIT_DIR)
  local GET_DIR_ROOT_GIT = GET_GIT_DIR:gsub('\n', '')
  local DIR_LOC_HISTORY = GET_DIR_ROOT_GIT .. "/.git/muryp"
  local LIST_INFO = {
    "title",
    "assignees",
    "author",
    "body",
    "closed",
    "closedAt",
    -- "comments",
    "createdAt",
    "id",
    "labels",
    "milestone",
    "number",
    "projectCards",
    "reactionGroups",
    "state",
    "title",
    "updatedAt",
    "url",
  }
  local LIST_INFO_JSON = {}
  for _, v in pairs(LIST_INFO) do
    table.insert(LIST_INFO_JSON, '--json ' .. v)
  end
  local LIST_INFO_CDM = "gh issue view " .. table.concat(LIST_INFO_JSON, ' ') .. ' ' .. issue_number
  local GET_ISSUE_DATA_JSON = vim.fn.system(LIST_INFO_CDM)
  local GET_ISSUE_DATA_OBJ = vim.fn.json_decode(GET_ISSUE_DATA_JSON)
  local HEADER_ISSUE_OBJ = {}
  for i, v in pairs(GET_ISSUE_DATA_OBJ) do
    HEADER_ISSUE_OBJ[i] = v
  end
  HEADER_ISSUE_OBJ.body = nil
  local HEADER_ISSUE_OBJ_TO_STR = require('nvim-muryp-git.utils.tableToString').serializeTable(HEADER_ISSUE_OBJ)
  local HEADER_ISSUE_STR_DEL_SPC = string.gsub(string.gsub(HEADER_ISSUE_OBJ_TO_STR, '\n ', '\n'), '^ ', '')
  local isIssueOpen = function()
    if GET_ISSUE_DATA_OBJ.closed == false then
      return 'OPEN'
    end
    return 'CLOSED'
  end
  local FILE_NAME = "/gh_issue-" ..
      '-' .. issue_number .. '-' .. string.gsub(GET_ISSUE_DATA_OBJ.title,' ','_') .. '-' .. isIssueOpen() .. ".md"
  local FILE_PWD = DIR_LOC_HISTORY .. FILE_NAME
  local HELP_HEADER = [[
<!--
maps :
- <leader><leader>p => push
- <leader><leader>e => edit header
- <leader><leader>o => open browser
- <leader><leader>e => list cmd
-->
<!--
NOTE : puth text under comment(all comment eddit is no effect )
-->
]]
  local ISSUE_GENERATE = '<!--' .. HEADER_ISSUE_STR_DEL_SPC .. '-->' .. GET_ISSUE_DATA_OBJ.body
  os.execute("mkdir " .. DIR_LOC_HISTORY)
  os.execute('echo "' .. HELP_HEADER .. ISSUE_GENERATE .. '" > ' .. FILE_PWD)
  vim.cmd('e ' .. FILE_PWD)
  require('nvim-muryp-git.telescope.gh.ghIssue.maps').maps()
end
return ghIssue
