
‰

Base.protoPacket"7
BaseMessage
name (	Rname
bytes (Rbytes"S
Account
account (	Raccount
password (	Rpassword
name (	Rname"P
ReqRegisterAccount:
register_account (2.Packet.AccountRregisterAccount"3
RetRegisterAccount

error_code (R	errorCode"G
ReqLoginAccount4
login_account (2.Packet.AccountRloginAccount"0
RetLoginAccount

error_code (R	errorCode"]
BaseRoomInfo
room_id (RroomId

player_num (R	playerNum
map_id (RmapId"
ReqHallMessage"x
SyncHallMessage
is_sync (RisSync
room_num (RroomNum1
	room_list (2.Packet.BaseRoomInfoRroomList"
ReqCreateRoom"G
RetCreateRoom

error_code (R	errorCode
room_id (RroomId"&
ReqJoinRoom
room_id (RroomId"G
RetJoinRoom

error_code (R	errorCode
self_pos (RselfPos"—
RoomPlayerInfo2
account_info (2.Packet.AccountRaccountInfo
room_pos (RroomPos
	is_master (RisMaster
is_ready (RisReady"s
RoomInfo
room_id (RroomId7
player_list (2.Packet.RoomPlayerInfoR
playerList
map_id (RmapId"&
ReqRoomInfo
room_id (RroomId"u
SyncRoomInfo
is_sync (RisSync

error_code (R	errorCode-
	room_info (2.Packet.RoomInfoRroomInfo"k
ReqPlayerAction
action_code (R
actionCode7
player_info (2.Packet.RoomPlayerInfoR
playerInfo"k
SyncPlayerAction
is_sync (RisSync
action_code (R
actionCode

error_code (R	errorCode"z
GamePlayerInfo2
account_info (2.Packet.AccountRaccountInfo
game_pos (RgamePos
color_id (RcolorId"Z
GameInfo
map_id (RmapId7
player_list (2.Packet.GamePlayerInfoR
playerList"=
SyncLoadGame-
	game_info (2.Packet.GameInfoRgameInfo"
ReportLoadGame"
ReqStartGame"
SyncStartGame"ˆ
Position
pos_x (RposX
pos_y (RposY
pos_z (RposZ
rot_x (RrotX
rot_y (RrotY
rot_z (RrotZ">
ReportPosition,
position (2.Packet.PositionRposition"l
SyncPosition.
player (2.Packet.GamePlayerInfoRplayer,
position (2.Packet.PositionRposition"9
ReportGameState&
game_state_code (RgameStateCode"g
SyncGameState.
player (2.Packet.GamePlayerInfoRplayer&
game_state_code (RgameStateCode