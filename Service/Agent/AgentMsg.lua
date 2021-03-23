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

local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"
local SVR = require "GlobalDefine.ServiceName"

local DEFINE = require "AgentDefine"
local Data = require "AgentData"

local _M = {}

------------------------------ Base ------------------------------

-- 心跳
function _M.Ping(msgTable)
  -- util.log("[Agent][Msg][Ping]")
  Data.base.lastPing = 0;
  SendToClient("Pong", {})
end

------------------------------ Login ------------------------------

-- 登录
function _M.ReqLoginAccount(msgTable)
  util.log("[Agent][Msg][ReqLoginAccount]")
  local info = msgTable.login_account
  local errorCode, totalInfo = skynet.call(SVR.login, "lua", "login", info.account, info.password)

  if errorCode == ERROR_CODE.BASE_SUCESS then
    Data.account = {
      uid = totalInfo.uid,
      account = totalInfo.account,
      password = totalInfo.password,
      name = totalInfo.name,
      score = totalInfo.score,
    }
  end

  SendToClient("RetLoginAccount", {
    error_code = errorCode,
  })
end

-- 登出 (UDP)
function _M.ReqLogoutAccount(msgTable)
  util.log("[Agent][Msg][ReqLogoutAccount]")
  Close()
end

-- 注册
function _M.ReqRegisterAccount(msgTable)
  util.log("[Agent][Msg][ReqRegisterAccount]")
  local info = msgTable.register_account
  local errorCode = skynet.call(SVR.login, "lua", "register", info.account, info.password, info.name)

  SendToClient("RetRegisterAccount", {
    error_code = errorCode,
  })
end

-- 查询信息
function _M.ReqSelfInfo(msgTable)
  util.log("[Agent][Msg][ReqSelfInfo]")
  local account = Data.account
  SendToClient("RetSelfInfo", {
    account = {
      account = account.account,
      name = account.name,
      score = account.score or 9,
    },
  })
end

------------------------------ Hall ------------------------------

-- 请求大厅信息
function _M.ReqHallMessage(msgTable)
  util.log("[Agent][Msg][ReqHallMessage]")
  local errorCode, roomNum, roomList = skynet.call(SVR.hall, "lua", "getHallInfo")
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return
  end

  local retList = {}
  for _, room in pairs(roomList) do
    table.insert(retList, {
      room_id = room.roomId,
      player_num = room.playerNum,
      map_id = room.mapId,
    })
  end

  SendToClient("SyncHallMessage", {
    is_sync = false,
    room_num = roomNum,
    room_list = retList,
  })
end

-- 创建房间
function _M.ReqCreateRoom(msgTable)
  util.log("[Agent][Msg][ReqCreateRoom]")
  local errorCode, newRoom = skynet.call(SVR.hall, "lua", "createRoom", Data.account, skynet.self())

  if errorCode == ERROR_CODE.BASE_SUCESS then
    Data.room.addr = newRoom
  end

  SendToClient("RetCreateRoom", {
    error_code = errorCode,
  })
end

-- 加入房间
function _M.ReqJoinRoom(msgTable)
  util.log("[Agent][Msg][ReqJoinRoom]")
  local errorCode, roomAddr = skynet.call(SVR.hall, "lua", "joinRoom", msgTable.room_id)
  if errorCode == ERROR_CODE.BASE_SUCESS then
    Data.room.addr = roomAddr
  end
  local errorCode ,selfPos = skynet.call(roomAddr, "lua", "playerJoin", Data.account, skynet.self())
  SendToClient("RetJoinRoom", {
    error_code = errorCode,
    self_pos = selfPos,
  })
end

------------------------------ Room ------------------------------

-- 请求房间详情
function _M.ReqRoomInfo(msgTable)
  util.log("[Agent][Msg][ReqRoomInfo]")
  local roomInfo = skynet.call(Data.room.addr, "lua", "packRoomInfo")

  SendToClient("SyncRoomInfo", {
    is_sync = false,
    error_code = ERROR_CODE.BASE_SUCESS,
    room_info = roomInfo
  })
end

-- 玩家房间内动作
function _M.ReqPlayerAction(msgTable)
  util.log("[Agent][Msg][ReqPlayerAction]")
  local roomAddr = Data.room.addr
  if not roomAddr then
    return
  end

  local actionCode = msgTable.action_code
  local ROOM_ACTION = DEFINE.ROOM_ACTION

  if actionCode == ROOM_ACTION.GET_READY then
    skynet.send(roomAddr, "lua", "playerReady", Data.account.uid, true)
  elseif actionCode == ROOM_ACTION.UN_READY then
    skynet.send(roomAddr, "lua", "playerReady", Data.account.uid, false)
  elseif actionCode == ROOM_ACTION.QUIT_ROOM then
    skynet.send(roomAddr, "lua", "playerQuit", Data.account.uid)
  elseif actionCode == ROOM_ACTION.CHANGE_MAP then
    skynet.send(roomAddr, "lua", "playerChangeMap", Data.account.uid, msgTable.extend)
  end
end

------------------------------ Race ------------------------------

-- 游戏加载完毕
function _M.ReportLoadGame(msgTable)
  util.log("[Agent][Msg][ReportLoadGame]")
  local race = Data.race.addr
  if not race then
    return
  end
  skynet.send(race, "lua", "playerLoadFinish", Data.account.uid)
end

-- 请求开始游戏
function _M.ReqStartGame(msgTable)
  util.log("[Agent][Msg][ReqStartGame]")
  local race = Data.race.addr
  if not race then
    return
  end
  skynet.send(race, "lua", "playerLoadFinish", Data.account.uid)
end

-- 汇报自身方位信息
function _M.ReportPosition(msgTable)
  -- util.log("[Agent][Msg][ReportPosition]")  -- ReportPosition消息太多了不打印日志
  local race = Data.race.addr
  if not race then
    return
  end
  skynet.send(race, "lua", "playerPosition", Data.account.uid, msgTable)
end

-- 汇报游戏状态
function _M.ReportGameState(msgTable)
  util.log("[Agent][Msg][ReportGameState]")

  local race = Data.race.addr
  if not race then
    return
  end
  skynet.send(race, "lua", "playerGameState", Data.account.uid, msgTable.game_state_code)
end

return _M