require("www/database2")
require("www/quest")
require("www/shop")
require("www/talants")
require("www/rating")
require("www/smithy")
require("www/statist")
require("www/souls_inventory")

local point = Entities:FindByName( nil, 'check_pizdobol'):GetAbsOrigin() 
local Unit = CreateUnitByName('npc_dummy_unit', point, true, nil, nil, DOTA_TEAM_BADGUYS)