return {
    -- Shell script formatting is now handled by conform.nvim in lsp.lua
    
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