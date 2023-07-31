local function deep_copy(any)
    if type(any) ~= 'table' then return any end

    local result = {}
    for key, value in pairs(any) do
        result[key] = deep_copy(value)
    end
    return result
end

return deep_copy
