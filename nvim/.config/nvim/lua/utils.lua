-- vim.keymap.set('n', '<A-j>', 'i;<Esc>', { desc = "Insert semicolon" })
-- vim.keymap.set('n', '<A-k>', 'i:<Esc>', { desc = "Insert colon" })
--
-- Using Alt + 8 and Alt + 0 for parentheses (since 9 is broken)
-- vim.keymap.set({'n', 'i'}, '<A-8>', '9', { desc = "Nine" })
-- vim.keymap.set({'n', 'i'}, '<A-0>', '(', { desc = "Left parenthesis" })
vim.keymap.set('i', '<A-8>', '9', { desc = "Nine" })
vim.keymap.set('i', '<A-0>', '(', { desc = "Left parenthesis" })
vim.keymap.set('i', '<A-[>', ':', { desc = "Nine" })
vim.keymap.set('i', '<A-]>', ';', { desc = "Left parenthesis" })
-- Special Case: Mapping 'jj' to ':' in Normal mode to enter command line
vim.keymap.set('n', '<leader>k', ':', { desc = "Enter command mode" })
