return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Add semantic token support for each language server
        lua_ls = {
          settings = {
            Lua = {
              semantic = {
                enable = true,
                annotations = true,
                variables = true,
              },
            },
          },
        },
        tsserver = {
          settings = {
            typescript = {
              format = {
                indentSize = 2,
                convertTabsToSpaces = true,
                trimTrailingWhitespace = true,
                insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
                insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = true,
              },
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
            javascript = {
              format = {
                indentSize = 2,
                convertTabsToSpaces = true,
                trimTrailingWhitespace = true,
              },
            },
          },
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
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                  parameterTypes = true,
                },
              },
              formatting = {
                provider = "black",
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
