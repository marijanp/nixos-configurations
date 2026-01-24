{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    nixd
    tinymist
  ];

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ../vim/.vimrc + ''
      " LSP config (the mappings used in the default file don't quite work right)
      nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
      nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> gl <cmd>lua vim.diagnostic.open_float()<CR>
      nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <silent> <leader>ln <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
      nnoremap <silent> <leader>lp <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
      nnoremap <silent> <leader>la <cmd>lua vim.lsp.buf.code_action()<CR>
      nnoremap <silent> <leader>lr <cmd>lua vim.lsp.buf.rename()<CR>
      nnoremap <silent> <leader>ls <cmd>lua vim.lsp.buf.signature_help()<CR>
      nnoremap <silent> <leader>lq <cmd>lua vim.diagnostic.setloclist()<CR>
    '';
    extraLuaConfig = /* lua */ ''
      vim.diagnostic.config({
        virtual_text = false,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
      -- lsp
      vim.lsp.config('*', {
        capabilities = capabilities
      })
      vim.lsp.enable('ocamllsp')
      vim.lsp.enable('tinymist')
      vim.lsp.enable('nixd')
      vim.lsp.enable('hls')
      vim.lsp.config('hls', {
        cmd = { "haskell-language-server", "--lsp" },
        settings = {
          haskell = {
            formattingProvider = "fourmolu"
          }
        }
      })
      vim.lsp.enable('rust-analyzer')
      vim.lsp.config('rust_analyzer', {
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = {
              command = "clippy"
            },
            diagnostics = {
              enable = false;
            }
          }
        }
      })
      vim.lsp.enable('clangd')
    '';
    plugins =
      with pkgs.vimPlugins;
      [
        {
          plugin = nightfox-nvim;
          type = "lua";
          config = /* lua */ ''
            require('nightfox').setup({
              palettes = {
                carbonfox = {
                  bg1 = "#000000", -- Black background
                }
              },
            })
            vim.cmd.colorscheme("carbonfox")
          '';
        }
        # utils
        vim-airline
        vim-signify # shows git diff
        rainbow-delimiters-nvim
        # plenary-nvim is a propagatedBuildInput of telescope-nvim but since recent bump it has to be added explicitly
        plenary-nvim
        {
          plugin = telescope-nvim;
          type = "lua";
          config = /* lua */ ''
            require('telescope').setup({})

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>tf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>tg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>tb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>th', builtin.help_tags, {})
          '';
        }
        {
          plugin = indent-blankline-nvim;
          type = "lua";
          config = /* lua */ ''
            require'ibl'.setup()
          '';
        }
        # format on save
        {
          plugin = neoformat;
          type = "lua";
          config = /* lua */ ''
            vim.g.neoformat_enable_nix = { 'nixfmt', 'nixpkgs-fmt'}
            vim.g.neoformat_enable_c = { 'clang-format' }
            vim.g.neoformat_enable_ocaml = { 'topiary', 'ocamlformat' }
            vim.cmd([[
              augroup fmt
                autocmd!
                autocmd BufWritePre * undojoin | Neoformat
              augroup END
            ]])
          '';
        }
        # cool lsp stuff
        nvim-lspconfig
        {
          plugin = lsp_lines-nvim;
          type = "lua";
          config = /* lua */ ''
            require'lsp_lines'.setup()
            vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
          '';
        }
        # syntax highlighting
        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = /* lua */ ''
            vim.api.nvim_create_autocmd('FileType', {
              pattern = '*',
              callback = function()
                pcall(vim.treesitter.start)
              end,
            })
          '';
        }
        # snippets
        luasnip
        cmp_luasnip
        # completion
        cmp-nvim-lsp # lsp completions
        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./cmp.lua;

        }
      ]
      ++ lib.optionals config.programs.opencode.enable [
        {
          plugin = opencode-nvim;
          type = "lua";
          config = /* lua */ ''
            vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").select() end, { desc = "Execute AI action" })
            vim.keymap.set({ "n", "x" }, "<leader>ap", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask/prompt AI" })
            vim.keymap.set({ "n", "t" }, "<leader>ac", function() require("opencode").toggle() end, { desc = "Toggle AI chat" })

            vim.keymap.set({ "n", "x" }, "ar", function() return require("opencode").operator("@this ") end, { expr = true, desc = "AI range operator" })
            vim.keymap.set("n", "<leader>al", function() return require("opencode").operator("@this ") .. "_" end, { expr = true, desc = "AI Line operator" })

            vim.keymap.set("n", "<leader>au", function() require("opencode").command("session.half.page.up") end, { desc = "AI chat page up" })
            vim.keymap.set("n", "<leader>ad", function() require("opencode").command("session.half.page.down") end, { desc = "AI chat page down" })
          '';
        }
      ];
  };
}
