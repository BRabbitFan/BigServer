-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:19:36
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-13 16:48:32
-- FilePath     : /BigServer/Service/Hall/HallData.lua
-- Description  : 游戏大厅--数据
-- -----------------------------

return  {

  ---全局配置
  GLOBAL_CONFIG = {};

  ---大厅信息
  ---@type table<maxRoomNum, ...>
  info = {
    ---@type integer
    maxRoomNum = nil,  ---最大房间数

    ---@type integer
    roomNum = nil,     ---当前房间数量
  },

  ---房间列表
  ---@type table<roomId, table<roomId|playerNum|mapId|roomAddr, ...>>
  roomList = {
    -- [1234] = {
    --   roomId = 1234;      ---房间id
    --   playerNum = 2;   ---玩家数量
    --   mapId = 3;       ---地图id
    --   roomAddr = xxx;  ---房间服务地址
    -- }, ...
  }

}