-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-22 13:07:03
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-22 13:07:03
-- FilePath     : /BigServer/Service/GateUdp/GateCmd.lua
-- Description  : UDP网关--指令
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"
local queue = require("skynet.queue")()

local util = require "Util.SvrUtil"

local SVR = require "GlobalDefine.ServiceName"

local Data = require "GateData"

local fd

local _M = {}

---处理客户端消息, 转发至Agent/Login
---@param bytes byte 消息字节
---@param source byte 来源 (客户端)
local function recv(bytes, source)
  local ip, port = socket.udp_address(source)
  local client = Data.client[source] or {}
  local agent = client.agent or nil
  if not agent then
    skynet.send(SVR.login, "lua", "chkToken", fd, bytes, source)
    return
  end

  skynet.send(agent, "client", bytes)
end

---接收客户端的消息, 加入消息队列(recv处理)
---@param bytes byte 消息字节
---@param source byte 来源 (客户端)
local function Recver(bytes, source)
  queue(recv, bytes, source)
end

-- 注册client消息, 网关只转发不接收
skynet.register_protocol({
  name = "client",
  id = skynet.PTYPE_CLIENT,
  pack = skynet.pack,
  -- unpack = skynet.unpack,
})

---启动网关
---@param conf table 配置表
function _M.start(conf)
  util.log("[Gate][Cmd][start] conf->"..util.tabToStr(conf, "block"))
  Data.conf = {
    addr = conf.addr,
    recvPort = conf.recvPort,
    sendPort = conf.sendPort,
    maxClient = conf.maxClient,
    svrName = conf.svrName,
  }
  util.setSvr(conf.svrName)

  fd = socket.udp(Recver, "0.0.0.0", Data.conf.recvPort)
end

---Agent准备好
---@param sendAddr string 客户端地址(sendAddr)
function _M.forward(sendAddr, agent)
  local ip, port = socket.udp_address(sendAddr)
	util.log("[Gate][Cmd][forward] address->"..ip..":"..port)

  Data.client[sendAddr] = {
    sendAddr = sendAddr,
    ip = ip,
    port = port,
    agent = agent,
  }
end

---Agent关闭
---@param sendAddr string 客户端发送地址
function _M.unforward(sendAddr)
	local ip, port = socket.udp_address(sendAddr)
	util.log("[Gate][Cmd][forward] address->"..ip..":"..port)

	Data.client[sendAddr] = nil
end

return _M
