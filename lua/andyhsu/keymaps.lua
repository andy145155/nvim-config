-- Centralized Keymap Configuration
local M = {}

-- Set leader key
vim.g.mapleader = " "

-- Helper function for keymaps
local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- ========================================
-- GENERAL NAVIGATION & EDITING
-- ========================================
map("n", "<leader>pv", vim.cmd.Ex, { desc = "File Explorer" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Line movement
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Better navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Jump list navigation
map("n", "<C-o>", "<C-o>", { desc = "Go back in jump list" })
map("n", "<C-i>", "<C-i>", { desc = "Go forward in jump list" })

-- Clipboard operations
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })
map("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })

-- Quick actions
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word" })
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make executable" })
map("n", "<leader><leader>", ":source %<CR>", { desc = "Source file" })

-- Disable annoying keys
map("n", "Q", "<nop>", { desc = "Disable Q" })
map("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- ========================================
-- LSP & CODE INTELLIGENCE
-- ========================================
M.setup_lsp_keymaps = function(bufnr)
    local opts = { buffer = bufnr }
    
    -- Navigation
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("error", opts, { desc = "Go to definition" }))
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("error", opts, { desc = "Find references" }))
    map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("error", opts, { desc = "Go to implementation" }))
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("error", opts, { desc = "Show documentation" }))
    
    -- Actions
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("error", opts, { desc = "Rename symbol" }))
    map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("error", opts, { desc = "Code actions" }))
    map("n", "<leader>f", vim.lsp.buf.format, vim.tbl_extend("error", opts, { desc = "Format document" }))
    
    -- Diagnostics
    map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("error", opts, { desc = "Previous diagnostic" }))
    map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("error", opts, { desc = "Next diagnostic" }))
    map("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("error", opts, { desc = "Show diagnostic" }))
end

-- ========================================
-- GIT (FUGITIVE)
-- ========================================
map("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })

-- ========================================
-- TERRAFORM
-- ========================================
M.setup_terraform_keymaps = function(bufnr)
    local opts = { buffer = bufnr }
    map("n", "<leader>ti", ":!terraform init<CR>", vim.tbl_extend("error", opts, { desc = "Terraform init" }))
    map("n", "<leader>tv", ":!terraform validate<CR>", vim.tbl_extend("error", opts, { desc = "Terraform validate" }))
    map("n", "<leader>tp", ":!terraform plan<CR>", vim.tbl_extend("error", opts, { desc = "Terraform plan" }))
end

-- ========================================
-- PYTHON
-- ========================================
map("n", "<leader>vs", "<cmd>VenvSelect<cr>", { desc = "Select Python venv" })
map("n", "<leader>pt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
map("n", "<leader>pf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run test file" })

-- ========================================
-- DEBUGGING (SIMPLIFIED)
-- ========================================
local function setup_dap_keymaps()
    local dap = require("dap")
    map("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
    map("n", "<F10>", dap.step_over, { desc = "Debug: Step over" })
    map("n", "<F11>", dap.step_into, { desc = "Debug: Step into" })
    map("n", "<F12>", dap.step_out, { desc = "Debug: Step out" })
    map("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
end

-- Call DAP keymaps when DAP is loaded
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "sh", "bash" },
    callback = function()
        if pcall(require, "dap") then
            setup_dap_keymaps()
        end
    end,
})

-- ========================================
-- YAML/CI
-- ========================================
map("n", "<leader>ys", "<cmd>Telescope yaml_schema<cr>", { desc = "Select YAML schema" })

return M 