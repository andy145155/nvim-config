return {
    -- YAML schema validation and completion
    {
        "someone-stole-my-name/yaml-companion.nvim",
        ft = { "yaml", "yml" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("yaml_schema")
            
            local cfg = require("yaml-companion").setup({
                -- Additional schemas
                schemas = {
                    {
                        name = "CircleCI",
                        uri = "https://json.schemastore.org/circleciconfig.json",
                    },
                    {
                        name = "GitHub Workflow",
                        uri = "https://json.schemastore.org/github-workflow.json",
                    },
                    {
                        name = "GitHub Action",
                        uri = "https://json.schemastore.org/github-action.json",
                    },
                },
                lspconfig = {
                    settings = {
                        yaml = {
                            validate = true,
                            schemaStore = {
                                enable = true,
                                url = "https://www.schemastore.org/api/json/catalog.json",
                            },
                        },
                    },
                },
            })
            
            require("lspconfig")["yamlls"].setup(cfg)
            
            -- Keymaps for schema selection
            vim.keymap.set("n", "<leader>ys", "<cmd>Telescope yaml_schema<cr>", { desc = "Select YAML schema" })
        end,
    },
    
    -- GitHub Actions workflow viewer
    {
        "topaxi/gh-actions.nvim",
        cmd = "GhActions",
        dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
        config = function()
            require("gh-actions").setup({})
        end,
        keys = {
            { "<leader>ga", "<cmd>GhActions<cr>", desc = "Open GitHub Actions viewer" },
        },
    },
    
    -- Better YAML folding
    {
        "pedrohdz/vim-yaml-folds",
        ft = { "yaml", "yml" },
    },
    
    -- CI/CD snippets
    {
        "rafamadriz/friendly-snippets",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            -- Load custom CI/CD snippets
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = { "./snippets" },
            })
        end,
    },
} 