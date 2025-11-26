local Skynet    = require "skynet"

local NS_PER_MS  = 1000000
local NS_PER_SEC = 1000000000

local function ns2ms(ns)
    return ns / NS_PER_MS
end

local function ns2sec(ns)
    return ns / NS_PER_SEC
end

local function runit(tag, times, f, ...)
    collectgarbage "stop"
    collectgarbage "collect"

    local t0 = Skynet.hpc()
    for _ = 1, times do
        f(...)
    end
    local t1 = Skynet.hpc()

    collectgarbage "restart"
    return {tag = tag, times = times, cost = (t1 - t0)}
end

local RESULTS = {}
local function record(tag, times, costns, verbose)
    if type(tag) == "table" then
        table.insert(RESULTS, tag)
    else
        table.insert(RESULTS, {tag = tag, times = times, cost = costns, verbose = verbose})
    end
end

local function distribution(tag, dist)
    table.insert(RESULTS, {tag = tag, distribution = dist})
end

local function delta(f)
    local data = {}
    for k, v in pairs(f()) do
        data[k] = v
    end
    return function()
        for k, v in pairs(f()) do
            data[k] = v - (data[k] or 0)
        end
        return data
    end
end

local function clear_results()
    RESULTS = {}
end

local function results()
    return RESULTS
end

local function gather(...)
    local data = {}
    local params = table.pack(...)
    for _, v in ipairs(params) do
        assert(type(v) == "table")
        for sk, sv in pairs(v) do
            data[sk] = sv
        end
    end
    return data
end

local function optval(arg, field, default)
    local val
    if arg then
        val = arg[field]
    end
    return val or default
end

return {
    ns2ms = ns2ms,
    ns2sec = ns2sec,

    runit = runit,
    delta = delta,
    gather = gather,

    record = record,
    distribution = distribution,

    clear_results = clear_results,
    results = results,

    optval = optval
}
