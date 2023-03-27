
vim.opt.encoding='utf-8'
vim.opt.fileencoding='utf-8'
vim.opt.cursorline=true
vim.opt.syntax='on'

--Show Line number
vim.opt.number=true
--Set Tab Width
vim.opt.tabstop=4
--Set Tab to Space
vim.opt.expandtab=true
--Set Show Command
vim.opt.showcmd=true
--Show Mode
vim.opt.showmode=true
--Set no Wrap
vim.opt.wrap=false
--Set Soft tab stop
vim.opt.softtabstop=4
--Set Soft tab width
vim.opt.shiftwidth=4
-- Don't Save Backup file
vim.opt.backup=false
-- Indents
vim.opt.autoindent=true
vim.opt.smartindent=true
vim.opt.cindent=true
--Show Row & Colume position
vim.opt.ruler=true
--Support mouse
vim.opt.mouse=a
-- Hightlight in Search
vim.opt.hlsearch=true
vim.opt.incsearch=true  -- Incremental Search 輸入字串就顯示匹配點

-- Set Scroll setting
vim.opt.scrolloff=3
vim.opt.scrolljump=5
vim.cmd([[highlight Search term=reverse ctermbg=4 ctermfg=7]])

vim.opt.listchars='eol:⏎,tab:¦.,trail:␠,nbsp:⎵'
vim.opt.list=true

-- Use relative line number
vim.wo.number = true
vim.wo.relativenumber = true

vim.wo.colorcolumn = "100"

---------------------
-- Key mapping
-- vim.api.nvim_set_keymap(mode, keys, mapping, options)
---------------------
function set_keymap(mode, keys, mapping)
    vim.api.nvim_set_keymap(
        mode,
        keys,
        mapping,
        {
            noremap=true,
            silent = true
        }
    )
end
---------------------
-- Quit
set_keymap('n', '<leader>q', '<cmd>q<CR>')

-- Tab Page
set_keymap('n', 'tn', '<cmd><C-u>tabnew<CR>')
set_keymap('n', 'te', '<cmd><C-u>Texplore<CR>')
set_keymap('n', 'th', '<cmd><C-u>tabprev<CR>')
set_keymap('n', 'tl', '<cmd><C-u>tabnext<CR>')
set_keymap('n', 'tc', '<cmd><C-u>tabclose<CR>')

-- Shift Tab
set_keymap('n','<tab>', 'v>')
set_keymap('n','<s-tab>', 'v<')

-- Command Mode
set_keymap('c', '<c-a>', '<home>')
set_keymap('c', '<c-e>', '<end>')
set_keymap('c', '<c-b>', '<left>')
set_keymap('c', '<c-f>', '<right>')
set_keymap('c', '<c-n>', '<down>')
set_keymap('c', '<c-p>', '<up>')
set_keymap('c', '<c-d>', '<del>')


---------------------
-- Plugin
---------------------

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
require("lazy").setup(
    {
        {
            'flazz/vim-colorschemes',
            lazy = false, -- make sure we load this during startup if it is your main colorscheme
            priority = 1000, -- make sure to load this before all the other start plugins
            config = function()
                -- load the colorscheme here
                -- vim.cmd([[colorscheme dante]])
            end,
        },
        {
            'folke/tokyonight.nvim',
            branch = 'main',
            config = function()
                -- load the colorscheme here
                vim.cmd[[colorscheme tokyonight-night]]
            end,
        },
        {
            'vim-airline/vim-airline',
            lazy = false,
            dependencies = {
                'vim-airline/vim-airline-themes',
            },
            config = function()
            end,
        },
        { "nvim-tree/nvim-web-devicons", lazy = false},
        {
            'preservim/nerdtree',
            keys = {
                {
                    '<leader>e',
                    '<cmd>NERDTree<CR>',
                    desc = 'Nerdtree',
                }
            },
            config = function()
                vim.g.NERDTreeIgnore={
                    '.pyc',
                    '^__pycache__$',
                }
            end,
        },
        {
            'preservim/tagbar',
            keys = {
                {
                    '<leader>t',
                    '<cmd>TagbarToggle<CR>',
                    desc = 'TagBar',
                }
            },
            config = function()
                vim.g.tagbar_autofocus = 1
                vim.g.tagbar_sort = 0
            end,
        },
        {
            'ctrlpvim/ctrlp.vim',
            config = function()
                vim.g.ctrlp_map = '<c-p>'
                vim.g.ctrlp_cmd = 'CtrlP'
                vim.g.ctrlp_working_path_mode = 'ra'
                vim.g.ctrlp_custom_ignore={
                    dir = '.(git|hg|svn)$',
                    file = '.(exe|so|dll)$',
                    link = 'some_bad_symbolic_links',
                }
            end,
        },
        'editorconfig/editorconfig-vim',
        'tpope/vim-fugitive',
        {
            "williamboman/mason.nvim",
            build = ":MasonUpdate", -- :MasonUpdate updates registry contents
            dependencies = {
                'neovim/nvim-lspconfig',
                'williamboman/mason-lspconfig.nvim',
            },
            config = function()
                require("mason").setup()
            end,

        },
        {
            'neovim/nvim-lspconfig',
            config = function()
                local lsp = require('lspconfig')
                lsp.pyright.setup {}
            end,
        },
        {
            'ms-jpq/coq_nvim',
            branch = 'coq',
            dependencies = {
                {'ms-jpq/coq.artifacts', branch = 'artifacts'},
                {'ms-jpq/coq.thirdparty', branch = '3p'},
            },
            config = function()
                --vim.cmd([[COQdeps]])
                local coq = require("coq")
                vim.cmd('COQnow -s')
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            config = function()
                require'nvim-treesitter.configs'.setup {
                    -- A list of parser names, or "all" (the five listed parsers should always be installed)
                    ensure_installed = {
                        'c',
                        'cmake',
                        'dockerfile',
                        'go',
                        'help',
                        'java',
                        'json',
                        'lua',
                        'python',
                        'php',
                        'markdown',
                        'query',
                        'rust',
                        'vim',
                    },

                    -- Install parsers synchronously (only applied to `ensure_installed`)
                    sync_install = false,

                    -- Automatically install missing parsers when entering buffer
                    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                    auto_install = true,

                    -- List of parsers to ignore installing (for "all")
                    ignore_install = { "javascript" },

                    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
                    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

                    highlight = {
                        enable = true,

                        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                        -- the name of the parser)
                        -- list of language that will be disabled
                        -- disable = { "c", "rust" },
                        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                        disable = function(lang, buf)
                            local max_filesize = 100 * 1024 -- 100 KB
                            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                            if ok and stats and stats.size > max_filesize then
                                return true
                            end
                        end,

                        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                        -- Using this option may slow down your editor, and you may see some duplicate highlights.
                        -- Instead of true it can also be a list of languages
                        additional_vim_regex_highlighting = false,
                    },
                }
            end,

        },
        {
            "ray-x/go.nvim",
            dependencies = {  -- optional packages
                "ray-x/guihua.lua",
                "neovim/nvim-lspconfig",
            },
            config = function()
                require("go").setup()
            end,
            event = {"CmdlineEnter"},
            ft = {"go", 'gomod'},
            build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
        },
        {
            "ellisonleao/glow.nvim",
            config = true,
            cmd = "Glow"
        }
    },
    {}
)









-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})
