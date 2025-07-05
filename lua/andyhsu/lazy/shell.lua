return {
    -- Shell script formatting and linting
    {
        "z0mbix/vim-shfmt",
        ft = { "sh", "bash", "zsh" },
        config = function()
            -- Format on save
            vim.g.shfmt_fmt_on_save = 1
            -- Use 2 spaces for indentation
            vim.g.shfmt_extra_args = "-i 2 -ci"
        end,
    },
    
    -- Better shell script detection
    {
        "chr4/sslsecure.vim",
        ft = { "sh", "bash", "zsh" },
    },
    
    -- Shell script runner
    {
        "jghauser/mkdir.nvim",
        config = function()
            require("mkdir")
        end,
    },
    
    -- Better shell navigation
    {
        "rafcamlet/nvim-luapad",
        cmd = { "Luapad", "LuaRun" },
    },
} 