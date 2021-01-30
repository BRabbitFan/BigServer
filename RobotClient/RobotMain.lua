-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 16:55:44
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 17:18:08
-- FilePath     : /BigServer/RobotClient/RobotMain.lua
-- Description  : 机器人客户端--主服务(控制服务)
-- -----------------------------

local skynet = require "skynet"

function StartClient(conf)
  local client = skynet.newservice("Client")
  local randomUser = tostring(math.random(10000, 99999))
  skynet.send(client, "lua", "start", {
    account = conf.account or randomUser,
    password = conf.password or randomUser,
  })
end

skynet.start(function()
  StartClient({
    account = "jhfan",
    password = "fanjh",
  })
  skynet.error("main start!!!!")
end)