-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:51:41
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-29 21:30:50
-- FilePath     : /BigServer/service/agent/data.lua
-- Description  : 玩家的个人信息
-- -----------------------------

return {

  -- 基本信息
  ---@type table<client|gate|watchdog, fd|addr>
  base = {
    -- 客户端socket句柄
    client = nil,  ---@type number
    -- 网关地址
    gate = nil,  ---@type number
    -- watchdog地址
    watchdog = nil,  ---@type number
  }

}