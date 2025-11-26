local desc = [[
lua 和 C 交互代价

lua call c dummy func -> lua 调用一个空的 c 函数
lua call lua dummy func -> lua 调用一个空的 lua 函数
lua pcall lua dummy func -> lua pcall 调用一个空的 lua 函数
lua xpcall lua dummy func -> lua xpcall 调用一个空的 lua 函数
]]

local SkynetCore = require "skynet.core"

local T = require "tutils"

local function run()
    local cdummy = SkynetCore.dummy
    local ldummy = function() end

    local reqs = 1000*10000

    local r

    r = T.runit("lua call c dummy func", reqs, cdummy, 1, 2, 3)
    T.record(r)

    r = T.runit("lua call lua dummy func", reqs, ldummy, 1, 2, 3)
    T.record(r)

    r = T.runit("lua pcall lua dummy func", reqs, function() pcall(ldummy, 1, 2, 3) end)
    T.record(r)

    r = T.runit("lua xpcall lua dummy func", reqs, function() xpcall(ldummy, debug.traceback) end)
    T.record(r)
end

return {
    run = run,
    desc = desc,
}
