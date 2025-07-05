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
        keys = {
            { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python VirtualEnv" },
            { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached Python VirtualEnv" },
        },
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
            
            -- Python specific debugging keymaps
            vim.keymap.set("n", "<leader>dpr", function()
                require("dap-python").test_method()
            end, { desc = "Debug Python method" })
            
            vim.keymap.set("n", "<leader>dpc", function()
                require("dap-python").test_class()
            end, { desc = "Debug Python class" })
            
            vim.keymap.set("v", "<leader>dps", function()
                require("dap-python").debug_selection()
            end, { desc = "Debug Python selection" })
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
            
            vim.keymap.set("n", "<leader>pd", function()
                require("neogen").generate()
            end, { desc = "Generate Python docstring" })
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
            
            vim.keymap.set("n", "<leader>pt", function()
                require("neotest").run.run()
            end, { desc = "Run nearest Python test" })
            
            vim.keymap.set("n", "<leader>pT", function()
                require("neotest").run.run(vim.fn.expand("%"))
            end, { desc = "Run Python test file" })
            
            vim.keymap.set("n", "<leader>po", function()
                require("neotest").output.open({ enter = true })
            end, { desc = "Show Python test output" })
        end,
    },
} 