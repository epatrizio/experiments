-- https://www.lua.org/pil/9.2.html Lua book 9.2 – Pipes and Filters
-- https://www.whoop.ee/post/understanding-coroutines.html

-- #WIP 

local vegetables_stack = {}

local function vstack_set(prod)
    return coroutine.create(function()
        local status, vege = coroutine.resume(prod)
        while status and vege ~= nil do
            table.insert(vegetables_stack, vege)
            print("producer", status, vege)
            status, vege = coroutine.resume(prod)
        end
    end)
end

local function vstack_get()
    return coroutine.create(function()
        while #vegetables_stack > 0 do
            local vege = table.remove(vegetables_stack)
            coroutine.yield(vege)
        end
    end)
end

local function producer()
    return coroutine.create(function()
        for i = 1, 10 do
            coroutine.yield("my_vege_" .. i)
        end
    end)
end

local function consumer(vs_get)
    return coroutine.create(function()
        local status, vege = coroutine.resume(vs_get)
        while status and vege ~= nil do
            print("consumer", status, vege)
            status, vege = coroutine.resume(vs_get)
        end
    end)
end

local prod = producer()
local vs_set = vstack_set(prod)

local vs_get = vstack_get()
local cons = consumer(vs_get)

coroutine.resume(vs_set)
coroutine.resume(prod)

coroutine.resume(cons)
coroutine.resume(vs_get)
