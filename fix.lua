local args = ...

if not args then
  print("args is nil")
  return
end

local svrData = args .. "Data"

local Data = require(svrData)
local util = require "Util.SvrUtil"

print(svrData .. " = " .. util.tabToStr(Data, "block"))
