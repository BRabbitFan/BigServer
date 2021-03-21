package.path = "./3rd/lua-protobuf/?.lua;" .. package.path
package.cpath = "./3rd/lua-protobuf/?.so;" .. package.cpath
local protoc = require "protoc"
local pb = require "pb"
local serpent = require "serpent"

local util = require "Util.BaseUtil"

local COLOR_LIST = {
  RAD = 1,
  BLUE = 2,
  GREEN = 3,
  YELLOW = 4,
}

local playerList = {
  [1] = {colorId = nil,},
  [2] = {colorId = nil,},
  [3] = {colorId = nil,},
}

local function getColor()

  while true do
    local index = math.random(1, util.tabLen(COLOR_LIST))
    local colorId = util.getValByIdx(COLOR_LIST, index)

    local isUsed = false
    for _, player in pairs(playerList) do
      if player.colorId == colorId then
        isUsed = true
        break
      end
    end

    if not isUsed then
      return colorId
    end

  end
end

local colorId = getColor()
playerList[1].colorId = colorId

local colorId = getColor()
playerList[2].colorId = colorId

local colorId = getColor()
playerList[3].colorId = colorId

print(playerList[1].colorId, playerList[2].colorId, playerList[3].colorId)

-- function getValueByIndex(table, index)
--   for key, value in pairs(table) do
--     if index == 1 then
--       return value
--     else
--       index = index - 1
--     end
--   end
-- end

-- for key, id in pairs(COLOR_LIST)do
--   print("  "..id)
-- end

-- print(getValueByIndex(COLOR_LIST, 1))
-- print(getValueByIndex(COLOR_LIST, 2))
-- print(getValueByIndex(COLOR_LIST, 3))
-- print(getValueByIndex(COLOR_LIST, 4))