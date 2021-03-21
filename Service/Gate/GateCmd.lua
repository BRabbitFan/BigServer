-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-18 18:07:40
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-18 18:07:40
-- FilePath     : /BigServer/Service/GateNew/GateCmd.lua
-- Description  : 网关--指令
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"

local util = require "Util.SvrUtil"

local Data = require "GateData"

local _M = {}

---新客户端连接
---@param fd number 客户端句柄
local function newClient(fd)
  util.log("[Gate][Cmd][newClient] fd->"..fd)
  -- 检查客户端数量
  if util.tabLen(Data.connection) >= Data.conf.maxClient then
    return
  end
  -- 开启新Agent
  local agent = skynet.newservice("Agent")
  skynet.send(agent, "lua", "start", {
    gate = skynet.self(),
    fd = fd,
  })
  -- 记录
  Data.connection[fd] = {
    fd = fd,
    agent = agent,
  }
end

---启动Gate
---@param conf table 配置表
function _M.start(conf)
  util.log("[Gate][Cmd][start] conf->"..util.tabToStr(conf, "block"))
  Data.conf = {
    addr = conf.addr,
    port = conf.port,
    maxClient = conf.maxClient,
    svrName = conf.svrName,
  }

  util.setSvr(conf.svrName)

  local newFd = socket.listen(conf.addr, conf.port)
  socket.start(newFd, newClient)
end

---Agent准备好
---@param fd string 对应的socket句柄
function _M.forward(fd)
	util.log("[Gate][Cmd][forward] fd->"..fd)
end

---Agent关闭
---@param fd string 对应的socket句柄
function _M.unforward(fd)
	util.log("[Gate][Cmd][unforward] fd->"..fd)
	Data.connection[fd] = nil
end

return _M