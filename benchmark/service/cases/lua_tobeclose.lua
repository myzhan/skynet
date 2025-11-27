local desc = [[
lua to-be-close 性能测试
]]

local T = require "tutils"

local close_f = function()
end

local function normal_func()
    close_f()
end

local t = {}
local mt = {__close=close_f}
local function tobeclose_func()
    local _ <close> = setmetatable(t, mt)
end

local function pcall_func()
    setmetatable(t, mt)
    pcall(close_f)
end

local cases = {
    "normal_function", 100000, normal_func,
    "to-be-closed-function", 100000, tobeclose_func,
    "pcall_function", 100000, pcall_func,
}

local function run()
    for i = 1, #cases, 3 do
        local r = T.runit("lua " .. cases[i], cases[i+1], cases[i+2])
        T.record(r)
    end
end


return {
    run = run,
    desc = desc,
}
