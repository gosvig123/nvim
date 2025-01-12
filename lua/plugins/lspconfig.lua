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
            },
          },
        },
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
            workingDirectory = { mode = "location" },
            quiet = false,
            onIgnoredFiles = "warn",
            problems = {
              shortenToSingleLine = false
            },
            validate = "on",
            rulesCustomizations = {
              {
                rule = "*",
                severity = "warn"
              }
            }
          },
          handlers = {
            ["window/showMessageRequest"] = function(_, result)
              return result
            end
          }
        },
        pylsp = {
          enabled = false,
          autostart = false,
          settings = {
            pylsp = {
              enabled = false,
              plugins = {
                all = {
                  enabled = false
                }
              }
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
                insertSpaceAfterKeywordsInControlFlowStatements = true,
                insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
                insertSpaceBeforeFunctionParenthesis = false,
                insertSpaceAfterCommaDelimiter = true,
                insertSpaceAfterSemicolonInForStatements = true,
                insertSpaceBeforeAndAfterBinaryOperators = true,
              },
              preferences = {
                quoteStyle = "single",
                importModuleSpecifierPreference = "shortest",
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
            ["$/progress"] = function() end,
          },
        },
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore"
              },
              completion = {
                completePropertyWithSemicolon = true,
                triggerPropertyValueCompletion = true
              },
              format = {
                enable = true,
                newlineBetweenSelectors = true,
                newlineBetweenRules = true,
                spaceAroundSelectorSeparator = true
              }
            }
          }
        },
        stylelint_lsp = {
          settings = {
            stylelintplus = {
              enable = true,
              validateOnType = true,
              validateOnSave = true,
              autoFixOnFormat = true,
              configFile = ".stylelintrc"
            }
          }
        }
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
