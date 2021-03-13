-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:20:03
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-13 18:31:56
-- FilePath     : /BigServer/Service/Hall/HallCmd.lua
-- Description  : 游戏大厅--服务命令
-- -----------------------------

local skynet = require "skynet"

local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"

local DATA = require "HallData"

local _M = {}

---服务初始化(MainSvr)
---@param conf table 配置表
function _M.start(conf)
  util.setSvr(conf.svrName)
end

---查询大厅信息
---@return number errorCode 错误码
---@return integer roomNum 房间数量
---@return table roomList 房间列表(HallData.info.roomList)
function _M.getHallInfo()
  return ERROR_CODE.BASE_SUCESS, DATA.info.roomNum, DATA.roomList
end

---玩家创建房间
---@return number errorCode 错误码
---@return number roomAddr 房间服务地址
function _M.createRoom()
  -- 检查房间数量上限
  if DATA.info.roomNum == DATA.GLOBAL_CONFIG.RoomRole.maxRoomNum then
    return ERROR_CODE.HALL_ROOM_NUM_MAX
  end
  -- 开启房间
  local newRoom = skynet.newservice("Room")
  skynet.call(newRoom, "lua", "start")
  -- 返回房间服务地址
  return ERROR_CODE.BASE_SUCESS, newRoom
end

---玩家加入房间
---@param roomId integer 要加入的房间Id
---@return number errorCode 错误码
---@return number roomAddr 房间服务地址
function _M.joinRoom(roomId)
  -- 查询房间
  local room = DATA.roomList[roomId] or nil
  if not room then
    return ERROR_CODE.HALL_ROOM_NOT_EXISTS
  end
  -- 满员检查
  if room.playerNum == DATA.GLOBAL_CONFIG.maxPlayerNum then
    return ERROR_CODE.HALL_PLAYER_NUM_FULL
  end
  -- 允许加入
  room.playerNum = room.playerNum + 1
  return ERROR_CODE.BASE_SUCESS, room.roomAddr
end

---玩家退出房间
---@param roomId integer 要退出的房间Id
---@return number errorCode 错误码
function _M.quitRoom(roomId)
  -- 查询房间
  local room = DATA.roomList[roomId] or nil
  if not room then
    return ERROR_CODE.HALL_ROOM_NOT_EXISTS
  end
  -- 退出房间
  room.playerNum = room.playerNum - 1
  if room.playerNum <= 0 then  -- 房间没人则关闭 (Room会请求closeRoom, 正常不应该进入此分支)
    _M.closeRoom(roomId)
  end
  return ERROR_CODE.BASE_SUCESS
end

---关闭房间
---@param roomId integer 要关闭的房间
---@return number errorCode 错误码
function _M.closeRoom(roomId)
  -- 查询房间
  if not DATA.roomList[roomId] then  -- 若不存在(已关闭)则返回
    return ERROR_CODE.BASE_SUCESS
  end
  -- 关闭房间
  DATA.roomList[roomId] = nil
  return ERROR_CODE.BASE_SUCESS
end

return _M