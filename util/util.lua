local skynet = require "skynet"
require "skynet.manager"

-- local _M = {}

function SetSvr(svrName)
  skynet.register("."..skynet.getenv(svrName))
end

---通过服务配置获得服务地址
---@param svrName string 服务名(config.serrvice中)
---@return string 服务地址
function GetSvr(svrName)
  return skynet.localname("."..skynet.getenv(svrName))
end

-- return _M