vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.cmd("set noshowmode")
vim.opt.laststatus = 0
vim.opt.ruler = false

require("conform").setup({
  formatters_by_ft = {
    elixir = { "mix" },
  },
})

require 'nvim-treesitter.configs'.setup {
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    additional_vim_regex_highlighting = false,
  },
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

require("nord").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  transparent = false,        -- Enable this to disable setting the background color
  terminal_colors = true,     -- Configure the colors used when opening a `:terminal` in Neovim
  diff = { mode = "bg" },     -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
  borders = true,             -- Enable the border between verticaly split windows visible
  errors = { mode = "bg" },   -- Display mode for errors and diagnostics
  -- values : [bg|fg|none]
  search = { theme = "vim" }, -- theme for highlighting search results
  -- values : [vim|vscode]
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = {},
    functions = {},
    variables = {},

    -- To customize lualine/bufferline
    bufferline = {
      current = {},
      modified = { italic = true },
    },

    lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
  },

  -- colorblind mode
  -- see https://github.com/EdenEast/nightfox.nvim#colorblind
  -- simulation mode has not been implemented yet.
  colorblind = {
    enable = false,
    preserve_background = false,
    severity = {
      protan = 0.0,
      deutan = 0.0,
      tritan = 0.0,
    },
  },

  -- Override the default colors
  ---@param colors Nord.Palette
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with all highlights and the colorScheme table
  ---@param colors Nord.Palette
  on_highlights = function(highlights, colors) end,
})


require("tiny-inline-diagnostic").setup({
  -- Choose a preset style for diagnostic appearance
  -- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
  preset = "modern",

  -- Make diagnostic background transparent
  transparent_bg = false,

  -- Make cursorline background transparent for diagnostics
  transparent_cursorline = true,

  -- Customize highlight groups for colors
  -- Use Neovim highlight group names or hex colors like "#RRGGBB"
  hi = {
    error = "DiagnosticError", -- Highlight for error diagnostics
    warn = "DiagnosticWarn",   -- Highlight for warning diagnostics
    info = "DiagnosticInfo",   -- Highlight for info diagnostics
    hint = "DiagnosticHint",   -- Highlight for hint diagnostics
    arrow = "NonText",         -- Highlight for the arrow pointing to diagnostic
    background = "CursorLine", -- Background highlight for diagnostics
    mixing_color = "Normal",   -- Color to blend background with (or "None")
  },

  -- List of filetypes to disable the plugin for
  disabled_ft = {},

  options = {
    -- Display the source of diagnostics (e.g., "lua_ls", "pyright")
    show_source = {
      enabled = false, -- Enable showing source names
      if_many = false, -- Only show source if multiple sources exist for the same diagnostic
    },

    -- Display the diagnostic code of diagnostics (e.g., "F401", "no-dupe-args")
    show_code = true,

    -- Use icons from vim.diagnostic.config instead of preset icons
    use_icons_from_diagnostic = false,

    -- Color the arrow to match the severity of the first diagnostic
    set_arrow_to_diag_color = false,


    -- Throttle update frequency in milliseconds to improve performance
    -- Higher values reduce CPU usage but may feel less responsive
    -- Set to 0 for immediate updates (may cause lag on slow systems)
    throttle = 20,

    -- Minimum number of characters before wrapping long messages
    softwrap = 30,

    -- Control how diagnostic messages are displayed
    -- NOTE: When using display_count = true, you need to enable multiline diagnostics with multilines.enabled = true
    --       If you want them to always be displayed, you can also set multilines.always_show = true.
    add_messages = {
      messages = true,             -- Show full diagnostic messages
      display_count = false,       -- Show diagnostic count instead of messages when cursor not on line
      use_max_severity = false,    -- When counting, only show the most severe diagnostic
      show_multiple_glyphs = true, -- Show multiple icons for multiple diagnostics of same severity
    },

    -- Settings for multiline diagnostics
    multilines = {
      enabled = false,          -- Enable support for multiline diagnostic messages
      always_show = false,      -- Always show messages on all lines of multiline diagnostics
      trim_whitespaces = false, -- Remove leading/trailing whitespace from each line
      tabstop = 4,              -- Number of spaces per tab when expanding tabs
      -- Restrict which severities are shown on non-cursor lines
      -- With always_show = true: listed severities stay visible on every line,
      -- all other severities only appear on the cursor line
      severity = nil, -- e.g. { vim.diagnostic.severity.ERROR }
    },

    -- Show all diagnostics on the current cursor line, not just those under the cursor
    show_all_diags_on_cursorline = false,

    -- Only show diagnostics when the cursor is directly over them, no fallback to line diagnostics
    show_diags_only_under_cursor = false,

    -- Display related diagnostics from LSP relatedInformation
    show_related = {
      enabled = true, -- Enable displaying related diagnostics
      max_count = 3,  -- Maximum number of related diagnostics to show per diagnostic
    },

    -- Enable diagnostics display in insert mode
    -- May cause visual artifacts; consider setting throttle to 0 if enabled
    enable_on_insert = false,

    -- Enable diagnostics display in select mode (e.g., during auto-completion)
    enable_on_select = false,

    -- Handle messages that exceed the window width
    overflow = {
      mode = "wrap", -- "wrap": split into lines, "none": no truncation, "oneline": keep single line
      padding = 0,   -- Extra characters to trigger wrapping earlier
    },

    -- Break long messages into separate lines
    break_line = {
      enabled = false, -- Enable automatic line breaking
      after = 30,      -- Number of characters before inserting a line break
    },

    -- Custom function to format diagnostic messages
    -- Receives diagnostic object, returns formatted string
    -- Example: function(diag) return diag.message .. " [" .. diag.source .. "]" end
    format = nil,

    -- Virtual text display priority
    -- Higher values appear above other plugins (e.g., GitBlame)
    virt_texts = {
      priority = 2048,
    },

    -- Filter diagnostics by severity levels
    -- Remove severities you don't want to display
    severity = {
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.INFO,
      vim.diagnostic.severity.HINT,
    },

    -- Events that trigger attaching diagnostics to buffers
    -- Default is {"LspAttach"}; change only if plugin doesn't work with your LSP setup
    overwrite_events = nil,

    -- Automatically disable diagnostics when opening diagnostic float windows
    override_open_float = false,

    -- Experimental options, subject to misbehave in future NeoVim releases
    experimental = {
      -- Make diagnostics not mirror across windows containing the same buffer
      -- See: https://github.com/rachartier/tiny-inline-diagnostic.nvim/issues/127
      use_window_local_extmarks = false,
    },
  },
})


require('mini.pairs').setup({
  -- In which modes mappings from this `config` should be created
  modes = { insert = true, command = false, terminal = false },

  -- Global mappings. Each right hand side should be a pair information, a
  -- table with at least these fields (see more in |MiniPairs.map|):
  -- - <action> - one of 'open', 'close', 'closeopen'.
  -- - <pair> - two character string for pair to be used.
  -- By default pair is not inserted after `\`, quotes are not recognized by
  -- <CR>, `'` does not insert the pair after a letter.
  -- Only parts of tables can be tweaked (others will use these defaults).
  mappings = {
    ['('] = { action = 'open', pair = '()', neigh_pattern = '^[^\\]' },
    ['['] = { action = 'open', pair = '[]', neigh_pattern = '^[^\\]' },
    ['{'] = { action = 'open', pair = '{}', neigh_pattern = '^[^\\]' },

    [')'] = { action = 'close', pair = '()', neigh_pattern = '^[^\\]' },
    [']'] = { action = 'close', pair = '[]', neigh_pattern = '^[^\\]' },
    ['}'] = { action = 'close', pair = '{}', neigh_pattern = '^[^\\]' },

    ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '^[^\\]', register = { cr = false } },
    ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '^[^%a\\]', register = { cr = false } },
    ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '^[^\\]', register = { cr = false } },
  },
})


require('gitsigns').setup {
  signs                        = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged                 = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged_enable          = true,
  signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    follow_files = true
  },
  auto_attach                  = true,
  attach_to_untracked          = false,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  blame_formatter              = nil, -- Use default
  sign_priority                = 6,
  update_debounce              = 100,
  status_formatter             = nil,   -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
}
