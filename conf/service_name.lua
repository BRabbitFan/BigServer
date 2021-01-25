-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-05 14:17:40
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-23 16:02:12
-- FilePath     : /BigServer/conf/service_name.lua
-- Description  : 服务别名表
-- -----------------------------

---服务别名表
---@type table<service_name, local_service_name>
local _M = {
  --#region gateway
  gate = ".gate",          -- 网关
  watchdog = ".watchdog",  -- watchdog
  --#endregion
}