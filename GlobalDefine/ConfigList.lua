-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 14:32:11
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-15 20:29:11
-- FilePath     : /BigServer/GlobalDefine/ConfigList.lua
-- Description  : 配置文件表--记录GameConfig目录中的配置文件
-- -----------------------------

--[[
  只有在此处被收录的配置并标记true的文件, 才会被ConfigLoader服务加载
--]]

return {
  ServiceName = true,    -- 服务名表
  RoomRole = true,       -- 房间内规则
  DatabaseConf = false,  -- 数据库相关配置
  RaceMap = true,        -- 比赛地图
}