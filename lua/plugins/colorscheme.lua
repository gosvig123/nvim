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
        -- Darker background colors
        colors.bg = "#0a0b12"        -- Darker main background
        colors.bg_dark = "#070810"   -- Even darker background
        colors.bg_float = "#0d0e16"  -- Darker float background
        colors.bg_popup = "#0d0e16"  -- Darker popup background
        colors.bg_sidebar = "#070810" -- Darker sidebar

        -- Higher contrast accent colors
        colors.blue = "#89d1fa"      -- Brighter blue
        colors.cyan = "#7aecff"      -- Brighter cyan
        colors.purple = "#c8b3ff"    -- Brighter purple
        colors.magenta = "#ff92f0"   -- Brighter magenta
        colors.green = "#95ffa4"     -- Brighter green
        colors.teal = "#92ffe1"      -- Brighter teal
        colors.comment = "#506178"   -- More visible comments

        -- Higher contrast UI elements
        colors.border = "#1f2133"
        colors.fg_gutter = "#3b3d57"
        colors.unused = "#959cbd"
      end,
      on_highlights = function(hl, c)
        -- Enhanced semantic highlighting with higher contrast
        hl.Type = { fg = c.blue, italic = true }
        hl.Function = { fg = c.magenta, bold = true }
        hl.Keyword = { fg = c.purple, italic = true }
        hl.Constant = { fg = "#ffb387" }  -- Brighter orange
        hl.String = { fg = c.green }
        hl.Variable = { fg = c.cyan }

        -- Enhanced treesitter highlights
        hl["@variable"] = { fg = c.cyan }
        hl["@function"] = { fg = c.magenta, bold = true }
        hl["@keyword"] = { fg = c.purple, italic = true }
        hl["@type"] = { fg = c.blue, italic = true }
        hl["@property"] = { fg = c.teal }
        hl["@parameter"] = { fg = "#e6eaf4" }  -- Brighter white

        -- UI element highlights with more contrast
        hl.LineNr = { fg = "#4a4d6a" }
        hl.CursorLine = { bg = "#131520" }
        hl.CursorLineNr = { fg = "#e6eaf4" }
        hl.Visual = { bg = "#252842" }

        -- Brighter diagnostic colors
        hl.DiagnosticError = { fg = "#ff7a93" }  -- Brighter red
        hl.DiagnosticWarn = { fg = "#ffb387" }   -- Brighter orange
        hl.DiagnosticInfo = { fg = "#89d1fa" }   -- Brighter blue
        hl.DiagnosticHint = { fg = "#92ffe1" }   -- Brighter teal

        -- Enhanced active line highlighting
        hl.CursorLine = {
          bg = "#131520",
          sp = "#7dcfff",
          underline = true,
          bold = true,
        }

        -- Brighter line number
        hl.CursorLineNr = {
          fg = "#7dcfff",
          bg = "#131520",
          bold = true,
          italic = true,
        }

        -- Enhanced comment visibility
        hl.Comment = { fg = c.comment, italic = true }

        -- Brighter inlay hints
        hl.LspInlayHint = { fg = "#6b7394", italic = true }
        hl.InlayHint = { fg = "#6b7394", italic = true }
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