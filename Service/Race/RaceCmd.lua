-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:22:44
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-12 21:22:53
-- FilePath     : /BigServer/Service/Race/RaceCmd.lua
-- Description  : 游戏服务--服务命令
-- -----------------------------

local skynet = require "skynet"
local stateQueue = require("skynet.queue")()  -- 状态更新队列, 防止乱序

local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"

local DEFINE = require "RaceDefine"
local Data = require "RaceData"

local _M = {}

---发送消息给比赛内全体玩家
---@param msgName string 消息名
---@param msgTable table 消息内容(table格式)
local function sendToAll(msgName, msgTable)
  util.log("[Race][Cmd][sendToAll]"..
           " msgName->"..tostring(msgName)..
           " msgTable"..util.tabToStr(msgTable))
  for _, player in pairs(Data.playerList) do
    skynet.send(player.agent, "lua", "sendToClient", msgName, msgTable)
  end
end

---获得一个未被占用的colorId
---@return integer colorId
local function getColor()
  local COLOR_LIST = Data.GLOBAL_CONFIG.RaceConf.COLOR_LIST
  local playerList = Data.playerList

  while true do
    local index = math.random(1, util.tabLen(COLOR_LIST))
    local colorId = util.getValByIdx(COLOR_LIST, index)

    local isUsed = false
    for _, player in pairs(playerList) do
      if player.colorId == colorId then
        isUsed = true
        break
      end
    end

    if not isUsed then
      return colorId
    end

  end
end

---启动Race
---@param conf table 配置表
function _M.start(conf)
  util.log("[Race][Cmd][start] conf->"..util.tabToStr(conf, "block"))
  -- 初始化数据
  Data.MAP_ID = conf.mapId
  local playerList = Data.playerList
  for _, player in pairs(conf.playerList) do
    table.insert(playerList, {
      uid = player.uid,
      account = player.account,
      name = player.name,
      pos = player.pos,
      state = DEFINE.STATE.LOADING,
      colorId = getColor(),
      agent = player.agent,
    })
  end
  -- 通知所有玩家
  local msg = {
    game_info = {
      map_id = Data.MAP_ID,
      player_list = {},
    },
  }
  local msgPlayerList = msg.game_info.player_list
  local dataPlayerList = Data.playerList
  for _, player in pairs(dataPlayerList) do
    table.insert(msgPlayerList, {
      game_pos = player.pos,
      color_id = player.colorId,
      account_info = {
        account = player.account,
        name = player.name,
      },
    })
  end
  sendToAll("SyncLoadGame", msg)
end

---通过uid找到游戏内的玩家
---@param uid integer uid
---@return integer errorCode 错误码
---@return table player 玩家table
local function findPlayerByUid(uid)
  -- util.log("[Race][Cmd][sendToAll] uid->"..tostring(uid))  -- ReportPosition消息太多了不打印日志
  for _, player in pairs(Data.playerList) do
    if player.uid == uid then
      return ERROR_CODE.BASE_SUCESS_WITH_TAB, player
    end
  end
  return ERROR_CODE.RACE_PLAYER_NOT_EXISTS
end

---检查是否所有玩家都处于同一状态
---@param stateCode integer 状态码
---@return boolean isAllOffline
local function isAllSameState(stateCode)
  util.log("[Race][Cmd][isAllSameState] stateCode->"..tostring(stateCode))
  for _, player in pairs(Data.playerList) do
    if player.state ~= stateCode then
      util.log("[Race][Cmd][isAllSameState]false")
      return false
    end
  end
  util.log("[Race][Cmd][isAllSameState]true")
  return true
end

---玩家加载游戏结束
---@param uid integer uid
---@return integer errorCode 错误码
function _M.playerLoadFinish(uid)
  util.log("[Race][Cmd][playerLoadFinish] uid->"..tostring(uid))
  local errorCode, player = findPlayerByUid(uid)
  if errorCode ~= ERROR_CODE.BASE_SUCESS_WITH_TAB then
    return errorCode
  end
  local STATE = DEFINE.STATE
  player.state = STATE.READY
  -- 所有玩家加载完毕则开始比赛
  if not isAllSameState(STATE.READY) then
    return ERROR_CODE.RACE_NOT_ALL_READY
  end
  for _, player in pairs(Data.playerList) do
    player.state = STATE.GAMING
  end
  sendToAll("SyncStartGame", {})
  Data.startTime = math.floor(skynet.time())
end

---玩家更新位置
---@param uid integer uid
---@param PositionTable table 位置信息(Position消息的table格式)
---@return integer errorCode 错误码
function _M.playerPosition(uid, PositionTable)
  -- util.log("[Race][Cmd][playerPosition]"..    -- ReportPosition消息太多了不打印日志
  --          " uid->"..tostring(uid)..
  --          " PositionTable->"..util.tabToStr(PositionTable))
  -- 找到上报的玩家
  local errorCode, reporter = findPlayerByUid(uid)
  if errorCode ~= ERROR_CODE.BASE_SUCESS_WITH_TAB then
    return errorCode
  end
  -- 向其他玩家同步
  for _, player in pairs(Data.playerList) do
    repeat
      if player.uid == uid then
        break
      end
      if player.state ~= DEFINE.STATE.GAMING then
        break
      end
      skynet.send(player.agent, "lua", "sendToClient", "SyncPosition", {
        position = PositionTable.position,
        player = {
          game_pos = reporter.pos,
          color_id = reporter.colorId,
          account_info = {
            account = reporter.acccount,
            name = reporter.name,
          },
        },
      })
    until true
  end
  return ERROR_CODE.BASE_SUCESS
end

---结束游戏
---@param winUid integer 赢家uid
local function finishGame(winUid)
  util.log("[Race][Cmd][finishGame]"..
           " winUid->"..tostring(winUid))
  for _, player in pairs(Data.playerList) do
    if player.uid == winUid then
      skynet.send(player.agent, "lua", "addScore", Data.GLOBAL_CONFIG.RaceConf.WIN_SCORE)
    end
    skynet.send(player.agent, "lua", "raceFinish")
  end
  skynet.exit()
end

---玩家更新游戏状态 (实际操作)
---@param uid integer uid
---@param stateCode integer 状态码
local function playerGameState(uid, stateCode)
  util.log("[Race][Cmd][playerGameState] uid->"..tostring(uid).." stateCode->"..tostring(stateCode))
  local errorCode, player = findPlayerByUid(uid)
  if errorCode ~= ERROR_CODE.BASE_SUCESS_WITH_TAB then
    return
  end
  player.state = stateCode

  local useTime = math.floor(skynet.time()) - Data.startTime
  sendToAll("SyncGameState", {
    game_state_code = stateCode,
    add_score = Data.GLOBAL_CONFIG.RaceConf.WIN_SCORE,
    use_time = useTime,
    player = {
      game_pos = player.pos,
      color_id = player.colorId,
      account_info = {
        name = player.name,
        account = player.account,
      },
    },
  })

  local STATE = DEFINE.STATE
  if stateCode == STATE.FINISH then
    finishGame(uid)
  elseif stateCode == STATE.OFFLINE then
    if isAllSameState(stateCode) then
      finishGame()
    end
  elseif stateCode == STATE.OVERTIME then
    if isAllSameState(stateCode) then
      finishGame()
    end
  end
end

---玩家更新游戏状态 (加入队列)
---@param uid integer uid
---@param stateCode integer 状态码
function _M.playerGameState(uid, stateCode)
  util.log("[Race][Cmd][playerGameState] add queue")
  stateQueue(playerGameState, uid, stateCode)
end

return _M