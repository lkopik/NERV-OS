-- ======================
-- EVANGELION NVIM CONFIG
-- Unit-01: READY FOR BATTLE
-- ======================

vim.cmd([[set termguicolors]]) -- Essential for true color

--[[
 ЦВЕТОВАЯ СХЕМА: Nerv Terminal
 Основные цвета:
  * Фон: #0a0a12 (тёмный сине-чёрный, как кабина пилота)
  * Акцент 1: #ff00d0 (яркий неоново-розовый, как LCL)
  * Акцент 2: #00ffff (циановый, как интерфейсы Nerv)
  * Акцент 3: #a288f7 (фиолетовый, как Unit-01)
  * Текст: #c0c0ce (светло-серый с фиолетовым оттенком)
--]]

-- Настройка внешнего вида
vim.opt.number = true          -- Номера строк
vim.opt.relativenumber = true  -- Относительные номера строк (для навигации)
vim.opt.cursorline = true      -- Подсветка текущей строки
vim.opt.signcolumn = 'yes'     -- Всегда показывать колонку знаков

-- Замените на вашу любимую моноширинную шрифт с поддержкой иконок
vim.opt.guifont = 'JetBrainsMono Nerd Font:h12'

-- Настройки для более агрессивного стиля
vim.opt.showmode = false       -- Скрыть -- INSERT -- т.к. у нас будет своя строка статуса
vim.opt.laststatus = 3         -- Глобальная строка статуса

-- Цветовая схема (базовая настройка)
vim.cmd([[
  highlight Normal guibg=#0a0a12 guifg=#c0c0ce
  highlight Comment guifg=#565f89 gui=italic

  " Яркие неоновые акценты
  highlight Identifier guifg=#a288f7
  highlight Statement guifg=#ff00d0 gui=bold
  highlight PreProc guifg=#00ffff
  highlight Type guifg=#7aa2f7
  highlight Special guifg=#ff007c

  " Поиск
  highlight Search guibg=#ff00d0 guifg=#0a0a12 gui=bold
  highlight IncSearch guibg=#00ffff guifg=#0a0a12 gui=bold

  " Строка статуса
  highlight StatusLine guibg=#16161e guifg=#c0c0ce
  highlight StatusLineNC guibg=#0a0a12 guifg=#565f89

  " Номера строк
  highlight LineNr guifg=#565f89
  highlight CursorLineNr guifg=#ff00d0 gui=bold

  " Выделение
  highlight Visual guibg=#1f1f30
  highlight Pmenu guibg=#16161e guifg=#c0c0ce
  highlight PmenuSel guibg=#ff00d0 guifg=#0a0a12

  " Диагностика (ошибки)
  highlight DiagnosticError guifg=#db4b4b
  highlight DiagnosticWarn guifg=#e0af68
  highlight DiagnosticInfo guifg=#00ffff
  highlight DiagnosticHint guifg=#a288f7
]])

-- Настройка таббара
vim.opt.showtabline = 2        -- Всегда показывать таббар

-- Автокоманды для дополнительной стилизации
vim.cmd([[
  augroup EvangelionTheme
    autocmd!
    " При запуске Neovim выводим сообщение в стиле Evangelion
    autocmd VimEnter * echo "SYSTEM: NERV TERMINAL INITIALIZED | USER: IKARI"
  augroup END
]])

-- ======================
-- PLUGINS (с помощью lazy.nvim)
-- ======================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("lazy").setup({
  -- EVANGELION STATUSLINE
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = {
            normal = {
              a = { bg = '#ff00d0', fg = '#0a0a12', gui = 'bold' },
              b = { bg = '#16161e', fg = '#c0c0ce' },
              c = { bg = '#0a0a12', fg = '#c0c0ce' }
            },
            insert = {
              a = { bg = '#00ffff', fg = '#0a0a12', gui = 'bold' },
              b = { bg = '#16161e', fg = '#c0c0ce' },
              c = { bg = '#0a0a12', fg = '#c0c0ce' }
            },
            visual = {
              a = { bg = '#a288f7', fg = '#0a0a12', gui = 'bold' },
              b = { bg = '#16161e', fg = '#c0c0ce' },
              c = { bg = '#0a0a12', fg = '#c0c0ce' }
            }
          },
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {
            { 'mode', separator = { left = '' }, right_padding = 2 }
          },
          lualine_b = { 'filename', 'diagnostics' },
          lualine_c = { 'fileformat' },
          lualine_x = { 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = {
            { 'location', separator = { right = '' }, left_padding = 2 }
          }
        }
      })
    end
  },

  -- EVANGELION ICONS
  { 'nvim-tree/nvim-web-devicons' },

  -- STARTUP SCREEN (в стиле MAGI System)
  {
    'goolord/alpha-nvim',
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')
      
      dashboard.section.header.val = {
        [[                                                                       ]],
        [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ █████╗ ██████╗   ]],
        [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║██╔══██╗██╔══██╗  ]],
        [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║███████║██████╔╝  ]],
        [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██║██╔══██╗  ]],
        [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║██║  ██║  ]],
        [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ]],
        [[                                                                       ]],
        [[                        N E R V   T E R M I N A L                      ]],
        [[                                                                       ]],
      }
      
      dashboard.section.buttons.val = {
        dashboard.button("e", "📄 New Unit", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "🔍 Find File", ":Telescope find_files<CR>"),
        dashboard.button("r", "🔄 Recent", ":Telescope oldfiles<CR>"),
        dashboard.button("c", "⚙️  Config", ":e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "⏹️  Exit", ":qa<CR>"),
      }
      
      alpha.setup(dashboard.config)
    end
  }
})

-- ======================
-- KEYMAPS (NERV COMMANDS)
-- ======================

vim.g.mapleader = " " -- Space как leader key

-- Основные команды навигации
vim.keymap.set('n', '<Leader>w', ':w<CR>', { desc = 'SYNC: Save File' })
vim.keymap.set('n', '<Leader>q', ':q<CR>', { desc = 'SHUTDOWN: Exit' })
vim.keymap.set('n', '<Leader>f', ':Telescope find_files<CR>', { desc = 'SEARCH: Find Files' })

-- Запуск инициализации (для отладки)
vim.keymap.set('n', '<Leader>ir', ':source $MYVIMRC<CR>', { desc = 'SYSTEM: Reload Config' })

-- Сообщение при выходе
vim.cmd([[
  augroup EvangelionExit
    autocmd!
    autocmd VimLeave * echo "SYSTEM: TERMINAL SESSION ENDED | SEELE PROTOCOL: ACTIVATED"
  augroup END
]])

-- ======================
-- FINAL INIT MESSAGE
-- ======================

print("▜ NERV TERMINAL INITIALIZED")
print("▜ USER: IKARI")
print("▜ SYSTEM: READY FOR SYNCHRONIZATION")
print("▜ LCL: OPTIMAL CONDITIONS")
