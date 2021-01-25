-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-05 14:17:40
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-25 21:56:54
-- FilePath     : /BigServer/conf/service_name.lua
-- Description  : 服务别名表
-- -----------------------------

---服务别名表
---@type table<service_name, local_service_name>
return {
  --#region gateway
  gate = ".gate",          -- 网关
  watchdog = ".watchdog",  -- watchdog
  --#endregion
  dataCenter = ".dataCenter",  -- 数据中心
}