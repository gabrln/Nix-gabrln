vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Find lazy.nvim from nixCats pack directory
local function find_lazy()
  local paths = vim.api.nvim_list_runtime_paths()
  for _, p in ipairs(paths) do
    if p:find("lazy%.nvim$") then
      return p
    end
  end
  return nil
end

local lazy_path = find_lazy()
if lazy_path then
  vim.opt.rtp:prepend(lazy_path)

  require("lazy").setup({
    { import = "plugins" },
  }, {
    defaults = { lazy = false },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = true, notify = false },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })
end

-- Noctalia matugen setup
local function safe_require(name)
  local ok, module = pcall(require, name)
  return ok and module or nil
end

local matugen = safe_require('matugen')
if matugen then
  matugen.setup()
end

local signal = vim.uv.new_signal()
signal:start('sigusr1', vim.schedule_wrap(function()
  package.loaded['matugen'] = nil
  require('matugen').setup()
end))
