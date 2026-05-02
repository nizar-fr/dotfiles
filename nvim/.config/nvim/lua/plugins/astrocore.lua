-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        ["<C-a>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<C-d>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        ["<Leader>pp"] = { "<cmd> Soil<CR>" },
        ["<C-s>"] = { ":w!<cr>", desc = "Save File" },
        ["<S-l>"] = { "<cmd> LiveServerStart<CR>" },
        ["<S-L>"] = { "<cmd> LiveServerStop<CR>" },
        ["gl"] = { "<cmd>lua vim.diagnostic.open_float()<CR>" },

        ["<C-z>"] = { "u", desc = "" },
        ["<S-Down>"] = { "<cmd>t.<cr>", desc = "" },
        ["<M-Down>"] = { "<cmd>m+<cr>", desc = "" },
        ["<S-Up>"] = { "<cmd>t -1<cr>", desc = "" },
        ["<M-Up>"] = { "<cmd>m-2<cr>", desc = "" },
        ["<leader>mx"] = { "<cmd> MarkdownPreview<CR>", desc = "Open Markdown in Browser" },
        ["<S-q>"] = { "<cmd> TSToggle highlight<CR>", desc = "Disable Treesitter Highlight" , noremap = true},
        ["<leader>rr"] = { "<cmd> Rest run<CR>", desc = "Run REST API Client" },
        ["<leader>ro"] = { "<cmd> Rest open<CR>", desc = "Open REST API Client" },
        ["<leader>rc"] = { "<cmd> Rest cookies<CR>", desc = "Open REST Cookies" },
        ["<leader>re"] = { "<cmd> Rest env<CR>", desc = "Open .env" },
        ["<leader>rl"] = { "<cmd> Rest logs<CR>", desc = "Open REST API Log" },
        ["<S-r>"] = { "<cmd> AerialToggle<CR>", desc = "Symbol Outline toogle" }, 
        ["<S-e>"] = { "<cmd> Neotree toggle<CR>", desc = "Toggle NeoTree" , noremap = true},
        ["<leader>rs"] = { "<cmd> RustAnalyzer stop<CR>", desc = "Stop RustAnalyzer" , noremap = true},
        -- ["<S-w>"] = { "<cmd> set wrap<CR>", desc = "Toggle Word Wrap" },
        -- ["S-e"] = {"<cmd> set nowrap<CR>", desc = "Toggle Word Wrap" },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
      i = {
        ["<C-z>"] = { "u", desc = "" },
        ["<C-x>"] = { "<BS>", desc = "" },
      },
    },
  },
}
