local extmarks = require("arttexconceal.extmarks")
local symbols = require("arttexconceal.symbols")

local M = {}

function M.process(buf, first_row, last_row, math_zones, handled_literals)
    local lines = vim.api.nvim_buf_get_lines(buf, first_row, last_row, false)
    for i, line in ipairs(lines) do
        local r = first_row + i - 1
        
        for _, item in ipairs(symbols.literals) do
            local start_idx = 1
            while true do
                local s, e
                if item.is_regex then
                    s, e = string.find(line, item.pattern, start_idx, false)
                else
                    s, e = string.find(line, item.pattern, start_idx, true)
                end
                if not s then break end
                
                local is_math = false
                for _, z in ipairs(math_zones) do
                    if r >= z.sr and r <= z.er then
                        if r == z.sr and s - 1 < z.sc then goto continue end
                        if r == z.er and s - 1 >= z.ec then goto continue end
                        is_math = true
                        break
                    end
                    ::continue::
                end
                
                local apply = false
                if item.env == "both" then
                    apply = true
                elseif item.env == "math" and is_math then
                    apply = true
                elseif item.env == "text" and not is_math then
                    apply = true
                end
                
                if apply then
                    extmarks.set(buf, r, s - 1, r, e, item.char, item.hl or "ArtTexConcealMath")
                    handled_literals[r .. "," .. (s - 1)] = true
                end
                start_idx = e + 1
            end
        end
    end
end

return M
