-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 17:10:35
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-08 14:38:21
-- FilePath     : /BigServer/RobotClient/Client/ClientCmd.lua
-- Description  : 机器人客户端--控制命令 (C2S)
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"
local netpack = require "skynet.netpack"

local STATE = require "ClientState"

local DATA = require "ClientData"
local player = DATA.player
local server = DATA.server

local _M = {}

---开启客户端
---@param baseInfo table<MainSvr|account|password|addr|port, ...>
---@return table DATA 客户端数据
---@return table STATE 客户端状态
function _M.start(baseInfo)
  MainSvr = baseInfo.MainSvr
  player.account = baseInfo.account
  player.password = baseInfo.password
  server.addr = baseInfo.addr
  server.port = baseInfo.port
  print(player.account,
  player.password,
  server.addr,
  server.port)
  return DATA, STATE
end

---返回控制服务地址
---@return number|boolean MainSvr 控制服务地址/false
function _M.getMainSvr()
  if not MainSvr then
    return false
  end
  return MainSvr
end

---返回服务器连接句柄
---@return number|boolean Server 服务器连接句柄/false
function _M.getServer()
  if not Server then
    return false
  end
  return Server
end

---向控制服务同步数据
---@param operator string 该函数的调用者(MsgFunc, 默认为MainSvr)
---@return table DATA 客户端数据
function _M.updateData(operator)
  if not operator then  -- 控制服务调用时不填写参数
    return DATA
  end
  skynet.send(MainSvr, "lua", "updateData", DATA)
end

---向控制服务同步数据
---@param operator string 该函数的调用者(MsgFunc, 默认为MainSvr)
---@return table STATE 客户端状态
function _M.updateState(operator)
  if not operator then  -- 控制服务调用时不填写参数
    return STATE
  end
  skynet.send(MainSvr, "lua", "updateState", STATE)
end

local function sender(fd)
  while true do
    local str = io.stdin:read()
    if str then
      print("send:"..str)
      socket.write(fd, str)
    end
  end
end

local function recver(fd)
  while true do
    local len = socket.read(fd, 2)
    if len then
      local l1, l2 = string.byte(len, 1, 2)
      len = l1 * 256 + l2
      local str = socket.read(fd, len)
      if str then
        print(str)
      end
    end
  end
end

function _M.connect()
  Server = socket.open(server.addr, server.port)
  -- skynet.fork(sender, Server)
  skynet.fork(recver, Server)
  socket.write(Server, netpack.pack("123"))
  -- socket.write(Server, netpack.pack("close"))
end

return _M