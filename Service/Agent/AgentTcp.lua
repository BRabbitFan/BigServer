-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-22 16:43:29
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-22 16:43:29
-- FilePath     : /BigServer/Service/Agent/AgentTcp.lua
-- Description  : Agent--TCP相关
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"

local pbmap = require "Util.PbMap"
local util = require "Util.SvrUtil"

local SVR = require "GlobalDefine.ServiceName"
local RACE_STATE = require("Race.RaceDefine").STATE

local Cmd = require "AgentCmd"
local Msg = require "AgentMsg"
local Data = require "AgentData"


---从客户端接收数据
---@param fd number 客户端句柄
function Recver(fd)
  util.log("[Agent][Recv] Recver start")
  socket.start(fd)
  fd = fd or Data.base.fd
  while true do
    local msgLen = socket.read(fd, 2)
    if msgLen then
      local l1, l2 = string.byte(msgLen, 1, 2)
      msgLen = l1 * 256 + l2
      local baseBytes = socket.read(fd, msgLen)
      local msgName, msgTable = pbmap.unpack(baseBytes)
      if msgName ~= "ReportPosition" then  -- ReportPosition消息太多了不打印日志
        util.log("[Agent][Recv] "..msgName.."\n"..msgName.." "..util.tabToStr(msgTable, "block"))
      end
      local func = Msg[msgName]
      if func then
        func(msgTable)
      end
    else
      break
    end
  end
  Close(fd)
end

---发送数据到客户端
---@param msgName string 消息名
---@param msgTable table 消息内容(table格式)
function SendToClient(msgName, msgTable)
  local msgBytes = pbmap.pack(msgName, msgTable)

  local name, table = pbmap.unpack(msgBytes)
  if name ~= "SyncPosition" then  -- SyncPosition消息太多了不打印日志
    util.log("[Agent][Send] "..name.."\n"..name.." "..util.tabToStr(table, "block"))
  end

  local sendBytes = string.pack(">s2", msgBytes)
  socket.write(Data.base.fd, sendBytes)
end

---关闭Agent
---@param fd number 客户端句柄
function Close(fd)
  util.log("[Agent][Cmd][close] fd->"..tostring(fd))
  fd = fd or Data.base.fd
  local uid = Data.account.uid or nil
  -- 关闭连接, 向网关与登录服务通知已登出
  socket.close(fd)
  skynet.send(SVR.gate, "lua", "unforward", fd)
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

-- 开启接收线程
skynet.fork(Recver, Data.base.fd)