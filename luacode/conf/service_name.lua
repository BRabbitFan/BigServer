-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-05 14:17:40
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-19 21:59:15
-- FilePath     : /BigServer/luacode/conf/service_name.lua
-- Description  : 配置表---服务别名表
-- -----------------------------

---配置表
---@type table<conf_table_name, conf_table<k, ...>>
conf = conf or {}

---服务别名表
---@type table<service_name, local_service_name>
conf.service_name = {
  --#region gateway
  gate = ".gate",          -- 网关
  watchdog = ".watchdog",  -- watchdog
  --#endregion
}