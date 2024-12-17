return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      -- Enable more semantic token highlights
      semantic_tokens = true,
      styles = {
        -- Style for semantic tokens with ice-themed modifications
        types = { italic = true },
        keywords = { italic = true },
        functions = { bold = true },
        variables = {},
        comments = { italic = true },
      },
      -- Ice-themed color modifications
      on_colors = function(colors)
        -- Cooler background colors
        colors.bg = "#1a1b26"
        colors.bg_dark = "#16161e"
        colors.bg_float = "#1e1e2e"
        colors.bg_popup = "#1e1e2e"
        colors.bg_sidebar = "#16161e"

        -- Ice-themed accent colors
        colors.blue = "#89b4fa"    -- Lighter, ice blue
        colors.cyan = "#89dceb"    -- Ice cyan
        colors.purple = "#b4befe"  -- Soft lavender
        colors.magenta = "#cba6f7" -- Soft purple
        colors.green = "#a6e3a1"   -- Mint green
        colors.teal = "#94e2d5"    -- Ice teal

        -- Softer UI elements
        colors.border = "#313244"
        colors.comment = "#9399b2"
        colors.fg_gutter = "#45475a"
      end,
      on_highlights = function(hl, c)
        -- Enhanced semantic highlighting with ice colors
        hl.Type = { fg = c.blue, italic = true }
        hl.Function = { fg = c.magenta, bold = true }
        hl.Keyword = { fg = c.purple, italic = true }
        hl.Constant = { fg = "#fab387" }  -- Soft orange
        hl.String = { fg = c.green }
        hl.Variable = { fg = c.cyan }

        -- Enhance treesitter highlights
        hl["@variable"] = { fg = c.cyan }
        hl["@function"] = { fg = c.magenta, bold = true }
        hl["@keyword"] = { fg = c.purple, italic = true }
        hl["@type"] = { fg = c.blue, italic = true }
        hl["@property"] = { fg = c.teal }
        hl["@parameter"] = { fg = "#cdd6f4" }  -- Soft white

        -- UI element highlights
        hl.LineNr = { fg = "#585b70" }
        hl.CursorLine = { bg = "#1e1e2e" }
        hl.CursorLineNr = { fg = "#cdd6f4" }
        hl.Visual = { bg = "#313244" }

        -- Diagnostic colors
        hl.DiagnosticError = { fg = "#f38ba8" }  -- Soft red
        hl.DiagnosticWarn = { fg = "#fab387" }   -- Soft orange
        hl.DiagnosticInfo = { fg = "#89b4fa" }   -- Ice blue
        hl.DiagnosticHint = { fg = "#94e2d5" }   -- Ice teal
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}