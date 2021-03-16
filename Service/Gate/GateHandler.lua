-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-06 16:12:10
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-11 23:56:25
-- FilePath     : /BigServer/Service/Gate/GateHandler.lua
-- Description  : 网关handler--处理客户端的消息(socket)
-- -----------------------------

local skynet = require "skynet.manager"

local util = require "Util.SvrUtil"

local Cmd = require "GateCmd"
local Data = require "GateData"

-- 注册client消息类型, 网关不打包、解包
skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
  pack = function (...) return ... end,
  unpack = function (...) return ... end,
}

local _M = {}

---网关启动
---@param source number 源地址(客户端)
---@param conf table<watchdog, ...> 配置
function _M.open(source, conf)
  Data.conf = conf
	skynet.register(conf.servername)
  print(util.tabToStr(Data.conf, "block"))
end

---有客户端连接
---@param fd number 句柄
---@param addr string 地址
function _M.connect(fd, addr)
  local agent = skynet.newservice("Agent")
  local conn = {
    fd = fd,
    ip = addr,
    agent = agent,
  }

  Data.connection[fd] = conn
  util.log(" [Gate] [connect] "..util.tabToStr(conn))

  skynet.send(agent, "lua", "start", {
    gate = skynet.self(),
    fd = fd,
  })
end

---链接关闭
---@param fd number 句柄
function _M.disconnect(fd)
  local agent = Data.connection[fd].agent
  if agent then
    skynet.send(agent, "lua", "close")
  end
end

---有消息到达
---@param fd number 句柄
---@param msg c指针 消息内容
---@param sz number 消息长度
---msg + sz = 未解包的消息(c指针)
function _M.message(fd, msg, sz)
  util.log(" [Gate] [handler.message] "..fd)

  local agent = Data.connection[fd].agent
  if agent then
    skynet.send(agent, "client", msg, sz)
  end
end

---处理其他服务的消息
---@param cmd string 消息名
---@param source number 服务源地址
---@return any
function _M.command(cmd, source, ...)
  local f = assert(Cmd[cmd])
  return f(source, ...)
end

return _M