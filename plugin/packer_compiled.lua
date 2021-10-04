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
local package_path_str = "C:\\Users\\userh\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?.lua;C:\\Users\\userh\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?\\init.lua;C:\\Users\\userh\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?.lua;C:\\Users\\userh\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?\\init.lua"
local install_cpath_pattern = "C:\\Users\\userh\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\lua\\5.1\\?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
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
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\AutoSave.nvim"
  },
  ["TrueZen.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\TrueZen.nvim"
  },
  ["bclose.vim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\bclose.vim"
  },
  ["coc.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\coc.nvim"
  },
  ["dashboard-nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\dashboard-nvim"
  },
  ["doom-one.vim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\doom-one.vim"
  },
  edge = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\edge"
  },
  ["galaxyline.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\galaxyline.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\gitsigns.nvim"
  },
  gruvbox = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\gruvbox"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n{\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\20buftype_exclude\1\3\0\0\rterminal\14dashboard\1\0\1\tchar\6|\nsetup\21indent_blankline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\indent-blankline.nvim"
  },
  indentLine = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\indentLine"
  },
  kommentary = {
    config = { "\27LJ\2\nO\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\26use_extended_mappings\22kommentary.config\frequire\0" },
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\kommentary"
  },
  ["lazygit.nvim"] = {
    loaded = false,
    needs_bufread = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\lazygit.nvim"
  },
  ["lightline-gruvbox.vim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lightline-gruvbox.vim"
  },
  material = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\material"
  },
  ["moonlight.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\moonlight.nvim"
  },
  ["nord-vim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nord-vim"
  },
  ["nvcode-color-schemes.vim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvcode-color-schemes.vim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-autopairs"
  },
  ["nvim-bufferline.lua"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-bufferline.lua"
  },
  ["nvim-neoclip.lua"] = {
    config = { "\27LJ\2\nf\0\0\3\0\5\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0'\2\1\0B\0\2\1K\0\1\0\19load_extension\14telescope\nsetup\fneoclip\frequire\0" },
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-neoclip.lua"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-web-devicons"
  },
  ["octo.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tocto\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\octo.nvim"
  },
  ["onedark.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\onedark.nvim"
  },
  onehalf = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\onehalf"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\popup.nvim"
  },
  rainbow = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\rainbow"
  },
  ["ranger.vim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\ranger.vim"
  },
  ["spaceline.vim"] = {
    config = { "\27LJ\2\n@\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\ncurve\29spaceline_seperate_style\6g\bvim\0" },
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\spaceline.vim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-fzy-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\tokyonight.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\ultisnips"
  },
  ["vim-clap"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-clap"
  },
  ["vim-closetag"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-closetag"
  },
  ["vim-colors-solarized"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-colors-solarized"
  },
  ["vim-colors-xcode"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-colors-xcode"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-devicons"
  },
  ["vim-floaterm"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-floaterm"
  },
  ["vim-obsession"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-obsession"
  },
  ["vim-rainbow"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-rainbow"
  },
  ["vim-sensible"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-sensible"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-snippets"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-unimpaired"
  },
  ["vim-visual-multi"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-visual-multi"
  },
  ["vim-which-key"] = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-which-key"
  },
  vimtex = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vimtex"
  },
  wal = {
    loaded = true,
    path = "C:\\Users\\userh\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\wal"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-neoclip.lua
time([[Config for nvim-neoclip.lua]], true)
try_loadstring("\27LJ\2\nf\0\0\3\0\5\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\4\0'\2\1\0B\0\2\1K\0\1\0\19load_extension\14telescope\nsetup\fneoclip\frequire\0", "config", "nvim-neoclip.lua")
time([[Config for nvim-neoclip.lua]], false)
-- Config for: spaceline.vim
time([[Config for spaceline.vim]], true)
try_loadstring("\27LJ\2\n@\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\ncurve\29spaceline_seperate_style\6g\bvim\0", "config", "spaceline.vim")
time([[Config for spaceline.vim]], false)
-- Config for: kommentary
time([[Config for kommentary]], true)
try_loadstring("\27LJ\2\nO\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\26use_extended_mappings\22kommentary.config\frequire\0", "config", "kommentary")
time([[Config for kommentary]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
