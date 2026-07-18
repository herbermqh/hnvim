local core = require("arttexconceal.core")
local config = require("arttexconceal.config")
local ui = require("arttexconceal.ui")

local M = {}

-- Plugin public API required by the skill
M.api = {
    enable = core.enable,
    disable = core.disable,
    toggle = core.toggle,
    is_active = function() return core.active end,
    open_theme_selector = ui.open_theme_selector,
    open_menu = ui.open_menu
}

--- Setup function for the plugin
function M.setup(opts)
    local ok, err = pcall(function()
        config.setup(opts)
    
    -- Expose commands (ArtTex)
    vim.api.nvim_create_user_command("ArtTexConcealEnable", function() M.api.enable() end, { desc = "Enable ArtTex Conceal" })
    vim.api.nvim_create_user_command("ArtTexConcealDisable", function() M.api.disable() end, { desc = "Disable ArtTex Conceal" })
    vim.api.nvim_create_user_command("ArtTexConcealToggle", function() M.api.toggle() end, { desc = "Toggle ArtTex Conceal" })
    vim.api.nvim_create_user_command("ArtTexConcealTheme", function() M.api.open_theme_selector() end, { desc = "Open Theme Selector for ArtTex Conceal" })
    vim.api.nvim_create_user_command("ArtTexConcealMenu", function() M.api.open_menu() end, { desc = "Open Main Menu for ArtTex Conceal" })
    vim.api.nvim_create_user_command("ArtTexConcealDiagnose", function() require("arttexconceal.core").diagnose() end, { desc = "Diagnose current line" })
    
    -- Aliases for ArtTeX (with capital X) to perfectly match the user's whichkey config
    vim.api.nvim_create_user_command("ArtTeXConcealEnable", function() M.api.enable() end, { desc = "Enable ArtTex Conceal" })
    vim.api.nvim_create_user_command("ArtTeXConcealDisable", function() M.api.disable() end, { desc = "Disable ArtTex Conceal" })
    vim.api.nvim_create_user_command("ArtTeXConcealToggle", function() M.api.toggle() end, { desc = "Toggle ArtTex Conceal" })
    vim.api.nvim_create_user_command("ArtTeXConcealMenu", function() M.api.open_menu() end, { desc = "Open Main Menu for ArtTex Conceal" })
    
    config.options = vim.tbl_deep_extend("force", config.options, opts or {})
    
    local symbols = require("arttexconceal.symbols")
    if symbols.load_custom_symbols then
        symbols.load_custom_symbols()
    end

    -- Enable by default if specified or fallback to true
    if config.options.enable_on_startup ~= false then
        M.api.enable()
    end

    -- The conceal attribute of extmarks requires conceallevel > 0
    vim.api.nvim_create_autocmd({"FileType", "BufEnter", "WinEnter", "CursorMoved", "CursorMovedI", "ModeChanged"}, {
        pattern = {"*.tex", "*.latex", "*.sty", "*.cls", "*.dtx", "tex", "plaintex"},
        callback = function()
            if M.api.is_active() then
                local win = vim.api.nvim_get_current_win()
                if vim.wo[win].conceallevel ~= 2 then
                    vim.wo[win].conceallevel = 2
                end
                if vim.wo[win].concealcursor ~= "" then
                    vim.wo[win].concealcursor = ""
                end
            end
        end
    })
    end)
    if not ok then
        require("arttexconceal.logger").error("Error in setup(): " .. tostring(err))
    end
end

return M
