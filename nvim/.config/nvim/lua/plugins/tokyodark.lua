
return {
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
        transparent = false
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
    end,
}
