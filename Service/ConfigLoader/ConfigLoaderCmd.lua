-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 21:53:46
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 14:16:55
-- FilePath     : /BigServer/Service/ConfigLoader/ConfigLoaderCmd.lua
-- Description  : 配置服务--服务器指令
-- -----------------------------

local skynet = require "skynet"
local sharedata = require "skynet.sharedata"

local _M = {}

local confPath = "GameConfig."

local confList = {
  ServiceName = true,
  -- fileName = true,  -- true代表允许被加载
}

-- 加载配置文件
local function loadConf(loadList)
  local CONF = {}
  for _, fileName in ipairs(loadList) do
    local filePath = confPath .. fileName
    CONF[fileName] = require(filePath)
  end
  if next(CONF) then
    sharedata.new("CONF", CONF)
  end
end

-- 重载配置文件
local function reloadConf(reloadList)
  
end

function _M.start(conf)
  if not conf then
    skynet.exit()
  end

  local realLoadList = {}

  if conf.loadAll then  -- 排除confList内被拒绝加载的文件
    for fileName, state in pairs(confList) do
      if state then
        table.insert(realLoadList, fileName)
      end
    end
  else  -- 检查传入文件名是否允许被加载
    for _, fileName in ipairs(conf.loadList) do
      if confList[fileName] then
        table.insert(realLoadList, fileName)
      end
    end
  end

  if conf.reload then
    reloadConf(realLoadList)
  else
    loadConf(realLoadList)
  end
end

return _M