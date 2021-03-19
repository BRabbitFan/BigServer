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

local SVR = require "GlobalDefine.ServiceName"
local ERROR_CODE = require "GlobalDefine.ErrorCode"

local Data = require "RoomData"

local _M = {}

local function chkRoomEmpty()
  local playerList = Data.playerList
  while true do
    skynet.sleep(10)
    if not next(playerList) then
      skynet.send(SVR.hall, "lua", "closeRoom", Data.ROOM_ID)
      skynet.exit()
    end
  end
end

function _M.start(conf)
  Data.ROOM_ID = conf.roomId
  Data.mapId = Data.GLOBAL_CONFIG.RaceConf.MAP_LIST.DEFAULT_MAP

  local master = conf.master
  table.insert(Data.playerList, {
    uid = master.uid,
    account = master.account,
    name = master.name,
    pos = 1,
    isReady = false,
    isMaster = true,
    agent = conf.agent,
  })

  skynet.fork(chkRoomEmpty)
end

local function sendToAll(msgName, msgTable)
  for _, player in pairs(Data.playerList) do
    skynet.send(player.agent, "lua", "sendToClient", msgName, msgTable)
  end
end

local function getEmptyPos()
  print(util.tabToStr(Data.playerList, "block"))
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

function _M.playerJoin(player, agent)
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
    agent = agent,
  })

  sendToAll("SyncRoomInfo", {
    is_sync = true,
    error_code = ERROR_CODE.BASE_SUCESS,
    room_info = _M.packRoomInfo(),
  })

  return ERROR_CODE.BASE_SUCESS, newPos
end

local function newMaster()
  local playerList = Data.playerList
  -- 先设置所有人都不是房主
  for _, player in pairs(playerList) do
    if player.isMaster then
      player.isMaster = false
    end
  end
  -- 再选取一位房主(当前列表内最早加入的)
  for _, player in pairs(playerList) do
    if not player.isMaster then
      player.isMaster = true
      break
    end
  end
end

local function getPlayerIndexByUid(uid)
  for index, player in pairs(Data.playerList) do
    if player.uid == uid then
      return index
    end
  end
  return false
end

local function isAllReady()
  local playerList = Data.playerList
  local maxPlayerNum = Data.GLOBAL_CONFIG.RoomRole.maxPlayerNum

  local playerNum = 0
  for _, player in pairs(playerList) do
    playerNum = playerNum + 1
    if not player.isReady then
      return false
    end
  end

  if playerNum == maxPlayerNum then
    return true
  end
  return false
end

local function startRace()
  -- 开启新游戏
  local newRace = skynet.newservice("Race")
  skynet.send(newRace, "lua", "start", {
    mapId = Data.mapId,
    playerList = Data.playerList,
  })
  -- 通知Agent游戏服务地址
  for _, player in pairs(Data.playerList) do
    skynet.send(player.agent, "lua", "initRace", newRace)
  end
  -- 开启游戏后房间销毁
  skynet.send(SVR.hall, "lua", "closeRoom", Data.ROOM_ID)
  skynet.exit()
end

function _M.playerReady(uid, isReady)
  local index = getPlayerIndexByUid(uid)
  if not index then
    return
  end

  local player = Data.playerList[index]
  if player.isReady == isReady then  -- 只有前后状态不一致才需要操作
    return
  end

  player.isReady = isReady
  sendToAll("SyncRoomInfo", {
    is_sync = true,
    error_code = ERROR_CODE.BASE_SUCESS,
    room_info = _M.packRoomInfo(),
  })

  if isAllReady() then
    startRace()
  end
end

function _M.playerQuit(uid)
  util.log("[Room][Cmd][playerQuit]uid->"..uid)
  local index = getPlayerIndexByUid(uid)
  if not index then
    return
  end

  local playerList = Data.playerList
  local isMaster = playerList[index].isMaster

  playerList[index] = nil
  if isMaster then
    newMaster()
  end

  skynet.send(SVR.hall, "lua", "quitRoom", Data.ROOM_ID)
  sendToAll("SyncRoomInfo", {
    is_sync = true,
    error_code = ERROR_CODE.BASE_SUCESS,
    room_info = _M.packRoomInfo(),
  })
end

function _M.playerChangeMap(uid, mapId)
  local player = Data.playerList[getPlayerIndexByUid(uid)]
  -- 检查有没有在房间内 , 是不是房主 , 前后地图有没有改变
  if (not player) or (not player.isMaster) or (Data.mapId == mapId) then
    return
  end
  Data.mapId = mapId
  sendToAll("SyncRoomInfo", {
    is_sync = true,
    error_code = ERROR_CODE.BASE_SUCESS,
    room_info = _M.packRoomInfo(),
  })
end

---打包RoomInfo消息 (protobuf)
---@return integer errorCode 错误码
---@return table RoomInfo (protobuf)
function _M.packRoomInfo()
  local room_info = {
    room_id = Data.ROOM_ID,
    map_id = Data.mapId,
    player_list = {},
  }

  local msgPlayerList = room_info.player_list
  local dataPlayerList = Data.playerList

  for _, player in pairs(dataPlayerList) do
    table.insert(msgPlayerList, {
      room_pos = player.pos,
      is_master = player.isMaster,
      is_ready = player.isReady,
      account_info = {
        name = player.name,
        account = player.account,
      },
    })
  end

  return room_info
end

return _M