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

local _M = {}

function _M.sendToClient(msgName, msgTable)
  SendToClient(msgName, msgTable)
end

function _M.start(conf)
  util.log("[Agent][Cmd][start]" .. util.tabToStr(conf))
  local base = Data.base
  base.fd = conf.fd
  base.gate = conf.gate
  skynet.call(SVR.gate, "lua", "forward", base.fd)
  skynet.fork(Recver, base.fd)
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

function _M.addScore(score)
  local account = Data.account
  account.score = account.score + score
  skynet.send(SVR.database, "lua", "updateScore", account.uid, account.score)
end

function _M.raceFinish()
  Data.race = {}
end

return _M