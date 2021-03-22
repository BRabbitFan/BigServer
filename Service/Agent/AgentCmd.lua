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

local util = require "Util.SvrUtil"

local SVR = require "GlobalDefine.ServiceName"

local DEFINE = require "AgentDefine"

local Data = require "AgentData"

local _M = {}

---发送数据到客户端
---@param msgName string 消息名
---@param msgTable table 消息内容(table格式)
function _M.sendToClient(msgName, msgTable)
  -- SyncPosition消息太多了不打印日志
  -- util.log("[Agent][Cmd][sendToClient] magName->"..tostring(msgName))
  SendToClient(msgName, msgTable)
end

---启动Agent
---@param conf table 参数列表
function _M.start(conf)
  util.log("[Agent][Cmd][start] conf->" .. util.tabToStr(conf, "block"))

  Data.base = {
    mode = conf.mode,
    fd = conf.fd,
    gate = conf.gate,
    address = conf.address or nil,  -- UDP mode
    port = conf.port or nil,  -- UDP mode
  }

  local NET_MODE = DEFINE.NET_MODE
  if conf.mode == NET_MODE.UDP then
    require "AgentUdp"
  elseif conf.mode == NET_MODE.TCP then
    require "AgentTcp"
    skynet.call(SVR.gate, "lua", "forward", Data.base.address)
  end

  skynet.call(SVR.gate, "lua", "forward", Data.base.fd)
end

---初始化Race服务
---@param race number race服务地址
function _M.initRace(race)
  util.log("[Agent][Cmd][initRace] race->"..tostring(race))
  Data.room = {}
  Data.race.addr = race
end

---加分
---@param score integer 增加的分数
function _M.addScore(score)
  util.log("[Agent][Cmd][addScore] score->"..tostring(score))
  local account = Data.account
  account.score = account.score + score
  skynet.send(SVR.database, "lua", "updateScore", account.uid, account.score)
end

---比赛结束
function _M.raceFinish()
  util.log("[Agent][Cmd][raceFinish]")
  Data.race = {}
end

return _M