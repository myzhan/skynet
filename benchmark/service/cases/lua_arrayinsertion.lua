local desc = [[
lua 数组 插入性能测试。
]]

local T = require "tutils"

local MAX_TIMES = 10000000
local function table_insert()
    local a = {n = 0}
    local max_times = MAX_TIMES
    local tinsert = table.insert
    for times = 1, max_times do
        tinsert(a, times)
    end
end

local function a_times_insert()
    local a = {n = 0} -- luacheck: ignore a
    local max_times = MAX_TIMES
    for times = 1, max_times do
        a[times] = times
    end
end

local function a_a_insert()
    local a = {n = 0} -- luacheck: ignore a
    local max_times = MAX_TIMES
    for times = 1, max_times do
        a[#a + 1] = times
    end
end

local function a_count_insert()
    local a = {n = 0} -- luacheck: ignore a
    local count = 1
    local max_times = MAX_TIMES
    for times = 1, max_times do
        a[count] = times
        count = count + 1
    end
end

local function a_a_n_insert()
    local a = {n = 0} -- luacheck: ignore a
    local max_times = MAX_TIMES
    for times = 1, max_times do
        a.n = a.n + 1
        a[a.n] = times
    end
end

local cases = {
    "table insert", 1, table_insert,
    "a[times] insert", 1, a_times_insert,
    "a[#a + 1] insert", 1, a_a_insert,
    "a[count] insert", 1, a_count_insert,
    "a[a.n] insert", 1, a_a_n_insert,
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
