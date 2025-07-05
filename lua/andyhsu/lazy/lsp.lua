return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
                terraform = { "terraform_fmt" },
                tf = { "terraform_fmt" },
                ["terraform-vars"] = { "terraform_fmt" },
                python = { "black", "isort" },
                yaml = { "yamlfmt" },
                json = { "jq" },
                lua = { "stylua" },
                bash = { "shfmt" },
                sh = { "shfmt" },
            }
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pylsp",
                "pyright",
                "bashls",
                "terraformls",
                "tflint",
                "yamlls",
                "vimls",
                "jsonls",
                "dockerls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup {
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    autoSearchPaths = true,
                                    diagnosticMode = "workspace",
                                    useLibraryCodeForTypes = true,
                                    typeCheckingMode = "basic",
                                    completeFunctionParens = true,
                                    extraPaths = {},
                                },
                            },
                        },
                    }
                end,

                ["pylsp"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pylsp.setup {
                        capabilities = capabilities,
                        settings = {
                            pylsp = {
                                plugins = {
                                    pycodestyle = { enabled = true, maxLineLength = 120 },
                                    pyflakes = { enabled = true },
                                    pylint = { enabled = false },
                                    black = { enabled = true },
                                    isort = { enabled = true },
                                    mypy = { enabled = true },
                                },
                            },
                        },
                    }
                end,

                ["yamlls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.yamlls.setup {
                        capabilities = capabilities,
                        settings = {
                            yaml = {
                                schemas = {
                                    -- CircleCI schema
                                    ["https://json.schemastore.org/circleciconfig.json"] = ".circleci/config.yml",
                                    -- GitHub Actions schemas
                                    ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
                                    ["https://json.schemastore.org/github-action.json"] = "action.{yml,yaml}",
                                    -- Kubernetes schemas
                                    ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
                                },
                                format = { enable = true },
                                validate = true,
                                completion = true,
                                hover = true,
                            },
                        },
                    }
                end,

                ["bashls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.bashls.setup {
                        capabilities = capabilities,
                        filetypes = { "sh", "bash", "zsh" },
                        settings = {
                            bashIde = {
                                globPattern = "*@(.sh|.inc|.bash|.command|.zsh|.zshrc|.bashrc|.bash_profile)",
                                explainshellEndpoint = "https://explainshell.com",
                            },
                        },
                    }
                end,

                ["vimls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.vimls.setup {
                        capabilities = capabilities,
                        init_options = {
                            diagnostic = {
                                enable = true
                            },
                            indexes = {
                                count = 3,
                                gap = 100,
                                projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
                                runtimepath = true,
                            },
                            isNeovim = true,
                            iskeyword = "@,48-57,_,192-255,-#",
                            runtimepath = "",
                            suggest = {
                                fromRuntimepath = true,
                                fromVimruntime = true
                            },
                            vimruntime = "",
                        },
                    }
                end,

                ["terraformls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.terraformls.setup {
                        capabilities = capabilities,
                        filetypes = { "terraform", "tf", "terraform-vars", "hcl" },
                        cmd = { "terraform-ls", "serve" },
                        root_dir = lspconfig.util.root_pattern(".terraform", ".git", "*.tf"),
                        settings = {
                            terraformls = {
                                indexing = {
                                    ignorePaths = { ".terragrunt-cache/**/*", "**/.terraform/**/*" },
                                },
                                ignoreDirectoryNames = { ".terragrunt-cache", ".terraform" },
                                -- Enable all experimental features
                                experimentalFeatures = {
                                    validateOnSave = true,
                                    prefillRequiredFields = true,
                                },
                                -- Enable code lens
                                codeLens = {
                                    enable = true,
                                },
                            },
                        },
                        on_attach = function(client, bufnr)
                            -- Enable completion triggered by <c-x><c-o>
                            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                            
                            -- Terraform specific keymaps
                            local opts = { noremap=true, silent=true, buffer=bufnr }
                            vim.keymap.set('n', '<leader>ti', ':!terraform init<CR>', opts, { desc = "Terraform init" })
                            vim.keymap.set('n', '<leader>tv', ':!terraform validate<CR>', opts, { desc = "Terraform validate" })
                            vim.keymap.set('n', '<leader>tp', ':!terraform plan<CR>', opts, { desc = "Terraform plan" })
                            vim.keymap.set('n', '<leader>tf', ':!terraform fmt<CR>', opts, { desc = "Terraform format" })
                        end,
                    }
                end,
            }
        })

        -- LSP Keybindings
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(args)
                local opts = { buffer = args.buf }
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts, { desc = "Show hover documentation" })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts, { desc = "Go to definition" })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts, { desc = "Go to declaration" })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts, { desc = "Go to implementation" })
                vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts, { desc = "Go to type definition" })
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts, { desc = "Find references" })
                vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts, { desc = "Show signature help" })
                vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts, { desc = "Rename symbol" })
                vim.keymap.set({"n", "x"}, "<F3>", vim.lsp.buf.format, opts, { desc = "Format document" })
                vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts, { desc = "Code actions" })
                
                vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts, { desc = "Show diagnostic" })
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts, { desc = "Previous diagnostic" })
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts, { desc = "Next diagnostic" })
            end,
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        -- Configure nvim-cmp with better completion settings for Terraform
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp', priority = 1000 },
                { name = 'luasnip', priority = 750 },
                { name = "copilot", group_index = 2, priority = 100 },
                { name = 'path', priority = 250 },
            }, {
                { name = 'buffer', priority = 50 },
            }),
            -- Enable completion triggered by "." and other characters for Terraform
            completion = {
                autocomplete = { 
                    require('cmp.types').cmp.TriggerEvent.TextChanged,
                    require('cmp.types').cmp.TriggerEvent.InsertEnter,
                },
                completeopt = 'menu,menuone,noinsert',
                keyword_length = 1,
            },
            experimental = {
                ghost_text = true,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            formatting = {
                format = function(entry, vim_item)
                    vim_item.kind = string.format('%s', vim_item.kind)
                    vim_item.menu = ({
                        nvim_lsp = '[LSP]',
                        luasnip = '[Snippet]',
                        buffer = '[Buffer]',
                        path = '[Path]',
                        copilot = '[Copilot]',
                    })[entry.source.name]
                    return vim_item
                end
            },
        })

        -- Set up Terraform-specific completion
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "terraform", "tf", "terraform-vars", "hcl" },
            callback = function()
                vim.bo.commentstring = '# %s'
                -- Trigger completion on "."
                vim.cmd [[
                    setlocal omnifunc=v:lua.vim.lsp.omnifunc
                    setlocal completeopt=menuone,noinsert,noselect
                ]]
            end,
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}

