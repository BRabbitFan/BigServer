-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2020-12-31 18:28:01
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 18:42:42
-- FilePath     : /BigServer/Service/Gateway/Watchdog.lua
-- Description  : 网关服务---watchdog
-- -----------------------------

local skynet = require "skynet"

local util = require "Util.SvrUtil"

local CMD = {}
local SOCKET = {}
local gate
local login
local agent = {}  ---@type table<fd, agent>

function SOCKET.open(fd, addr)
	util.log("New client from : " .. addr)
	agent[fd] = skynet.newservice("Agent")
	skynet.call(agent[fd], "lua", "start", {
		gate = gate,
		fd = fd,
		watchdog = skynet.self()
	})
end

local function close_agent(fd)
	local a = agent[fd]
	agent[fd] = nil
	if a then
		skynet.call(gate, "lua", "kick", fd)
		-- disconnect never return
		skynet.send(a, "lua", "disconnect")
	end
end

function SOCKET.close(fd)
	print("socket close",fd)
	close_agent(fd)
end

function SOCKET.error(fd, msg)
	print("socket error",fd, msg)
	close_agent(fd)
end

function SOCKET.warning(fd, size)
	-- size K bytes havn't send out in fd
	print("socket warning", fd, size)
end

function SOCKET.data(fd, msg)
end

function CMD.start(conf)
	skynet.call(gate, "lua", "open" , conf)
end

function CMD.close(fd)
	close_agent(fd)
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		if cmd == "socket" then
			local f = SOCKET[subcmd]
			f(...)
			-- socket api don't need return
		else
			local f = assert(CMD[cmd])
			skynet.ret(skynet.pack(f(subcmd, ...)))
		end
	end)
	login = skynet.newservice("Login")
	gate = skynet.newservice("Gate")
end)