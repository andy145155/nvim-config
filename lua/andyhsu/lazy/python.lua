return {
    -- Python specific plugins
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = { 
            "neovim/nvim-lspconfig", 
            "nvim-telescope/telescope.nvim",
            "mfussenegger/nvim-dap-python"
        },
        ft = "python",
        config = function()
            require("venv-selector").setup({
                name = { "venv", ".venv", "env", ".env" },
                auto_refresh = true,
            })
        end,
        -- Keymaps are now in centralized keymaps.lua
    },
    
    -- Python debugging
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
            
            -- Python debugging keymaps are now in centralized keymaps.lua
        end,
    },
    
    -- Better Python indentation
    {
        "Vimjas/vim-python-pep8-indent",
        ft = "python",
    },
    
    -- Python docstring generator
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        ft = "python",
        config = function()
            require("neogen").setup({
                enabled = true,
                languages = {
                    python = {
                        template = {
                            annotation_convention = "google_docstrings",
                        },
                    },
                },
            })
            
            -- Docstring keymaps are now in centralized keymaps.lua
        end,
    },
    
    -- Python testing
    {
        "nvim-neotest/neotest",
        ft = "python",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        runner = "pytest",
                        python = ".venv/bin/python",
                    }),
                },
            })
            
            -- Testing keymaps are now in centralized keymaps.lua
        end,
    },
} 