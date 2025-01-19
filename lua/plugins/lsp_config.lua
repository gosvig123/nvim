return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
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
