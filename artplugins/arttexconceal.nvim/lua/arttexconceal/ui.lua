local themes = require("arttexconceal.themes")
local config = require("arttexconceal.config")

local M = {}

function M.open_theme_selector()
    local ok, err = pcall(function()
        local available_themes = themes.get_themes()
        local current_theme = themes.get_active_theme_name(config.options.theme)
        
        local has_builder, ui_mod = pcall(require, "arttexworkspace.ui")
        
        if has_builder and ui_mod.create_menu then
            local menu_options = {}
            for i, theme in ipairs(available_themes) do
                local label = i .. ". " .. theme
                if theme == current_theme then
                    label = label .. " [Active]"
                end
                
                table.insert(menu_options, {
                    text = label,
                    action = function()
                        config.options.theme = theme
                        themes.apply(theme)
                        
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].filetype == "tex" then
                                vim.api.nvim_win_call(win, function()
                                    vim.cmd("redraw!")
                                end)
                            end
                        end
                        print("[ArtTexConceal] Theme set to: " .. theme)
                    end
                })
            end
            
            ui_mod.create_menu({
                title = "ArtTex Themes",
                prompt = "Selecciona un esquema de colores",
                options = menu_options
            })
        else
            vim.ui.select(available_themes, {
                prompt = "🎨 Select ArtTexConceal Theme (Current: " .. current_theme .. "):",
                format_item = function(item)
                    if item == current_theme then
                        return item .. " (Active)"
                    end
                    return item
                end,
            }, function(choice)
                if choice then
                    config.options.theme = choice
                    themes.apply(choice)
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        if vim.bo[buf].filetype == "tex" then
                            vim.api.nvim_win_call(win, function()
                                vim.cmd("redraw!")
                            end)
                        end
                    end
                    print("[ArtTexConceal] Theme set to: " .. choice)
                end
            end)
        end
    end)
    if not ok then
        require("arttexconceal.logger").error("Error in open_theme_selector: " .. tostring(err))
    end
end

function M.open_menu()
    local ok, err = pcall(function()
        local core = require("arttexconceal.core")
        local config = require("arttexconceal.config")
        local themes = require("arttexconceal.themes")
        
        local function force_redraw()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == "tex" then
                    vim.api.nvim_win_call(win, function()
                        vim.cmd("redraw!")
                    end)
                end
            end
        end
        
        local has_builder, ui_mod = pcall(require, "arttexworkspace.ui")
        
        if has_builder and ui_mod.create_menu then
            ui_mod.create_menu({
                title = "ArtTexConceal",
                prompt = "Opciones de Conceal Visual (Usa las píldoras direccionales)",
                options = {
                    {
                        text = "1. Toggle Global Conceal [" .. (core.active and "ON" or "OFF") .. "]",
                        action = function()
                            if core.active then core.disable() else core.enable() end
                        end
                    },
                    {
                        text = "2. Toggle Math Conceal [" .. (config.options.enable_math_conceal and "ON" or "OFF") .. "]",
                        action = function()
                            config.options.enable_math_conceal = not config.options.enable_math_conceal
                            config.save_prefs()
                            core.reprocess_all_buffers()
                            print("[ArtTexConceal] Math Conceal: " .. (config.options.enable_math_conceal and "ON" or "OFF"))
                        end
                    },
                    {
                        text = "3. Toggle Bold (Negrilla) [" .. (config.options.enable_format_bold and "ON" or "OFF") .. "]",
                        action = function()
                            config.options.enable_format_bold = not config.options.enable_format_bold
                            config.save_prefs()
                            core.reprocess_all_buffers()
                            print("[ArtTexConceal] Bold: " .. (config.options.enable_format_bold and "ON" or "OFF"))
                        end
                    },
                    {
                        text = "4. Toggle Italic (Cursiva) [" .. (config.options.enable_format_italic and "ON" or "OFF") .. "]",
                        action = function()
                            config.options.enable_format_italic = not config.options.enable_format_italic
                            config.save_prefs()
                            core.reprocess_all_buffers()
                            print("[ArtTexConceal] Italic: " .. (config.options.enable_format_italic and "ON" or "OFF"))
                        end
                    },
                    {
                        text = "5. Toggle Mathsf (Mono) [" .. (config.options.enable_format_mathsf and "ON" or "OFF") .. "]",
                        action = function()
                            config.options.enable_format_mathsf = not config.options.enable_format_mathsf
                            config.save_prefs()
                            core.reprocess_all_buffers()
                            print("[ArtTexConceal] Mathsf: " .. (config.options.enable_format_mathsf and "ON" or "OFF"))
                        end
                    },
                    {
                        text = "6. Change Theme [" .. themes.get_active_theme_name(config.options.theme) .. "]",
                        action = function() M.open_theme_selector() end
                    }
                }
            })
        else
            print("Menu builder from arttexworkspace not found!")
        end
    end)
    if not ok then
        require("arttexconceal.logger").error("Error in open_menu: " .. tostring(err))
    end
end

return M
