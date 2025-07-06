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
-- COMMENTING (Comment.nvim)
-- ========================================
-- gcc - Comment/uncomment current line
-- gc<motion> - Comment/uncomment using motion (e.g., gc5j for 5 lines down)
-- gcA - Add comment at end of line
-- gco - Add comment below current line
-- gcO - Add comment above current line
-- Visual mode: gc - Comment/uncomment selection

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
    map("n", "<leader>q", vim.diagnostic.setloclist, vim.tbl_extend("error", opts, { desc = "Open diagnostic list" }))
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
-- Python support is now minimal - just LSP and syntax highlighting
-- No virtual environment or testing keymaps needed

-- ========================================
-- YAML
-- ========================================
map("n", "<leader>ys", "<cmd>Telescope yaml_schema<cr>", { desc = "Select YAML schema" })

-- ========================================
-- DIAGNOSTICS (GLOBAL)
-- ========================================
map("n", "<leader>da", "<cmd>Telescope diagnostics<cr>", { desc = "All diagnostics" })
map("n", "<leader>db", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Buffer diagnostics" })

return M 