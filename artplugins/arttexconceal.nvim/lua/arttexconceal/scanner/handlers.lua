local extmarks = require("arttexconceal.extmarks")
local symbols = require("arttexconceal.symbols")
local config = require("arttexconceal.config")
local mathzone = require("arttexconceal.mathzone")
local depth_module = require("arttexconceal.scanner.depth")

local M = {}

M.dispatch = {}

function M.dispatch.bracket(node, buf, name, math_zones, handled_literals, container_cache)
    local in_math = mathzone.is_in_mathzone_list(math_zones, node:range())
    if in_math and config.options.enable_math_conceal then
        local depth = depth_module.get_unified_depth(node, buf, container_cache)
        local hl_idx = ((depth - 1) % 6) + 1
        local sr, sc, er, ec = node:range()
        extmarks.set_hl(buf, sr, sc, er, ec, "ArtTexConcealRainbow" .. hl_idx)
    end
end

M.dispatch.left = M.dispatch.bracket
M.dispatch.right = M.dispatch.bracket
M.dispatch.sqrt = M.dispatch.bracket

function M.dispatch.delim(node, buf, name, math_zones, handled_literals, container_cache)
    local in_math = mathzone.is_in_mathzone_list(math_zones, node:range())
    if in_math and config.options.enable_math_conceal then
        local depth = depth_module.get_unified_depth(node, buf, container_cache)
        local hl_idx = ((depth - 1) % 6) + 1
        local hl = "ArtTexConcealRainbow" .. hl_idx
        
        local sr, sc, er, ec = node:range()
        extmarks.set(buf, sr, sc, er, ec, "", hl)
        
        local ns = node:next_sibling()
        if ns then
            local nsr, nsc, ner, nec = ns:range()
            extmarks.set_hl(buf, nsr, nsc, ner, nec, hl)
        end
    end
end

function M.dispatch.cmd(node, buf, name, math_zones, handled_literals, container_cache)
    local sr, sc = node:range()
    local in_math = mathzone.is_in_mathzone_list(math_zones, node:range())
    
    local pos_key = sr .. "," .. sc
    if not in_math and handled_literals[pos_key] then return end
    if in_math and handled_literals[pos_key] then return end
    
    local cmd_node = node:child(0)
    if not cmd_node or cmd_node:type() ~= "command_name" then return end
    
    local cmd_text = vim.treesitter.get_node_text(cmd_node, buf)
    local cmd_in_math = mathzone.is_in_mathzone_list(math_zones, cmd_node:range())
    
    if cmd_text == "\\frac" or cmd_text == "\\dfrac" or cmd_text == "\\tfrac" or cmd_text == "\\cfrac" or cmd_text == "\\binom" or cmd_text == "\\dbinom" or cmd_text == "\\tbinom" then
        if cmd_in_math and config.options.enable_math_conceal then
            local depth = depth_module.get_unified_depth(cmd_node, buf, container_cache)
            local hl_idx = ((depth - 1) % 6) + 1
            local rainbow_hl = "ArtTexConcealRainbow" .. hl_idx
            
            local cmd_sr, cmd_sc, cmd_er, cmd_ec = cmd_node:range()
            extmarks.set_hl(buf, cmd_sr, cmd_sc, cmd_er, cmd_ec, rainbow_hl)
            
            local arg1 = node:child(1)
            local arg2 = node:child(2)
            if arg1 and arg2 and arg1:type() == "curly_group" and arg2:type() == "curly_group" then
                local function get_inner(cg)
                    for c in cg:iter_children() do
                        if c:type() ~= "{" and c:type() ~= "}" then
                            return vim.treesitter.get_node_text(c, buf):match("^%s*(.-)%s*$")
                        end
                    end
                    return ""
                end
                
                local t1 = get_inner(arg1)
                local t2 = get_inner(arg2)
                local frac_char = symbols.fractions[t1 .. "/" .. t2]
                if frac_char then
                    local sr2, sc2 = node:range()
                    local _, _, er2, ec2 = arg2:range()
                    extmarks.set(buf, sr2, sc2, er2, ec2, frac_char, rainbow_hl)
                end
            end
        end
    elseif cmd_text == "\\{" or cmd_text == "\\}" then
        if cmd_in_math and config.options.enable_math_conceal then
            local depth = depth_module.get_unified_depth(cmd_node, buf, container_cache)
            local hl_idx = ((depth - 1) % 6) + 1
            local nsr, nsc, ner, nec = node:range()
            local char = cmd_text == "\\{" and "{" or "}"
            extmarks.set(buf, nsr, nsc, ner, nec, char, "ArtTexConcealRainbow" .. hl_idx)
        end
    elseif cmd_text == "\\textbf" or cmd_text == "\\textit" or cmd_text == "\\textsf" or cmd_text == "\\note" or cmd_text == "\\note*" or cmd_text == "\\bfseries" or cmd_text == "\\itshape" or cmd_text == "\\ttfamily" or cmd_text == "\\caption" or cmd_text == "\\caption*" or cmd_text == "\\captionof" or cmd_text == "\\image" then
        if not cmd_in_math then
            local hl = ""
            local icon = ""
            local left_brace = ""
            local right_brace = ""
            if (cmd_text == "\\textbf" or cmd_text == "\\bfseries") and config.options.enable_format_bold then hl = "ArtTexConcealBold" end
            if (cmd_text == "\\textit" or cmd_text == "\\itshape") and config.options.enable_format_italic then hl = "ArtTexConcealItalic" end
            if (cmd_text == "\\textsf" or cmd_text == "\\ttfamily") and config.options.enable_format_mathsf then hl = "ArtTexConcealMathsf" end
            if cmd_text == "\\note" or cmd_text == "\\note*" then 
                hl = "ArtTexConcealNote"
                icon = "󰈉 [ "
                right_brace = " ]"
            end
            if cmd_text == "\\caption" or cmd_text == "\\caption*" or cmd_text == "\\captionof" then
                hl = "ArtTexConcealSpecial"
                icon = "󰦨 "
            end
            if cmd_text == "\\image" then
                hl = "ArtTexConcealImage"
                icon = " "
            end
            
            if hl ~= "" then
                local cmd_sr, cmd_sc, cmd_er, cmd_ec = cmd_node:range()
                extmarks.set(buf, cmd_sr, cmd_sc, cmd_er, cmd_ec, icon, hl)
                
                local target_group = nil
                for child in node:iter_children() do
                    local ct = child:type()
                    if ct == "curly_group" or ct == "curly_group_text" or ct == "curly_group_text_list" or ct == "curly_group_path" then
                        target_group = child
                        break
                    end
                end
                
                if not target_group and node:parent() and node:parent():type() == "curly_group" then
                    target_group = node:parent()
                end
                
                if target_group then
                    for cg_child in target_group:iter_children() do
                        local t = cg_child:type()
                        local csr, csc, cer, cec = cg_child:range()
                        if t == "{" then
                            extmarks.set(buf, csr, csc, cer, cec, left_brace, hl)
                        elseif t == "}" then
                            extmarks.set(buf, csr, csc, cer, cec, right_brace, hl)
                        else
                            extmarks.set_hl(buf, csr, csc, cer, cec, hl)
                        end
                    end
                end
            end
        end
    elseif cmd_text:match("^\\math") then
        if cmd_in_math and config.options.enable_math_conceal then
            local depth = depth_module.get_unified_depth(cmd_node, buf, container_cache)
            local hl_idx = ((depth - 1) % 6) + 1
            local rainbow_hl = "ArtTexConcealRainbow" .. hl_idx
            
            local cmd_sr, cmd_sc, cmd_er, cmd_ec = cmd_node:range()
            extmarks.set_hl(buf, cmd_sr, cmd_sc, cmd_er, cmd_ec, rainbow_hl)
            
            local arg = node:child(1)
            if arg and arg:type() == "curly_group" then
                local inner = ""
                for c in arg:iter_children() do
                    if c:type() ~= "{" and c:type() ~= "}" then
                        inner = vim.treesitter.get_node_text(c, buf):match("^%s*(.-)%s*$") or ""
                        break
                    end
                end
                
                local alpha_type = cmd_text:sub(2)
                local alpha_map = symbols.alphabets[alpha_type]
                if alpha_map then
                    local replaced = ""
                    local as_ascii = config.options.math_alphabets_as_ascii
                    for i = 1, #inner do
                        local c = inner:sub(i, i)
                        if c:match("%s") then
                            replaced = replaced .. " "
                        else
                            replaced = replaced .. (as_ascii and c or (alpha_map[c] or c))
                        end
                    end
                    local sr3, sc3 = node:range()
                    local _, _, er3, ec3 = arg:range()
                    extmarks.set(buf, sr3, sc3, er3, ec3, replaced, "ArtTexConcealMath" .. alpha_type:sub(5):gsub("^%l", string.upper))
                end
            end
        end
    else
        local item = cmd_in_math and symbols.math_words[cmd_text] or symbols.text_words[cmd_text]
        if item then
            local hl = item.hl
            if cmd_in_math and config.options.enable_math_conceal then
                if cmd_text == "\\sqrt" then
                    local depth = depth_module.get_unified_depth(node:child(0) or node, buf, container_cache)
                    local hl_idx = ((depth - 1) % 6) + 1
                    hl = "ArtTexConcealRainbow" .. hl_idx
                end
                local cmd_sr, cmd_sc, cmd_er, cmd_ec = cmd_node:range()
                extmarks.set(buf, cmd_sr, cmd_sc, cmd_er, cmd_ec, item.char, hl)
            elseif not cmd_in_math then
                local cmd_sr, cmd_sc, cmd_er, cmd_ec = cmd_node:range()
                extmarks.set(buf, cmd_sr, cmd_sc, cmd_er, cmd_ec, item.char, hl)
                
                local target_group = nil
                for child in node:iter_children() do
                    local ct = child:type()
                    if ct == "curly_group" or ct == "curly_group_text" or ct == "curly_group_text_list" or ct == "curly_group_path" then
                        target_group = child
                        break
                    end
                end
                if target_group then
                    for cg_child in target_group:iter_children() do
                        local t = cg_child:type()
                        if t == "{" or t == "}" then
                            local csr, csc, cer, cec = cg_child:range()
                            extmarks.set(buf, csr, csc, cer, cec, "", nil)
                        end
                    end
                end
            end
        end
    end
end

function M.dispatch.structural(node, buf, name, math_zones)
    local in_math = mathzone.is_in_mathzone_list(math_zones, node:range())
    if in_math then return end
    
    local hl_map = {
        chapter = "ArtTexConcealChapter",
        section = "ArtTexConcealSection",
        subsection = "ArtTexConcealSubSection",
        subsubsection = "ArtTexConcealSubSubSection",
        label = "ArtTexConcealLabel",
        ref = "ArtTexConcealRef",
        caption = "ArtTexConcealSpecial",
        cite = "ArtTexConcealNote",
        includegraphics = "ArtTexConcealImage"
    }
    local icon_map = {
        chapter = "¶",
        section = "§",
        subsection = "§§",
        subsubsection = "§§§",
        label = "󰃳 ",
        ref = "󰌷 ",
        caption = "󰦨 ",
        cite = "󰌷 ",
        includegraphics = " "
    }
    local hl = hl_map[name]
    local icon = icon_map[name]
    
    local cmd_node = node:child(0)
    if cmd_node then
        local sr, sc, er, ec = cmd_node:range()
        extmarks.set(buf, sr, sc, er, ec, icon, hl)
    end
    
    for child in node:iter_children() do
        if child:type() == "curly_group" or child:type() == "curly_group_text" or child:type() == "curly_group_text_list" or child:type() == "curly_group_path" then
            for cg_child in child:iter_children() do
                local t = cg_child:type()
                local csr, csc, cer, cec = cg_child:range()
                if t == "{" or t == "}" then
                    extmarks.set(buf, csr, csc, cer, cec, "", nil)
                else
                    extmarks.set_hl(buf, csr, csc, cer, cec, hl)
                end
            end
        end
    end
end

M.dispatch.chapter = M.dispatch.structural
M.dispatch.section = M.dispatch.structural
M.dispatch.subsection = M.dispatch.structural
M.dispatch.subsubsection = M.dispatch.structural
M.dispatch.label = M.dispatch.structural
M.dispatch.ref = M.dispatch.structural
M.dispatch.caption = M.dispatch.structural
M.dispatch.cite = M.dispatch.structural
M.dispatch.includegraphics = M.dispatch.structural

function M.dispatch.sub(node, buf, name, math_zones)
    local in_math = mathzone.is_in_mathzone_list(math_zones, node:range())
    if not in_math or not config.options.enable_math_conceal then return end
    local first_child = node:child(0)
    local second_child = node:child(1)
    if not first_child or not second_child then return end
    
    local inner = ""
    if second_child:type() == "curly_group" then
        for c in second_child:iter_children() do
            if c:type() ~= "{" and c:type() ~= "}" then
                inner = vim.treesitter.get_node_text(c, buf):match("^%s*(.-)%s*$") or ""
                break
            end
        end
    else
        inner = vim.treesitter.get_node_text(second_child, buf):match("^%s*(.-)%s*$") or ""
    end

    local map = symbols.subscripts
    local replaced = ""
    local can_conceal = true
    
    if inner:match("^\\") then
        local mapped = map[inner]
        if mapped then replaced = mapped else can_conceal = false end
    else
        for i = 1, #inner do
            local c = inner:sub(i, i)
            if c:match("%s") then replaced = replaced .. " "
            elseif map[c] then replaced = replaced .. map[c]
            else can_conceal = false break end
        end
    end
    
    if can_conceal then
        local sr, sc = node:range()
        local _, _, er, ec = second_child:range()
        extmarks.set(buf, sr, sc, er, ec, replaced, "ArtTexConcealSub")
    end
end

function M.dispatch.sup(node, buf, name, math_zones)
    local in_math = mathzone.is_in_mathzone_list(math_zones, node:range())
    if not in_math or not config.options.enable_math_conceal then return end
    local first_child = node:child(0)
    local second_child = node:child(1)
    if not first_child or not second_child then return end
    
    local inner = ""
    if second_child:type() == "curly_group" then
        for c in second_child:iter_children() do
            if c:type() ~= "{" and c:type() ~= "}" then
                inner = vim.treesitter.get_node_text(c, buf):match("^%s*(.-)%s*$") or ""
                break
            end
        end
    else
        inner = vim.treesitter.get_node_text(second_child, buf):match("^%s*(.-)%s*$") or ""
    end

    local map = symbols.superscripts
    local replaced = ""
    local can_conceal = true
    
    if inner:match("^\\") then
        local mapped = map[inner]
        if mapped then replaced = mapped else can_conceal = false end
    else
        for i = 1, #inner do
            local c = inner:sub(i, i)
            if c:match("%s") then replaced = replaced .. " "
            elseif map[c] then replaced = replaced .. map[c]
            else can_conceal = false break end
        end
    end
    
    if can_conceal then
        local sr, sc = node:range()
        local _, _, er, ec = second_child:range()
        extmarks.set(buf, sr, sc, er, ec, replaced, "ArtTexConcealSuper")
    end
end

function M.dispatch.word(node, buf, name, math_zones)
    local in_math = mathzone.is_in_mathzone_list(math_zones, node:range())
    if in_math and config.options.enable_math_conceal then
        local txt = vim.treesitter.get_node_text(node, buf)
        if txt == "\\#" then
            local sr, sc, er, ec = node:range()
            extmarks.set(buf, sr, sc, er, ec, "#", "ArtTexConcealSpecial")
        end
    end
end

return M
