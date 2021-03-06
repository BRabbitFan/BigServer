-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 16:55:44
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-06 15:34:32
-- FilePath     : /BigServer/RobotClient/RobotMain.lua
-- Description  : 机器人客户端--主服务(控制服务)
-- -----------------------------

local skynet = require "skynet"

local util = require "Util.BaseUtil"

---客户端列表
ClientList = {}  ---@type table<account, table<client|DATA|STATE, ...>>
-- 服务器ip
ServerAddr = nil  ---@type string
-- 服务器端口
ServerPort = nil  ---@type string

function StartClient(conf)
  local randomAccount = tostring(math.random(10000, 99999))
  local info = {
    account = conf.account or randomAccount,
    password = conf.password or randomAccount,
    addr = conf.addr or ServerAddr,
    port = conf.port or ServerPort,
  }
  local newClient = skynet.newservice("Client")
  local newDATA, newSTATE = skynet.call(newClient, "lua", "start", info)
  ClientList[info.account] = {
    client = newClient,
    DATA = newDATA,
    STATE = newSTATE,
  }
end

skynet.start(function()
  ServerAddr = skynet.getenv "server_addr"
  ServerPort = skynet.getenv "server_port"

  -- print(type(ServerAddr), type(ServerPort))

  StartClient({
    MainSvr = skynet.self(),
    account = "jhfan",
    password = "fanjh",
    addr = ServerAddr,
    port = ServerPort,
  })

  skynet.send(ClientList.jhfan.client, "lua", "connect")

end)