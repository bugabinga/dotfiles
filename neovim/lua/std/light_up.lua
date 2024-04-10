local _ = {}

--- Highlights given words in a buffer.
--- Word matching is case sensitive.
--- @param bufnr number Number of buffer to highlight. If 0, current buffer is used.
--- @param words table Word to highlight group name mapping. Every occurrence with keys in this table, will be
--- highlighted with its mapped value, which is expected to be a highlight group name.
_.buffer = function ( bufnr, words )
  vim.validate {
    bufnr = { bufnr, 'number', },
    words = { words, 'table', },
  }

  local namespace = vim.api.nvim_create_namespace 'light_up_ns'
  vim.api.nvim_buf_clear_namespace( bufnr, namespace, 0, -1 )

  local handler = function ( event, buffer_handle, tick, first_line, last_line_changed, last_line_updated, bytes )
    -- vim.print( event, buffer_handle, tick, first_line, last_line_changed, last_line_updated, bytes )
    assert( event == 'lines', 'this handler is for `on_lines` notification' )

    local last = math.max( last_line_updated, last_line_changed )
    local lines = vim.api.nvim_buf_get_lines( bufnr, first_line, last, true )
    --NOTE: dubbel loop. can we faster?
    for index, line in ipairs( lines ) do
      local current_line = first_line + index - 1 -- adjust for 0-based indexing
      for word, highlight_group in pairs( words ) do
        -- NOTE: the way find is used here, we can only ever match one word per line
        -- vim.print( 'looking for word ', word, line )
        local start_offset, end_offset = line:find( '[%s%.](' .. word .. ')[%s$]' )
        if start_offset then
          -- vim.print( 'marking line ' .. current_line, start_offset, end_offset, highlight_group )
          vim.api.nvim_buf_set_extmark( bufnr, namespace, current_line, start_offset, {
            end_col = end_offset - 1,
            hl_group = highlight_group,
          } )
          break
        end
      end
    end
  end

  local ok = vim.api.nvim_buf_attach( bufnr, false, { on_lines = handler, } )
  if not ok then error( 'unable to attach to buffer ' .. bufnr ) end

  -- initial scan of whole buffer
  handler( 'lines', bufnr, nil, 0, -1, -1, nil )
end

--- @return table groups A map of all highlight group names, mapping to themselves g:match('^([%w@%._]+)%s').
_.get_vim_highlight_groups = function ()
  local groups = {}

  local highlight_command_output = vim.fn.execute 'highlight'
  for line in highlight_command_output:gmatch '[^\n]+' do
    -- Delimiter      xxx guifg=#727272
    -- @punctuation.special xxx links to Special
    -- Match anything that could be a valid highlight name
    local match = line:match '^([%w@%._]+)%s'
    if match then groups[match] = match end
  end

  return groups
end

return _
