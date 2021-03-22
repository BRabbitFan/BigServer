-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-22 13:07:52
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-22 13:07:52
-- FilePath     : /BigServer/Service/GateUdp/GateData.lua
-- Description  : UDP网关--数据
-- -----------------------------

return {
  ---网关配置
  ---@type table<addr|port|maxClient|svrName, ...>
  conf = {},

  ---address->链接信息映射
  ---@type table<address, fd|address|agent>
  connection = {},
}