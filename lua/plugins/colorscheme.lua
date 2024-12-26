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
        colors.comment = "#768390" -- Brighter comment color for better readability

        -- Softer UI elements
        colors.border = "#313244"
        colors.fg_gutter = "#45475a"

        -- Add a new color for unused components
        colors.unused = "#959cbd"  -- More visible gray with slight blue tint
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

        -- Enhanced active line highlighting
        hl.CursorLine = {
          bg = "#232433",
          sp = "#7dcfff",  -- Add a border color
          underline = true,
          bold = true,
        }

        -- Make the line number stand out more
        hl.CursorLineNr = {
          fg = "#7dcfff",
          bg = "#232433",
          bold = true,
          italic = true,
        }

        -- Add a sign column indicator
        hl.CursorLineSign = {
          bg = "#232433",
          sp = "#7dcfff",
          underline = true
        }

        -- Add a right border indicator
        hl.CursorColumn = {
          bg = "#232433",
        }

        -- Enhance the color of text on the current line
        hl.CursorLineFold = {
          fg = "#7dcfff",
          bold = true,
        }

        -- Add new highlights for unused variables and components
        hl["@variable.unused"] = { fg = c.unused, italic = true }
        hl["@parameter.unused"] = { fg = c.unused, italic = true }
        hl["@function.unused"] = { fg = c.unused, italic = true }
        hl["@method.unused"] = { fg = c.unused, italic = true }

        -- Make diagnostic hints more visible
        hl.DiagnosticHint = { fg = c.unused }
        hl.DiagnosticUnnecessary = { fg = c.unused }

        -- Enhance comment visibility
        hl.Comment = { fg = c.comment, italic = true }

        -- Add inlay hint highlighting
        hl.LspInlayHint = { fg = "#565f89", italic = true }
        hl.InlayHint = { fg = "#565f89", italic = true }
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