-- ============================================
-- Neovim Configuration for macOS
-- Apple Silicon (M1/M2/M3/M4)
-- ============================================
-- Copy this file to: ~/.config/nvim/init.lua
--
-- Requirements (install via Homebrew):
--   brew install neovim node ripgrep fzf fd
--
-- Plugins auto-install on first launch via lazy.nvim
--
-- QUICK REFERENCE:
-- ----------------
-- Plugin Manager:  :Lazy           (open lazy.nvim UI)
-- File Tree:       <C-n>           (toggle nvim-tree)
-- Fuzzy Finder:    :Files          (fzf file search)
-- Git Status:      <leader>gs      (open fugitive)
-- Undo History:    <F5>            (toggle undotree)
-- Which Key:       <leader>        (show keybindings)
-- ============================================

-- ============================================
-- PLUGIN MANAGER: lazy.nvim
-- ============================================
-- Bootstrap lazy.nvim (auto-installs on first run)
-- Documentation: https://github.com/folke/lazy.nvim
--
-- Commands:
--   :Lazy          - Open plugin manager UI
--   :Lazy update   - Update all plugins
--   :Lazy sync     - Install/clean/update plugins
--   :Lazy clean    - Remove unused plugins
--   :Lazy health   - Check plugin health
-- ============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================
-- PLUGINS
-- ============================================
require("lazy").setup({

  -- ==========================================
  -- COLOR SCHEME
  -- ==========================================
  -- Catppuccin: Soothing pastel theme
  -- Documentation: https://github.com/catppuccin/nvim
  --
  -- Flavors:
  --   catppuccin-latte     (light)
  --   catppuccin-frappe    (dark, muted)
  --   catppuccin-macchiato (dark, vibrant)
  --   catppuccin-mocha     (dark, rich)
  --
  -- Commands:
  --   :colorscheme catppuccin-macchiato
  --   :Catppuccin <flavor>
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,  -- Load before other plugins
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",  -- Match Ghostty theme
        transparent_background = false,
        integrations = {
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          cmp = true,
          which_key = true,
        },
      })
      vim.cmd.colorscheme "catppuccin-macchiato"
    end,
  },

  -- ==========================================
  -- TREESITTER - Syntax Highlighting
  -- ==========================================
  -- nvim-treesitter: Better syntax highlighting and code understanding
  -- Documentation: https://github.com/nvim-treesitter/nvim-treesitter
  --
  -- Commands:
  --   :TSInstall <language>   - Install parser
  --   :TSUpdate               - Update all parsers
  --   :TSInstallInfo          - Show installed parsers
  --
  -- NOTE: New nvim-treesitter (0.11+) uses async install.
  -- Run :TSInstall lua vim ... manually once to install parsers.
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,  -- Must not be lazy-loaded
    build = ":TSUpdate",
    config = function()
      -- Optional: configure install directory
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Enable treesitter highlighting for supported filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua", "vim", "vimdoc", "query",
          "nix", "elixir", "heex", "eex",
          "python", "javascript", "typescript", "typescriptreact",
          "fish", "bash", "sh",
          "json", "yaml", "toml", "html", "css", "markdown",
          "go", "rust",
        },
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  -- ==========================================
  -- SYNTAX & LANGUAGE SUPPORT (Legacy)
  -- ==========================================
  -- These provide additional support beyond treesitter
  -- vim-nix: Nix language syntax highlighting
  "LnL7/vim-nix",

  -- vim-fish: Fish shell syntax highlighting
  "dag/vim-fish",

  -- vim-elixir: Elixir language support
  "elixir-editors/vim-elixir",

  -- ==========================================
  -- UI & STATUS LINE: lualine.nvim
  -- ==========================================
  -- lualine.nvim: Fast and easy to configure statusline
  -- Documentation: https://github.com/nvim-lualine/lualine.nvim
  --
  -- Features:
  --   - Shows current mode (NORMAL, INSERT, VISUAL)
  --   - Displays git branch and diff stats
  --   - Shows LSP diagnostics
  --   - File encoding, format, type
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        tabline = {
          lualine_a = { "buffers" },
          lualine_z = { "tabs" },
        },
      })
    end,
  },

  -- nvim-web-devicons: File type icons
  -- Requires Nerd Font installed and set in terminal
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },

  -- ==========================================
  -- GIT INTEGRATION: gitsigns.nvim
  -- ==========================================
  -- gitsigns.nvim: Git decorations and hunk actions
  -- Documentation: https://github.com/lewis6991/gitsigns.nvim
  --
  -- Signs:
  --   │  Added line
  --   │  Modified line
  --   _  Removed line
  --
  -- Keymaps (defined in config):
  --   ]c          - Jump to next hunk
  --   [c          - Jump to previous hunk
  --   <leader>hs  - Stage hunk
  --   <leader>hr  - Reset hunk
  --   <leader>hp  - Preview hunk
  --   <leader>hb  - Blame line
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
          untracked    = { text = "┆" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
          map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
          map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
          map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff this ~" })
          map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
        end,
      })
    end,
  },

  -- vim-fugitive: Git wrapper
  -- Documentation: https://github.com/tpope/vim-fugitive
  --
  -- Commands:
  --   :G or :Git     - Open git status (interactive)
  --   :Gwrite        - Stage current file (git add)
  --   :Gread         - Checkout current file (discard changes)
  --   :Gcommit       - Commit staged changes
  --   :Gpush         - Push to remote
  --   :Gpull         - Pull from remote
  --   :Gblame        - Show git blame
  --   :Gdiff         - Show diff in split
  --   :Glog          - Load file history into quickfix
  --
  -- Keymaps (defined below):
  --   <leader>gs  - Git status
  --   <leader>gh  - Get diff from right (merge conflicts)
  --   <leader>gu  - Get diff from left (merge conflicts)
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", ":G<CR>", { silent = true, desc = "Git status" })
      vim.keymap.set("n", "<leader>gh", ":diffget //3<CR>", { silent = true, desc = "Get right diff" })
      vim.keymap.set("n", "<leader>gu", ":diffget //2<CR>", { silent = true, desc = "Get left diff" })
    end,
  },

  -- ==========================================
  -- FILE NAVIGATION & SEARCH
  -- ==========================================
  -- fzf.vim: Fuzzy finder (primary)
  -- Documentation: https://github.com/junegunn/fzf.vim
  --
  -- Commands:
  --   :Files [path]    - Find files (respects .gitignore)
  --   :GFiles          - Git files (git ls-files)
  --   :Buffers         - Open buffers
  --   :Rg [pattern]    - Ripgrep search in files
  --   :Lines           - Lines in loaded buffers
  --   :BLines          - Lines in current buffer
  --   :History         - Recently opened files
  --   :History:        - Command history
  --   :History/        - Search history
  --   :Commands        - Available commands
  --   :Maps            - Key mappings
  --   :Commits         - Git commits
  --   :BCommits        - Git commits for current buffer
  --
  -- In fzf window:
  --   <C-t>  - Open in new tab
  --   <C-x>  - Open in horizontal split
  --   <C-v>  - Open in vertical split
  --   <C-j>/<C-k> - Navigate results
  -- fzf is installed via Homebrew, just load the plugin
  { "junegunn/fzf", dir = "/opt/homebrew/opt/fzf" },
  {
    "junegunn/fzf.vim",
    config = function()
      vim.keymap.set("n", "<C-p>", ":Files<CR>", { silent = true, desc = "Find files" })
      vim.keymap.set("n", "<leader>ff", ":Files<CR>", { silent = true, desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", ":Rg<CR>", { silent = true, desc = "Grep files" })
      vim.keymap.set("n", "<leader>fb", ":Buffers<CR>", { silent = true, desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", ":History<CR>", { silent = true, desc = "Find history" })
    end,
  },

  -- ==========================================
  -- LSP & COMPLETION: Native LSP + nvim-cmp
  -- ==========================================
  -- Mason for managing LSP servers
  -- Documentation: https://github.com/williamboman/mason.nvim
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "pyright",
          "jsonls",
          "yamlls",
          "html",
          "cssls",
          "eslint",
        },
        automatic_installation = true,
      })
    end,
  },

  -- SchemaStore for JSON/YAML schemas
  { "b0o/schemastore.nvim" },

  -- nvim-lspconfig: Quickstart configs for Neovim LSP
  -- Documentation: https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/schemastore.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Keymaps for LSP (set on attach)
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
        vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
        vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostics to loclist" }))
      end

      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- Diagnostic signs
      local signs = { Error = "✘", Warn = "⚠", Hint = "➤", Info = "ℹ" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Get schemastore schemas
      local schemastore = require("schemastore")

      -- Setup individual LSP servers using vim.lsp.config (Neovim 0.11+)
      -- Lua
      vim.lsp.config.lua_ls = {
        default_config = {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- TypeScript/JavaScript
      vim.lsp.config.ts_ls = {
        default_config = {
          cmd = { "typescript-language-server", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
          root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Python
      vim.lsp.config.pyright = {
        default_config = {
          cmd = { "pyright-langserver", "--stdio" },
          filetypes = { "python" },
          root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- JSON
      vim.lsp.config.jsonls = {
        default_config = {
          cmd = { "vscode-json-language-server", "--stdio" },
          filetypes = { "json", "jsonc" },
          root_markers = { ".git" },
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- YAML
      vim.lsp.config.yamlls = {
        default_config = {
          cmd = { "yaml-language-server", "--stdio" },
          filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
          root_markers = { ".git" },
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas = schemastore.yaml.schemas({
                extra = {
                  {
                    description = "Kubernetes",
                    fileMatch = { "**/k8s/**/*.yaml", "**/kubernetes/**/*.yaml", "**/manifests/**/*.yaml" },
                    name = "kubernetes",
                    url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/all.json",
                  },
                },
              }),
            },
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- HTML
      vim.lsp.config.html = {
        default_config = {
          cmd = { "vscode-html-language-server", "--stdio" },
          filetypes = { "html", "templ" },
          root_markers = { "package.json", ".git" },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- CSS
      vim.lsp.config.cssls = {
        default_config = {
          cmd = { "vscode-css-language-server", "--stdio" },
          filetypes = { "css", "scss", "less" },
          root_markers = { "package.json", ".git" },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- ESLint
      vim.lsp.config.eslint = {
        default_config = {
          cmd = { "vscode-eslint-language-server", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
          root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json", "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs" },
        },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      }

      -- Nix (nil)
      vim.lsp.config.nil_ls = {
        default_config = {
          cmd = { "nil" },
          filetypes = { "nix" },
          root_markers = { "flake.nix", "default.nix", "shell.nix", ".git" },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Elixir
      vim.lsp.config.elixirls = {
        default_config = {
          cmd = { "/opt/homebrew/bin/elixir-ls" },
          filetypes = { "elixir", "eelixir", "heex", "surface" },
          root_markers = { "mix.exs", ".git" },
          settings = {
            elixirLS = {
              dialyzerEnabled = true,
              fetchDeps = false,
              enableTestLenses = true,
              suggestSpecs = true,
            },
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Enable LSP servers
      vim.lsp.enable({ "lua_ls", "ts_ls", "pyright", "jsonls", "yamlls", "html", "cssls", "eslint", "nil_ls", "elixirls" })
    end,
  },

  -- nvim-cmp: Autocompletion
  -- Documentation: https://github.com/hrsh7th/nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP source
      "hrsh7th/cmp-buffer",       -- Buffer source
      "hrsh7th/cmp-path",         -- Path source
      "hrsh7th/cmp-cmdline",      -- Cmdline source
      "L3MON4D3/LuaSnip",         -- Snippet engine
      "saadparwaiz1/cmp_luasnip", -- Snippet source
      "rafamadriz/friendly-snippets", -- Snippet collection
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })

      -- Cmdline setup
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })
    end,
  },

  -- ==========================================
  -- FILE TREE: nvim-tree.lua
  -- ==========================================
  -- nvim-tree.lua: File system explorer
  -- Documentation: https://github.com/nvim-tree/nvim-tree.lua
  --
  -- Keymap:
  --   <C-n>  - Toggle nvim-tree (defined below)
  --
  -- Inside nvim-tree:
  --   o / <CR> - Open file/expand directory
  --   <Tab>    - Preview file
  --   a        - Create file/directory
  --   d        - Delete file/directory
  --   r        - Rename file/directory
  --   x        - Cut file/directory
  --   c        - Copy file/directory
  --   p        - Paste file/directory
  --   y        - Copy name
  --   Y        - Copy relative path
  --   gy       - Copy absolute path
  --   I        - Toggle hidden files
  --   H        - Toggle dotfiles
  --   R        - Refresh
  --   q        - Close
  --   ?        - Show help
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
          custom = { ".git", "node_modules", ".cache" },
        },
        git = {
          enable = true,
          ignore = false,
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      })

      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle nvim-tree" })
      vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { silent = true, desc = "Focus nvim-tree" })
    end,
  },

  -- ==========================================
  -- EDITING ENHANCEMENTS
  -- ==========================================
  -- vim-commentary: Comment stuff out
  -- Documentation: https://github.com/tpope/vim-commentary
  --
  -- Keymaps:
  --   gcc         - Comment out a line
  --   gc{motion}  - Comment out target of motion
  --   gc          - In visual mode, comment selection
  --   gcap        - Comment out a paragraph
  "tpope/vim-commentary",

  -- undotree: Visualize undo history
  -- Documentation: https://github.com/mbbill/undotree
  --
  -- Keymap:
  --   <F5>  - Toggle undotree (defined below)
  --
  -- Inside undotree:
  --   j/k   - Navigate history
  --   Enter - Select state
  --   p     - Preview change
  --   q     - Close
  "mbbill/undotree",

  -- vim-tmux-navigator: Seamless tmux/vim navigation
  -- Documentation: https://github.com/christoomey/vim-tmux-navigator
  --
  -- Keymaps (work in both vim and tmux):
  --   <C-h>  - Move to left pane
  --   <C-j>  - Move to pane below
  --   <C-k>  - Move to pane above
  --   <C-l>  - Move to right pane
  --   <C-\>  - Move to previous pane
  "christoomey/vim-tmux-navigator",

  -- which-key: Keybinding hints
  -- Documentation: https://github.com/folke/which-key.nvim
  --
  -- Press <leader> and wait to see available keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = { enabled = true, suggestions = 20 },
        },
        win = {
          border = "rounded",
        },
      })
      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunk" },
        { "<leader>t", group = "Tab" },
        { "<leader>c", group = "Code" },
      })
    end,
  },
})

-- ============================================
-- GENERAL SETTINGS
-- ============================================
vim.opt.autoread = true             -- Reload files changed outside vim
vim.opt.backspace = "indent,eol,start"  -- Make backspace work normally

-- ============================================
-- BACKUP & SWAP FILES
-- ============================================
-- Disable swap/backup to avoid clutter
-- Persistent undo is enabled below instead
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- ============================================
-- ENCODING
-- ============================================
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "utf-8"
vim.opt.fileformats = "unix"
vim.opt.termguicolors = true        -- Enable 24-bit colors

-- ============================================
-- EDITOR APPEARANCE
-- ============================================
vim.opt.exrc = true                 -- Allow project-specific .nvimrc
vim.opt.guicursor = ""              -- Block cursor always
vim.opt.signcolumn = "yes"          -- Always show sign column
vim.opt.title = true                -- Set terminal title
vim.opt.relativenumber = true       -- Relative line numbers
vim.opt.number = true               -- Show absolute line number on current line
vim.opt.history = 1000              -- Command history size
vim.opt.showcmd = true              -- Show partial commands
vim.opt.showmode = true             -- Show current mode
vim.opt.hidden = true               -- Allow hidden buffers
vim.opt.linespace = 0               -- No extra line spacing
vim.opt.showmatch = true            -- Highlight matching brackets
vim.opt.winminheight = 0            -- Allow zero-height windows
vim.opt.wildmenu = true             -- Enhanced command completion
vim.opt.wildmode = "list:longest,full"
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"
vim.opt.clipboard = "unnamed,unnamedplus"  -- Use system clipboard

-- ============================================
-- REGEX
-- ============================================
vim.opt.magic = true                -- Enable regex magic characters

-- ============================================
-- SCROLLING
-- ============================================
vim.opt.scrolljump = 5              -- Lines to scroll when cursor leaves screen
vim.opt.scrolloff = 5               -- Keep 5 lines above/below cursor
vim.opt.sidescrolloff = 15          -- Keep 15 columns left/right of cursor
vim.opt.sidescroll = 1              -- Scroll horizontally by 1 column

-- ============================================
-- CODE FOLDING
-- ============================================
-- Commands:
--   za  - Toggle fold under cursor
--   zc  - Close fold
--   zo  - Open fold
--   zR  - Open all folds
--   zM  - Close all folds
vim.opt.foldmethod = "expr"         -- Use treesitter for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"  -- Neovim 0.10+ native API
vim.opt.foldnestmax = 10            -- Maximum fold depth
vim.opt.foldenable = false          -- Don't fold by default
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "1"            -- Show fold column

-- ============================================
-- LINE WRAPPING
-- ============================================
vim.opt.wrap = true                 -- Wrap long lines
vim.opt.linebreak = true            -- Wrap at word boundaries

-- ============================================
-- TAB & INDENTATION
-- ============================================
vim.opt.expandtab = true            -- Convert tabs to spaces
vim.opt.smarttab = true             -- Smart tab handling
vim.opt.tabstop = 4                 -- Tab = 4 spaces visually
vim.opt.softtabstop = 4             -- Tab = 4 spaces when editing
vim.opt.shiftwidth = 4              -- Indent = 4 spaces
vim.opt.shiftround = true           -- Round indent to multiple of shiftwidth

-- ============================================
-- PERFORMANCE
-- ============================================
vim.opt.updatetime = 250            -- Faster CursorHold events (improves LSP/gitsigns)
vim.opt.timeoutlen = 300            -- Key sequence timeout (ms)

-- ============================================
-- STATUS LINE
-- ============================================
vim.opt.laststatus = 3              -- Global statusline

-- ============================================
-- VISUAL SETTINGS
-- ============================================
vim.opt.background = "dark"
vim.opt.ruler = true
vim.opt.rulerformat = "%30(%=:b%n%y%m%r%w\\ %l,%c%V\\ %P%)"
vim.opt.visualbell = true           -- Visual bell instead of beep
vim.opt.errorbells = false          -- No error bells
vim.opt.spelllang = "en_us"         -- Spell check language
vim.opt.cursorline = true           -- Highlight current line

-- ============================================
-- COMPLETION
-- ============================================
vim.opt.completeopt = "menuone,noselect"  -- Better completion experience

-- ============================================
-- SPLIT WINDOWS
-- ============================================
-- New splits open below and to the right
vim.opt.splitbelow = true
vim.opt.splitright = true

-- ============================================
-- MOUSE
-- ============================================
vim.opt.mouse = "a"                 -- Enable mouse in all modes
vim.opt.mousehide = true            -- Hide mouse while typing

-- ============================================
-- INDENTATION
-- ============================================
vim.opt.autoindent = true           -- Copy indent from current line
vim.opt.smartindent = true          -- Smart auto-indenting

-- ============================================
-- PERSISTENT UNDO
-- ============================================
-- Keeps undo history between sessions
-- Use <F5> to visualize with undotree
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true

-- ============================================
-- SEARCHING
-- ============================================
vim.opt.ignorecase = true           -- Ignore case when searching
vim.opt.smartcase = true            -- Case-sensitive if uppercase present
vim.opt.hlsearch = true             -- Highlight all matches
vim.opt.incsearch = true            -- Incremental search

-- ============================================
-- IGNORED FILES/DIRECTORIES
-- ============================================
vim.opt.wildignore = {
  "*/tmp/*", "*.so", "*.swp", "*.zip",
  "*.o", "*.obj", "*~",
  "*vim/backups*",
  "*sass-cache*",
  "*DS_Store*",
  "vendor/rails/**",
  "vendor/cache/**",
  "*.gem",
  "log/**",
  "tmp/**",
  "*.png", "*.jpg", "*.gif",
  "node_modules/**",
  ".git/**",
}

-- ============================================
-- KEY MAPPINGS
-- ============================================

-- --------------------------------------------
-- UNDOTREE
-- --------------------------------------------
-- <F5> - Toggle undo tree visualization
vim.keymap.set("n", "<F5>", ":UndotreeToggle<CR>", { silent = true, desc = "Toggle Undotree" })

-- --------------------------------------------
-- SUDO SAVE
-- --------------------------------------------
-- :W - Save file with sudo (when you forgot to open with sudo)
-- <Leader>W - Same as :W
vim.cmd("command W w !sudo tee % > /dev/null")
vim.keymap.set("n", "<Leader>W", ":w !sudo tee % > /dev/null<CR>", { silent = true, desc = "Sudo save" })

-- --------------------------------------------
-- SPLIT MANAGEMENT
-- --------------------------------------------
-- <Leader>sv - Create vertical split
-- <Leader>sh - Create horizontal split
vim.keymap.set("n", "<Leader>sv", ":<C-u>vsplit<CR>", { silent = true, desc = "Vertical split" })
vim.keymap.set("n", "<Leader>sh", ":<C-u>split<CR>", { silent = true, desc = "Horizontal split" })

-- --------------------------------------------
-- BUFFER NAVIGATION
-- --------------------------------------------
-- <leader>bp - Previous buffer
-- <leader>bn - Next buffer
-- <leader>bl - List all buffers
-- <leader>bd - Close current buffer
vim.keymap.set("n", "<leader>bp", ":bp<CR>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", ":bn<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bl", ":ls<CR>", { silent = true, desc = "List buffers" })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { silent = true, desc = "Close buffer" })

-- --------------------------------------------
-- TAB MANAGEMENT
-- --------------------------------------------
-- <leader>tn - New tab
-- <leader>to - Close all other tabs
-- <leader>tc - Close current tab
-- <leader>tm - Move tab
-- <leader>tt - Next tab
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { silent = true, desc = "New tab" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { silent = true, desc = "Close other tabs" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { silent = true, desc = "Close tab" })
vim.keymap.set("n", "<leader>tm", ":tabmove<CR>", { silent = true, desc = "Move tab" })
vim.keymap.set("n", "<leader>tt", ":tabnext<CR>", { silent = true, desc = "Next tab" })

-- --------------------------------------------
-- EDITING HELPERS
-- --------------------------------------------
-- <leader>i - Fix indentation in entire file
vim.keymap.set("n", "<leader>i", "mmgg=G`m<CR>", { silent = true, desc = "Fix indentation" })

-- <leader><space> - Clear search highlighting
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

-- <leader>sp - Toggle spell checking
vim.keymap.set("n", "<leader>sp", ":set spell!<CR>", { silent = true, desc = "Toggle spell check" })

-- ============================================
-- AUTOCOMMANDS
-- ============================================
vim.api.nvim_create_augroup("init_settings", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "init_settings",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "init_settings",
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = "init_settings",
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd("normal! g`\"")
    end
  end,
})

-- ============================================
-- FILETYPE SETTINGS
-- ============================================
vim.cmd("filetype plugin indent on")

-- ============================================
-- QUICK REFERENCE - ALL CUSTOM KEYMAPS
-- ============================================
--
-- FILE NAVIGATION:
--   <C-n>           Toggle nvim-tree
--   <C-p>           Find files (fzf)
--   <leader>ff      Find files (fzf)
--   <leader>fg      Grep files (fzf)
--   <leader>fb      Find buffers (fzf)
--   <leader>fh      Find history (fzf)
--   <leader>e       Focus nvim-tree
--
-- GIT:
--   <leader>gs      Git status (fugitive)
--   <leader>gh      Get diff from right
--   <leader>gu      Get diff from left
--   ]c              Next git hunk
--   [c              Previous git hunk
--   <leader>hs      Stage hunk
--   <leader>hr      Reset hunk
--   <leader>hp      Preview hunk
--   <leader>hb      Blame line
--
-- BUFFERS & TABS:
--   <leader>bp      Previous buffer
--   <leader>bn      Next buffer
--   <leader>bl      List buffers
--   <leader>bd      Close buffer
--   <leader>tn      New tab
--   <leader>tc      Close tab
--   <leader>tt      Next tab
--
-- SPLITS:
--   <Leader>sv      Vertical split
--   <Leader>sh      Horizontal split
--   <C-h/j/k/l>     Navigate splits (with tmux)
--
-- EDITING:
--   gcc             Comment line
--   gc{motion}      Comment motion
--   <leader>i       Fix indentation
--   <leader>sp      Toggle spell check
--   <leader><space> Clear search highlight
--
-- UNDO:
--   <F5>            Toggle undotree
--   u               Undo
--   <C-r>           Redo
--
-- LSP:
--   gd              Go to definition
--   gD              Go to declaration
--   gy              Go to type definition
--   gi              Go to implementation
--   gr              Go to references
--   K               Hover documentation
--   <C-k>           Signature help
--   <leader>rn      Rename symbol
--   <leader>ca      Code action
--   <leader>f       Format buffer
--   [d              Previous diagnostic
--   ]d              Next diagnostic
--   <leader>e       Show diagnostic float
--   <leader>q       Diagnostics to loclist
--
-- COMPLETION:
--   <C-Space>       Trigger completion
--   <Tab>           Next item / expand snippet
--   <S-Tab>         Previous item
--   <CR>            Confirm selection
--   <C-e>           Abort completion
--   <C-b>/<C-f>     Scroll docs
--
-- ============================================
