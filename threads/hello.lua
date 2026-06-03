local function server(msg)
    -- server stuff ...
    -- suspension: data passing
    coroutine.yield("hello, " .. msg .. "!")
    -- server stuff ...
end

local function client(serv, msg)
    -- create a specific coroutine for a unique server request
    local serv = coroutine.create(serv)
    local status, server_ret_msg = coroutine.resume(serv, msg)
    print(status, server_ret_msg)
end

client(server, "world_1")
client(server, "world_2")
client(server, "world_3")
client(server, "world_4")
