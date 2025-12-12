local desc=[[
验证 sproto 消息 encode / decode 能力。
考虑对 sproto.encode/sproto.decode 处理能力，lua 表： {a=1,b=2,c={1,2,3}}。

sproto pack -> 序列化简单 lua table, 5w 次
sproto unpack -> 反序列化 lua table, 5w 次
]]

local T = require "tutils"
local C = require "common"

local function run()
    local count = 5*10000
    local sp = C.create_sproto_codec()

    for _, t in ipairs {"simple_message", "normal_message"} do
        local m = C.serialize_messages[t]
        local r
        r = T.runit(("sproto pack(%s)"):format(t), count, function()
            sp:encode(t, m)
        end)
        T.record(r)

        local code = sp:encode(t, m)
        r = T.runit(("sproto unpack(%s)"):format(t), count, function()
            sp:decode(t, code)
        end)
        T.record(r)
    end
end

return {
    run = run,
    desc = desc,
}
