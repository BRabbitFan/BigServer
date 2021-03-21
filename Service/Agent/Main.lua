-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:39:48
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:43:26
-- FilePath     : /BigServer/Service/Agent/Main.lua
-- Description  : Agent服务入口 -- 一个Agent对应一个Client
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"

local pbmap = require "Util.PbMap"
local util = require "Util.SvrUtil"

local Cmd = require "AgentCmd"
local Msg = require "AgentMsg"

local Data = require "AgentData"

---从客户端接收数据
---@param fd number 客户端句柄
function Recver(fd)
  socket.start(fd)
  fd = fd or Data.base.fd
  while true do
    local msgLen = socket.read(fd, 2)
    if msgLen then
      local l1, l2 = string.byte(msgLen, 1, 2)
      msgLen = l1 * 256 + l2
      local baseBytes = socket.read(fd, msgLen)
      local msgName, msgTable = pbmap.unpack(baseBytes)
      if msgName ~= "ReportPosition" then
        util.log("[Agent][Recv]"..msgName.." "..util.tabToStr(msgTable, "block"))
      end
      local func = Msg[msgName]
      if func then
        func(msgTable)
      end
    else
      break
    end
  end
  Cmd.close(fd)
end

---发送数据到客户端
---@param msgName string 消息名
---@param msgTable table 消息内容(table格式)
function SendToClient(msgName, msgTable)
  local msgBytes = pbmap.pack(msgName, msgTable)

  local name, table = pbmap.unpack(msgBytes)
  if name ~= "SyncPosition" then
    util.log("[Agent][Send]"..name.." "..util.tabToStr(table, "block"))
  end

  local sendBytes = string.pack(">s2", msgBytes)
  socket.write(Data.base.fd, sendBytes)
end

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(func(...))
    end
  end)
end)