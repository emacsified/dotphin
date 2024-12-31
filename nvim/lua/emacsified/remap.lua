
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move line down"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move line up"})

vim.keymap.set("n", "J", "mzJ`z", {desc = "Join line below"})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc = "Move down half screen"})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc = "Move up half screen"})
vim.keymap.set("n", "n", "nzzzv", {desc = "Move to next search item"})
vim.keymap.set("n", "N", "Nzzzv", {desc = "Move to previous search item"})

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end, {desc = "Start Vim With Me"})
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end, {desc = "Stop Vim With Me"})

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], {desc = "Paste over selection"})

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], {desc = "Copy to clipboard"})
vim.keymap.set("n", "<leader>Y", [["+Y]], {desc = "Copy to clipboard"})

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]], {desc = "Delete without yanking"})

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>", {desc = "Escape with Ctrl-C"})

vim.keymap.set("n", "Q", "<nop>", {desc = "Disable Ex mode"})
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", {desc = "Open tmux sessionizer"})
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {desc = "Format code"})

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", {desc = "Next quickfix"})
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", {desc = "Previous quickfix"})
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", {desc = "Next location"})
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", {desc = "Previous location"})

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {desc = "Search and replace word under cursor"})
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }, {desc = "Make file executable"})

vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
, {desc = "Error handling"})

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>", {desc = "Open packer config"});
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", {desc = "Make it rain"});

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, {desc = "Source file"})

