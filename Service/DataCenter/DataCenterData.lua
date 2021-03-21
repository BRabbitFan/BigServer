-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-16 15:57:07
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:57:07
-- FilePath     : /BigServer/Service/DataCenter/DataCenterData.lua
-- Description  : 数据中心服务--数据
-- -----------------------------

return {
  ---已注册的所有账户列表
  ---@type table<account, boolean>
  AccountList = {},

  ---在线玩家uid->Agent地址映射表
  ---@type table<uid, agent>
  UidToAgent = {},
}