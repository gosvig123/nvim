return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      capabilities = {
        textDocument = {
          inlayHint = {
            dynamicRegistration = true
          }
        }
      },
      setup = {
        ["*"] = function(server, opts)
          opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
            textDocument = {
              codeAction = { dynamicRegistration = true },
              documentHighlight = { dynamicRegistration = true },
              codeLens = { dynamicRegistration = true }
            }
          })

          opts.handlers = opts.handlers or {}
          opts.handlers["textDocument/semanticTokens/full"] = function(err, result, ctx, config)
            if vim.api.nvim_buf_is_valid(ctx.bufnr) then
              vim.lsp.semantic_tokens.on_full(err, result, ctx, config)
            end
          end
        end
      },
      servers = {
        tsserver = {
          suggest = {
            autoImports = true,
            completeFunctionCalls = true,
          },
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = {
                  enabled = "all"
                },
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = {
                  enabled = "all"
                },
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              },
            },
          },
        },
        pylyzer = {
          enabled = false,
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                autoimportCompletions = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
                useLibraryCodeForTypes = true,
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                  chainedCalls = true,
                  parameterNames = true,
                  parameterTypes = true,
                  argumentNames = true,
                  argumentTypes = true,
                  includeCallExpressions = true,
                  includeMemberExpressions = true,
                  genericTypes = true,
                  tupleTypes = true,
                  dictionaryTypes = true,
                  listTypes = true,
                  stringTypes = true,
                  unionTypes = true,
                  enumerationTypes = true,
                  structureTypes = true,
                  numberTypes = true,
                  booleanTypes = true,
                  anyTypes = true,
                  undefinedTypes = true,
                  nullTypes = true,
                  voidTypes = true,
                  objectTypes = true,
                  arrayTypes = true,
                  unknownTypes = true,
                  indexTypes = true,
                  recursiveTypes = true,
                  callableTypes = true,
                  selfParameterTypes = true,
                  callArgumentNames = true,
                  pytestParameters = true,
                },
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "warning",
                  reportMissingImports = "error",
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = true,
      format = {
        timeout_ms = 5000,
      },
      diagnostics = {
        virtual_text = {
          prefix = "●",
          spacing = 4,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
      }
    }
  }
}
