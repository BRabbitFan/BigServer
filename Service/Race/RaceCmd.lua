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

local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"

local DEFINE = require "RaceDefine"
local Data = require "RaceData"

local _M = {}

local function sendToAll(msgName, msgTable)
  for _, player in pairs(Data.playerList) do
    print("player", player.name)
    skynet.send(player.agent, "lua", "sendToClient", msgName, msgTable)
  end
end

local function getColor()
  local COLOR_LIST = Data.GLOBAL_CONFIG.RaceConf.COLOR_LIST
  local index = 1
  while true do
    local colorId = COLOR_LIST[index]
    local isExists = false
    for _, player in pairs(Data.playerList) do
      if colorId == player.colorId then
        isExists = true
        break
      end
    end
    if not isExists then
      return colorId
    else
      index = index + 1
    end
  end
end

function _M.start(conf)
  -- 初始化数据
  Data.mapId = conf.mapId
  local playerList = Data.playerList
  for _, player in pairs(conf.playerList) do
    table.insert(playerList, {
      uid = player.uid,
      account = player.account,
      name = player.name,
      pos = player.pos,
      state = DEFINE.STATE.LOADING,
      finishTime = DEFINE.NOT_FINISH,
      colorId = player.pos,  -- TODO : 实现getColor(), 现在被阻塞了
      agent = player.agent,
    })
  end
  -- 通知所有玩家
  local msg = {
    game_info = {
      map_id = Data.mapId,
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
  print("sendToAll", util.tabToStr(msg, "block"))
  sendToAll("SyncLoadGame", msg)
end

local function findPlayerByUid(uid)
  for _, player in pairs(Data.playerList) do
    if player.uid == uid then
      return ERROR_CODE.BASE_FAILED_WITH_TAB, player
    end
  end
  return ERROR_CODE.BASE_FAILED
end

local function isAllLoadFinish()
  local STATE = DEFINE.STATE
  for _, player in pairs(Data.playerList) do
    if player.state == (STATE.LOADING or STATE.OFFLINE) then
      return false
    end
  end
  return true
end

function _M.playerLoadFinish(uid)
  local errorCode, player = findPlayerByUid(uid)
  if errorCode ~= ERROR_CODE.BASE_FAILED_WITH_TAB then
    return
  end
  player.state = DEFINE.STATE.READY
  -- 所有玩家加载完毕则开始比赛
  if not isAllLoadFinish() then
    return
  end
  for _, player in pairs(Data.playerList) do
    player.start = DEFINE.STATE.GAMING
  end
  sendToAll("SyncStartGame", {})
end

function _M.playerPosition(uid, PositionTable)
  -- 找到上报的玩家
  local errorCode, reporter = findPlayerByUid(uid)
  if errorCode ~= ERROR_CODE.BASE_FAILED_WITH_TAB then
    return
  end
  -- 向其他玩家同步
  for _, player in pairs(Data.playerList) do
    if player.uid ~= uid then
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
    end
  end
end

local function finishGame(player)
  print("player finish game, name->", player.name)
end

local function playerOvertime(player)
  print("player overtime, name->", player.name)
end

function _M.playerGameState(uid, stateCode)
  local player = findPlayerByUid(uid)
  player.start = stateCode

  local STATE = DEFINE.STATE
  if stateCode == STATE.FINISH then
    finishGame(player)
  elseif stateCode == STATE.OVERTIME then
    playerOvertime(player)
  end
end

return _M