-- Harpoon2 - fast file navigation
--
-- vim.pack does not support branch pinning, so we manage harpoon2 ourselves.
-- On first load this will clone harpoon2 into the pack opt directory and
-- notify you to restart nvim. Subsequent starts load it normally.
-- To update: git -C (pack_opt_dir)/harpoon pull

local pack_opt = vim.fn.stdpath 'data' .. '/site/pack/core/opt'
local harpoon_dir = pack_opt .. '/harpoon'

if vim.fn.isdirectory(harpoon_dir) == 0 then
  vim.notify('Installing harpoon2...', vim.log.levels.INFO)
  local result = vim.system({
    'git', 'clone', '--branch', 'harpoon2', '--depth', '1',
    'https://github.com/ThePrimeagen/harpoon',
    harpoon_dir,
  }):wait()

  if result.code ~= 0 then
    vim.notify('Failed to install harpoon2:\n' .. (result.stderr or ''), vim.log.levels.ERROR)
    return
  end

  vim.notify('harpoon2 installed. Please restart nvim.', vim.log.levels.INFO)
  return
end

vim.cmd.packadd 'harpoon'

local harpoon = require 'harpoon'
harpoon:setup()

-- Add current file to harpoon list
vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon: [A]dd file' })

-- Toggle the harpoon quick menu
vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: Toggle menu' })

-- Navigate to harpoon marks 1-4
-- NOTE: <C-h> is used for window navigation in the base config, so we use <leader>1..<leader>4 instead
vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon: go to file 1' })
vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon: go to file 2' })
vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon: go to file 3' })
vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon: go to file 4' })
