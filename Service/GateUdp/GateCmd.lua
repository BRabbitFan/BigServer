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

local Data = require "GateData"

local fd

local _M = {}

local function newClient(address)
  util.log("[Gate][Cmd][newClient] fd->"..fd)
  -- 检查客户端数量
  if util.tabLen(Data.connection) >= Data.conf.maxClient then
    return
  end
  -- 开启新Agent
  local agent = skynet.newservice("Agent")
  skynet.call(agent, "lua", "start", {
    mode = "udp",
    gate = skynet.self(),
    fd = fd,
    address = address,
    port = Data.conf.sendPort,
  })
  -- 记录
  Data.connection[address] = {
    address = address,
    fd = fd,
    agent = agent,
  }
end

local function rec(msg, source)
  local address, port = socket.udp_address(source)

  if not Data.connection[address] then
    newClient(address)
  end

  local agent = Data.connection[address].agent
  skynet.send(agent, "client", source, msg)
end
local function Recver(msg, source)
  queue(rec, msg, source)
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
---@param address string 客户端地址
function _M.forward(address)
	util.log("[Gate][Cmd][forward] address->"..address)
end

---Agent关闭
---@param address string 客户端地址
function _M.unforward(address)
	util.log("[Gate][Cmd][unforward] address->"..address)
	Data.connection[address] = nil
end

return _M
