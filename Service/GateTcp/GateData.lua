-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-18 18:08:24
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-18 18:08:24
-- FilePath     : /BigServer/Service/GateNew/GateData.lua
-- Description  : 网关--数据
-- -----------------------------

return {
  ---网关配置
  ---@type table<addr|port|maxClient|svrName, ...>
  conf = {},

  ---fd->链接信息映射
  ---@type table<fd, fd|agent>
  connection = {},
}