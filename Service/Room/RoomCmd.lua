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

---检查是否是空房间
local function chkRoomEmpty()
  util.log("[Room][Cmd][chkRoomEmpty] start check")
  local playerList = Data.playerList
  while true do
    skynet.sleep(10)
    if not next(playerList) then
      skynet.send(SVR.hall, "lua", "closeRoom", Data.ROOM_ID)
      skynet.exit()
    end
  end
end

---启动Room
---@param conf table 配置表
function _M.start(conf)
  util.log("[Room][Cmd][start] conf->"..util.tabToStr(conf, "block"))
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

---向房间内全体玩家发送消息
---@param msgName string 消息名
---@param msgTable table 消息内容(table格式)
local function sendToAll(msgName, msgTable)
  util.log("[Room][Cmd][sendToAll]"..
           " msgName->"..tostring(msgName)..
           " msgTable->"..util.tabToStr(msgTable))
  for _, player in pairs(Data.playerList) do
    skynet.send(player.agent, "lua", "sendToClient", msgName, msgTable)
  end
end

---获得一个空位
---@return integer errorCode 错误码
---@return integer 位置Id
local function getEmptyPos()
  util.log("[Room][Cmd][getEmptyPos]")
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

---玩家加入房间
---@param player table 玩家信息
---@param agent integer Agent地址
---@return integer errorCode 错误码
---@return integer 该玩家的位置
function _M.playerJoin(player, agent)
  util.log("[Room][Cmd][playerJoin] player->"..util.tabToStr(player).." agent->"..tostring(agent))
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

---选取新房主
local function newMaster()
  util.log("[Room][Cmd][newMaster]")
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

---通过uid获得玩家的索引
---@param uid integer uid
---@return integer index playerList中的索引
local function getPlayerIndexByUid(uid)
  util.log("[Room][Cmd][getPlayerIndexByUid] uid->"..tostring(uid))
  for index, player in pairs(Data.playerList) do
    if player.uid == uid then
      return ERROR_CODE.BASE_SUCESS, index
    end
  end
  return ERROR_CODE.ROOM_PLAYER_NOT_EXISTS
end

---检查是否所有玩家都准备了
---@return boolean isAllReady
local function isAllReady()
  util.log("[Room][Cmd][isAllReady]")
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

---开始游戏
local function startRace()
  util.log("[Room][Cmd][startRace]")
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

---玩家更新准备状态
---@param uid integer uid
---@param isReady boolean 是否准备
---@return integer errorCode 错误码
function _M.playerReady(uid, isReady)
  util.log("[Room][Cmd][playerReady] uid->"..tostring(uid).." isReady->"..tostring(isReady))
  local errorCode, index = getPlayerIndexByUid(uid)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return errorCode
  end

  local player = Data.playerList[index]
  if player.isReady == isReady then  -- 只有前后状态不一致才需要操作
    return ERROR_CODE.ROOM_READY_SAME
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
  return ERROR_CODE.BASE_SUCESS
end

---玩家退出房间
---@param uid integer uid
---@return integer errorCode 错误码
function _M.playerQuit(uid)
  util.log("[Room][Cmd][playerQuit]uid->"..tostring(uid))
  local errorCode, index = getPlayerIndexByUid(uid)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return errorCode
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
  return ERROR_CODE.BASE_SUCESS
end

---玩家换地图
---@param uid integer uid
---@param mapId integer 地图Id
---@return any
function _M.playerChangeMap(uid, mapId)
  util.log("[Room][Cmd][playerChangeMap]uid->"..tostring(uid).." mapId->"..tostring(mapId))
  local errorCode, index = getPlayerIndexByUid(uid)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return errorCode
  end
  local player = Data.playerList[index]

  -- 检查有没有在房间内 , 是不是房主 , 前后地图有没有改变
  if not player then
    return ERROR_CODE.ROOM_PLAYER_NOT_EXISTS
  elseif not player.isMaster then
    return ERROR_CODE.ROOM_NOT_MASTER
  elseif Data.mapId == mapId then
    return ERROR_CODE.ROOM_MAP_SAME
  end

  Data.mapId = mapId
  sendToAll("SyncRoomInfo", {
    is_sync = true,
    error_code = ERROR_CODE.BASE_SUCESS,
    room_info = _M.packRoomInfo(),
  })
  skynet.send(SVR.hall, "lua", "changeMap", Data.ROOM_ID, Data.mapId)
  return ERROR_CODE.BASE_SUCESS
end

---打包RoomInfo消息 (protobuf)
---@return integer errorCode 错误码
---@return table RoomInfo (protobuf)
function _M.packRoomInfo()
  util.log("[Room][Cmd][packRoomInfo]")
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