-- DouyinDanmu/Utils/JSON.lua
-- JSON解析工具

DouyinDanmu = DouyinDanmu or {}
DouyinDanmu.JSON = DouyinDanmu.JSON or {}

-- 简单的JSON解析器
-- 注意：这是一个简化版的JSON解析器，仅支持基本功能

-- 解析JSON字符串
function DouyinDanmu.JSON.parse(str)
    if not str or str == "" then
        return nil
    end
    
    -- 移除空白字符
    str = string.gsub(str, "%s+", "")
    
    -- 解析对象或数组
    if string.sub(str, 1, 1) == "{" then
        return DouyinDanmu.JSON.parseObject(str)
    elseif string.sub(str, 1, 1) == "[" then
        return DouyinDanmu.JSON.parseArray(str)
    else
        return nil
    end
end

-- 解析JSON对象
function DouyinDanmu.JSON.parseObject(str)
    local obj = {}
    local i = 2 -- 跳过开始的 {
    local len = string.len(str)
    
    -- 空对象
    if string.sub(str, i, i) == "}" then
        return obj
    end
    
    while i <= len do
        -- 解析键
        if string.sub(str, i, i) ~= "\"" then
            i = i + 1
        else
            local key = ""
            i = i + 1 -- 跳过开始的 "
            
            while i <= len and string.sub(str, i, i) ~= "\"" do
                key = key .. string.sub(str, i, i)
                i = i + 1
            end
            
            i = i + 1 -- 跳过结束的 "
            
            -- 跳过冒号
            while i <= len and string.sub(str, i, i) ~= ":" do
                i = i + 1
            end
            i = i + 1 -- 跳过 :
            
            -- 解析值
            local value, nextIndex = DouyinDanmu.JSON.parseValue(str, i)
            obj[key] = value
            i = nextIndex
            
            -- 跳过逗号或结束括号
            if string.sub(str, i, i) == "," then
                i = i + 1
            elseif string.sub(str, i, i) == "}" then
                break
            end
        end
    end
    
    return obj
end

-- 解析JSON数组
function DouyinDanmu.JSON.parseArray(str)
    local arr = {}
    local i = 2 -- 跳过开始的 [
    local len = string.len(str)
    
    -- 空数组
    if string.sub(str, i, i) == "]" then
        return arr
    end
    
    while i <= len do
        -- 解析值
        local value, nextIndex = DouyinDanmu.JSON.parseValue(str, i)
        table.insert(arr, value)
        i = nextIndex
        
        -- 跳过逗号或结束括号
        if string.sub(str, i, i) == "," then
            i = i + 1
        elseif string.sub(str, i, i) == "]" then
            break
        end
    end
    
    return arr
end

-- 解析JSON值
function DouyinDanmu.JSON.parseValue(str, startIndex)
    local i = startIndex
    local len = string.len(str)
    
    -- 跳过空白字符
    while i <= len and string.match(string.sub(str, i, i), "%s") do
        i = i + 1
    end
    
    -- 解析不同类型的值
    if string.sub(str, i, i) == "{" then
        -- 对象
        local endIndex = DouyinDanmu.JSON.findMatchingBrace(str, i, "{", "}")
        local objStr = string.sub(str, i, endIndex)
        return DouyinDanmu.JSON.parseObject(objStr), endIndex + 1
    elseif string.sub(str, i, i) == "[" then
        -- 数组
        local endIndex = DouyinDanmu.JSON.findMatchingBrace(str, i, "[", "]")
        local arrStr = string.sub(str, i, endIndex)
        return DouyinDanmu.JSON.parseArray(arrStr), endIndex + 1
    elseif string.sub(str, i, i) == "\"" then
        -- 字符串
        i = i + 1 -- 跳过开始的 "
        local value = ""
        while i <= len and string.sub(str, i, i) ~= "\"" do
            value = value .. string.sub(str, i, i)
            i = i + 1
        end
        return value, i + 1 -- 跳过结束的 "
    elseif string.sub(str, i, i + 3) == "true" then
        -- 布尔值 true
        return true, i + 4
    elseif string.sub(str, i, i + 4) == "false" then
        -- 布尔值 false
        return false, i + 5
    elseif string.sub(str, i, i + 3) == "null" then
        -- null
        return nil, i + 4
    else
        -- 数字
        local numStr = ""
        while i <= len and string.match(string.sub(str, i, i), "[0-9%.%-e]") do
            numStr = numStr .. string.sub(str, i, i)
            i = i + 1
        end
        return tonumber(numStr), i
    end
end

-- 查找匹配的括号
function DouyinDanmu.JSON.findMatchingBrace(str, startIndex, openBrace, closeBrace)
    local count = 1
    local i = startIndex + 1
    local len = string.len(str)
    
    while i <= len and count > 0 do
        if string.sub(str, i, i) == openBrace then
            count = count + 1
        elseif string.sub(str, i, i) == closeBrace then
            count = count - 1
        end
        i = i + 1
    end
    
    return i - 1
end

-- 将Lua表转换为JSON字符串
function DouyinDanmu.JSON.stringify(value)
    if value == nil then
        return "null"
    elseif type(value) == "boolean" then
        return value and "true" or "false"
    elseif type(value) == "number" then
        return tostring(value)
    elseif type(value) == "string" then
        return "\"" .. string.gsub(value, "\"", "\\\"") .. "\""
    elseif type(value) == "table" then
        -- 检查是否为数组
        local isArray = true
        local maxIndex = 0
        for k, v in pairs(value) do
            if type(k) ~= "number" or k < 1 or math.floor(k) ~= k then
                isArray = false
                break
            end
            maxIndex = math.max(maxIndex, k)
        end
        
        if isArray and maxIndex > 0 then
            -- 数组
            local items = {}
            for i = 1, maxIndex do
                table.insert(items, DouyinDanmu.JSON.stringify(value[i]))
            end
            return "[" .. table.concat(items, ",") .. "]"
        else
            -- 对象
            local items = {}
            for k, v in pairs(value) do
                table.insert(items, "\"" .. k .. "\":" .. DouyinDanmu.JSON.stringify(v))
            end
            return "{" .. table.concat(items, ",") .. "}"
        end
    else
        return "null" -- 不支持的类型
    end
end

-- 导出JSON函数到全局命名空间
JSON = {
    parse = DouyinDanmu.JSON.parse,
    stringify = DouyinDanmu.JSON.stringify
}
