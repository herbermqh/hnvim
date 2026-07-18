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
    
    local graphemes = vim.fn.split(char, '\\zs')
    local num_graphemes = #graphemes
    local text_len = ec - sc
    
    if num_graphemes <= 1 then
        M.set_extmark(buf, sr, sc, er, ec, {
            end_col = ec, end_row = er, conceal = char, hl_group = hl, priority = 1000
        })
    else
        if text_len >= num_graphemes then
            for i = 1, num_graphemes do
                local cur_sc = sc + i - 1
                M.set_extmark(buf, sr, cur_sc, sr, cur_sc + 1, {
                    end_col = cur_sc + 1, end_row = sr, conceal = graphemes[i], hl_group = hl, priority = 1000
                })
            end
            if text_len > num_graphemes then
                M.set_extmark(buf, sr, sc + num_graphemes, er, ec, {
                    end_col = ec, end_row = er, conceal = "", hl_group = hl, priority = 1000
                })
            end
        else
            for i = 1, text_len do
                local cur_sc = sc + i - 1
                M.set_extmark(buf, sr, cur_sc, sr, cur_sc + 1, {
                    end_col = cur_sc + 1, end_row = sr, conceal = graphemes[i], hl_group = hl, priority = 1000
                })
            end
            local remaining_str = table.concat(graphemes, "", text_len + 1)
            M.set_extmark(buf, er, ec, er, ec, {
                virt_text = {{remaining_str, hl}}, virt_text_pos = "inline", priority = 1000
            })
        end
    end
end

return M
