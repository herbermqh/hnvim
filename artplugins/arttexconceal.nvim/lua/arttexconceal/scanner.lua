local mathzone = require("arttexconceal.mathzone")
local extmarks = require("arttexconceal.extmarks")
local symbols = require("arttexconceal.symbols")
local config = require("arttexconceal.config")

local M = {}

local function get_unified_depth(target_node, buf)
    local depth = 1
    
    local p = target_node:parent()
    while p do
        local pt = p:type()
        if pt == "curly_group" or pt == "curly_group_text" or pt == "math_delimiter" or pt == "generic_environment" or pt == "math_environment" then
            depth = depth + 1
        end
        p = p:parent()
    end
    
    local is_structural_boundary = false
    local node_type = target_node:type()
    if node_type == "{" or node_type == "}" or node_type == "\\left" or node_type == "\\right" or node_type == "\\begin" or node_type == "\\end" then
        is_structural_boundary = true
    end
    
    local parent_type = target_node:parent() and target_node:parent():type()
    if parent_type == "math_delimiter" and (node_type == "(" or node_type == ")" or node_type == "[" or node_type == "]") then
        is_structural_boundary = true
    end
    
    if is_structural_boundary then
        depth = depth - 1
    end

    local container = target_node:parent()
    while container do
        local ct = container:type()
        if ct == "curly_group" or ct == "curly_group_text" or ct == "math_delimiter" or ct == "math_environment" or ct == "inline_formula" or ct == "displayed_equation" or ct == "generic_environment" or ct == "source_file" then
            break
        end
        container = container:parent()
    end
    
    if container then
        local flat_depth = 0
        local is_close = (node_type == ")" or node_type == "]")
        local target_id = target_node:id()
        local found = false
        
        local function traverse(n)
            if found then return end
            if n:id() == target_id then
                found = true
                return
            end
            local t = n:type()
            
            local is_boundary = false
            local pt = n:parent() and n:parent():type()
            if pt == "math_delimiter" and (t == "(" or t == ")" or t == "[" or t == "]") then
                is_boundary = true
            end
            
            if not is_boundary then
                if t == "(" or t == "[" then
                    flat_depth = flat_depth + 1
                elseif t == ")" or t == "]" then
                    flat_depth = flat_depth - 1
                elseif t == "command_name" then
                    local txt = vim.treesitter.get_node_text(n, buf)
                    if txt == "\\{" then flat_depth = flat_depth + 1
                    elseif txt == "\\}" then flat_depth = flat_depth - 1
                    end
                end
            end
            for child in n:iter_children() do
                local ct = child:type()
                if ct ~= "curly_group" and ct ~= "curly_group_text" and ct ~= "math_delimiter" and ct ~= "math_environment" and ct ~= "inline_formula" and ct ~= "displayed_equation" and ct ~= "generic_environment" then
                    traverse(child)
                end
            end
        end
        
        for child in container:iter_children() do
            local ct = child:type()
            if ct ~= "curly_group" and ct ~= "curly_group_text" and ct ~= "math_delimiter" and ct ~= "math_environment" and ct ~= "inline_formula" and ct ~= "displayed_equation" and ct ~= "generic_environment" then
                traverse(child)
            end
            if found then break end
        end
        
        if is_close and not is_structural_boundary then
            flat_depth = flat_depth - 1
        end
        
        depth = depth + math.max(0, flat_depth)
    end
    
    return math.max(1, depth)
end

function M.process_lines(buf, first_row, last_row)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    
    local ok, parser = pcall(vim.treesitter.get_parser, buf, "latex")
    if not ok or not parser then return end
    
    local tree = parser:parse({first_row, last_row})[1]
    if not tree then return end
    local root = tree:root()
    
    local math_zones = mathzone.get_math_zones(buf, root, first_row, last_row)
    local handled_literals = {}
    
    local lines = vim.api.nvim_buf_get_lines(buf, first_row, last_row, false)
    for i, line in ipairs(lines) do
        local r = first_row + i - 1
        
        -- Exact string matching for text/math literals (outside TS to handle simple replacements)
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
    
    local ok_q, query = pcall(vim.treesitter.query.parse, "latex", [[
        (generic_command) @cmd
        (chapter) @chapter
        (section) @section
        (subsection) @subsection
        (subsubsection) @subsubsection
        (caption) @caption
        (label_definition) @label
        (label_reference) @ref
        (subscript) @sub
        (superscript) @sup
        (word) @word
        "(" @bracket
        ")" @bracket
        "[" @bracket
        "]" @bracket
        "\\left" @delim
        "\\right" @delim
    ]])
    if not ok_q then return end
    
    local math_zones = mathzone.get_math_zones(buf, root, first_row, last_row)
    
    for id, node in query:iter_captures(root, buf, first_row, last_row) do
        local name = query.captures[id]
        
        if name == "bracket" then
            local in_math = mathzone.is_in_mathzone_list(math_zones, node:range())
            if in_math and config.options.enable_math_conceal then
                local txt = vim.treesitter.get_node_text(node, buf)
                local depth = get_unified_depth(node, buf)
                local hl_idx = ((depth - 1) % 6) + 1
                local sr, sc, er, ec = node:range()
                extmarks.set(buf, sr, sc, er, ec, txt, "ArtTexConcealRainbow" .. hl_idx)
            end
            
        elseif name == "delim" then
            local in_math = mathzone.is_in_mathzone_list(math_zones, node:range())
            if in_math and config.options.enable_math_conceal then
                local sr, sc, er, ec = node:range()
                extmarks.set(buf, sr, sc, er, ec, "", "")
            end
            
        elseif name == "cmd" then
            local sr, sc = node:range()
            local in_math = mathzone.is_in_mathzone_list(math_zones, node:range())
            
            if not in_math and handled_literals[sr .. "," .. sc] then
                goto ts_continue
            end
            if in_math and handled_literals[sr .. "," .. sc] then
                goto ts_continue
            end
            
            local cmd_node = node:child(0)
            if cmd_node and cmd_node:type() == "command_name" then
                local cmd_text = vim.treesitter.get_node_text(cmd_node, buf)
                local in_math = mathzone.is_in_mathzone_list(math_zones, cmd_node:range())
                
                if cmd_text == "\\frac" or cmd_text == "\\dfrac" or cmd_text == "\\tfrac" or cmd_text == "\\cfrac" or cmd_text == "\\binom" or cmd_text == "\\dbinom" or cmd_text == "\\tbinom" then
                    if in_math and config.options.enable_math_conceal then
                        local arg1 = node:child(1)
                        local arg2 = node:child(2)
                        if arg1 and arg2 and arg1:type() == "curly_group" and arg2:type() == "curly_group" then
                            local t1 = vim.treesitter.get_node_text(arg1, buf):gsub("[{}]", ""):match("^%s*(.-)%s*$")
                            local t2 = vim.treesitter.get_node_text(arg2, buf):gsub("[{}]", ""):match("^%s*(.-)%s*$")
                            local frac_char = symbols.fractions[t1 .. "/" .. t2]
                            if frac_char then
                                local depth = get_unified_depth(node:child(0) or node, buf)
                                local hl_idx = ((depth - 1) % 6) + 1
                                
                                local sr, sc = node:range()
                                local _, _, er, ec = arg2:range()
                                extmarks.set(buf, sr, sc, er, ec, frac_char, "ArtTexConcealRainbow" .. hl_idx)
                            end
                        end
                    end
                elseif cmd_text == "\\{" or cmd_text == "\\}" then
                    if in_math and config.options.enable_math_conceal then
                        local depth = get_unified_depth(cmd_node, buf)
                        local hl_idx = ((depth - 1) % 6) + 1
                        local sr, sc, er, ec = node:range()
                        local char = cmd_text == "\\{" and "{" or "}"
                        extmarks.set(buf, sr, sc, er, ec, char, "ArtTexConcealRainbow" .. hl_idx)
                    end
                elseif cmd_text == "\\textbf" or cmd_text == "\\textit" or cmd_text == "\\textsf" or cmd_text == "\\note" or cmd_text == "\\note*" or cmd_text == "\\bfseries" or cmd_text == "\\itshape" or cmd_text == "\\ttfamily" or cmd_text == "\\caption" or cmd_text == "\\caption*" or cmd_text == "\\captionof" then
                    if not in_math then
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
                            left_brace = ""
                            right_brace = " ]"
                        end
                        if cmd_text == "\\caption" or cmd_text == "\\caption*" or cmd_text == "\\captionof" then
                            hl = "ArtTexConcealSpecial"
                            icon = "󰦨 "
                            left_brace = ""
                            right_brace = ""
                        end
                        
                        if hl ~= "" then
                            -- Hide command name and optionally show icon
                            local sr, sc, er, ec = cmd_node:range()
                            extmarks.set(buf, sr, sc, er, ec, icon, hl)
                            
                            -- Process curly_group if \textbf-like (child is curly_group)
                            local target_group = nil
                            for child in node:iter_children() do
                                if child:type() == "curly_group" then
                                    target_group = child
                                    break
                                end
                            end
                            
                            -- If \bfseries-like, it has no curly_group child, but might be inside a curly_group parent
                            if not target_group and node:parent() and node:parent():type() == "curly_group" then
                                target_group = node:parent()
                            end
                            
                            if target_group then
                                for cg_child in target_group:iter_children() do
                                    local t = cg_child:type()
                                    if t == "{" then
                                        local csr, csc, cer, cec = cg_child:range()
                                        extmarks.set(buf, csr, csc, cer, cec, left_brace, hl)
                                    elseif t == "}" then
                                        local csr, csc, cer, cec = cg_child:range()
                                        extmarks.set(buf, csr, csc, cer, cec, right_brace, hl)
                                    else
                                        local csr, csc, cer, cec = cg_child:range()
                                        extmarks.set_hl(buf, csr, csc, cer, cec, hl)
                                    end
                                end
                            end
                        end
                    end
                elseif cmd_text:match("^\\math") then
                    if in_math and config.options.enable_math_conceal then
                        local arg = node:child(1)
                        if arg and arg:type() == "curly_group" then
                            local inner = vim.treesitter.get_node_text(arg, buf):gsub("[{}]", ""):match("^%s*(.-)%s*$")
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
                                local sr, sc = node:range()
                                local _, _, er, ec = arg:range()
                                extmarks.set(buf, sr, sc, er, ec, replaced, "ArtTexConcealMath" .. alpha_type:sub(5):gsub("^%l", string.upper))
                            end
                        end
                    end
                else
                    local item = in_math and symbols.math_words[cmd_text] or symbols.text_words[cmd_text]
                    if item then
                        local hl = item.hl
                        if in_math and config.options.enable_math_conceal then
                            if cmd_text == "\\sqrt" then
                                local depth = get_unified_depth(node:child(0) or node, buf)
                                local hl_idx = ((depth - 1) % 6) + 1
                                hl = "ArtTexConcealRainbow" .. hl_idx
                            end
                            local sr, sc, er, ec = cmd_node:range()
                            extmarks.set(buf, sr, sc, er, ec, item.char, hl)
                        elseif not in_math then
                            local sr, sc, er, ec = cmd_node:range()
                            extmarks.set(buf, sr, sc, er, ec, item.char, hl)
                            
                            -- Process curly_group to hide braces
                            for child in node:iter_children() do
                                if child:type() == "curly_group" then
                                    for cg_child in child:iter_children() do
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
            end
            
        elseif name == "chapter" or name == "section" or name == "subsection" or name == "subsubsection" or name == "label" or name == "ref" or name == "caption" then
            if not in_math then
                local hl_map = {
                    chapter = "ArtTexConcealChapter",
                    section = "ArtTexConcealSection",
                    subsection = "ArtTexConcealSubSection",
                    subsubsection = "ArtTexConcealSubSubSection",
                    label = "ArtTexConcealLabel",
                    ref = "ArtTexConcealRef",
                    caption = "ArtTexConcealSpecial"
                }
                local icon_map = {
                    chapter = "¶",
                    section = "§",
                    subsection = "§§",
                    subsubsection = "§§§",
                    label = "󰃳",
                    ref = "󰌷",
                    caption = "󰦨 "
                }
                local hl = hl_map[name]
                local icon = icon_map[name]
                
                -- Hide command name and show icon
                local cmd_node = node:child(0)
                if cmd_node then
                    local sr, sc, er, ec = cmd_node:range()
                    extmarks.set(buf, sr, sc, er, ec, icon, hl)
                end
                
                -- Process curly_group
                for child in node:iter_children() do
                    if child:type() == "curly_group" or child:type() == "curly_group_text" or child:type() == "curly_group_text_list" or child:type() == "curly_group_path" then
                        for cg_child in child:iter_children() do
                            local t = cg_child:type()
                            if t == "{" or t == "}" then
                                local sr, sc, er, ec = cg_child:range()
                                extmarks.set(buf, sr, sc, er, ec, "", nil)
                            else
                                local sr, sc, er, ec = cg_child:range()
                                extmarks.set_hl(buf, sr, sc, er, ec, hl)
                            end
                        end
                    end
                end
            end
elseif name == "sub" or name == "sup" then
            if in_math and config.options.enable_math_conceal then
                local first_child = node:child(0)
                local second_child = node:child(1)
                
                if first_child and second_child then
                    local inner = vim.treesitter.get_node_text(second_child, buf):gsub("[{}]", ""):match("^%s*(.-)%s*$")
                    local map = (name == "sub") and symbols.subscripts or symbols.superscripts
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
                        local hl = (name == "sub") and "ArtTexConcealSub" or "ArtTexConcealSuper"
                        extmarks.set(buf, sr, sc, er, ec, replaced, hl)
                    end
                end
            end
            
        elseif name == "word" then
            if in_math and config.options.enable_math_conceal then
                local txt = vim.treesitter.get_node_text(node, buf)
                if txt == "\\#" then
                    local sr, sc, er, ec = node:range()
                    extmarks.set(buf, sr, sc, er, ec, "#", "ArtTexConcealSpecial")
                end
            end
        end
        ::ts_continue::
    end
end

return M
