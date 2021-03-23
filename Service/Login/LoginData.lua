-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-22 22:37:44
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-22 22:37:44
-- FilePath     : /BigServer/Service/Login/LoginData.lua
-- Description  : 登录服务--数据
-- -----------------------------

return {
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