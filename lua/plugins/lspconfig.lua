return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = true,
        virtual_text = {
          spacing = 4,
          prefix = "●",
        },
        severity_sort = true,
      },
      inlay_hints = {
        enabled = true,
      },
      capabilities = {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true,
              commitCharactersSupport = true,
              deprecatedSupport = true,
              preselectSupport = true,
            }
          }
        }
      },
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
        eslint = {
          settings = {
            format = {
              enable = true,
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
                includeInlayEnumMemberValueHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
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
                  classVariableTypes = true,
                  variableTypes = true,
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
      format = {
        formatting_options = nil,
        timeout_ms = 3000,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    },
  },
}
