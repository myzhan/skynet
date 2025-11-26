local CASE_NAME = ...

local Skynet = require "skynet"
local T = require "tutils"
local Case = require(CASE_NAME)

local Command = {}

function Command.run(args)
    Case.run(args)
    return T.results()
end

-- 每个
Skynet.start(function ()
    math.randomseed(0)
    Skynet.dispatch("lua", function (_, _, cmd, ...)
        local f = Command[cmd]
        if f then
            return Skynet.retpack(f(...))
        end
    end)
end)