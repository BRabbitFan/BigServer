-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-31 21:41:16
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-31 21:41:17
-- FilePath     : /BigServer/hotfix.lua
-- Description  : 热更新脚本示例
-- -----------------------------

local skynet = require "skynet"
local util = require "Util.SvrUtil"
local SVR = require "GlobalDefine.ServiceName"
local ERROR_CODE = require "GlobalDefine.ErrorCode"
local Data = require "HallData"
local Cmd = require "HallCmd"

local function packSyncHallMessage()
  util.log("[Hall][Cmd][packSyncHallMessage]")
  local msg = {
    is_sync = true,
    room_num = util.tabLen(Data.roomList),
    room_list = {},
  }
  local msgRoomList = msg.room_list
  local DataRoomList = Data.roomList
  for _, room in pairs(DataRoomList) do
    table.insert(msgRoomList, {
      room_id = room.roomId,
      player_num = room.playerNum,
      map_id = room.mapId,
    })
  end
  return msg
end
local function sendToAllOnlinePlayer(msgName, msgTable)
  util.log("[Hall][Cmd][sendToAllOnlinePlayer]"..
           " msgName->"..tostring(msgName)..
           " msgTable->"..util.tabToStr(msgTable))
  skynet.send(SVR.dataCenter, "lua", "sendToAllOnlinePlayer", msgName, msgTable)
end

function Cmd.joinRoom(roomId)
  util.log("[Hall][Cmd][joinRoom] roomId->"..tostring(roomId))
  local room = Data.roomList[roomId] or nil
  if not room then
    return ERROR_CODE.HALL_ROOM_NOT_EXISTS
  end
  if room.playerNum == Data.GLOBAL_CONFIG.maxPlayerNum then
    return ERROR_CODE.HALL_PLAYER_NUM_FULL
  end

  room.playerNum = room.playerNum + 1  -- debug

  sendToAllOnlinePlayer("SyncHallMessage", packSyncHallMessage())
  return ERROR_CODE.BASE_SUCESS, room.roomAddr
end





