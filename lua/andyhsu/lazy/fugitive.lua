return {
    "tpope/vim-fugitive",
    config = function()
        -- Buffer-local fugitive mappings for push, pull --rebase, and push with tracking
        local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})
        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = ThePrimeagen_Fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end
                local bufnr = vim.api.nvim_get_current_buf()
                local opts = {buffer = bufnr, remap = false, desc = "Git push"}
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, opts)
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({'pull',  '--rebase'})
                end, vim.tbl_extend("force", opts, { desc = "Git pull --rebase" }))
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", vim.tbl_extend("force", opts, { desc = "Push with tracking" }))
            end,
        })
        -- Diffget mappings (global)
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "Get diff from left (ours)" })
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "Get diff from right (theirs)" })
    end
}
