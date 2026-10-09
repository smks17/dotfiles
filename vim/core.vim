let vimplug_exists=stdpath('data') . '/site/autoload/plug.vim'
if has('win32')&&!has('win64')
  let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists=expand('curl')
endif

if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!"curl_exists" -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif


call plug#begin()
"snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" nerdtree
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" theme and visual
Plug 'ryanoasis/vim-devicons'   "vim icon
Plug 'ajmwagar/vim-deus'        "theme
Plug 'morhetz/gruvbox'          "theme

Plug 'tpope/vim-commentary'
Plug 'mhinz/vim-startify'       "quick start page
Plug 'KabbAmine/vCoolor.vim'    "color picker
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'jackguo380/vim-lsp-cxx-highlight'
call plug#end()
