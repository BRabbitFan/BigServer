-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-13 19:08:37
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-13 19:08:46
-- FilePath     : /BigServer/Service/Room/RoomCmd.lua
-- Description  : 房间服务--指令
-- -----------------------------

local skynet = require "skynet"

local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"

local Data = require "RoomData"

local _M = {}

function _M.start(conf)
  Data.ROOM_ID = conf.roomId

  local master = conf.master
  table.insert(Data.playerList, {
    uid = master.uid,
    account = master.account,
    name = master.name,
    pos = 1,
    isReady = false,
    isMaster = true,
  })
end

local function getEmptyPos()
  for pos = 1, 3 do
    local isFind = false
    for _, player in pairs(Data.playerList) do
      if player.pos == pos then
        isFind = true
        break
      end
    end
    if not isFind then
      return ERROR_CODE.BASE_SUCESS, pos
    end
  end
  return ERROR_CODE.ROOM_PLAYER_FULL
end

function _M.playerJoin(player)
  local errorCode, newPos = getEmptyPos()
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return errorCode
  end

  table.insert(Data.playerList, {
    uid = player.uid,
    account = player.account,
    name = player.name,
    pos = newPos,
    isReady = false,
    isMaster = false,
  })
  return ERROR_CODE.BASE_SUCESS
end

function _M.getRoomInfo()
  return ERROR_CODE.BASE_SUCESS, Data
end

return _M