-- -----------------------------
-- symbol_custom_string_obkoro1: https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-06 16:26:32
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-06 16:42:59
-- FilePath     : /BigServer/Service/Gate/GateData.lua
-- Description  : 网关数据--配置与链接信息等
-- -----------------------------

return {
  ---网关配置
  ---@type table<port|maxclient|nodelay|servername, ...>
  conf = {},

  ---fd->链接信息映射
  ---@type table<fd, fd|addr|agent>
  connection = {},

  ---agent->Fd映射
  ---@type table<agent, fd>
  agentToFd = {},
}