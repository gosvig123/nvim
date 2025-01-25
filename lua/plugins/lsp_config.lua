return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        ["*"] = function(server, opts)
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
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
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
                  geneicTypes = true,
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
                },
              },
            },
          },
        },
      },
    },
  },
}
