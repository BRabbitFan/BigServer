--[[
这个是测试数据, 服务别名定义放在GlobalName/ServiceName.lua中
]]

---服务别名表
---@type table<service_name, local_service_name>
return {
  --#region gateway
  gate = ".gate",          -- 网关
  watchdog = ".watchdog",  -- watchdog
  --#endregion
  dataCenter = ".dataCenter",  -- 数据中心
}