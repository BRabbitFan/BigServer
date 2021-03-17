-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:53:49
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:43:34
-- FilePath     : /BigServer/Service/Agent/AgentMsg.lua
-- Description  : 客户端的请求消息处理
-- -----------------------------

local skynet = require "skynet"

local pbmap = require "Util.PbMap"
local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"
local SVR = require "GlobalDefine.ServiceName"

local Cmd = require "AgentCmd"
local Data = require "AgentData"

local _M = {}

-- 登录
function _M.ReqLoginAccount(msgTable)
  local info = msgTable.login_account
  local errorCode, totalInfo = skynet.call(SVR.login, "lua", "login", info.account, info.password)

  if errorCode == ERROR_CODE.BASE_SUCESS then
    local account = Data.account
    account.uid = totalInfo.uid
    account.account = totalInfo.account
    account.password = totalInfo.password
    account.name = totalInfo.name
  end

  Cmd.sendToClient(pbmap.pack("RetLoginAccount", {
    error_code = errorCode,
  }))
end

-- 注册
function _M.ReqRegisterAccount(msgTable)
  local info = msgTable.register_account
  local errorCode = skynet.call(SVR.login, "lua", "register", info.account, info.password, info.name)

  Cmd.sendToClient(pbmap.pack("RetRegisterAccount", {
    error_code = errorCode,
  }))
end

-- 请求大厅信息
function _M.ReqHallMessage(msgTable)
  local errorCode, roomNum, roomList = skynet.call(SVR.hall, "lua", "getHallInfo")
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return -- TODO
  end

  local retList = {}
  for _, room in pairs(roomList) do
    table.insert(retList, {
      room_id = room.roomId,
      player_num = room.playerNum,
      map_id = room.mapId,
    })
  end

  Cmd.sendSyncHallMessage({
    is_sync = false,
    room_num = roomNum,
    room_list = retList,
  })
end

-- 创建房间
function _M.ReqCreateRoom(msgTable)
  local errorCode, newRoom = skynet.call(SVR.hall, "lua", "createRoom", Data.account)

  if errorCode == ERROR_CODE.BASE_SUCESS then
    Data.room.addr = newRoom
  end

  Cmd.sendToClient(pbmap.pack("RetCreateRoom", {
    error_code = errorCode,
  }))
end

-- 加入房间
function _M.ReqJoinRoom(msgTable)
  local errorCode, roomAddr = skynet.call(SVR.hall, "lua", "joinRoom", msgTable.room_id)
  if errorCode == ERROR_CODE.BASE_SUCESS then
    Data.room.addr = roomAddr
  end
  errorCode = skynet.call(roomAddr, "lua", "playerJoin", Data.account)
  Cmd.sendToClient(pbmap.pack("RetJoinRoom", {
    error_code = errorCode,
  }))
end

-- 请求房间详情
function _M.ReqRoomInfo(msgTable)
  local errorCode, roomInfo = skynet.call(Data.room.addr, "lua", "getRoomInfo")

  local retMsg = {
    is_sync = false,
    error_code = errorCode,
    room_info = {
      room_id = roomInfo.ROOM_ID,
      map_id = roomInfo.mapId,
      player_list = {},
    }
  }
  local player_list = retMsg.room_info.player_list
  for _, player in pairs(roomInfo.playerList) do
    table.insert(player_list, {
      account_info = {
        account = player.account,
        name = player.name,
      },
      room_pos = tostring(player.pos),
      is_ready = player.isReady,
      is_master = player.isMaster,
    })
  end

  Cmd.sendToClient(pbmap.pack("SyncRoomInfo", retMsg))
end

return _M