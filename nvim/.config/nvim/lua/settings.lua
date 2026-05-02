vim.opt.conceallevel = 2
vim.opt_local.conceallevel = 2
vim.opt_global.conceallevel = 2

vim.keymap.set('n', '<S-w>', function()
    if vim.wo.wrap then
        vim.wo.wrap = false
        print('Wrap: OFF')
    else
        vim.wo.wrap = true
        print('Wrap: ON')
    end
end, { desc = 'Toggle line wrapping' })
