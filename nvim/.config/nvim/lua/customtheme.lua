local bg_color = '#0A0E14'
local tree_color = '#0A0E14'
local blendness = 100
-- local bg_color = '#090C11'

vim.api.nvim_set_hl(0, "Normal", { fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg, bg = bg_color, blend = blendness })
vim.api.nvim_set_hl(0, "LineNr", { fg = vim.api.nvim_get_hl(0, { name = 'LineNr' }).fg, bg = bg_color , blend = blendness})
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = vim.api.nvim_get_hl(0, { name = 'CursorLineNr' }).fg, bg = bg_color , blend = blendness})
vim.api.nvim_set_hl(0, "FoldColumn", { fg = vim.api.nvim_get_hl(0, { name = 'FoldColumn' }).fg, bg = bg_color , blend = blendness})
vim.api.nvim_set_hl(0, "SignColumn", { bg = bg_color , blend = blendness})
vim.api.nvim_set_hl(0, "LineNrBackground", { bg = bg_color , blend = blendness})
vim.api.nvim_set_hl(0, "Normal", { fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg, bg = bg_color , blend = blendness})
vim.api.nvim_set_hl(0, "NormalNC", { fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg, bg = bg_color , blend = blendness})
vim.api.nvim_set_hl(0, "LineNrNC", { fg = '#6E7887', bg = bg_color , blend = blendness}) -- Slightly dimmer line numbers for inactive windows
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = tree_color , blend = blendness})
vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = tree_color , blend = blendness}) -- Non-focused window
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { fg = tree_color, bg = tree_color , blend = blendness}) -- Hide ~ lines
vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = '#1A222D' , blend = blendness}) -- Optional: Slightly lighter bg for cursor line


