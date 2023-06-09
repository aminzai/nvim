
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
vim.opt.mouse='a'
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
set_keymap('n', 'tn', '<cmd>tabnew<CR>')
set_keymap('n', 'te', '<cmd>Texplore<CR>')
set_keymap('n', 'th', '<cmd>tabprev<CR>')
set_keymap('n', 'tl', '<cmd>tabnext<CR>')
set_keymap('n', 'tc', '<cmd>tabclose<CR>')

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
            'nvim-lualine/lualine.nvim',
            config = function ()
                require('lualine').setup(
                    {
                        options = {
                            theme = 'material',
                        }
                    }
                )
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
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v1.x',
            dependencies = {
                -- LSP Support
                {'neovim/nvim-lspconfig'},             -- Required
                {'williamboman/mason.nvim'},           -- Optional
                {'williamboman/mason-lspconfig.nvim'}, -- Optional
                -- Autocompletion
                {'hrsh7th/nvim-cmp'},         -- Required
                {'hrsh7th/cmp-nvim-lsp'},     -- Required
                {'hrsh7th/cmp-buffer'},       -- Optional
                {'hrsh7th/cmp-path'},         -- Optional
                {'saadparwaiz1/cmp_luasnip'}, -- Optional
                {'hrsh7th/cmp-nvim-lua'},     -- Optional
                -- Snippets
                {'L3MON4D3/LuaSnip'},             -- Required
                {'rafamadriz/friendly-snippets'}, -- Optional
            },
            config = function() 
                local lsp = require('lsp-zero').preset({
                    name = 'minimal',
                    set_lsp_keymaps = true,
                    manage_nvim_cmp = true,
                    suggest_lsp_servers = false,
                })
                -- (Optional) Configure lua language server for neovim
                lsp.nvim_workspace()
                lsp.setup()
                require("mason-lspconfig").setup {
                    ensure_installed = {
                        'dockerls',
                        'html',
                        'jdtls',
                        'jsonls',
                        'pyright',
                        'yamlls',
                    },
                }
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
        { 'fatih/vim-go' },
        {
            "ellisonleao/glow.nvim",
            config = true,
            cmd = "Glow"
        },
        {
                'nvim-telescope/telescope.nvim',
                branch = '0.1.x',
                dependencies = {
                    'nvim-lua/plenary.nvim'
                },
                config = function ()
                    local builtin = require('telescope.builtin')
                    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
                    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
                    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
                    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
                end
        },
        {
            'mfussenegger/nvim-jdtls',
            dependencies = {
                'mfussenegger/nvim-dap',
            },
            config = function()
                local opts = {}
                local pkg_status, jdtls = pcall(require,"jdtls")
                if not pkg_status then
                    vim.notify("unable to load nvim-jdtls", "error")
                    return {}
                end
                -- local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
                local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
                local root_markers = { ".gradle", "gradlew", ".git" }
                local root_dir = jdtls.setup.find_root(root_markers)
                local home = os.getenv("HOME")
                local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
                local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name
                opts.cmd = {
                    jdtls_bin,
                    "-data",
                    workspace_dir,
                }
                local on_attach = function(client, bufnr)
                    jdtls.setup.add_commands() -- important to ensure you can update configs when build is updated
                    -- if you setup DAP according to https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration you can uncomment below
                    -- jdtls.setup_dap({ hotcodereplace = "auto" })
                    -- jdtls.dap.setup_dap_main_class_configs()
                    -- you may want to also run your generic on_attach() function used by your LSP config
                end
                opts.on_attach = on_attach
                opts.capabilities = vim.lsp.protocol.make_client_capabilities()

                require('jdtls').start_or_attach(opts)
                require('jdtls').setup_dap()
            end,
        },
        {
            'mfussenegger/nvim-dap-python',
            dependencies = {
                'mfussenegger/nvim-dap',
            },
            config = function()
            end,
        },
        {
            'mfussenegger/nvim-dap',
            dependencies = {
                'rcarriga/nvim-dap-ui',
                'theHamsta/nvim-dap-virtual-text',
                'nvim-telescope/telescope.nvim',
                'nvim-telescope/telescope-dap.nvim',
            },
            config = function()
                require('telescope').load_extension('dap')
                -- vim.keymap.set('n', '<leader>fd', builtin.help_tags, {})
            end,
        },
    },
    {}
)


