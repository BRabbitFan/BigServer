-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:53:10
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:45:51
-- FilePath     : /BigServer/Service/Agent/AgentCmd.lua
-- Description  : agent的命令
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"

local util = require "Util.SvrUtil"
local pbmap = require "Util.PbMap"

local SVR = require "GlobalDefine.ServiceName"

local RACE_STATE = require("Race.RaceDefine").STATE

local Data = require "AgentData"
local Msg = require "AgentMsg"

local _M = {}

function _M.sendToClient(msgName, msgTable)
  SendToClient(msgName, msgTable)
end

local function recver(fd)
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
  _M.close(fd)
end

function _M.start(conf)
  util.log("[Agent][Cmd][start]" .. util.tabToStr(conf))
  local base = Data.base
  base.fd = conf.fd
  base.gate = conf.gate
  skynet.call(SVR.gate, "lua", "forward", base.fd)
  skynet.fork(recver, base.fd)
end

function _M.close(fd)
  util.log("[Agent][Cmd][close]")

  fd = fd or Data.base.fd
  local uid = Data.account.uid or nil

  socket.close(fd)
  skynet.send(SVR.gate, "lua", "unforward", fd)
  skynet.send(SVR.login, "lua", "logout", uid)

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

  skynet.exit()
end

function _M.initRace(race)
  Data.room = {}
  Data.race.addr = race
end

function _M.raceFinish()
  Data.race = {}
end

return _M