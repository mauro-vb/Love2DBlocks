local metatable_functions = {}

local function value_to_string(v)
    if type(v) == "table" then
        local parts = {}
        for k, val in pairs(v) do
            table.insert(parts, tostring(k) .. "=" .. value_to_string(val))
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    else
        return tostring(v)
    end
end

function metatable_functions.pretty_print(object, toprint)
    if type(object) ~= "table" then
        return "Invalid object"
    end
    if type(toprint) ~= "table" then
        return "Invalid field list"
    end

    local output = {}
    for _, field in ipairs(toprint) do
        local value = object[field]
        table.insert(output, field .. "=" .. value_to_string(value or "(nil)"))
    end

    return "[" .. object.name .. "] " .. table.concat(output, ", ")
end

function metatable_functions.make_pretty_print(fields)
    return function(object)
        return metatable_functions.pretty_print(object, fields)
    end
end

return metatable_functions

