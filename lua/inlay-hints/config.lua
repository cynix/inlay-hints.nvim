local M = {}

local defaults = {
  -- renderer to use
  renderer = "inlay-hints/render/dynamic",

  hints = {
    parameter = {
      show = true,
      highlight = "Comment",
    },
    type = {
      show = true,
      highlight = "Comment",
    },
  },

  -- Only show inlay hints for the current line
  only_current_line = false,

  eol = {
    -- whether to align to the extreme right or not
    right_align = false,

    -- padding from the right if right_align is true
    right_align_padding = 7,
  },
}

M.options = {}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

return M
