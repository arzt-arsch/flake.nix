local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "nvim-lua/plenary.nvim",
  "rose-pine/neovim",
  "Shatur/neovim-ayu",
  "neanias/everforest-nvim",
  "Everblush/nvim",
  "folke/tokyonight.nvim",
  "EdenEast/nightfox.nvim",
  "LunarVim/horizon.nvim",
  "rebelot/kanagawa.nvim",
  "aktersnurra/no-clown-fiesta.nvim",
  "Mofiqul/vscode.nvim",
  {
    "Everblush/nvim",
    name = "everblush",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000
  },
  "savq/melange-nvim",
  "rmehri01/onenord.nvim",
  "luisiacc/gruvbox-baby",
  "AlexvZyl/nordic.nvim",
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.cmd [[
      let g:gruvbox_material_background = "hard"
    ]]
    end
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup {}
    end
  },

  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
      require("which-key").setup({})
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup(
        {
          opleader = {
            line = "<M-;>",
          },
          toggler = {
            line = "<M-;>",
          },
        })
    end
  },

  {
    "windwp/nvim-autopairs",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      vim.cmd [[
        TSUpdate
      ]]
      require "nvim-treesitter.configs".setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
        auto_install = true,
        highlight = {
          enable = true,
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil
        }
      }
    end
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      -- {
      --   "williamboman/mason.nvim",
      --   build = function()
      --     pcall(vim.cmd, "MasonUpdate")
      --   end,
      -- },
      -- { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },

      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
      { "molleweide/LuaSnip-snippets.nvim" },
    }
  },

  "eandrju/cellular-automaton.nvim",
  "mbbill/undotree",
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local actions = require "telescope.actions"
      local telescope = require("telescope")

      local action_state = require("telescope.actions.state")
      local colorscheme_act = {}
      colorscheme_act.save_colorscheme = function(prompt_bufnr)
        local entry = action_state.get_selected_entry(prompt_bufnr)

        vim.loop.fs_open(vim.fs.dirname(vim.env.MYVIMRC)
          .. "/lua/user/colorscheme.lua", "w", 432, function(err, fd)
            if err then
              print(err)
            end
            vim.loop.fs_write(fd, "vim.cmd [[colorscheme " .. entry.value .. "]]"
            , nil, function()
              vim.loop.fs_close(fd)
            end)
          end)
        actions.select_default()
      end

      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-n>"] = actions.cycle_history_next,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
            }
          }
        },
        pickers = {
          find_files = {
            find_command = { "rg", "-uu", "--files", "--hidden", "--glob", "!**/.git/*", "--glob", "!**target/*" },
          },
          colorscheme = {
            enable_preview = true,
            mappings = {
              i = {
                ["<CR>"] = colorscheme_act.save_colorscheme,
              },
              n = {
                ["<CR>"] = colorscheme_act.save_colorscheme,
              }
            }
          }
        },
      }
    end
  },

  {
    "declancm/maximize.nvim",
    config = function() require("maximize").setup() end
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup {
        options = {
          mode = "tabs",
          themable = true,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = true,
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or ""
            return " " .. icon .. "  " .. count
          end
        }
      }
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("user.lualine")
    end
  },
  -- {
  --   "ggandor/leap.nvim",
  --   config = function()
  --     require("leap").add_default_mappings()
  --   end
  -- },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup()
    end
  },

  { "ThePrimeagen/vim-be-good" },
  {
    "anuvyklack/keymap-layer.nvim",
    config = function()
      local KeyLayer = require("keymap-layer")

      local m = { "n", "x" } -- modes
      local side_scroll = KeyLayer({
        enter = {
          { m, "zl", "zl" },
          { m, "zh", "zh" },
        },
        layer = {
          { m, "l", "2zl" },
          { m, "h", "2zh" },
        },
        exit = {
          { m, "<ESC>" }
        },
        config = {
          on_enter = function()
            print("Enter horizontal scrolling mode")
            vim.bo.modifiable = false
          end,
          on_exit  = function() print("Exit horizontal scrolling mode") end,
          timeout  = 3000, -- milliseconds
        }

      })
      local window_resize = KeyLayer({
        enter = {
          { m, "<C-q>", "" },
        },
        layer = {
          { m, "l", ":vertical resize -2<CR>" },
          { m, "h", ":vertical resize +2<CR>" },
          { m, "j", ":resize -2<CR>" },
          { m, "k", ":resize +2<CR>" },
        },
        exit = {
          { m, "<ESC>" }
        },
        config = {
          on_enter = function()
            print("Enter window resizig mode")
            vim.bo.modifiable = false
          end,
          on_exit  = function() print("Exit window resizing mode") end,
          timeout  = 3000, -- milliseconds
        }
      })
    end
  },
  "wakatime/vim-wakatime",
  "nvim-pack/nvim-spectre",

  "wfxr/minimap.vim",

  -- {
  --     "SmiteshP/nvim-navic",
  --     dependencies = "neovim/nvim-lspconfig",
  --     config = function ()
  --       require("nvim-navic").setup{}
  --     end
  -- },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("barbecue").setup {}
    end
  },

  "mrjones2014/nvim-ts-rainbow",

  {
    "echasnovski/mini.trailspace",
    version = false,
    config = function()
      require("mini.trailspace").setup()
    end
  },

  {
    "gelguy/wilder.nvim",
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })
    end,
  },

  "rcarriga/nvim-notify",

  -- {
  --   "m4xshen/hardtime.nvim",
  --   opts = {
  --     disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "undotree", "oil", "spectre_panel" },
  --     max_count = 4,
  --   },
  -- },

  {
    "ggandor/flit.nvim",
    dependencies = {
      "ggandor/leap.nvim",
    },
    config = function()
      require("flit").setup {
        keys = { f = "f", F = "F", t = "t", T = "T" },
        -- A string like "nv", "nvo", "o", etc.
        labeled_modes = "v",
        multiline = true,
        -- Like `leap`s similar argument (call-specific overrides).
        -- E.g.: opts = { equivalence_classes = {} }
        opts = {}
      }
    end
  },

  {
    "liangxianzhe/nap.nvim",
    config = function()
      require("nap").setup {
        next_repeat = "<C-n>",
        prev_repeat = "<C-p>",
        next_prefix = "m",
        prev_prefix = "M",
      }
    end
  },
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup()
    end
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup()
    end
  },

  "lambdalisue/suda.vim",

  {
    "lrangell/theme-cycler.nvim",
    config = function()
      require "themeCycler"
    end
  },

  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end
  },

  {
    "abecodes/tabout.nvim",
    config = function()
      require("tabout").setup()
    end
  },

  {
    "mcauley-penney/tidy.nvim",
    config = function()
      require("tidy").setup()
    end
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  },

  {
    "ggandor/lightspeed.nvim",
    config = function()
      require("lightspeed").setup {}
    end
  },
  "kdheepak/lazygit.nvim",
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      disabled_filetypes = {
        "qf",
        "netrw",
        "NvimTree",
        "lazy",
        "mason",
        "undotree",
        "oil",
        "spectre_panel"
      },
      custom_colorcolumn = {
        rust = "99"
      },
    }
  },
  "tikhomirov/vim-glsl",
  "ThePrimeagen/harpoon",
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        char = '┊',
        space_char_blankline = " ",
        show_current_context = true,
      }
    end
  },
  { -- This plugin
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults" },
    dependencies = { "stevearc/overseer.nvim" },
    config = function(_, opts) require("compiler").setup(opts) end,
  },
  {                                                    -- The framework we use to run tasks
    "stevearc/overseer.nvim",
    commit = "3047ede61cc1308069ad1184c0d447ebee92d749", -- Recommended to to avoid breaking changes
    cmd = { "CompilerOpen", "CompilerToggleResults" },
    opts = {
      -- Tasks are disposed 5 minutes after running to free resources.
      -- If you need to close a task inmediatelly:
      -- press ENTER in the menu you see after compiling on the task you want to close.
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
        bindings = {
          ["q"] = function() vim.cmd("OverseerClose") end,
        },
      },
    },
  },
})
