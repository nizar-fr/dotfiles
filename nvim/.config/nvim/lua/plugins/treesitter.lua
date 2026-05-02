-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "astro",
      "angular",
      "vue",
      "typescript",
      "rust",
      -- "htmlangular",
      -- add more arguments for adding more treesitter parsers
    },highlight = {
      -- enable = false,
      -- -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- -- Set this to `true` if you depend on 'syntax' being enabled (like for উদাহরণ color schemes)
      -- -- (if possible, switch to a colorscheme that uses highlights instead.)
      -- additional_vim_regex_highlighting = false,
    },
  },
  dependencies = { "OXY2DEV/markview.nvim" },
  lazy = false,
  branch = "feature-angular",
}
