-- -----------------------------
-- symbol_custom_string_obkoro1: https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:23:06
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-12 21:23:07
-- FilePath     : /BigServer/Service/Race/RaceData.lua
-- Description  : 游戏服务--数据
-- -----------------------------

return {
  -- 全局定义
  GLOBAL_CONFIG = {},

  ---@type integer
  MAP_ID = nil,  -- 地图号

  ---@type integer
  startTime = nil,  -- 开始时间(时间戳)

  ---玩家列表
  ---@type list<_, table<uid|account|name|pos|inOnlie|isFinish|agent, ...>>
  playerList = {
    -- [1] = {
    --   uid = 23,
    --   account = "qwer",
    --   name = "playerA",
    --   pos = 2,
    --   state = 0,
    --   colorId = 2,
    --   agent = xxx,
    -- }, ...
  },
}