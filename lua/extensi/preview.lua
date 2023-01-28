local previewers = require("telescope.previewers")

local _img = { ".*%.png", ".*%.jpg", ".*%.ico", } -- Put all filetypes that slow you down in this array
local img_files = function(filepath)
  for _, v in ipairs(_img) do
    if filepath:match(v) then
      return false
    end
  end
  local name_file = filepath:gsub("^.+/", "")
  local isRcFile = name_file:gsub(".+rc", "") == ""
  if name_file:match(".*%.(.+)") or isRcFile then
    return true
  end
  if filepath:match(".*/bin/.*") then
    return false
  end
  return true
end

local new_maker = function(filepath, bufnr, opts)
  if img_files(filepath) then
    previewers.buffer_previewer_maker(filepath, bufnr, opts)
  else
    require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "cannot be previewed")
  end
end

return new_maker
