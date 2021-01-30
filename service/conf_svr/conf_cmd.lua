-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 21:53:46
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 12:00:19
-- FilePath     : /BigServer/service/conf_svr/conf_cmd.lua
-- Description  : 配置服务--服务器指令
-- -----------------------------

local skynet = require "skynet"
local sharedata = require "skynet.sharedata"

local _M = {}

local confPath = "conf"

local confList = {
  service_name = true,
  -- fileName = true,  -- true代表允许被加载
}

-- 加载配置文件
local function loadConf(loadList)
  local CONF = {}
  for _, fileName in ipairs(loadList) do
    local filePath = confPath .. "." .. fileName
    CONF[fileName] = require(filePath)
  end
  sharedata.new("CONF", CONF)
end

-- 重载配置文件
local function reloadConf(reloadList)
  
end

-- 服务启动
function _M.start(loadTable)
  if not loadTable then
    skynet.exit()
  end

  local loadList = {}

  if loadTable.loadAll then
    for fileName, state in pairs(confList) do
      if state then
        table.insert(loadList, fileName)
      end
    end
  else
    for _, fileName in ipairs(loadTable.loadList) do
      if confList[fileName] then
        table.insert(loadList, fileName)
      end
    end
  end

  loadConf(confList)
end

return _M