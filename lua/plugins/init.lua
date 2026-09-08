-- Own plugins: use the local checkout under ~/Documents/aurelio when it
-- exists (dev machine), otherwise install from GitHub (e.g. on NixOS).
local function own(repo, spec)
  local local_dir = vim.fn.expand("~/Documents/aurelio/" .. repo)
  if vim.fn.isdirectory(local_dir) == 1 then
    spec.dir = local_dir
  else
    spec[1] = "jamescalam/" .. repo
    spec.version = "*" -- latest semver release tag
  end
  return spec
end

return {
  -- neo-herdr: capture review comments in Neovim and send them to the
  -- currently active herdr agent. Own plugin. Maps under <leader>h.
  own("neo-herdr.nvim", {
    name = "neo-herdr",
    lazy = false,
    config = function()
      require("neo-herdr").setup()
    end,
  }),
  -- neo-reviewr: native diff-review view (changed-files tree + unified diff) that
  -- queues comments into neo-herdr's batch. Own plugin. Opens with <leader>hv.
  own("neo-reviewr.nvim", {
    name = "neo-reviewr",
    lazy = false,
    dependencies = { "neo-herdr" },
    config = function()
      require("neo-reviewr").setup()
    end,
  }),
  -- context-switch: floating project picker over ~/Documents/aurelio (git repos
  -- by default). Jumps to / opens / closes project tabs. Own plugin. <leader>rp.
  own("context-switch.nvim", {
    name = "context-switch",
    lazy = false,
    config = function()
      require("context-switch").setup({ root = "~/Documents/aurelio" })
    end,
  }),
  {
    "Vigemus/iron.nvim",
    lazy = false,
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")
      local python = require("configs.python")

      -- ipython for the project that owns the buffer the REPL was requested
      -- from: the venv's own ipython if installed, otherwise uv with ipython
      -- layered on top of the project's deps, otherwise a standalone ipython.
      local last_root
      local function ipython_cmd(meta)
        local buf = meta and meta.current_bufnr or 0
        local root = vim.fs.root(buf, { "pyproject.toml", ".venv", ".git" }) or vim.fn.getcwd()
        local venv_ipython = python.venv_tool("ipython", root)
        local cmd
        if venv_ipython then
          cmd = { venv_ipython, "--no-autoindent" }
        elseif vim.fn.filereadable(root .. "/pyproject.toml") == 1 then
          cmd = { "uv", "run", "--project", root, "--with", "ipython", "ipython", "--no-autoindent" }
        else
          cmd = { "uvx", "ipython", "--no-autoindent" }
        end
        -- iron re-resolves the command on every send; only announce a change
        if root ~= last_root then
          last_root = root
          vim.notify("ipython: " .. vim.fn.fnamemodify(root, ":~"), vim.log.levels.INFO)
        end
        return cmd
      end

      iron.setup({
        config = {
          scratch_repl = false,
          close_window_on_exit = false,
          repl_definition = {
            sh = {
              command = { "zsh" },
            },
            python = {
              command = ipython_cmd,
              format = common.bracketed_paste_python,
              -- "# %%" is the py:percent standard (jupytext, VS Code, PyCharm);
              -- the older "#---" / "# ---" markers still work for existing files.
              block_dividers = { "# %%", "#---", "# ---" },
            },
          },
          -- open with 18 lines at bottom of nvim as a proper split
          repl_open_cmd = view.split.belowright(18),
        },
        keymaps = {
          toggle_repl = "<space>rr",
          restart_repl = "<space>rR",
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_line = "<space>sl",
          send_code_block = "<space>sb",
          send_code_block_and_move = "<space>sn",
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      })
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,  -- Load immediately for startup command
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Documents/notes",
        },
      },
      -- setup daily notes/todos
      daily_notes = {
        folder = "todos",
        date_format = "%Y-%m-%d",
        template = nil,
      },
    },
    -- open daily note on nvim startup
    config = function(_, opts)
      require("obsidian").setup(opts)
      -- auto open today's note and overview in split
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local overview_path = vim.fn.expand("~/Documents/notes/todos/overview.md")
          -- Only on machines that actually have the vault
          if vim.fn.argc() == 0 and vim.fn.isdirectory(vim.fn.expand("~/Documents/notes")) == 1 then
            -- Open today's todo note
            vim.cmd("ObsidianToday")
            -- Defer the split to ensure ObsidianToday completes first
            vim.defer_fn(function()
              if vim.fn.filereadable(overview_path) == 1 then
                vim.cmd("belowright split " .. overview_path)
                -- Return focus to the top split (today's todo)
                vim.cmd("wincmd k")
              end
            end, 100)
          end
        end,
      })
    end,
    -- custom keymaps
    keys = {
      { "<leader>no", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note" },
      { "<leader>bo", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
      { "<leader>gd", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link under cursor" },
      { "<leader>ro", "<cmd>ObsidianSearch<cr>", desc = "Telescope search Obsidian vault" },
      { "<leader>td", "<cmd>ObsidianDailies<cr>", desc = "Show daily todo notes" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, for file icons
    config = function()
      -- Custom theme: dark background with light text, colored mode blocks with dark text
      local custom_theme = {
        normal = {
          a = { fg = '#030712', bg = '#ccfbf1', gui = 'bold' },  -- Dark text on cyan
          b = { fg = '#e5e7eb', bg = '#030712' },  -- Light text on dark bg
          c = { fg = '#e5e7eb', bg = '#030712' },
        },
        insert = {
          a = { fg = '#030712', bg = '#4ade80', gui = 'bold' },  -- Dark text on green
          b = { fg = '#e5e7eb', bg = '#030712' },  -- Light text on dark bg
          c = { fg = '#e5e7eb', bg = '#030712' },
        },
        visual = {
          a = { fg = '#030712', bg = '#818cf8', gui = 'bold' },  -- Dark text on purple
          b = { fg = '#e5e7eb', bg = '#030712' },  -- Light text on dark bg
          c = { fg = '#e5e7eb', bg = '#030712' },
        },
        replace = {
          a = { fg = '#030712', bg = '#f87171', gui = 'bold' },  -- Dark text on red
          b = { fg = '#e5e7eb', bg = '#030712' },  -- Light text on dark bg
          c = { fg = '#e5e7eb', bg = '#030712' },
        },
        command = {
          a = { fg = '#030712', bg = '#fbbf24', gui = 'bold' },  -- Dark text on yellow
          b = { fg = '#e5e7eb', bg = '#030712' },  -- Light text on dark bg
          c = { fg = '#e5e7eb', bg = '#030712' },
        },
        inactive = {
          a = { fg = '#4b5563', bg = '#020610' },
          b = { fg = '#4b5563', bg = '#020610' },
          c = { fg = '#4b5563', bg = '#020610' },
        },
      }

      require('lualine').setup({
        options = {
          theme = custom_theme,
          component_separators = { left = '|', right = '|'},
          section_separators = { left = '', right = ''},
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
    keys = {
      {
        "<leader>fm",
        function() require("conform").format({ lsp_format = "fallback" }) end,
        mode = { "n", "v" },
        desc = "Format buffer (conform, LSP fallback)",
      },
    },
  },
  -- Add Mason (manager for LSP and linters)
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  -- Add LSP  
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  -- Add neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,  -- load immediately
    priority = 1000,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          use_libuv_file_watcher = true,
        },
      })
    end,
  },
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<S-Tab>"] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp", max_item_count = 20 },
          { name = "luasnip" },
        }, {
          { name = "buffer", max_item_count = 10 },
          { name = "path" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        performance = {
          debounce = 60,
          throttle = 30,
        },
      }
    end,
  },
  {
    "tpope/vim-fugitive",
    lazy = false
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
	  accept_selection = "<Tab>",
  	}
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "buffers", -- set to "tabs" to show tab pages instead
        numbers = "none",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        show_buffer_close_icons = true,
        show_close_icon = true,
        color_icons = true,
        get_element_icon = function(element)
          local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = true })
          return icon, hl
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      local python = require("configs.python")

      -- Set linters per filetype
      lint.linters_by_ft = {
        python = { "mypy" },
      }

      -- Configure mypy: prefer the project venv's mypy, and always check
      -- against the venv interpreter so installed packages resolve.
      lint.linters.mypy.cmd = function()
        return python.venv_tool("mypy") or "mypy"
      end
      lint.linters.mypy.args = {
        "--ignore-missing-imports",
        "--show-error-codes",
        "--show-column-numbers",
        "--strict",
        "--python-executable",
        function() return python.venv_python() end,
      }

      -- mypy is slow, so only lint on read/write/leaving insert (not every keystroke)
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("user.lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        current_line_blame = true, -- Enabled by default
        current_line_blame_opts = {
          delay = 300,
          virt_text_pos = 'eol',
        },
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
      })
    end,
  },
  {
    "linrongbin16/gitlinker.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup()
    end,
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Copy git link" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link in browser" },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Lazy-load only when one of these commands is invoked (or a key below is pressed)
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true, -- richer add/change/delete highlighting
        hooks = {
          -- Absolute line numbers inside diffs; relativenumber stays on elsewhere.
          -- Fires for every diff window, so both panes get plain, file-accurate numbers.
          diff_buf_win_enter = function(_, winid)
            vim.wo[winid].relativenumber = false
            vim.wo[winid].number = true
          end,
        },
        view = {
          -- Side-by-side for normal diffs
          default = { layout = "diff2_horizontal" },
          -- 3-way (base / ours / theirs) for merge conflicts — the big win over fugitive
          merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = true,
          },
          -- File-history diffs also side-by-side
          file_history = { layout = "diff2_horizontal" },
        },
      })
    end,
    keys = {
      { "<leader>dd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: review working tree" },
      { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
      { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: current file history" },
      { "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: repo history" },
      { "<leader>db", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diffview: review branch vs main" },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "ghost",
        options = {
          show_source = {
            enabled = true,
          },
          multilines = {
            enabled = true,
            always_show = false,
          },
        },
      })
      -- Disable built-in virtual text diagnostics since tiny-inline-diagnostic handles it
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
}
