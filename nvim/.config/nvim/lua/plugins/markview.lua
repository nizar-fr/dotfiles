if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "OXY2DEV/markview.nvim",

  dependencies = {
    -- You may not need this if you don't lazy load
    -- Or if the parsers are in your $RUNTIMEPATH
    -- "nvim-treesitter/nvim-treesitter",
    -- "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  priority = 49,
  opts = {
    markdown = {
      headings = {
        enable = true,

        --- Amount of character to shift per heading level
        ---@type integer
        shift_width = 1,
        heading_1 = {
          style = "label",

          --- Alignment of the heading.
          ---@type "left" | "center" | "right"
          align = "center",

          --- Primary highlight group. Used by other
          --- options that end with "_hl" when their
          --- values are nil.
          ---@type string
          hl = "MarkviewHeading1",

          --- Left corner, Added before the left padding
          ---@type string?
          corner_left = "",

          --- Left padding, Added before the icon
          ---@type string?
          padding_left = " ~ ",

          --- Right padding, Added after the heading text
          ---@type string?
          padding_right = " ~ ",

          --- Right corner, Added after the right padding
          ---@type string?
          corner_right = "",

          ---@type string?
          corner_left_hl = "MarkviewHeading1Sign",
          ---@type string?
          padding_left_hl = nil,

          ---@type string?
          padding_right_hl = nil,
          ---@type string?
          corner_right_hl = "MarkviewHeading1Sign",

          --- Text to show on the signcolumn.
          ---@type string?
          sign = "󰌕 ",

          --- Highlight group for the sign.
          ---@type string?
          sign_hl = "MarkviewHeading1Sign",

          --- Icon to show before the heading text.
          ---@type string?
          icon = "",

          --- Highlight group for the Icon.
          ---@type string?
          icon_hl = "MarkviewHeading1",
        },
        heading_2 = {
          style = "icon",

          --- Primary highlight group. Used by other
          --- options that end with "_hl" when their
          --- values are nil.
          ---@type string
          hl = "MarkviewHeading2",

          --- Character used to shift/indent the heading
          ---@type string
          shift_char = "",

          --- Highlight group for the "shift_char"
          ---@type string?
          shift_hl = "MarkviewHeading2Sign",

          --- Text to show on the signcolumn
          ---@type string?
          sign = "󰌕 ",

          --- Highlight group for the sign
          ---@type string?
          sign_hl = "MarkviewHeading2Sign",

          --- Icon to show before the heading text
          ---@type string?
          icon = "📙 ",

          --- Highlight group for the Icon
          ---@type string?
          icon_hl = "MarkviewHeading2",
          padding_right = " ",
        },
        heading_3 = {
          style = "label",

          --- Alignment of the heading.
          ---@type "left" | "center" | "right"
          align = "left",

          --- Primary highlight group. Used by other
          --- options that end with "_hl" when their
          --- values are nil.
          ---@type string
          hl = "MarkviewHeading3",

          --- Left corner, Added before the left padding
          ---@type string?
          corner_left = "",

          --- Left padding, Added before the icon
          ---@type string?
          padding_left = " ",

          --- Right padding, Added after the heading text
          ---@type string?
          padding_right = " ~ ",

          --- Right corner, Added after the right padding
          ---@type string?
          corner_right = "",

          ---@type string?
          corner_left_hl = "MarkviewHeading3Sign",
          ---@type string?
          padding_left_hl = nil,

          ---@type string?
          padding_right_hl = nil,
          ---@type string?
          corner_right_hl = "MarkviewHeading3Sign",

          --- Text to show on the signcolumn.
          ---@type string?
          sign = "󰌕 ",

          --- Highlight group for the sign.
          ---@type string?
          sign_hl = "MarkviewHeading3Sign",

          --- Icon to show before the heading text.
          ---@type string?
          icon = "",

          --- Highlight group for the Icon.
          ---@type string?
          icon_hl = "MarkviewHeading3",
        },
        heading_4 = {
          style = "label",

          --- Alignment of the heading.
          ---@type "left" | "center" | "right"
          align = "left",

          --- Primary highlight group. Used by other
          --- options that end with "_hl" when their
          --- values are nil.
          ---@type string
          hl = "MarkviewHeading4",

          --- Left corner, Added before the left padding
          ---@type string?
          corner_left = "",

          --- Left padding, Added before the icon
          ---@type string?
          padding_left = " ",

          --- Right padding, Added after the heading text
          ---@type string?
          padding_right = " ",

          --- Right corner, Added after the right padding
          ---@type string?
          corner_right = "",

          ---@type string?
          corner_left_hl = "MarkviewHeading4Sign",
          ---@type string?
          padding_left_hl = nil,

          ---@type string?
          padding_right_hl = nil,
          ---@type string?
          corner_right_hl = "MarkviewHeading4Sign",

          --- Text to show on the signcolumn.
          ---@type string?
          sign = "󰌕 ",

          --- Highlight group for the sign.
          ---@type string?
          sign_hl = "MarkviewHeading4Sign",

          --- Icon to show before the heading text.
          ---@type string?
          icon = "",

          --- Highlight group for the Icon.
          ---@type string?
          icon_hl = "MarkviewHeading4",
        },
        heading_5 = {},
        heading_6 = {},

        setext_1 = {
          style = "simple",

          --- Background highlight group.
          ---@type string
          hl = "MarkviewHeading1",
        },
        setext_2 = {
          style = "decorated",

          --- Text to show on the signcolumn.
          ---@type string?
          sign = "󰌕 ",

          --- Highlight group for the sign.
          ---@type string?
          sign_hl = "MarkviewHeading2Sign",

          --- Icon to show before the heading text.
          ---@type string?
          icon = "  ",

          --- Highlight group for the Icon.
          ---@type string?
          icon_hl = "MarkviewHeading2",

          --- Bottom border for the heading.
          ---@type string?
          border = "▂",

          --- Highlight group for the bottom border.
          ---@type string?
          border_hl = "MarkviewHeading2",
        },
      },
      list_items = {
        enable = true,

        --- Amount of spaces that defines an indent
        --- level of the list item.
        ---@type integer
        indent_size = 0,

        --- Amount of spaces to add per indent level
        --- of the list item.
        ---@type integer
        shift_width = 2,

        marker_minus = {
          add_padding = true,

          text = "",
          hl = "MarkviewListItemMinus",
        },
        marker_plus = {
          add_padding = true,

          text = "",
          hl = "MarkviewListItemPlus",
        },
        marker_star = {
          add_padding = true,

          text = "",
          hl = "MarkviewListItemStar",
        },

        --- These items do NOT have a text or
        --- a hl property!

        --- n. Items
        marker_dot = {
          add_padding = true,
        },

        --- n) Items
        marker_parenthesis = {
          add_padding = true,
        },
      },
    },
  },
  config = function(_, opts)
    require("markview").setup(opts) -- calling setup is optional
  end,
  -- config = function()
  --     require("markview").setup({
  --         headings = {
  --               heading_1 = {
  --                 style = "icon",
  --                 hl = "col_1"
  --             },
  --         },
  --         -- buf_ignore = { "nofile" },
  --         -- modes = { "n", "no" },
  --         --
  --         -- options = {
  --         --     on_enable = {},
  --         --     on_disable = {}
  --         -- },
  --         --
  --         -- block_quotes = {},
  --         -- checkboxes = {},
  --         -- code_blocks = {},
  --         --
  --         -- horizontal_rules = {},
  --         -- inline_codes = {},
  --         -- links = {},
  --         -- list_items = {},
  --         -- tables = {}
  --     });
  -- end,
}
