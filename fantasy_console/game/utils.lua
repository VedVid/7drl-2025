local utils = {}

function utils.has_value (table, value)
    for i, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

return utils
