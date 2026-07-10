local M = {}

function M.enable()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
    vim.b.arttex_conceal = true
end

function M.disable()
    vim.opt_local.conceallevel = 0
    vim.b.arttex_conceal = false
end

function M.toggle()
    if vim.opt_local.conceallevel:get() == 0 then
        M.enable()
    else
        M.disable()
    end
end

return M
