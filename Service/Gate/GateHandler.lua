-- -----------------------------
-- symbol_custom_string_obkoro1: https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-06 16:12:10
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-06 20:18:58
-- FilePath     : /BigServer/Service/Gate/GateHandler.lua
-- Description  : 网关handler--处理客户端的消息(socket)
-- -----------------------------

local skynet = require "skynet.manager"
local gateserver = require "snax.gateserver"

local util = require "Util.SvrUtil"

local CMD = require "GateCmd"
local DATA = require "GateData"

local _M = {}

---网关启动
---@param source number 源地址(客户端)
---@param conf table<watchdog, ...> 配置
function _M.open(source, conf)
  DATA.conf = conf
	skynet.register(conf.servername)
  print(util.tabToStr(DATA.conf, "block"))
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

  DATA.connection[fd] = conn

  util.log(" [Gate] [connect] "..util.tabToStr(conn))

  skynet.call(agent, "lua", "start", {
    gate = skynet.self(),
    fd = fd,
    watchdog = skynet.self(),
  })
end

function _M.disconnect(fd)
  local agent = DATA.connection[fd].agent
  skynet.send(agent, "lua", "close")

end

function _M.message(...)
  
end

---处理其他服务的消息
---@param cmd string 消息名
---@param source number 服务源地址
---@return any
function _M.command(cmd, source, ...)
  local f = assert(CMD[cmd])
  return f(source, ...)
end

return _M