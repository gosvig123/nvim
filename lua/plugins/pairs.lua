return {
  'echasnovski/mini.pairs',
  event = "VeryLazy",
  config = function()
    require('mini.pairs').setup({
      -- In addition to default pairs, add JSX specific pairs
      pairs = {
        { '(', ')' },
        { '[', ']' },
        { '{', '}' },
        { '"', '"' },
        { "'", "'" },
        { '`', '`' },
        { '<', '>' },
      },
      modes = {
        insert = true,
        command = false,
        terminal = false,
      },
      -- Don't auto-close if there's a alphanumeric character after cursor
      neigh_pattern = '[%w%.]',
      -- Disable specific mappings
      mappings = {
        ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
        ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
        ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
        ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].' },
        ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^\\].' },
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].' },
      },
    })
  end,
}