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
        -- Cooler, more sophisticated background colors
        colors.bg = "#0c0d16"        -- Slightly darker, bluer background
        colors.bg_dark = "#090a12"   -- Darker background with blue undertone
        colors.bg_float = "#0f1019"  -- Floating windows
        colors.bg_popup = "#0f1019"  -- Popups
        colors.bg_sidebar = "#090a12" -- Sidebar

        -- Refined, cold-themed accent colors
        colors.blue = "#79b8ff"      -- Softer, ice blue
        colors.cyan = "#56d4dd"      -- Muted cyan
        colors.purple = "#b4a5ff"    -- Softer purple
        colors.magenta = "#79b8ff"   -- Replaced with ice blue (was pink)
        colors.green = "#7ee2b8"     -- Softer, mint green
        colors.teal = "#68c7ba"      -- Muted teal
        colors.comment = "#506178"   -- Keeping good comment visibility

        -- Refined UI elements
        colors.border = "#1a1c2a"    -- Subtler border
        colors.fg_gutter = "#363b47" -- More sophisticated gutter
        colors.unused = "#8b8fa3"    -- Softer unused

        -- Enhanced indent and structure colors
        colors.bg_highlight = "#161827"  -- Stronger highlight for active sections
        colors.fg_gutter = "#404557"     -- More visible gutter
        colors.border = "#202334"        -- Stronger borders for better structure
      end,
      on_highlights = function(hl, c)
        -- Refined semantic highlighting
        hl.Type = { fg = c.blue, italic = true }
        hl.Function = { fg = "#68a5ff", bold = true }  -- Ice blue for functions
        hl.Keyword = { fg = c.purple, italic = true }
        hl.Constant = { fg = "#e0af68" }  -- Warmer orange for contrast
        hl.String = { fg = c.green }
        hl.Variable = { fg = c.cyan }

        -- Matching treesitter highlights
        hl["@function"] = { fg = "#68a5ff", bold = true }  -- Ice blue for functions
        hl["@variable"] = { fg = c.cyan }
        hl["@keyword"] = { fg = c.purple, italic = true }
        hl["@type"] = { fg = c.blue, italic = true }
        hl["@property"] = { fg = "#68c7ba" }  -- Softer teal
        hl["@parameter"] = { fg = "#d8dee9" }  -- Softer white

        -- Enhanced UI elements
        hl.LineNr = { fg = "#404557" }        -- More subtle line numbers
        hl.CursorLine = { bg = "#111219" }    -- Slightly bluer cursor line
        hl.Visual = { bg = "#1f2233" }        -- Cooler visual selection

        -- Refined diagnostic colors
        hl.DiagnosticError = { fg = "#ff616e" }  -- Less harsh red
        hl.DiagnosticWarn = { fg = "#e0af68" }   -- Warmer orange
        hl.DiagnosticInfo = { fg = "#79b8ff" }   -- Ice blue
        hl.DiagnosticHint = { fg = "#68c7ba" }   -- Muted teal

        -- Sophisticated cursor line
        hl.CursorLine = {
          bg = "#111219",
          sp = "#68a5ff",    -- Ice blue underline
          underline = true,
          bold = true,
        }

        -- Matching cursor line number
        hl.CursorLineNr = {
          fg = "#68a5ff",    -- Ice blue
          bg = "#111219",
          bold = true,
          italic = true,
        }

        -- Clear comments
        hl.Comment = { fg = "#506178", italic = true }

        -- Subtle inlay hints
        hl.LspInlayHint = { fg = "#5a6377", italic = true }
        hl.InlayHint = { fg = "#5a6377", italic = true }

        -- Enhanced indentation and scope highlighting
        hl.IndentBlanklineChar = { fg = "#2a2f44" }        -- Darker indent lines
        hl.IndentBlanklineContextChar = { fg = "#445166" }  -- Brighter context indent
        hl.IndentBlanklineContextStart = {
          sp = "#445166",
          underline = true
        }

        -- Improved semantic token highlighting
        hl["@variable.builtin"] = { fg = "#79b8ff", italic = true }  -- Built-in variables
        hl["@constructor"] = { fg = "#b4a5ff", bold = true }         -- Constructors
        hl["@field"] = { fg = "#68c7ba" }                           -- Object fields
        hl["@method"] = { fg = "#68a5ff", bold = true }             -- Methods
        hl["@namespace"] = { fg = "#7ee2b8", bold = true }          -- Namespaces
        hl["@operator"] = { fg = "#b4a5ff" }                        -- Operators
        hl["@parameter"] = { fg = "#e0e4ef" }                       -- Parameters (brighter)
        hl["@string.special"] = { fg = "#e0af68" }                  -- Special strings

        -- Enhanced scope highlighting
        hl.MatchParen = {
          fg = "#79b8ff",
          bold = true,
          underline = true
        }

        -- Improved active line highlighting
        hl.CursorLine = {
          bg = "#131520",
          sp = "#68a5ff",
          underline = true,
        }

        -- Better visual selection
        hl.Visual = {
          bg = "#232742",  -- More noticeable but still elegant
          bold = true
        }

        -- Enhanced fold highlighting
        hl.Folded = {
          fg = "#68a5ff",
          bg = "#161827",
          italic = true
        }
        hl.FoldColumn = { fg = "#445166" }

        -- Enhanced git sign colors
        hl.GitSignsAdd = { fg = "#4fd6be" }        -- Bright cyan-green for additions
        hl.GitSignsChange = { fg = "#ffc777" }     -- Warm yellow for changes
        hl.GitSignsDelete = { fg = "#ff757f" }     -- Soft red for deletions
        hl.GitSignsUntracked = { fg = "#4fd6be" }  -- Same as add for untracked

        -- Line number highlights for git changes
        hl.GitSignsAddNr = { fg = "#4fd6be" }
        hl.GitSignsChangeNr = { fg = "#ffc777" }
        hl.GitSignsDeleteNr = { fg = "#ff757f" }
        hl.GitSignsUntrackedNr = { fg = "#4fd6be" }
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