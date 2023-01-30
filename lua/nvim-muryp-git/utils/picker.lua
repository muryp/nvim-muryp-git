return function(arg)
  local pickers      = require "telescope.pickers"
  local previewers   = require "telescope.previewers"
  local finders      = require "telescope.finders"
  local actions      = require "telescope.actions"
  local conf         = require("telescope.config").values
  local action_state = require "telescope.actions.state"
  local callback     = arg.callBack
  local opts         = arg.opts
  local preview_arg  = arg.PREVIEW_OPTS
  local title        = arg.title
  local DIR_ISSUE    = arg.DIR_ISSUE

  local showPreview
  if preview_arg == 'GH_ISSUE' then
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
    showPreview = previewers.new_termopen_previewer {
      get_command = function(entry)
        return { "bat","--pager", "less -RS", DIR_ISSUE .. '/' .. entry.value }
        -- return { "less","-RS",  DIR_ISSUE .. '/' .. entry.value }
      end,
    }
  end
  pickers.new({}, {
    prompt_title = title,
    finder = finders.new_table {
      results = opts
    },
    attach_mappings = function(prompt_bufnr, _)
      -- modifying what happens on selection with <CR>
      actions.select_default:replace(function()
        local MULTI_SELECT = action_state.get_current_picker(prompt_bufnr)._multi._entries
        actions.close(prompt_bufnr)
        local SELECTION_TABLE = {}
        local TABLE_LENG = 0
        for key, _ in pairs(MULTI_SELECT) do
          table.insert(SELECTION_TABLE, key[1])
          TABLE_LENG = TABLE_LENG + 1
        end
        local selection = function()
          if TABLE_LENG == 0 then
            return action_state.get_selected_entry()[1]
          end
          return SELECTION_TABLE
        end
        callback(selection())
      end)
      -- keep default keybindings
      return true
    end,
    previewer = showPreview,
    sorter = conf.generic_sorter({}),
  }):find()
end
