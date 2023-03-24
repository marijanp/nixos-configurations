{ pkgs, lib, agenix, ... }:
{
  home.packages = with pkgs; [
    nil
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
      # utils
      vim-airline
      vim-signify # shows git diff
      {
        plugin = rainbow;
        config = "let g:rainbow_active = 1";
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          require("indent_blankline").setup {
            show_current_context = true,
          }
        '';
      }
      # languages
      vim-nix
      haskell-vim
      purescript-vim
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
          require'lspconfig'.nil_ls.setup{
            capabilities = capabilities
          }
          require'lspconfig'.purescriptls.setup{
            capabilities = capabilities
          }
        '';
      }
    ];
  };
}

