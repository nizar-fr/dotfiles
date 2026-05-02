function InsertPrompt(model)
  local topic = vim.fn.input("Enter note topic: ")
  local note = ""
  if model == "gemini" then
    note = Prompt(topic, "gemini")
  else
    note = Prompt(topic, "deepseek")
  end
  vim.api.nvim_paste(note, false, -1)  -- Paste the note
  vim.cmd("startinsert")  -- Switch to Insert mode after pasting
end

local basic_content_def = {
  "Then for the content",
  "# Title",
  "## Table of content",
  "## Description",
  "## Basic Syntax and Rules",
  "## Brief History with subcontent:",
  "- Introduced at: {version}.",
  "- Year: {year}.",
  "### How previous version handle this situation",
  "## Why and when to use",
  "## Use Cases & Its Examples",
  "## Best Practices",
  "## Common Pitfalls",
}
local basic_content = table.concat(basic_content_def, "\n")
local number_of_strings = #basic_content_def


local csharp_library_content = table.concat({
  "Then for the content",
  "# Title",
  "## Table of content",
  "## Description",
  "## Definition",
  "- {class, function, property, struct, or, anything else}",
  "- {other properties like is it sealed, static, is it nullable, etc}",
  "- {other properties if available}",
  "- {and other properties if available}",
  "- {and so on if available}",
  "- Namespace : ",
  "- ",
  "- ### {if it is interface or function or delegate, include this}",
  "- ### {}",
  "- ### ",
  "## Basic Syntax and Rules",
  "## Brief History with subcontent:",
  "- Introduced at: {version}.",
  "- Year: {year}.",
  "### How previous version handle this situation",
  "## Why and when to use",
  "## Use Cases & Its Examples",
  "## Best Practices",
  "## Common Pitfalls",
})

-- C#
local csharp_exception = table.concat({
  "If snippet is C#, use ```cs instead of ```csharp.",
  "Use K&R indentation style, where the opening curly brace is on the same LOC as the declaration. ",   
  "Like this",
  "```cs",
  "something {",
  "",
  "}",
}, "\n")

local csharp_exception_gemini = table.concat({
  "Like this",
  "```cs",
  "something {",
  "",
  "}",
  "```",
}, "\n")



function Prompt(prompt, model)
  local frontmatter = table.concat({
    "Create a complete and comprehensive note about",
    prompt,
    "With this content",
    "Frontmatter: Fill this frontmatter",
    "id: ",
    "aliases: ",
    "tags: ",
    "author: Nizarudin Fahmi",
    "category: ",
    "date: YYYY-MM-DDTHH:MM",
    "lastmod: YYYY-MM-DDTHH:MM",
    "model: gemini-2.0-flash",
    "references: {provide link or book}",
    "status: draft",
    "summary: ",
    "title: For ",
    "todo: ",
    "type: note",
  }, "\n")

  local deepseek_prompt = table.concat({
    frontmatter,
    basic_content,
    csharp_exception,
    "",
    "",-- Optional trailing newline
  }, "\n")

  local gemini_prompt = table.concat({
    frontmatter,
    basic_content,
    -- csharp_exception,
    -- csharp_exception_gemini,
    "This includes everything from class, function, and everything else.",
    "",
    "",
    "",-- Optional trailing newline
  }, "\n")

  if model == "gemini" then
    return gemini_prompt
  else
    return table.concat({
      frontmatter,
      basic_content,
      csharp_exception,
      "",
      "",-- Optional trailing newline
    }, "\n")
    
  end
end

-- vim.keymap.set("n", "<leader>mg", function() InsertPrompt("gemini") end, { desc = "Generate Note" })
-- vim.keymap.set("n", "<leader>mf", function() InsertPrompt("deepseek") end, { desc = "Generate Prompt" })
--
-- vim.keymap.set("n", "<leader>mc", function() vim.api.nvim_buf_set_lines(0, 0, 51, false, {}) end, { desc = "Clean Prompt" })
-- vim.keymap.set("n", "<leader>mv", function() vim.api.nvim_buf_set_lines(0, 0, 41, false, {}) end, { desc = "Clean Prompt" })

vim.keymap.set("n", "<leader>mg", function() InsertPrompt("gemini") end, { desc = "Generate Note" })
vim.keymap.set("n", "<leader>mf", function() InsertPrompt("deepseek") end, { desc = "Generate Prompt" })

vim.keymap.set("n", "<leader>mc", function() vim.api.nvim_buf_set_lines(0, 0, 37, false, {}) end, { desc = "Clean Prompt" })
vim.keymap.set("n", "<leader>mv", function() vim.api.nvim_buf_set_lines(0, 0, 27, false, {}) end, { desc = "Clean Prompt" })



