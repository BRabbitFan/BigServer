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

local function recv(bytes, source)
  util.log("[Gate][Cmd][recv]")
  local ip, port = socket.udp_address(source)
  local client = Data.client[source] or {}
  local agent = client.agent or nil
  if not agent then
    skynet.send(SVR.login, "lua", "chkToken", fd, bytes, ip, port, source)
    return
  end

  skynet.send(agent, "client", bytes)
end
local function Recver(msg, source)
  queue(recv, msg, source)
end

skynet.register_protocol({
  name = "client",
  id = skynet.PTYPE_CLIENT,
  pack = skynet.pack,
  -- unpack = skynet.unpack,
})

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
