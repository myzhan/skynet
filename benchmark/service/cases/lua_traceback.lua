local desc = [[
lua traceback 性能测试
]]

local T = require "tutils"

local norm_config = {
    show_parameter = true,  -- 是否打印参数值
    show_upvalue = true,   -- 是否打印upvalue值
    show_localvalue = false, -- 是否打印localvalue值
    max_print_depth = 2,    -- table打印最大深度
    max_print_table = 100,  -- table打印最大长度
}

local quick_config = {
    levels2 = 0,            -- 参数信息显示条数
    show_parameter = false,  -- 是否打印参数值
    show_upvalue = false,   -- 是否打印upvalue值
    show_localvalue = false, -- 是否打印localvalue值
    max_print_depth = 2,    -- table打印最大深度
    max_print_table = 100,  -- table打印最大长度
}


local rawtraceback = debug.traceback
local cases = {
    "rawtraceback", 1000, rawtraceback, -- luacheck: ignore
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
