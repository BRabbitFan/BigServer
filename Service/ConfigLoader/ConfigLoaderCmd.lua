-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 21:53:46
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-15 20:26:48
-- FilePath     : /BigServer/Service/ConfigLoader/ConfigLoaderCmd.lua
-- Description  : 配置服务--服务器指令
-- -----------------------------

local skynet = require "skynet"
local sharedata = require "skynet.sharedata"
local util = require "Util.BaseUtil"

local _M = {}

local confPath = "GameConfig."

local confList = require "GlobalDefine.ConfigList" or {}

local function unrequire(modName)
  package.loaded[modName] = nil
  _ENV[modName] = nil
  collectgarbage()
end

-- 加载配置文件
local function loadConf(isReload)
  local CONF = {}
  for fileName, state in pairs(confList) do
    if state then
      local filePath = confPath .. fileName
      CONF[fileName] = require(filePath)
    end
  end
  if next(CONF) then
    if isReload then
      sharedata.update("CONF", CONF)
    else
      sharedata.new("CONF", CONF)
    end
  end
end

function _M.start(conf)
  if not conf then
    skynet.exit()
  end
  loadConf(conf.isReload)
end

return _M