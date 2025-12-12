local desc = [[
lua gc 代价。考虑单 vm 大约2g 内存。
]]

local T = require "tutils"

local function run()
    collectgarbage "stop"

    for _ = 1, 40*1000*1000 do
        _ = {}
    end

    local r = T.runit("lua gc 2g memory", 1, collectgarbage, "collect")

    T.record(r)
end

return {
    run = run,
    desc = desc,
}
