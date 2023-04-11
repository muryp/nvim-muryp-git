---@param Arg {callBack:function,opts:Object,PREVIEW_OPTS:string,title:string,DIR_ISSUE:string}
---@return nil : Telescope custom list
return function(Arg)
  local pickers      = require "telescope.pickers"
  local previewers   = require "telescope.previewers"
  local finders      = require "telescope.finders"
  local actions      = require "telescope.actions"
  local conf         = require("telescope.config").values
  local action_state = require "telescope.actions.state"
  local callBack     = Arg.callBack     ---if user select/enter
  local Opts         = Arg.opts         ---list opts for choose
  local PREVIEW_ARG  = Arg.PREVIEW_OPTS ---what preview use it
  local TITLE        = Arg.title        ---title for telescope
  local DIR_ISSUE    = Arg.DIR_ISSUE

  -- Fungsi untuk mengaktifkan highlight sintaksis Markdown
  local function enable_markdown_highlight(bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'filetype', 'markdown')
    vim.api.nvim_command('runtime! syntax/markdown.vim')
  end

  --- for content result by issue number
  local CONTENT_RESULT = {}
  local loadingCmd = function(index, bufnr)
    local timer = vim.loop.new_timer()
    timer:start(1000, 0,
      vim.schedule_wrap(function()
        if CONTENT_RESULT[index] == nil then
          ---chaching fetch from gh issue
          CONTENT_RESULT[index] = vim.split(vim.fn.system('gh issue view ' .. index), "\n")
        end
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, CONTENT_RESULT[index])
      end))
  end
  local showPreview
  if PREVIEW_ARG == 'GH_ISSUE' then
    showPreview = previewers.new_buffer_previewer {
      get_buffer_by_name = function(_, entry)
        return entry.filename
      end,
      define_preview = function(self, entry)
        local bufnr = self.state.bufnr
        local index = vim.split(entry.value, "\t")[1]
        enable_markdown_highlight(bufnr)
        -- add loading text if content will not generate now
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'loading...' })

        if CONTENT_RESULT[index] == nil then
          loadingCmd(index, bufnr)
          return
        end
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, CONTENT_RESULT[index])
      end
    }
  else
    showPreview = previewers.new_buffer_previewer {
      get_buffer_by_name = function(_, entry)
        return entry.filename
      end,
      define_preview = function(self, entry)
        local bufnr = self.state.bufnr
        enable_markdown_highlight(bufnr)
        local filename = DIR_ISSUE .. '/' .. entry.value
        local content = {}
        for line in io.lines(filename) do
          table.insert(content,line)
        end
        -- add loading text if content will not generate now
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
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
