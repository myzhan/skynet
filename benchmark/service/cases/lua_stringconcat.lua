local desc = [[
lua string concat 性能, 每种拼接字符串方式执行 1000次。
]]

local T = require "tutils"

local function inline_concat()
    local bs = string.rep("INLINE----", 1000)
    local _ = bs .. bs .. bs .. bs .. bs .. bs .. bs .. bs .. bs .. bs
end

local function separate_concat()
    local bs = string.rep("SEPARATE--", 1000)
    local s = bs
    s = s .. bs
    s = s .. bs
    s = s .. bs
    s = s .. bs
    s = s .. bs
    s = s .. bs
    s = s .. bs
    s = s .. bs
    s = s .. bs -- luacheck: ignore s
end

local function loop_concat()
    local bs = string.rep("LOOP------", 1000)
    local s = bs
    for _ = 1, 9 do
        s = s .. bs
    end
end

local function table_concat()
    local bs = string.rep("CONCAT-----", 1000)
    local t = {bs, bs, bs, bs, bs, bs, bs, bs, bs, bs}
    local concat = table.concat
    local _ = concat(t)
end

local function string_format_concat()
    local bs = string.rep("FORMAT----", 1000)
    local format = string.format
    local _ = format("%s%s%s%s%s%s%s%s%s%s", bs, bs, bs, bs, bs, bs, bs, bs, bs, bs)
end

local TIMES = 1000
local cases = {
    "inline concat", TIMES, inline_concat,
    "separate concat", TIMES, separate_concat,
    "loop_concat", TIMES, loop_concat,
    "table_concat", TIMES, table_concat,
    "string_format_concat", TIMES, string_format_concat,
}

local function run()
    for i = 1, #cases, 3 do
       local r = T.runit("lua " .. cases[i], cases[i + 1], cases[i + 2])
       T.record(r)
    end
end

return {
    run = run,
    desc = desc,
}
