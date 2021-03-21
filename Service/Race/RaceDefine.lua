-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-19 15:10:23
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-19 15:10:23
-- FilePath     : /BigServer/Service/Race/RaceDefine.lua
-- Description  : 游戏服务--有关定义
-- -----------------------------

return {
  -- 玩家状态
  STATE = {
    OFFLINE = -1,  -- 掉线
    LOADING = 0,   -- 加载中
    READY = 1,     -- 准备(加载完毕)
    GAMING = 2,    -- 游戏中
    FINISH = 3,    -- 完赛
    OVERTIME = 4,  -- 超时
  },
}