return {
  {
    "Vigemus/iron.nvim",
    lazy = false,
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      -- Cache for selected venv per working directory
      local selected_venv_cache = {}

      iron.setup({
        config = {
          scratch_repl = false,
          close_window_on_exit = false,
          repl_definition = {
            sh = {
              command = {"zsh"}
            },
            python = {
              command = function()
                local cwd = vim.fn.getcwd()

                -- Check if we already have a cached selection for this directory
                if selected_venv_cache[cwd] then
                  local venv = selected_venv_cache[cwd]
                  return { "sh", "-c", string.format("source '%s' && cd '%s' && uv run ipython", venv.activate, venv.dir) }
                end

                -- Find all .venv/bin/activate files
                local find_cmd = string.format("find '%s' -type f -path '*/.venv/bin/activate' 2>/dev/null", cwd)
                local handle = io.popen(find_cmd)
                local result = handle:read("*a")
                handle:close()

                local venv_paths = {}
                for path in result:gmatch("[^\r\n]+") do
                  local project_dir = path:gsub("/.venv/bin/activate$", "")
                  table.insert(venv_paths, {
                    activate = path,
                    dir = project_dir,
                    display = vim.fn.fnamemodify(project_dir, ":~")
                  })
                end

                if #venv_paths == 0 then
                  vim.notify("No .venv found, using uv run from: " .. cwd, vim.log.levels.WARN)
                  return { "sh", "-c", string.format("cd '%s' && uv run ipython", cwd) }
                elseif #venv_paths == 1 then
                  local venv = venv_paths[1]
                  selected_venv_cache[cwd] = venv
                  vim.notify(string.format("Initializing iPython from %s", venv.display), vim.log.levels.INFO)
                  return { "sh", "-c", string.format("source '%s' && cd '%s' && uv run ipython", venv.activate, venv.dir) }
                else
                  -- Multiple venvs found - use first as default and show selection
                  local selected_venv = venv_paths[1]

                  vim.ui.select(
                    venv_paths,
                    {
                      prompt = "Select virtual environment:",
                      format_item = function(item)
                        return item.display
                      end,
                    },
                    function(choice)
                      if choice then
                        selected_venv = choice
                        selected_venv_cache[cwd] = choice
                      end
                    end
                  )

                  -- Cache the selection (even if user hasn't selected yet, we use default)
                  selected_venv_cache[cwd] = selected_venv
                  vim.notify(string.format("Initializing iPython from %s", selected_venv.display), vim.log.levels.INFO)
                  return { "sh", "-c", string.format("source '%s' && cd '%s' && uv run ipython --no-autoindent", selected_venv.activate, selected_venv.dir) }
                end
              end,
              format = require("iron.fts.common").bracketed_paste,
              block_dividers = { "#---", "# ---" },
            },
          },
          -- open with 18 lines at bottom of nvim as a proper split
          repl_open_cmd = require("iron.view").split.belowright(18)
        },
        keymaps = {
          toggle_repl = "<space>rr",
          restart_repl = "<space>rR",
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_line = "<space>sl",
          send_code_block = "<space>sb"
        },
        highlight = {
          italic = true
        },
        ignore_blank_lines = true,
      })
    end
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,  -- Load immediately for startup command
    ft = "markdown",
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
      -- auto open today's note
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 then
            vim.cmd("ObsidianToday")
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
    "Shatur/neovim-ayu",
    name = "ayu",
    lazy = false,
    priority = 1000,  -- ensures it loads first
    config = function()
      require('ayu').setup({
        mirage = false,  -- Set to false to use dark variant
        overrides = {}, -- A table of overrides
      })
      -- Load and set the custom colorscheme
      vim.cmd.colorscheme "charon-dark"
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 999,  -- loads after ayu
    opts = {
      flavour = "mocha", -- options: latte, frappe, macchiato, mocha
      transparent_background = false, -- set to true if you want transparency
      integrations = {
        lualine = true,  -- if you have lualine installed
      },
    },
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
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
  -- Add python pyright server for LSP
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
  -- Disable NvChad's default nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
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
    tag = "0.1.5",
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
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      
      -- Set linters per filetype
      lint.linters_by_ft = {
        python = { "mypy" },
      }
      
      -- Configure mypy
      lint.linters.mypy.args = {
        "--ignore-missing-imports",
        "--show-error-codes",
        "--show-column-numbers",
        "--warn-return-any",
        "--strict",
      }
      
      -- Set up autocmd to trigger linting
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
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
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup({
        use_local_fs = false,
        enable_builtin = true,
        default_remote = {"upstream", "origin"},
        default_merge_method = "commit",
        ssh_aliases = {},
        reaction_viewer_hint_icon = "",
        user_icon = " ",
        timeline_marker = "",
        timeline_indent = 2,
        right_bubble_delimiter = "",
        left_bubble_delimiter = "",
        github_hostname = "",
        snippet_context_lines = 4,
        gh_env = {},
        timeout = 5000,
        ui = {
          use_signcolumn = true,
        },
        issues = {
          order_by = {
            field = "CREATED_AT",
            direction = "DESC"
          }
        },
        pull_requests = {
          order_by = {
            field = "CREATED_AT", 
            direction = "DESC"
          },
          always_select_remote_on_create = false
        },
        file_panel = {
          size = 10,
          use_icons = true
        },
        mappings = {
          issue = {
            close_issue = { lhs = "<space>ic", desc = "close issue" },
            reopen_issue = { lhs = "<space>io", desc = "reopen issue" },
            list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
            reload = { lhs = "<C-r>", desc = "reload issue" },
            open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
            copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            add_assignee = { lhs = "<space>aa", desc = "add assignee" },
            remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
            create_label = { lhs = "<space>lc", desc = "create label" },
            add_label = { lhs = "<space>la", desc = "add label" },
            remove_label = { lhs = "<space>ld", desc = "remove label" },
            goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<space>ghc", desc = "add comment" },
            delete_comment = { lhs = "<space>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
          },
          pull_request = {
            checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
            merge_pr = { lhs = "<space>pm", desc = "merge commit PR" },
            squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
            rebase_and_merge_pr = { lhs = "<space>prm", desc = "rebase and merge PR" },
            list_commits = { lhs = "<space>pc", desc = "list PR commits" },
            list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
            show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
            add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
            remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
            close_issue = { lhs = "<space>ic", desc = "close PR" },
            reopen_issue = { lhs = "<space>io", desc = "reopen PR" },
            list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
            reload = { lhs = "<C-r>", desc = "reload PR" },
            open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
            copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            goto_file = { lhs = "gf", desc = "go to file" },
            add_assignee = { lhs = "<space>aa", desc = "add assignee" },
            remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
            create_label = { lhs = "<space>lc", desc = "create label" },
            add_label = { lhs = "<space>la", desc = "add label" },
            remove_label = { lhs = "<space>ld", desc = "remove label" },
            goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<space>ghc", desc = "add comment" },
            delete_comment = { lhs = "<space>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
          },
          review_thread = {
            goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<space>ghc", desc = "add comment" },
            add_suggestion = { lhs = "<space>cs", desc = "add suggestion" },
            delete_comment = { lhs = "<space>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
            select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
            select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
          },
          submit_win = {
            approve_review = { lhs = "<C-a>", desc = "approve review" },
            comment_review = { lhs = "<C-m>", desc = "comment review" },
            request_changes = { lhs = "<C-r>", desc = "request changes review" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          },
          review_diff = {
            submit_review = { lhs = "<leader>vs", desc = "submit review" },
            discard_review = { lhs = "<leader>vd", desc = "discard review" },
            add_review_comment = { lhs = "<space>ghc", desc = "add a new review comment" },
            add_review_suggestion = { lhs = "<space>cs", desc = "add a new review suggestion" },
            focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
            toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
            next_thread = { lhs = "]t", desc = "move to next thread" },
            prev_thread = { lhs = "[t", desc = "move to previous thread" },
            select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
            select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
            select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
            goto_file = { lhs = "gf", desc = "go to file" },
          },
          file_panel = {
            submit_review = { lhs = "<leader>vs", desc = "submit review" },
            discard_review = { lhs = "<leader>vd", desc = "discard review" },
            next_entry = { lhs = "j", desc = "move to next changed file" },
            prev_entry = { lhs = "k", desc = "move to previous changed file" },
            select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
            refresh_files = { lhs = "R", desc = "refresh changed files panel" },
            focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
            toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
            select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
            select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
            select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
          }
        }
      })
    end,
  }
}
