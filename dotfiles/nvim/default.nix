{ pkgs, lib, agenix, ... }:
{
  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ../vim/.vimrc + ''
      " LSP config (the mappings used in the default file don't quite work right)
      nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
      nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
      nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
      nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
    '';
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-signify # show git diff
      vim-nix
      haskell-vim
      purescript-vim
      cmp_luasnip # required by nvim-cmp
      luasnip # required by nvim-cmp
      cmp-nvim-lsp # required by nvim-cmp
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./cmp.lua;
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          require'lspconfig'.hls.setup{
            cmd = { "haskell-language-server", "--lsp" }
          }
          require'lspconfig'.nil_ls.setup{}
          require'lspconfig'.purescriptls.setup{}
        '';
      }
    ];
  };

  home.packages = with pkgs; [
    nil
  ];
}

