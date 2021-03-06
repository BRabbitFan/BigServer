-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:51:41
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-06 16:51:43
-- FilePath     : /BigServer/Service/Agent/AgentData.lua
-- Description  : 玩家的个人信息
-- -----------------------------

return {

  ---基本信息
  ---@type table<fd|gate, ...>
  base = {
    ---客户端socket句柄
    ---@type number
    fd = nil,

    ---网关地址
    ---@type number
    gate = nil,
  }

}