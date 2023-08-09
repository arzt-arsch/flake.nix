local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local map = vim.api.nvim_set_keymap

--Remap space as leader key
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
-- map("n", "<C-S-k>", ":resize +2<CR>", opts)
-- map("n", "<C-S-j>", ":resize -2<CR>", opts)
-- map("n", "<C-S-h>", ":vertical resize +2<CR>", opts)
-- map("n", "<C-S-l>", ":vertical resize -2<CR>", opts)

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

map("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)

map("n", "g'", "<cmd>s/\"/'/g<CR><cmd>nohl<CR>", opts)
map("n", "g\"", "<cmd>s/'/\"/g<CR><cmd>nohl<CR>", opts)

map("n", "gl", "$", opts)
map("n", "gh", "^", opts)
map("v", "gl", "$", opts)
map("v", "gh", "^", opts)

map("n", "<Tab>", "gt", opts)
map("n", "<S-Tab>", "gT", opts)

map("n", "<leader>nn", "<cmd>set number!<CR>", opts)
map("n", "<leader>nr", "<cmd>set relativenumber!<CR>", opts)

map("n", "<C-Space>", "<cmd>nohl<CR>", opts)

map("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", opts)

map("n", "<leader>f", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>tl", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>th", "<cmd>Telescope help_tags<CR>", opts)
map("n", "<leader>tm", "<cmd>Telescope man_pages<CR>", opts)
map("n", "<leader>tg", "<cmd>Telescope git_files<CR>", opts)
map("n", "<leader>to", "<cmd>Telescope oldfiles<CR>", opts)
map("n", "<leader>tc", "<cmd>Telescope colorscheme<CR>", opts)
map("n", "<leader>tt", "<cmd>Telescope<CR>", opts)

map('n', '<Leader>z', "<cmd>lua require('maximize').toggle()<CR>", opts)

map('n', '<Leader>u', "<cmd>UndotreeToggle<CR>", opts)

map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)

map("n", "<C-i>", "<C-i>zz", opts)
map("n", "<C-o>", "<C-o>zz", opts)

map("n", "gd", "<C-]>", opts)

map("n", "<leader>a", "<cmd>lua _G.toggle_autopairs()<CR>", opts)

map("n", "<leader>mm", "<cmd>MinimapToggle<CR>", opts)
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", opts)

map("n", "<leader>B", "<cmd>TransparentToggle<CR>", opts)
map("n", "<leader>Z", "<cmd>ZenMode<CR>", opts)

map("n", "<leader>o", "<cmd>lua require('oil').open()<CR>", opts)

map("n", "<leader>s", "<cmd>Spectre<CR>", opts)

map("n", "<leader>c", "<cmd>ColorizerToggle<CR>", opts)

map("n", "<leader>g", "<cmd>LazyGit<CR>", opts)

map("n", "<A-1>", "<cmd>lua require(\"harpoon.ui\").nav_file(1) <CR>", opts)
map("n", "<A-2>", "<cmd>lua require(\"harpoon.ui\").nav_file(2) <CR>", opts)
map("n", "<A-3>", "<cmd>lua require(\"harpoon.ui\").nav_file(3) <CR>", opts)
map("n", "<A-4>", "<cmd>lua require(\"harpoon.ui\").nav_file(4) <CR>", opts)
map("n", "<A-5>", "<cmd>lua require(\"harpoon.ui\").nav_file(5) <CR>", opts)
map("n", "<A-6>", "<cmd>lua require(\"harpoon.ui\").nav_file(6) <CR>", opts)
map("n", "<A-7>", "<cmd>lua require(\"harpoon.ui\").nav_file(7) <CR>", opts)
map("n", "<leader>hm", "<cmd>lua require(\"harpoon.ui\").toggle_quick_menu() <CR>", opts)
map("n", "<leader>ha", "<cmd>lua require(\"harpoon.mark\").add_file() <CR>", opts)

map("n", "<F6>", "<cmd>CompilerOpen<CR>", opts)
