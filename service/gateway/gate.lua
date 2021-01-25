-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2020-12-31 19:41:13
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-25 21:51:00
-- FilePath     : /BigServer/service/gateway/gate.lua
-- Description  : 网关服务---消息分发
-- -----------------------------

local skynet = require "skynet"
local gateserver = require "snax.gateserver"

-- watchdog地址
local watchdog  ---@type string

-- {句柄->连接信息} 映射表
local connection = {}  ---@type table<fd, connection<fd|ip|client|agent, ...>>

local forwarding = {}  ---@type table<agent, connection<fd|client|agent|ip|mode, ...>>

local handler = {}  ---@type table<_, fun(...)>
local CMD = {}

---网关启动时调用
---@param source number 源地址(客户端)
---@param conf table<watchdog, ...> 配置
function handler.open(source, conf)
	watchdog = conf.watchdog or source
end

---有消息到达时调用
---@param fd number 句柄
---@param msg any msg + sz = 未解包的消息
---@param sz any msg + sz = 未解包的消息
function handler.message(fd, msg, sz)
	-- recv a package, forward it
	local c = connection[fd]
	local agent = c.agent
	if agent then
		-- It's safe to redirect msg directly , gateserver framework will not free msg.
		skynet.redirect(agent, c.client, "client", fd, msg, sz)
	else
		skynet.send(watchdog, "lua", "socket", "data", fd, skynet.tostring(msg, sz))
		-- skynet.tostring will copy msg to a string, so we must free msg here.
		skynet.trash(msg,sz)
	end
end

---有客户端连接时调用
---@param fd number 句柄
---@param addr string 地址
function handler.connect(fd, addr)
	local c = {
		fd = fd,
		ip = addr,
	}
	connection[fd] = c
	skynet.send(watchdog, "lua", "socket", "open", fd, addr)
end

local function unforward(c)
	if c.agent then
		forwarding[c.agent] = nil
		c.agent = nil
		c.client = nil
	end
end

local function close_fd(fd)
	local c = connection[fd]
	if c then
		unforward(c)
		connection[fd] = nil
	end
end

function handler.disconnect(fd)
	close_fd(fd)
	skynet.send(watchdog, "lua", "socket", "close", fd)
end

function handler.error(fd, msg)
	close_fd(fd)
	skynet.send(watchdog, "lua", "socket", "error", fd, msg)
end

function handler.warning(fd, size)
	skynet.send(watchdog, "lua", "socket", "warning", fd, size)
end

function CMD.forward(source, fd, client, address)
	local c = assert(connection[fd])
	unforward(c)
	c.client = client or 0
	c.agent = address or source
	forwarding[c.agent] = c
	gateserver.openclient(fd)
end

function CMD.accept(source, fd)
	local c = assert(connection[fd])
	unforward(c)
	gateserver.openclient(fd)
end

function CMD.kick(source, fd)
	gateserver.closeclient(fd)
end

function handler.command(cmd, source, ...)
	local f = assert(CMD[cmd])
	return f(source, ...)
end

-- 注册client消息类型. 默认打包, 默认解包.
skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
}

-- 启动网关
gateserver.start(handler)
