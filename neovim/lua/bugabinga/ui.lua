local want = require'std.want'
local display = require'std.display'

return want{
  'nui.popup',
  'nui.text',
  'nui.line',
}(
  function(
    NuiPopup,
    NuiText,
    NuiLine
  )
    local get_nui_popup = function()
      local popup =  NuiPopup{
        relative = 'editor',
        focusable = true,
        position= '50%',
        enter = true,
        size = {
          width = '69%',
          height = '42%',
        },
        border = {
          style = vim.g.border_style,
        },
        buf_options = {
          modifiable = true,
          readonly = false,
        }
      }
      popup:map("n", "q", function() popup:unmount() end, { noremap = true })
      return popup
    end

    return {
      show_tree = function(tree)
        local popup = get_nui_popup()
        local bufnr = popup.bufnr
        local text, _ = display(tree)

        local line_number = 1
        for line in text:gmatch('[^\r\n]+') do
          local nui_line = NuiLine()
          nui_line:append(NuiText(line, 'NormalFloat'))
          nui_line:render(bufnr, -1, line_number)
          line_number = line_number + 1
        end

        popup:mount()
      end,
    }
  end)
