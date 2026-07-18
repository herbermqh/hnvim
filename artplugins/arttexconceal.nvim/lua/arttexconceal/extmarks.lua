local M = {}
M.namespace = vim.api.nvim_create_namespace("arttexconceal")

function M.clear(buf, start_row, end_row)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    pcall(vim.api.nvim_buf_clear_namespace, buf, M.namespace, start_row, end_row)
end

function M.set_extmark(buf, sr, sc, er, ec, opts)
    pcall(vim.api.nvim_buf_set_extmark, buf, M.namespace, sr, sc, opts)
end

function M.set_hl(buf, sr, sc, er, ec, hl)
    M.set_extmark(buf, sr, sc, er, ec, {
        end_col = ec, end_row = er, hl_group = hl, priority = 1000
    })
end

function M.set(buf, sr, sc, er, ec, char, hl)
    if not char or char == "" then
        M.set_extmark(buf, sr, sc, er, ec, {
            end_col = ec, end_row = er, conceal = "", hl_group = hl, priority = 1000
        })
        return
    end
    
    -- Hide the original text completely
    M.set_extmark(buf, sr, sc, er, ec, {
        end_col = ec, end_row = er, conceal = "", priority = 1000
    })
    
    -- Insert the icon/char as inline virtual text (handles double-width correctly)
    M.set_extmark(buf, sr, sc, sr, sc, {
        virt_text = {{char, hl}}, virt_text_pos = "inline", priority = 1000
    })
end

return M
