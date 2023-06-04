---@param Arg {ISSUE_NUMBER:number} : get issue number
---@return { title:string, body:string, state:string } : object all info about issue
return function(Arg)
  local LIST_INFO = {
    "title",
    "assignees",
    "author",
    "body",
    -- "closed",
    "closedAt",
    -- "comments",
    -- "createdAt",
    -- "id",
    "labels",
    "milestone",
    "number",
    -- "projectCards",
    -- "reactionGroups",
    "state",
    "title",
    "updatedAt",
    "url",
  }
  local LIST_INFO_JSON = {}
  for _, v in pairs(LIST_INFO) do
    table.insert(LIST_INFO_JSON, '--json ' .. v)
  end
  local LIST_INFO_CDM = "gh issue view " .. table.concat(LIST_INFO_JSON, ' ') .. ' ' .. Arg.ISSUE_NUMBER
  local GET_ISSUE_DATA_JSON = vim.fn.system(LIST_INFO_CDM)
  local IssueData = vim.fn.json_decode(GET_ISSUE_DATA_JSON)
  return IssueData
end
