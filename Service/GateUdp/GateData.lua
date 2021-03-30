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

  ---addr->链接信息映射
  ---@type table<addr, sendAddr|ip|port|agent>
  client = {},

  ---@type integer
  maxToken = nil,  -- 最大token

  ---等待检查列表
  ---@type table<mode|token|fd|recvAddr|sendAddr, ...>
  waitChk = {
    -- mode = "udp",
    -- token = 1234,
    -- fd = 6,
    -- recvAddr = ...,
    -- sendAddr = ...,
  },
}