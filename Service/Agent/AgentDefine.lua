-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-18 14:25:21
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-18 14:25:21
-- FilePath     : /BigServer/Service/Agent/AgentConf.lua
-- Description  : Agent定义
-- -----------------------------

return {
  ---房间内动作
  ROOM_ACTION = {
    [1] = "GET_READY",
    [2] = "UN_READY",
    [3] = "QUIT_ROOM",
    [4] = "CHANGE_MAP",
    GET_READY = 1,   -- 准备
    UN_READY = 2,    -- 取消准备
    QUIT_ROOM= 3,    -- 退出房间
    CHANGE_MAP = 4,  -- 换地图
  },

  ---网络连接模式
  NET_MODE = {
    TCP = "tcp",
    UDP = "udp",
  }
}