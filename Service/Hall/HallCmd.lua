-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:20:03
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-13 18:35:17
-- FilePath     : /BigServer/Service/Hall/HallCmd.lua
-- Description  : 游戏大厅--服务命令
-- -----------------------------

local skynet = require "skynet"

local util = require "Util.SvrUtil"

local SVR = require "GameConfig.ServiceName"
local ERROR_CODE = require "GlobalDefine.ErrorCode"

local Data = require "HallData"

local _M = {}

---启动Hall
---@param conf table 配置表
function _M.start(conf)
  util.setSvr(conf.svrName)
  Data.info.roomNum = 0;
end

---打包消息SyncHallMessage
---@return table SyncHallMessage
local function packSyncHallMessage()
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

---将消息发送给全体在线玩家
---@param msgName string 消息名
---@param msgTable table 消息table
local function sendToAllOnlinePlayer(msgName, msgTable)
  skynet.send(SVR.dataCenter, "lua", "sendToAllOnlinePlayer", msgName, msgTable)
end

---查询大厅信息
---@return number errorCode 错误码
---@return integer roomNum 房间数量
---@return table roomList 房间列表(HallData.info.roomList)
function _M.getHallInfo()
  return ERROR_CODE.BASE_SUCESS, util.tabLen(Data.roomList), Data.roomList
end

---获得新的随机房间号
---@return integer newRoomId 房间号
local function getNewRoomId()
  local roomList = Data.roomList
  local newRoomId
  while true do
    newRoomId = math.random(1000, 9999)
    local isExists = false
    for _, room in ipairs(roomList) do
      if room.roomId == newRoomId then
        isExists = true
        break
      end
    end
    if not isExists then
      return newRoomId
    end
  end
end

---玩家创建房间
---@param account table 创建房间的玩家账号信息
---@return number errorCode 错误码
---@return number roomAddr 房间服务地址
function _M.createRoom(account, agent)
  local info = Data.info
  local roomList = Data.roomList
  -- 检查房间数是否已满
  if info.roomNum == Data.GLOBAL_CONFIG.RoomRole.maxRoomNum then
    return ERROR_CODE.HALL_ROOM_NUM_MAX
  end
  -- 开启新房间
  local newRoomId = getNewRoomId()
  local newRoom = skynet.newservice("Room")
  skynet.call(newRoom, "lua", "start", {
    roomId = newRoomId,
    master = account,
    agent = agent,
  })
  -- 记录房间
  roomList[newRoomId] = {
    roomId = newRoomId,
    playerNum = 1,
    mapId = 1,
    roomAddr = newRoom,
  }
  -- 同步给全体玩家
  sendToAllOnlinePlayer("SyncHallMessage", packSyncHallMessage())
  -- 返回新房间
  return ERROR_CODE.BASE_SUCESS, newRoom
end

---玩家加入房间
---@param roomId integer 要加入的房间Id
---@return number errorCode 错误码
---@return number roomAddr 房间服务地址
function _M.joinRoom(roomId)
  local room = Data.roomList[roomId] or nil
  if not room then
    return ERROR_CODE.HALL_ROOM_NOT_EXISTS
  end

  if room.playerNum == Data.GLOBAL_CONFIG.maxPlayerNum then
    return ERROR_CODE.HALL_PLAYER_NUM_FULL
  end

  room.playerNum = room.playerNum + 1

  -- 同步给全体玩家
  sendToAllOnlinePlayer("SyncHallMessage", packSyncHallMessage())

  return ERROR_CODE.BASE_SUCESS, room.roomAddr
end

---玩家退出房间
---@param roomId integer 要退出的房间Id
---@return number errorCode 错误码
function _M.quitRoom(roomId)
  local room = Data.roomList[roomId] or nil
  if not room then
    return ERROR_CODE.HALL_ROOM_NOT_EXISTS
  end

  room.playerNum = room.playerNum - 1
  if room.playerNum <= 0 then  -- 房间没人则关闭 (Room会请求closeRoom, 正常不应该进入此分支)
    _M.closeRoom(roomId)
  end

  -- 同步给全体玩家
  sendToAllOnlinePlayer("SyncHallMessage", packSyncHallMessage())

  return ERROR_CODE.BASE_SUCESS
end

---玩家切换地图
---@param roomId integer 换地图的房间号
---@param mapId integer 新地图
---@return number errorCode 错误码
function _M.changeMap(roomId, mapId)
  local room = Data.roomList[roomId] or nil
  if not room then
    return ERROR_CODE.HALL_ROOM_NOT_EXISTS
  end

  if room.mapId == mapId then
    return ERROR_CODE.HALL_ROOM_MAP_SAME
  end

  room.mapId = mapId
  sendToAllOnlinePlayer("SyncHallMessage", packSyncHallMessage())
  return ERROR_CODE.BASE_SUCESS
end

---关闭房间
---@param roomId integer 要关闭的房间
---@return number errorCode 错误码
function _M.closeRoom(roomId)
  if not Data.roomList[roomId] then  -- 若不存在(已关闭)则返回
    return ERROR_CODE.HALL_ROOM_NOT_EXISTS
  end

  Data.roomList[roomId] = nil

  sendToAllOnlinePlayer("SyncHallMessage", packSyncHallMessage())

  return ERROR_CODE.BASE_SUCESS
end

return _M