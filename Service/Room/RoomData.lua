-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-13 19:08:19
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-13 19:08:29
-- FilePath     : /BigServer/Service/Room/RoomData.lua
-- Description  : 房间服务--数据
-- -----------------------------

return  {

  ---全局配置
  GLOBAL_CONFIG = {};

  ---@type integer
  ROOM_ID = nil,  -- 房间号

  ---@type integer
  mapId = nil,  -- 地图Id

  ---玩家列表
  ---@type list<_, table<name|pos|isReady|isMaster, ...>>
  playerList = {
  --   [1] = {
  --     uid = 100,
  --     account = "asdf",
  --     name = "playerA",
  --     pos = 2,
  --     isReady = false,
  --     isMaster = true,
  --     agent = xxx,
  --   }, ...
  }
}