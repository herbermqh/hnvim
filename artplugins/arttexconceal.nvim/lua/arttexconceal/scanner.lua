local mathzone = require("arttexconceal.mathzone")
local extmarks = require("arttexconceal.extmarks")
local config = require("arttexconceal.config")
local literals = require("arttexconceal.scanner.literals")
local handlers = require("arttexconceal.scanner.handlers")

local M = {}

-- Query string definition
local QUERY_STR = [[
    (generic_command) @cmd
    (chapter) @chapter
    (section) @section
    (subsection) @subsection
    (subsubsection) @subsubsection
    (caption) @caption
    (label_definition) @label
    (label_reference) @ref
    (citation) @cite
    (graphics_include) @includegraphics
    (subscript) @sub
    (superscript) @sup
    (word) @word
    ["{" "}" "[" "]" "(" ")"] @bracket
    "\\left" @delim
    "\\right" @delim
    ((command_name) @sqrt (#eq? @sqrt "\\sqrt"))
]]

local parsed_query = nil
local query_error = false

function M.process_lines(buf, first_row, last_row)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    
    local ok, parser = pcall(vim.treesitter.get_parser, buf, "latex")
    if not ok or not parser then return end
    
    local tree = parser:parse({first_row, last_row})[1]
    if not tree then return end
    local root = tree:root()
    
    local math_zones = mathzone.get_math_zones(buf, root, first_row, last_row)
    local handled_literals = {}
    
    -- Cache parsed query
    if not parsed_query and not query_error then
        local ok_q, query = pcall(vim.treesitter.query.parse, "latex", QUERY_STR)
        if ok_q and query then
            parsed_query = query
        else
            query_error = true
        end
    end
    
    literals.process(buf, first_row, last_row, math_zones, handled_literals)
    
    if not parsed_query then return end
    
    -- Container depth cache to convert O(N^2) depth parsing to O(N)
    local container_cache = {}
    
    for id, node in parsed_query:iter_captures(root, buf, first_row, last_row) do
        local name = parsed_query.captures[id]
        local handler = handlers.dispatch[name]
        
        if handler then
            local ok_h, err_h = pcall(handler, node, buf, name, math_zones, handled_literals, container_cache)
            if not ok_h then
                vim.notify("ArtTexConceal Error in handler " .. name .. ": " .. tostring(err_h), vim.log.levels.ERROR)
            end
        end
    end
end

return M
