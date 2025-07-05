return {
    -- DAP (Debug Adapter Protocol) core
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- UI for debugging
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim",
            
            -- Language specific debug adapters
            "mfussenegger/nvim-dap-python",
            "leoluz/nvim-dap-go",
            "jbyuki/one-small-step-for-vimkind",
            
            -- Required dependency for nvim-dap-ui
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            
            -- Setup DAP UI
            dapui.setup({
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        position = "left",
                        size = 40,
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        position = "bottom",
                        size = 10,
                    },
                },
            })
            
            -- Virtual text setup
            require("nvim-dap-virtual-text").setup({
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
            })
            
            -- Bash/Shell debugging
            dap.adapters.bashdb = {
                type = "executable",
                command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
                name = "bashdb",
            }
            
            dap.configurations.sh = {
                {
                    type = "bashdb",
                    request = "launch",
                    name = "Launch file",
                    showDebugOutput = true,
                    pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
                    pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
                    trace = true,
                    file = "${file}",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    pathCat = "cat",
                    pathBash = "/bin/bash",
                    pathMkfifo = "mkfifo",
                    pathPkill = "pkill",
                    args = {},
                    env = {},
                    terminalKind = "integrated",
                },
            }
            
            -- Auto open/close DAP UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
            
            -- Debugging keymaps
            vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
            vim.keymap.set("n", "<leader>dB", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "Debug: Set conditional breakpoint" })
            vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
            vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run last" })
            vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
            vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "Debug: Evaluate" })
            vim.keymap.set("v", "<leader>de", dapui.eval, { desc = "Debug: Evaluate selection" })
        end,
    },
    
    -- Mason integration for DAP
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "python",
                    "bash",
                    "codelldb",
                },
                automatic_setup = true,
                handlers = {},
            })
        end,
    },
} 