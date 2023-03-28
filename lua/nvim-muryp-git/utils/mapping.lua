---@diagnostic disable: duplicate-doc-field, duplicate-doc-alias
---@class opts
---@field silent boolean
---@field noremap boolean
---@field nowait boolean
--
---@class optsWK:opts
---@field mode string|string[]
---@field buffer number|nil
---@field prefix string The prefix to be added to the argument

---@alias cmd string
---@alias description string
--
---@class data:optsWK
---@field[1] cmd
---@field[2] description
--
---@param mappings table<string, data|string|table<string, data|string>>
---@param opts optsWK The argument to be processed
local function normalMap(mappings, opts)
  ---@class childern
  ---@field[1] data
  ---@field[2] {prefix:string}
  ---@type childern
  local childern = {}
  for key, mapping in pairs(mappings) do
    -- exclude name key
    if key ~= 'name' then
      ---@type string|string[]
      local mode
      -- cek is mode nil
      if mapping.mode == nil or opts.mode == nil then
        mode = { 'n', 'v' }
      else
        mode = mapping.mode or opts.mode
      end
      ---@type opts options for for how map execute
      local opts2 = {}
      local isNowait = mapping.nowait or opts.nowait
      if isNowait ~= nil and type(isNowait) == "boolean" then
        opts2.nowait = isNowait
      end
      local isNoremap = mapping.noremap or opts.noremap
      if isNoremap ~= nil and type(isNoremap) == "boolean" then
        opts2.noremap = isNoremap
      end
      local isSilent = mapping.silent or opts.silent
      if isSilent ~= nil and type(isSilent) == "boolean" then
        opts2.silent = isSilent
      end
      --end opts
      -- cek is have childern
      if mapping.name == nil then
        vim.keymap.set(mode, opts.prefix .. key, mapping[1], opts2)
      else
        table.insert(childern, { mapping, opts.prefix .. key })
      end
    end
  end
  -- exec childern
  for _, mapping in ipairs(childern) do
    local opts2 = opts
    opts2.prefix = mapping[2]
    normalMap(mapping[1], opts2)
  end
end
---Function to do something with a given argument
---@param mappings table<string, data>|{name:string}
---@param opts optsWK The argument to be processed
return function(mappings, opts)
  local isWk, wk = pcall(require, 'which-key')
  -- cek is whiki installed
  if isWk then
    wk.register(mappings, opts)
    wk.setup()
  else
    normalMap(mappings, opts)
  end
end
