local ih = require("inlay-hints")
local InlayHintKind = ih.kind

local M = {}

local function clear_ns(ns, bufnr)
  -- clear namespace which clears the virtual text as well
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

function M.render_line(line, line_hints, bufnr, ns)
  local opts = ih.config.options.eol or {}

  local virt_text = ""

  local type_hints = {}
  local param_hints = {}

  -- segregate paramter hints and other hints
  for _, hint in ipairs(line_hints) do
    if hint.kind == InlayHintKind.Type then
      table.insert(type_hints, hint)
    elseif hint.kind == InlayHintKind.Parameter then
      table.insert(param_hints, hint)
    end
  end

  -- show parameter hints inside brackets with commas and a thin arrow
  if not vim.tbl_isempty(param_hints) and opts.show_parameter_hints then
    for i, hint in ipairs(param_hints) do
      virt_text = virt_text .. hint.label
      if i ~= #param_hints then
        virt_text = virt_text .. ", "
      end
    end
  end

  -- show other hints with commas and a thicc arrow
  if not vim.tbl_isempty(type_hints) then
    for i, hint in ipairs(type_hints) do
        virt_text = virt_text .. hint.label

      if i ~= #type_hints then
        virt_text = virt_text .. ", "
      end
    end
  end

  if virt_text ~= "" then
    vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
      virt_text_pos = opts.right_align and "right_align" or "eol",
      virt_text = {
        { virt_text, opts.highlight },
      },
      hl_mode = "combine",
    })
  end
end

function M.render(bufnr, ns, hints)
  clear_ns(ns, bufnr)

  for line, line_hints in pairs(hints) do
    M.render_line(line, line_hints, bufnr, ns)
  end
end

return M
