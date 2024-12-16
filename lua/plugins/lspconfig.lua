return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Configure TypeScript LSP
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              }
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              }
            }
          }
        },
        -- Python configuration
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                -- Disable reference notifications
                diagnosticSeverityOverrides = {
                  reportGeneralTypeIssues = "none",
                  reportOptionalMemberAccess = "none",
                },
              },
            },
          },
          -- Disable progress notifications
          handlers = {
            ["$/progress"] = function() end
          },
        },
      },
    },
  },
}