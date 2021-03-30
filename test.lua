
--[[ TestService.lua ]]
local skynet = require "skynet"  -- 导入skynet模块

skynet.start(function()  -- 服务启动，指定入口函数
  skynet.dispatch("lua", function(session, address, ...)  -- 注册lua消息的callback函数
    skynet.retpack(...)  -- 应答消息
  end)
end)




