-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-22 16:45:34
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-22 16:45:34
-- FilePath     : /BigServer/Service/Agent/AgentUdp.lua
-- Description  : Agent--UDP相关
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"

local pbmap = require "Util.PbMap"
local util = require "Util.SvrUtil"

local RACE_STATE = require("Race.RaceDefine").STATE
local SVR = require "GlobalDefine.ServiceName"

local Msg = require "AgentMsg"
local Data = require "AgentData"

-- 注册client类型消息, Agent只做处理, 不发送
skynet.register_protocol({
  name = "client",
  id = skynet.PTYPE_CLIENT,
  -- pack = skynet.pack,
  unpack = skynet.unpack,
})

---处理client类型消息, 即客户端发来的信息
---@param session number 服务内消息session
---@param source number 源地址(网关)
---@param baseBytes byte 消息字节
skynet.dispatch("client", function(session, source, baseBytes)
  local msgName, msgTable = pbmap.unpack(baseBytes)
  if msgName ~= "ReportPosition" then  -- ReportPosition消息太多了不打印日志
    util.log("[Agent][Recv] "..msgName.."\n"..msgName.." "..util.tabToStr(msgTable, "block"))
  end
  local func = Msg[msgName]
  if func then
    func(msgTable)
  end
end)

---发送数据到客户端
---@param msgName string 消息名
---@param msgTable table 消息内容(table格式)
function SendToClient(msgName, msgTable)
  local msgBytes = pbmap.pack(msgName, msgTable)

  local name, table = pbmap.unpack(msgBytes)
  if name ~= "SyncPosition" then  -- SyncPosition消息太多了不打印日志
    util.log("[Agent][Send] "..name.."\n"..name.." "..util.tabToStr(table, "block"))
  end

  socket.sendto(Data.base.fd, Data.base.recvAddr, msgBytes)
  -- socket.udp_connect(Data.base.fd, Data.base.address, Data.base.port)
  -- socket.write(Data.base.fd, msgBytes)
end

---客户端退出, 关闭Agent
function Close()
  util.log("[Agent][Cmd][close]")
  local uid = Data.account.uid or nil
  -- 关闭连接, 向网关与登录服务通知已登出
  skynet.send(SVR.gate, "lua", "unforward", Data.base.sendAddr)
  skynet.send(SVR.login, "lua", "logout", uid)
  -- 若在房间内 / 在游戏中 , 则通知服务玩家退出
  repeat
    local room = Data.room.addr
    if room then
      skynet.send(room, "lua", "playerQuit", uid)
      break
    end

    local race = Data.race.addr
    if race then
      skynet.send(race, "lua", "playerGameState", uid, RACE_STATE.OFFLINE)
      break
    end
  until true
  -- 关闭Agent
  skynet.exit()
end

-- 心跳计时器 每秒更新心跳间隔
skynet.fork(function()
  local base = Data.base
  base.lastPing = 0
  while true do
    skynet.sleep(100)
    base.lastPing = base.lastPing + 1

    if base.lastPing > 30 then
      Close()
    end
  end
end)