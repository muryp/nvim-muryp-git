return function(arg)
  local GET_ISSUE_DATA_OBJ = arg.GET_ISSUE_DATA_OBJ
  local HEADER_ISSUE_OBJ = {}
  for key, v in pairs(GET_ISSUE_DATA_OBJ) do
    if key == 'author' then
      HEADER_ISSUE_OBJ[key] = '"' .. GET_ISSUE_DATA_OBJ[key].name .. '"'
    elseif key == 'labels' or key == 'assignees' then
      -- get name label
      local LIST = ''
      for _, val in pairs(GET_ISSUE_DATA_OBJ[key]) do
        LIST = LIST .. '[' .. val.name .. ']' .. ','
      end
      HEADER_ISSUE_OBJ[key] = '"' .. LIST .. '"'
    elseif key == 'title' then
      HEADER_ISSUE_OBJ[key] = '"' .. GET_ISSUE_DATA_OBJ[key] .. '"'
    else
      HEADER_ISSUE_OBJ[key] = v
    end
  end
  HEADER_ISSUE_OBJ.body = nil
  local HEADER_ISSUE_OBJ_TO_STR = require('nvim-muryp-git.utils.tableToString').serializeTable(HEADER_ISSUE_OBJ)
  local HEADER_ISSUE_STR_DEL_SPC = string.gsub(string.gsub(HEADER_ISSUE_OBJ_TO_STR, '\n ', '\n'), '^ ', '')
  return HEADER_ISSUE_STR_DEL_SPC
end
