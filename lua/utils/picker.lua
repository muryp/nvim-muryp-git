return function(arg)
  local pickers = require "telescope.pickers"
  local previewers = require "telescope.previewers"
  local finders = require "telescope.finders"
  local actions = require "telescope.actions"
  local conf = require("telescope.config").values
  local action_state = require "telescope.actions.state"
  local callback = arg.callBack
  local opts = arg.opts
  local preview_arg = arg.isPreview
  local title = arg.title

  local showPreview
  if preview_arg == true then
    showPreview = previewers.new_termopen_previewer {
      get_command = function(entry)
        local tmp_table = vim.split(entry.value, "\t")
        if vim.tbl_isempty(tmp_table) then
          return { "echo", "" }
        end
        return { "gh", "issue", "view", tmp_table[1] }
      end,
    }
  else
    showPreview = false
  end
  pickers.new({}, {
    prompt_title = title,
    finder = finders.new_table {
      results = opts
    },
    attach_mappings = function(prompt_bufnr, _)
      -- modifying what happens on selection with <CR>
      actions.select_default:replace(function()
        -- closing picker
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        callback(selection)
        -- do stuff
      end)
      -- keep default keybindings
      return true
    end,
    previewer = showPreview,
    sorter = conf.generic_sorter({}),
  }):find()
end
