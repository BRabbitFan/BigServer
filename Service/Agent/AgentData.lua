-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:51:41
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-12 17:22:49
-- FilePath     : /BigServer/Service/Agent/AgentData.lua
-- Description  : 玩家的个人信息
-- -----------------------------

return {

  ---基本信息
  ---@type table<fd|gate, ...>
  base = {
    ---@type string
    mode = nil,  -- 网络连接模式 ("tcp" / "udp")

    ---@type number
    fd = nil,    -- 客户端socket句柄

    ---@type byte
    sendAddr = nil,  -- 客户端发送地址

    ---@type byte
    recvAddr = nil,  -- 客户端接收地址

    ---@type number
    lastPing = nil,  -- 距离上一次心跳的时间
  },

  ---账号信息
  ---@type table<account|password|name, ...>
  account = {
    ---@type integer
    uid = nil,      -- uid

    ---@type string
    account = nil,  -- 账号

    ---@type string
    password = nil, -- 密码

    ---@type string
    name = nil,     -- 名字

    ---@type integer
    score = nil,    -- 积分
  },

  ---房间信息
  ---@type table<addr, ...>
  room = {
    addr = nil,  -- 服务地址
  },

  ---游戏信息
  ---@type table
  race = {
    addr = nil,  -- 服务地址
  },

}