local Data = require "DataCenterData"
local util = require "Util.SvrUtil"

local Cmd = require "DataCenterCmd"

Cmd.setPlayerRegister("aaa")

print(util.tabToStr(Data, "block"))
