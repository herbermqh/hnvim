local M = {}

function M.get_container_flat_depths(container, buf, container_cache)
    local container_id = container:id()
    if container_cache and container_cache[container_id] then
        return container_cache[container_id]
    end

    local depths = {}
    local current_flat_depth = 0

    local function traverse(n)
        depths[n:id()] = current_flat_depth
        
        local t = n:type()
        local is_boundary = false
        local pt = n:parent() and n:parent():type()
        if pt == "math_delimiter" and (t == "(" or t == ")" or t == "[" or t == "]") then
            is_boundary = true
        end
        
        if not is_boundary then
            if t == "(" or t == "[" then
                current_flat_depth = current_flat_depth + 1
            elseif t == ")" or t == "]" then
                current_flat_depth = current_flat_depth - 1
            elseif t == "command_name" then
                local txt = vim.treesitter.get_node_text(n, buf)
                if txt == "\\{" then current_flat_depth = current_flat_depth + 1
                elseif txt == "\\}" then current_flat_depth = current_flat_depth - 1
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
    end

    if container_cache then
        container_cache[container_id] = depths
    end
    return depths
end

function M.get_unified_depth(target_node, buf, container_cache)
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
        local flat_depths = M.get_container_flat_depths(container, buf, container_cache)
        local flat_depth = flat_depths[target_node:id()] or 0
        local is_close = (node_type == ")" or node_type == "]")
        
        if is_close and not is_structural_boundary then
            flat_depth = flat_depth - 1
        end
        
        depth = depth + math.max(0, flat_depth)
    end
    
    return math.max(1, depth)
end

return M
