-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 21:53:46
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-29 22:59:39
-- FilePath     : /BigServer/service/conf_svr/conf_cmd.lua
-- Description  : 配置服务--服务器指令
-- -----------------------------

local skynet = require "skynet"

local _M = {}

local function loadConf()
  
end

local function loadProto()
  
end

function _M.start(loadTable)
  repeat
    if not loadTable then
      break
    end
    local confList = loadTable.conf
    local protoList = loadTable.proto
  until true
  skynet.exit()
end

return _M