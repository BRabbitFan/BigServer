-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:51:41
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-12 17:22:49
-- FilePath     : /BigServer/Service/Agent/AgentData.lua
-- Description  : 玩家的个人信息
-- -----------------------------

return {

  ---基本信息
  ---@type table<fd|gate, ...>
  base = {
    ---@type number
    fd = nil,   ---客户端socket句柄

    ---@type number
    gate = nil,  ---网关地址
  },

  ---账号信息
  ---@type table<account|password|name, ...>
  account = {
    ---@type string
    account = nil,  ---账号

    ---@type string
    password = nil, ---密码

    ---@type string
    name = nil,     ---名字
  },

}