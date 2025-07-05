return {
    -- YAML language server with enhanced schemas
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
                -- General purpose schemas
                schemas = {
                    {
                        name = "Kubernetes",
                        uri = "https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json",
                    },
                    {
                        name = "Docker Compose",
                        uri = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
                    },
                    {
                        name = "Ansible Playbook",
                        uri = "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook",
                    },
                    {
                        name = "Ansible Tasks",
                        uri = "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks",
                    },
                    {
                        name = "OpenAPI 3.0",
                        uri = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.json",
                    },
                    {
                        name = "OpenAPI 3.1",
                        uri = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json",
                    },
                },
                lspconfig = {
                    settings = {
                        yaml = {
                            validate = true,
                            completion = true,
                            hover = true,
                            schemaStore = {
                                enable = true,
                                url = "https://www.schemastore.org/api/json/catalog.json",
                            },
                            schemas = {
                                -- Kubernetes files
                                ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = {
                                    "*.k8s.yaml",
                                    "*.k8s.yml",
                                    "**/k8s/**/*.yaml",
                                    "**/k8s/**/*.yml",
                                    "**/kubernetes/**/*.yaml",
                                    "**/kubernetes/**/*.yml",
                                },
                                -- Docker Compose files
                                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                                    "docker-compose*.yml",
                                    "docker-compose*.yaml",
                                    "compose*.yml",
                                    "compose*.yaml",
                                },
                                -- Ansible files
                                ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = {
                                    "**/playbooks/**/*.yml",
                                    "**/playbooks/**/*.yaml",
                                    "playbook*.yml",
                                    "playbook*.yaml",
                                },
                            },
                        },
                    },
                },
            })
            
            require("lspconfig")["yamlls"].setup(cfg)
        end,
    },
    
    -- Better YAML folding
    {
        "pedrohdz/vim-yaml-folds",
        ft = { "yaml", "yml" },
    },
    
    -- YAML snippets for common patterns
    {
        "rafamadriz/friendly-snippets",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
} 