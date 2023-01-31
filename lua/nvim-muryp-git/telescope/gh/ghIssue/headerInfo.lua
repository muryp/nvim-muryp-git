return function(Arg)
  local GetIssueData = Arg.GetIssueData ---@type Object
  local HeaderIssue = {}
  for KEY, VAL in pairs(GetIssueData) do
    if KEY == 'author' then
      HeaderIssue[KEY] = '"' .. GetIssueData[KEY].name .. '"'
    elseif KEY == 'labels' or KEY == 'assignees' then
      local LIST = '' --- get name label
      for _, Val in pairs(GetIssueData[KEY]) do
        LIST = LIST .. '[' .. Val.name .. ']' .. ','
      end
      HeaderIssue[KEY] = '"' .. LIST .. '"'
    elseif KEY == 'title' then
      HeaderIssue[KEY] = '"' .. GetIssueData[KEY] .. '"'
    else
      HeaderIssue[KEY] = VAL
    end
  end
  HeaderIssue.body = nil
  local HEADER_ISSUE = require('nvim-muryp-git.utils.tableToString').serializeTable(HeaderIssue)
  local HEADER_ISSUE_DEL_SPC = string.gsub(string.gsub(HEADER_ISSUE, '\n ', '\n'), '^ ', '')
  return HEADER_ISSUE_DEL_SPC
end
