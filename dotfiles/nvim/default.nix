{ pkgs, ... }:
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
    extraLuaConfig = ''
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
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nightfox-nvim;
        type = "lua";
        config = ''
          require('nightfox')
          vim.cmd.colorscheme("nordfox")
        '';
      }
      # utils
      vim-airline
      vim-signify # shows git diff
      rainbow-delimiters-nvim
      {
        plugin = telescope-nvim;
        config = ''
          nnoremap <leader>tf <cmd>Telescope find_files<cr>
          nnoremap <leader>tg <cmd>Telescope live_grep<cr>
          nnoremap <leader>tb <cmd>Telescope buffers<cr>
          nnoremap <leader>th <cmd>Telescope help_tags<cr>
        '';
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          require'ibl'.setup()
        '';
      }
      # format on save
      {
        plugin = neoformat;
        type = "lua";
        config = ''
          vim.g.neoformat_enable_nix = { 'nixfmt', 'nixpkgs-fmt'}
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
      {
        plugin = lsp_lines-nvim;
        type = "lua";
        config = ''
          require'lsp_lines'.setup()
          vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
        '';
      }
      # languages
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup({
            highlight = {
              enable = true,
            },
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
      # lsp
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          require'lspconfig'.hls.setup{
            cmd = { "haskell-language-server", "--lsp" }
          , capabilities = capabilities
          , settings = {
              haskell = {
                formattingProvider = "fourmolu"
              }
            }
          }
          require'lspconfig'.ocamllsp.setup{
            capabilities = capabilities
          }
          require'lspconfig'.tinymist.setup{
            capabilities = capabilities
          }
          require'lspconfig'.nixd.setup{
            capabilities = capabilities
          }
          require'lspconfig'.rust_analyzer.setup{
            capabilities = capabilities
          , settings = {
              ['rust-analyzer'] = {
                checkOnSave = {
                  command = "clippy"
                },
                diagnostics = {
                  enable = false;
                }
              }
            }
          }
        '';
      }
    ];
  };
}

