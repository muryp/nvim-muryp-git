---@param Arg {callBack:function,opts:Object,PREVIEW_OPTS:string,title:string,DIR_ISSUE:string}
---@return nil : Telescope custom list
return function(Arg)
  local pickers      = require "telescope.pickers"
  local previewers   = require "telescope.previewers"
  local finders      = require "telescope.finders"
  local actions      = require "telescope.actions"
  local conf         = require("telescope.config").values
  local action_state = require "telescope.actions.state"
  local callBack     = Arg.callBack ---if user select/enter
  local Opts         = Arg.opts ---list opts for choose
  local PREVIEW_ARG  = Arg.PREVIEW_OPTS ---what preview use it
  local TITLE        = Arg.title ---title for telescope
  local DIR_ISSUE    = Arg.DIR_ISSUE

  local showPreview
  if PREVIEW_ARG == 'GH_ISSUE' then
    showPreview = previewers.new_termopen_previewer {
      get_command = function(entry)
        local TmpTable = vim.split(entry.value, "\t")
        if vim.tbl_isempty(TmpTable) then
          return { "echo", "" }
        end
        return { "gh", "issue", "view", TmpTable[1] }
      end,
    }
  else
    showPreview = previewers.new_termopen_previewer {
      get_command = function(entry)
        return { "bat", "--pager", "less -RS", DIR_ISSUE .. '/' .. entry.value }
      end,
    }
  end
  pickers.new({}, {
    prompt_title = TITLE,
    finder = finders.new_table {
      results = Opts
    },
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local MultiSelect = action_state.get_current_picker(prompt_bufnr)._multi._entries
        actions.close(prompt_bufnr)
        local UserSelect = {}
        local TABLE_LENG = 0
        for key, _ in pairs(MultiSelect) do
          table.insert(UserSelect, key[1])
          TABLE_LENG = TABLE_LENG + 1
        end
        ---@return string|string[]
        local singleSelect = function()
          if TABLE_LENG == 0 then
            return action_state.get_selected_entry()[1]
          end
          return UserSelect
        end
        callBack(singleSelect())
      end)
      -- keep default keybindings
      return true
    end,
    previewer = showPreview,
    sorter = conf.generic_sorter({}),
  }):find()
end
