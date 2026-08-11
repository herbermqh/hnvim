local config = require("arttexconceal.config")
local logger = require("arttexconceal.logger")
local themes = require("arttexconceal.themes")
local scanner = require("arttexconceal.scanner")
local extmarks = require("arttexconceal.extmarks")

local M = {}
M.active = false
local attached_buffers = {}
local debounce_timers = {}

function M.setup_highlights()
    local ok, err = pcall(function()
        local theme_name = themes.get_active_theme_name(config.options.theme)
        themes.apply(theme_name)
    end)
    if not ok then logger.error("Error setting up highlights: " .. tostring(err)) end
end

local function background_process_all(buf)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    local total_lines = vim.api.nvim_buf_line_count(buf)
    local chunk_size = 50
    local current_row = 0
    
    local function process_next_chunk()
        if not M.active or not vim.api.nvim_buf_is_valid(buf) then return end
        if current_row >= total_lines then return end
        local end_row = math.min(current_row + chunk_size, total_lines)
        
        -- Clear the current chunk before processing to clean orphaned extmarks without global flicker
        extmarks.clear(buf, current_row, end_row)
        scanner.process_lines(buf, current_row, end_row)
        
        current_row = end_row
        if current_row < total_lines then
            vim.defer_fn(process_next_chunk, 10)
        end
    end
    process_next_chunk()
end

function M.reprocess_all_buffers()
    if not M.active then return end
    for buf, attached in pairs(attached_buffers) do
        if attached and vim.api.nvim_buf_is_valid(buf) then
            background_process_all(buf)
        end
    end
end

local function attach_to_buffer(buf)
    if attached_buffers[buf] then return end
    local ok = pcall(vim.api.nvim_buf_attach, buf, false, {
        on_lines = function(_, _, _, firstline, _, new_lastline)
            if not M.active then return true end
            vim.schedule(function()
                if not vim.api.nvim_buf_is_valid(buf) then return end
                -- Immediate update for modified lines
                extmarks.clear(buf, firstline, new_lastline)
                scanner.process_lines(buf, firstline, new_lastline)
                
                -- Debounce full sweep to clear orphans
                if debounce_timers[buf] then
                    debounce_timers[buf]:stop()
                end
                debounce_timers[buf] = vim.loop.new_timer()
                debounce_timers[buf]:start(500, 0, vim.schedule_wrap(function()
                    if M.active and vim.api.nvim_buf_is_valid(buf) then
                        background_process_all(buf)
                    end
                end))
            end)
        end,
        on_detach = function()
            attached_buffers[buf] = nil
            if debounce_timers[buf] then
                debounce_timers[buf]:stop()
                debounce_timers[buf] = nil
            end
        end
    })
    if ok then
        attached_buffers[buf] = true
        background_process_all(buf)
    end
end

function M.enable()
    local ok, err = pcall(function()
        if M.active then return end
        M.active = true
        M.setup_highlights()
        
        vim.g.tex_conceal = "" -- Prevent standard syntax engine clashes
        
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype or ""
            if ft == "tex" or ft == "latex" or ft == "plaintex" or ft == "sty" or ft == "cls" or ft == "dtx" then
                vim.api.nvim_win_call(win, function()
                    vim.opt_local.conceallevel = 2
                    vim.opt_local.concealcursor = ""
                end)
                attach_to_buffer(buf)
            end
        end
        -- Fallback to reprocess everything attached (e.g. from BufEnter)
        M.reprocess_all_buffers()
        
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("ArtTexConcealAttach", { clear = true }),
            pattern = {"*.tex", "*.latex", "*.sty", "*.cls", "*.dtx", "tex", "plaintex"},
            callback = function(args)
                if M.active then
                    vim.opt_local.conceallevel = 2
                    vim.opt_local.concealcursor = ""
                    attach_to_buffer(args.buf)
                end
            end
        })
    end)
    if not ok then
        logger.error("Error in enable(): " .. tostring(err))
        M.active = false
    end
end

function M.disable()
    local ok, err = pcall(function()
        if not M.active then return end
        M.active = false
        pcall(vim.api.nvim_del_augroup_by_name, "ArtTexConcealAttach")
        
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            extmarks.clear(buf, 0, -1)
            local ft = vim.bo[buf].filetype or ""
            if ft == "tex" or ft == "latex" or ft == "plaintex" or ft == "sty" or ft == "cls" or ft == "dtx" then
                vim.api.nvim_win_call(win, function()
                    vim.opt_local.conceallevel = 0
                end)
            end
        end
        
        for buf, attached in pairs(attached_buffers) do
            if attached and vim.api.nvim_buf_is_valid(buf) then
                extmarks.clear(buf, 0, -1)
            end
        end
        attached_buffers = {}
    end)
    if not ok then logger.error("Error in disable(): " .. tostring(err)) end
end

function M.toggle()
    if M.active then M.disable() else M.enable() end
end

function M.diagnose()
    vim.notify("Diagnosis not available in background mode yet.", vim.log.levels.INFO)
end

return M
