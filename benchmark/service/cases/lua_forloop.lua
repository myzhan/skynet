local desc = [[
lua for loop 性能测试。
]]

local T = require "tutils"

local g_a = {}
for i = 1, 100 do
	g_a[i] = i
end
local length = #g_a

local function for_loop_by_pairs()
    local a = g_a
    for _, v in pairs(a) do
        local _ = v
    end
end

local function for_loop_by_ipairs()
    local a = g_a
    for _, v in ipairs(a) do
        local _ = v
    end
end

local function for_loop_by_literal_length()
    local a = g_a
    for i = 1, 100 do
        local _ = a[i]
    end
end

local function for_loop_by_sharp()
    local a = g_a
    for i = 1, #a do
        local _ = a[i]
    end
end

local function for_loop_by_const_length()
    local a = g_a
    local len = length
    for i = 1, len do
        local _ = a[i]
    end
end


local TIMES = 100000
local cases = {
    "for loop by pairs", TIMES, for_loop_by_pairs,
    "for loop by ipairs", TIMES, for_loop_by_ipairs,
    "for loop by literal length", TIMES, for_loop_by_literal_length,
    "for loop by sharp", TIMES, for_loop_by_sharp,
    "for loop by const length", TIMES, for_loop_by_const_length,
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
