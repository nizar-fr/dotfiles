local hdd_dir = "/media/nizar/1E064EC0064E9923/Users/Nizar/temp_hd/"
-- local me_dir = "/_Me/"
local obd_dir = "/media/nizar/1E064EC0064E9923/Users/Nizar/temp_hd//note/"
local todo_dir = "/media/nizar/1E064EC0064E9923/Users/Nizar/temp_hd//personal/todo/"
local book_dir = "/media/nizar/1E064EC0064E9923/Users/Nizar/temp_hd//note//_book/"
-- local tolearn_dir = me_dir .. "/tolearn/"
local research_dir = "/media/nizar/1E064EC0064E9923/Users/Nizar/temp_hd//personal/research/"
-- local meet_dir = me_dir .. "/meet/"
local daily_dir = "/media/nizar/1E064EC0064E9923/Users/Nizar/temp_hd//personal/daily/"

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      { name = "daily", path = daily_dir },
      -- { name = "meet", path= meet_dir},
      { name = "todo", path = todo_dir },
      { name = "book", path = book_dir },
      { name = "research", path = research_dir },
      -- { name = "tolearn" , path= tolearn_dir },
      { name = "rs", path = obd_dir .. "rust" },
      { name = "py", path = obd_dir .. "python" },
      { name = "js", path = obd_dir .. "ecmascript" },
      { name = "lgl", path = obd_dir .. "legal" },
      { name = "jsdoc", path = obd_dir .. "ecma-docs" },
      { name = "mrkt", path = obd_dir .. "marketing" },
      { name = "zig", path = obd_dir .. "zig" },
      { name = "cpp", path = obd_dir .. "cpp" },
      { name = "gpt", path = obd_dir .. "_gpt" },
      { name = "go", path = obd_dir .. "go" },
      { name = "csh", path = obd_dir .. "csharp" },
      { name = "php", path = obd_dir .. "php" },
      { name = "dsgn", path = obd_dir .. "design" },
      { name = "lua" , path = obd_dir .. "lua" },
      { name = "cs", path = obd_dir .. "computer-science" }
    },
    -- daily_notes = {
    --   folder = me_dir .. "/daily",
    --   date_format = "%Y-%m-%d",
    --   alias_format = "%B %-d, %Y",
    --   -- Optional, default tags to add to each new daily note created.
    --   default_tags = { "daily-notes" },
    --   -- Optional, if you want to automatically insert a template from your template directory like daily.md
    -- },
    --   template = nil
    mappings = {
      ["gf"] = {
        action = function() return require("obsidian").util.gf_passthrough() end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function() return require("obsidian").util.toggle_checkbox() end,
        opts = { buffer = true },
      },
      ["<cr>"] = {
        action = function() return require("obsidian").util.smart_action() end,
        opts = { buffer = true, expr = true },
      },
    },
    ui = {
      enable = false, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      max_file_length = 5000, -- disable UI features for files with more than this many lines
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then note:add_alias(note.title) end

      local time_now = os.date("%Y-%m-%dT%H:%M", os.time())
      local out = {
        id = note.id,
        title = note.title,
        author = "Nizarudin Fahmi",
        aliases = note.aliases,
        category = "",
        tags = note.tags,
        date = time_now,
        lastmod = "",
        references = "",
        type = "note",
        status = "draft",
        summary = "",
        todo = "",
      }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      out.lastmod = time_now
      return out
    end,

    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      -- vim.fn.jobstart({"open", url})  -- Mac OS
      vim.fn.jobstart { "xdg-open", url } -- linux
    end,
  },
}
