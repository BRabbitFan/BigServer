package.path = "./3rd/lua-protobuf/?.lua;" .. package.path
package.cpath = "./3rd/lua-protobuf/?.so;" .. package.cpath
local protoc = require "protoc"
local pb = require "pb"
local serpent = require "serpent"

local util = require "Util.BaseUtil"

pb.loadfile "Proto/Base.pb"

local tab = {
  is_sync = false,
  room_num = 1,
  room_list = {},
}

table.insert(tab.room_list, {
  room_id = 5542,
  player_num = 1,
  map_id = 1,
})

local bytes = pb.encode("Packet.SyncHallMessage", tab)
local table = pb.decode("Packet.SyncHallMessage", bytes)

print(util.tabToStr(table, "block"))