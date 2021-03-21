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

local SVR = require "GlobalDefine.ServiceName"

local RACE_STATE = require("Race.RaceDefine").STATE

local Data = require "AgentData"

local _M = {}

---发送数据到客户端
---@param msgName string 消息名
---@param msgTable table 消息内容(table格式)
function _M.sendToClient(msgName, msgTable)
  SendToClient(msgName, msgTable)
end

---启动Agent
---@param conf table 参数列表
function _M.start(conf)
  util.log("[Agent][Cmd][start]" .. util.tabToStr(conf))
  local base = Data.base
  base.fd = conf.fd
  base.gate = conf.gate
  skynet.call(SVR.gate, "lua", "forward", base.fd)
  skynet.fork(Recver, base.fd)
end

---关闭Agent
---@param fd number 客户端句柄
function _M.close(fd)
  util.log("[Agent][Cmd][close]")
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

---初始化Race服务
---@param race number race服务地址
function _M.initRace(race)
  Data.room = {}
  Data.race.addr = race
end

---加分
---@param score integer 增加的分数
function _M.addScore(score)
  local account = Data.account
  account.score = account.score + score
  skynet.send(SVR.database, "lua", "updateScore", account.uid, account.score)
end

---比赛结束
function _M.raceFinish()
  Data.race = {}
end

return _M