-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "C:\\Users\\heber\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?.lua;C:\\Users\\heber\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?\\init.lua;C:\\Users\\heber\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?.lua;C:\\Users\\heber\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?\\init.lua"
local install_cpath_pattern = "C:\\Users\\heber\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\lua\\5.1\\?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["AutoSave.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\AutoSave.nvim",
    url = "https://github.com/Pocco81/AutoSave.nvim"
  },
  ["Catppuccino.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\Catppuccino.nvim",
    url = "https://github.com/Pocco81/Catppuccino.nvim"
  },
  ["TrueZen.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\TrueZen.nvim",
    url = "https://github.com/Pocco81/TrueZen.nvim"
  },
  ["aquarium-vim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\aquarium-vim",
    url = "https://github.com/frenzyexists/aquarium-vim"
  },
  aurora = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\aurora",
    url = "https://github.com/ray-x/aurora"
  },
  ["barbar.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\barbar.nvim",
    url = "https://github.com/romgrk/barbar.nvim"
  },
  ["bclose.vim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\bclose.vim",
    url = "https://github.com/rbgrouleff/bclose.vim"
  },
  ["calvera-dark.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\calvera-dark.nvim",
    url = "https://github.com/yashguptaz/calvera-dark.nvim"
  },
  ["coc.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\coc.nvim",
    url = "https://github.com/neoclide/coc.nvim"
  },
  ["dashboard-nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\dashboard-nvim",
    url = "https://github.com/glepnir/dashboard-nvim"
  },
  ["galaxyline.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\galaxyline.nvim",
    url = "https://github.com/glepnir/galaxyline.nvim"
  },
  ["github-nvim-theme"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\github-nvim-theme",
    url = "https://github.com/projekt0n/github-nvim-theme"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n{\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\20buftype_exclude\1\3\0\0\rterminal\14dashboard\1\0\1\tchar\6|\nsetup\21indent_blankline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  indentLine = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\indentLine",
    url = "https://github.com/Yggdroot/indentLine"
  },
  kommentary = {
    config = { "\27LJ\2\nO\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\26use_extended_mappings\22kommentary.config\frequire\0" },
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\kommentary",
    url = "https://github.com/b3nj5m1n/kommentary"
  },
  ["lazygit.nvim"] = {
    loaded = false,
    needs_bufread = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\lazygit.nvim",
    url = "https://github.com/kdheepak/lazygit.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lush.nvim",
    url = "https://github.com/rktjmp/lush.nvim"
  },
  material = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\material",
    url = "https://github.com/marko-cerovac/material.nvim"
  },
  ["moonlight.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\moonlight.nvim",
    url = "https://github.com/shaunsingh/moonlight.nvim"
  },
  neovim = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neovim",
    url = "https://github.com/rose-pine/neovim"
  },
  ["nightfox.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nightfox.nvim",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["nord.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nord.nvim",
    url = "https://github.com/shaunsingh/nord.nvim"
  },
  ["nvcode-color-schemes.vim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvcode-color-schemes.vim",
    url = "https://github.com/christianchiarulli/nvcode-color-schemes.vim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-neoclip.lua"] = {
    config = { "\27LJ\2\nf\0\0\3\0\5\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0'\2\1\0B\0\2\1K\0\1\0\19load_extension\14telescope\nsetup\fneoclip\frequire\0" },
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-neoclip.lua",
    url = "https://github.com/AckslD/nvim-neoclip.lua"
  },
  ["nvim-papadark"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-papadark",
    url = "https://github.com/MordechaiHadad/nvim-papadark"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14nvim-tree\frequire\0" },
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["octo.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tocto\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\octo.nvim",
    url = "https://github.com/pwntester/octo.nvim"
  },
  ["omni.vim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\omni.vim",
    url = "https://github.com/yonlu/omni.vim"
  },
  ["onedark.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\onedark.nvim",
    url = "https://github.com/navarasu/onedark.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  rainbow = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\rainbow",
    url = "https://github.com/luochen1990/rainbow"
  },
  ["ranger.vim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\ranger.vim",
    url = "https://github.com/francoiscabrol/ranger.vim"
  },
  ["space-nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\space-nvim",
    url = "https://github.com/Th3Whit3Wolf/space-nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-fzy-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzy-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\tokyonight.nvim",
    url = "https://github.com/herbermqh/tokyonight.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\ultisnips",
    url = "https://github.com/sirver/ultisnips"
  },
  ["uwu.vim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\uwu.vim",
    url = "https://github.com/mangeshrex/uwu.vim"
  },
  ["vim-clap"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-clap",
    url = "https://github.com/liuchengxu/vim-clap"
  },
  ["vim-closetag"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-closetag",
    url = "https://github.com/alvan/vim-closetag"
  },
  ["vim-colors-solarized"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-colors-solarized",
    url = "https://github.com/micha/vim-colors-solarized"
  },
  ["vim-colors-xcode"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-colors-xcode",
    url = "https://github.com/arzg/vim-colors-xcode"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-floaterm"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-floaterm",
    url = "https://github.com/voldikss/vim-floaterm"
  },
  ["vim-moonfly-colors"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-moonfly-colors",
    url = "https://github.com/bluz71/vim-moonfly-colors"
  },
  ["vim-nightfly-guicolors"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-nightfly-guicolors",
    url = "https://github.com/bluz71/vim-nightfly-guicolors"
  },
  ["vim-obsession"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-obsession",
    url = "https://github.com/tpope/vim-obsession"
  },
  ["vim-rainbow"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-rainbow",
    url = "https://github.com/frazrepo/vim-rainbow"
  },
  ["vim-sensible"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-sensible",
    url = "https://github.com/tpope/vim-sensible"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  ["vim-visual-multi"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-visual-multi",
    url = "https://github.com/mg979/vim-visual-multi"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-vsnip",
    url = "https://github.com/herbermqh/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-vsnip-integ",
    url = "https://github.com/hrsh7th/vim-vsnip-integ"
  },
  ["vim-which-key"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-which-key",
    url = "https://github.com/liuchengxu/vim-which-key"
  },
  vimtex = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vimtex",
    url = "https://github.com/herbermqh/vimtex"
  },
  ["vn-night.nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vn-night.nvim",
    url = "https://github.com/nxvu699134/vn-night.nvim"
  },
  ["xresources-nvim"] = {
    loaded = true,
    path = "C:\\Users\\heber\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\xresources-nvim",
    url = "https://github.com/nekonako/xresources-nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: nvim-neoclip.lua
time([[Config for nvim-neoclip.lua]], true)
try_loadstring("\27LJ\2\nf\0\0\3\0\5\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0'\2\1\0B\0\2\1K\0\1\0\19load_extension\14telescope\nsetup\fneoclip\frequire\0", "config", "nvim-neoclip.lua")
time([[Config for nvim-neoclip.lua]], false)
-- Config for: kommentary
time([[Config for kommentary]], true)
try_loadstring("\27LJ\2\nO\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\26use_extended_mappings\22kommentary.config\frequire\0", "config", "kommentary")
time([[Config for kommentary]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
