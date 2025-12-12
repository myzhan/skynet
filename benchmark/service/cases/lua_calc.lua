local desc = [[
验证 lua 性能。

matmul1000x1000 -> lua 中进行大量数学计算操作。
10add/10sub/10mul/10div -> 分别执行10次加减乘除
]]

-- [TODO] 更合适的用例，能直观了解 lua 不同方面的 benchmark。

local T = require "tutils"

local function matmul1000x1000()
    -- Writen by Attractive Chaos; distributed under the MIT license

    local matrix = {}

    function matrix.T(a)
        local m, n, x = #a, #a[1], {};
        for i = 1, n do
            x[i] = {};
            for j = 1, m do x[i][j] = a[j][i] end
        end
        return x;
    end

    function matrix.mul(a, b)
        assert(#a[1] == #b);
        local m, n, p, x = #a, #a[1], #b[1], {};
        local c = matrix.T(b); -- transpose for efficiency
        for i = 1, m do
            x[i] = {}
            local xi = x[i];
            for j = 1, p do
                local sum, ai, cj = 0, a[i], c[j];
                -- for luajit, caching c[j] or not makes no difference; lua is not so clever
                for k = 1, n do sum = sum + ai[k] * cj[k] end
                xi[j] = sum;
            end
        end
        return x;
    end

    local function matgen(n)
        local a, tmp = {}, 1. / n / n;
        for i = 1, n do
            a[i] = {}
            for j = 1, n do
                a[i][j] = tmp * (i - j) * (i + j - 2)
            end
        end
        return a;
    end


    local n = 1000
    n = math.floor(n/2) * 2;
    matrix.mul(matgen(n), matgen(n))
end

local function addsubmuldiv()
    local a = 1
    a = a + 1.1
    a = a + 2.2
    a = a + 3.3
    a = a + 4.4
    a = a + 5.5
    a = a + 6.6
    a = a + 7.7
    a = a + 8.8
    a = a + 9.9
    a = a + 10.10

    a = a - 1.1
    a = a - 2.2
    a = a - 3.3
    a = a - 4.4
    a = a - 5.5
    a = a - 6.6
    a = a - 7.7
    a = a - 8.8
    a = a - 9.9
    a = a - 10.10

    a = a * 1.1
    a = a * 2.2
    a = a * 3.3
    a = a * 4.4
    a = a * 5.5
    a = a * 6.6
    a = a * 7.7
    a = a * 8.8
    a = a * 9.9
    a = a * 10.10

    a = a / 1.1
    a = a / 2.2
    a = a / 3.3
    a = a / 4.4
    a = a / 5.5
    a = a / 6.6
    a = a / 7.7
    a = a / 8.8
    a = a / 9.9
    a = a / 10.10 -- luacheck:ignore
end

local cases = {
    "1000x1000 matrix multiply", 1, matmul1000x1000,
    "10add/10sub/10mul/10div", 1000, addsubmuldiv
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
