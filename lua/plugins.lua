local fn = vim.fn

-- Automatically install packer if it isn't installed.
local packer_install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(packer_install_path)) > 0 then
	print("Packer Installation not found")
	print("Cloning Packer from Github")
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		packer_install_path,
	})
	print("Installing packer now, close and re-open nvim when finished...")
	vim.cmd([[packadd packer.nvim]])
end


vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerSync
	augroup end
]])

local ok, packer = pcall(require, "packer")
if not ok then
	print("packer could not be loaded in")
	return
end

packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use) 
	use("wbthomason/packer.nvim") -- Packer will manage itself this way

	-- Telescope plugin
	use {
  		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		-- or                          , branch = '0.1.x',
  		requires = { {'nvim-lua/plenary.nvim'} }
	}

	-- Color scheme (rose-pine)
	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	})

	-- Treesitter (Plugin)
	use({ 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' } })


	-- Harpoooon
	use {
    		"ThePrimeagen/harpoon",
    		branch = "harpoon2",
    		requires = { {"nvim-lua/plenary.nvim"} }
	}

	-- Sync it up on save, no more :PackerSync
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

