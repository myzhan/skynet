local desc =[[
验证 lua 消息 encode / decode 能力。
考虑对 skynet.pack/skynet.unpack 处理能力，lua 表： {a=1,b=2,c={1,2,3}}。

lua pack -> 序列化简单 lua table, 5w 次
lua unpack -> 反序列化简单 lua table, 5w 次
lua unpackstring -> 反序列化字符串数据块, 5w 次
]]

local Skynet = require "skynet"

local T = require "tutils"
local C = require "common"

local function run()
    local count = 5*10000

    local r
    local bs = {}

    -- warm up
    for i=1, count*2 do
        bs[i] = true
    end

    for _, t in ipairs {"simple_message", "normal_message"} do
        local m = C.serialize_messages[t]
        -- 序列化简单 lua table
        local i = 1
        r = T.runit(("lua pack(%s)"):format(t), count, function()
            local msg, sz = Skynet.pack(m)
            bs[i] = msg
            bs[i+1] = sz
            i = i+2
        end)
        T.record(r)

        -- clear
        for j=1, i-1, 2 do
            Skynet.trash(bs[j], bs[j+1])
        end

        -- 反序列化简单 lua table
        local msg, sz = Skynet.pack(m)
        r = T.runit(("lua unpack(%s)"):format(t), count, function()
            Skynet.unpack(msg, sz)
        end)
        T.record(r)

        -- 反序列化字符串包
        local str = Skynet.tostring(msg, sz)
        r = T.runit(("lua unpackstring(%s)"):format(t), count, function()
            Skynet.unpack(str)
        end)
        T.record(r)

        Skynet.trash(msg, sz)
    end
end

return {
    run = run,
    desc = desc,
}
