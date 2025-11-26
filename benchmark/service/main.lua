local Skynet = require "skynet"
require "skynet.manager"
local sformat = string.format

local testcases = {"lua_forloop", "lua_arrayinsertion", "lua_capi"}

local function print_result(result)
    for _, v in ipairs(result) do
        print(sformat("testcase:%40s \t cost:%.2fms", v.tag, v.cost/1000000))
    end
end

Skynet.start(function()
    print("Running all testcases")
    for _, case in ipairs(testcases) do
        -- 每个用例文件，起一个单独的 lua 虚拟机，比较干净
        local ok, service = pcall(Skynet.newservice, "cases/main", case)
        if not ok then
            print("Failed to start case " .. case)
        end
        local result = Skynet.call(service, "lua", "run")
        print_result(result)
        Skynet.kill(service)
    end
    Skynet.abort()
end)