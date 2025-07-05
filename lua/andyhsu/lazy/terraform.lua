return {
    -- Terraform syntax highlighting and more
    {
        "hashivim/vim-terraform",
        ft = { "terraform", "tf", "terraform-vars", "hcl" },
        config = function()
            vim.g.terraform_align = 1
            vim.g.terraform_fmt_on_save = 1
        end,
    },
    
    -- Better HCL syntax support
    {
        "hashicorp/hcl",
        name = "vim-hcl",
        ft = { "hcl", "terraform", "tf" },
    },
} 