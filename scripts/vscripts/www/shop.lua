if Shop == nil then
    _G.Shop = class({})
end

function Shop:init()
	Shop.pShop = {}
    CustomGameEventManager:RegisterListener("giveItem", Dynamic_Wrap( Shop, 'giveItem' ))
	CustomGameEventManager:RegisterListener("buyItem", Dynamic_Wrap( Shop, 'buyItem' ))
    CustomGameEventManager:RegisterListener("takeOffEffect", Dynamic_Wrap( Shop, 'takeOffEffect' ))
	ListenToGameEvent("player_reconnected", Dynamic_Wrap( Shop, 'OnPlayerReconnected' ), self)
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( Shop, 'OnGameRulesStateChange'), self)
	CustomGameEventManager:RegisterListener("GetPets",function(_, keys)
        Shop:GetPets(keys)
    end)
	CustomGameEventManager:RegisterListener("UpdatePetButton",function(_, keys)
        Shop:UpdatePetButton(keys)
    end)
	CustomGameEventManager:RegisterListener("OpenTreasure",function(_, keys)
        Shop:OpenTreasure(keys)
    end)
	CustomGameEventManager:RegisterListener("SprayToggleActivate",function(_, keys)
        Shop:SprayToggleActivate(keys)
    end)
	
	ListenToGameEvent("player_chat", Dynamic_Wrap( Shop, "OnChat" ), self )
	Shop.marci = {name = "change_hero_marci", hero_name = "npc_dota_hero_marci", available={[0]=false,[1]=false,[2]=false,[3]=false,[4]=false}, selected={[0]=false,[1]=false,[2]=false,[3]=false,[4]=false}}
	Shop.pango = {name = "change_hero_pangolier", hero_name = "npc_dota_hero_pangolier",available={[0]=false,[1]=false,[2]=false,[3]=false,[4]=false}, selected={[0]=false,[1]=false,[2]=false,[3]=false,[4]=false}}
	Shop.pet = {}
	CustomGameEventManager:RegisterListener("GetPet",function(_, keys)
        Shop:GetPet(keys)
    end)
	CustomGameEventManager:RegisterListener("AutoGetPetOprion",function(_, keys)
        Shop:AutoGetPetOprion(keys)
    end)
	Shop.Auto_Pet = {}
	Shop.Change_Available = {}
	Shop.sprayCategory = 4
	Shop.spray = {}
end

function Shop:GetPets(keys)
	print("Shop:GetPets(keys)")
	DeepPrintTable(keys)
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "GetPets_Js", {
		shop = Shop.pShop[keys.PlayerID],
		exp = pets_exp,
		auto_pet = Shop.Auto_Pet[keys.PlayerID]
	} )
end

function Shop:OnChat( event )
    local text = event.text
	local pid = event.playerid
	local steamID = PlayerResource:GetSteamAccountID(pid)
	if steamID == 169401485 or steamID == 1062658804 or steamID == 455872541 or steamID == 393187346 or steamID == 1250222698 then
		if text == "pet" then
			Shop:RefreshPet(pid)
		end
	end
end

function Shop:RefreshPet(PlayerID)
	local hero = PlayerResource:GetSelectedHeroEntity(PlayerID)
	item = hero:GetItemInSlot( 16 )
	if item == nil then
		return
	end
	hero:RemoveItem(item)

	for _,v in pairs(Shop.pShop[PlayerID][1]) do
		if type(v) == 'table' then
			if v.status == "issued" then
				v.status = "taik"
				break
			end
		end
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( PlayerID ), "shop_refresh_pets", Shop.pShop[PlayerID] )
end

function Shop:OnGameRulesStateChange(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(2, function() 
			for i = 0 , PlayerResource:GetPlayerCount()-1 do --
				if PlayerResource:IsValidPlayer(i) then
					if Shop.Auto_Pet[i] then 
						Shop:GetPet({
							PlayerID = i,
							pet = {name = Shop.Auto_Pet[i]},
						})
					else
						Shop:GetPet({
							PlayerID = i,
							pet = {name = "spell_item_pet"},
						})
					end
					Shop.Change_Available[i] = true
					CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "UpdatePetIcon", {
						can_change = Shop.Change_Available[i]
					} )
				end
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( i ), "initShop", Shop.pShop[i] )
			end
		end)	
	end
end

function Shop:OnPlayerReconnected(keys)
	local sid = PlayerResource:GetSteamAccountID(keys.PlayerID)
	local req = CreateHTTPRequestScriptVM( "POST", DataBase.updatecoins  .. '&sid=' .. sid )
	req:SetHTTPRequestGetOrPostParameter('sid',tostring(sid))
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			Shop.pShop[keys.PlayerID].coins = tonumber(res.Body)
		end
	end)
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(2, function() 
			local sid = PlayerResource:GetSteamAccountID( keys.PlayerID )
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "initShop", Shop.pShop[keys.PlayerID] )
			-- local selected = nil
			-- for _,item in ipairs(Shop.pShop[keys.PlayerID][1]) do
			-- 	if item.name == Shop.pet[keys.PlayerID] then
			-- 		selected = item
			-- 		break
			-- 	end
			-- end
			Shop:GetPets(keys)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(keys.PlayerID), "UpdatePetIcon", {
				can_change = Shop.Change_Available[keys.PlayerID],
				-- selected = selected,
			} )
		end)
	end
end


function Shop:createShop()

	if SHOP then
		for i = 0 , PlayerResource:GetPlayerCount() do --
			if PlayerResource:IsValidPlayer(i) then -- 
				local sid = PlayerResource:GetSteamAccountID(i)
				local arr = {}
				for sKey, sValue in pairs(basicshop) do
					if type(sValue) == 'table' then
						arr[sKey] = {}
						for oKey, oValue in pairs(sValue) do
							arr[sKey][oKey] = {}
							if type(oValue) == 'table' then

								for pKey, pValue in pairs(oValue) do
									arr[sKey][oKey][pKey] = pValue
								end
								
								if SHOP[i+1][oValue.name] then
									arr[sKey][oKey].onStart = tonumber(SHOP[i+1][oValue.name])
									arr[sKey][oKey].now = tonumber(SHOP[i+1][oValue.name])
									if arr[sKey][oKey].type == "consumabl" then
										arr[sKey][oKey].status = 'consumabl'
									elseif tonumber(SHOP[i+1][oValue.name]) > 0 then
										if arr[sKey][oKey].type == "talant" or arr[sKey][oKey].type == "pet_change" then
											arr[sKey][oKey].status = 'active'
										else
											arr[sKey][oKey].status = 'taik'
										end
									else
										arr[sKey][oKey].status = 'buy'
									end
								else
									if arr[sKey][oKey].type == "hero_change" then
										arr[sKey][oKey].onStart = 1
										arr[sKey][oKey].now = 1
										if SHOP[i+1]["totaldonate"] >= 2000 then
											arr[sKey][oKey].status = 'shop_select'
										else
											arr[sKey][oKey].status = 'shop_lock'
										end
									else
										arr[sKey][oKey].onStart = 0
										arr[sKey][oKey].now = 0
										if arr[sKey][oKey].type == "consumabl" then
											arr[sKey][oKey].status = 'consumabl'
										else
											arr[sKey][oKey].status = 'buy'
										end
									end
								end
							elseif type(oValue) == 'string' then
								arr[sKey][oKey] = oValue
							end
						end
					end
				end
			
				if SHOP[i+1].coins then
					arr.coins = SHOP[i+1].coins
				else
					arr.coins = 0
				end
				if SHOP[i+1].mmrpoints then
					arr.mmrpoints = SHOP[i+1].mmrpoints
				else
					arr.mmrpoints = 0
				end
				if SHOP[i+1].totaldonate then
					arr.totaldonate = SHOP[i+1].totaldonate
				else
					arr.totaldonate = 0
				end
				if SHOP[i+1].feed then
					arr.feed = SHOP[i+1].feed
				else
					arr.feed = 0
				end
				
				if SHOP[i+1].other_60 then
					arr.ban = SHOP[i+1].other_60
				else
					arr.ban = 0
				end
				Shop.pShop[i] = arr
				CustomNetTables:SetTableValue("shopinfo", tostring(i), {feed = arr.feed, coins = arr.coins, mmrpoints = arr.mmrpoints, likes = RATING[ 'rating' ][ i + 1 ][ 'likes' ], reports = RATING[ 'rating' ][ i + 1 ][ 'reports' ]})

				Shop.Auto_Pet[i] = SHOP[i+1].auto_pet
				Shop.spray[i] = SHOP[i+1].auto_spray
				Shop.Change_Available[i] = true
			end
		end
		
		for i = 0, 4 do
            Timers:CreateTimer(function()
                if PlayerResource:GetPlayer(i) == nil then
                    return nil
                end
                if PlayerResource:HasSelectedHero(i) then
                    local heroName = PlayerResource:GetSelectedHeroName(i)
                    talants:pickinfo(i,false)
                    return nil
                else
                  --  print(PlayerResource:HasSelectedHero(i))
                end
                return 1.0
            end)
        end
	else
		print("============================")
		print("ERROR: _G.SHOP not exist")
		print("CREATE SHOP FAILED")
		print("============================")
	end
end

function Shop:giveItem(t)
	local pid = t.PlayerID
	local sid = PlayerResource:GetSteamAccountID(pid)
	local categoryKey = t.i
	local productKey = t.n
	if tonumber(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now']) <= 0 or Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] == "issued" then
		return
	end
	local hero = PlayerResource:GetSelectedHeroEntity( pid )
	-- print(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now'])
	Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now'] = tonumber(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now']) - 1
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == 'pet' and Shop.pShop[pid][1][1].now == 1 then
		for PetKey,PetValue in pairs(Shop.pShop[pid][1]) do
			if PetValue.status == "issued" then
				PetValue.status = "taik"
				item16 = hero:GetItemInSlot( 16 )
				--print(item16)
				if item16 ~= nil then
					--print("remove:item16")
					hero:RemoveItem(item16)
				end
				PetValue.now = PetValue.now + 1
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( pid ), "change_pet", {1, PetKey} )
				break
			end
		end
	end
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now'] == 0 and Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] ~= "consumabl" then 
		Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] = 'issued'
	end
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == "effect" then
		LinkLuaModifier( "modifier_" .. Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].name, "effects/" .. Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].name, LUA_MODIFIER_MOTION_NONE )
		hero:AddNewModifier( hero, nil, "modifier_" .. Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].name, {} )
		Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] = 'takeoff'
	else
		local player = PlayerResource:GetSelectedHeroEntity(pid)
		local spawnPoint = player:GetAbsOrigin()
		player:AddItemByName(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname)
	end
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == "hero_change" then
		Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].status = "active"
		for heroChangeKey,heroChangeValue in pairs(Shop.pShop[pid][tonumber(categoryKey)]) do
			if heroChangeValue.type == "hero_change" and heroChangeKey ~= tonumber(productKey) then
				heroChangeValue.status = "shop_lock"
			end
		end
		Shop:ChangeHero(pid, Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].hero_name)
	end
	-- CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "UpdateStore", {
	-- 	shopinfo = Shop.pShop[pid], 
	-- 	updateCount = {
	-- 		{categoryKey = categoryKey, productKey = productKey},
	-- 	},
	-- })
end

function Shop:takeOffEffect(t)
	local pid = t.PlayerID
	Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['now'] = tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['now']) + 1

    local hero = PlayerResource:GetSelectedHeroEntity( pid )
    hero:RemoveModifierByName( "modifier_" .. Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)].name)

end


function Shop:buyItem(t)
	local pid = t.PlayerID
	local i = tonumber(t.i)
	local n = tonumber(t.n)
	local shop_type = Shop.pShop[pid][i][n]["type"]
	-- print('amountBuy=',t.amountBuy)
	if t.currency == 1 and Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] and tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] * t.amountBuy) > tonumber(Shop.pShop[pid].mmrpoints) then
		return
	elseif t.currency == 0 and Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don'] and tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don']*t.amountBuy) > tonumber(Shop.pShop[pid].coins) then
		return
	end
	if Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["type"] ~= "gem" and Shop.pShop[pid][i][n]["type"] ~= "loot-box" and Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["type"] ~= "feed" then
		Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['now'] = tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)].now) + t.amountBuy
		Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['onStart'] = tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['onStart']) + t.amountBuy
	end
	if t.currency == 1 then
		Shop.pShop[pid].mmrpoints = Shop.pShop[pid].mmrpoints - Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] * t.amountBuy
	else
		Shop.pShop[pid].coins = Shop.pShop[pid].coins - Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don'] * t.amountBuy
	end
	if DataBase:isCheatOn() == false then --
		local sql_name = {}
		local give = {}
		local currency = 'don'
		if t.currency == 1 then currency = 'rp' end
		local price = Shop.pShop[pid][i][n]['price'][currency]
		
		if Shop.pShop[pid][i][n]["type"] == "gem" then
			local gem_name = 'gem_' .. Shop.pShop[pid][i][n]['gem_type']
			sql_name[gem_name] = t.amountBuy
			give[gem_name] = Shop.pShop[pid][i][n]['give']
		elseif Shop.pShop[pid][i][n]["type"] == "loot-box" then
			-- loot box 
			for z = 1, t.amountBuy do
				local randomInt = RandomInt(1,100)
				local ds = 0
				local slt = nil
			end
		else
			local name = Shop.pShop[pid][i][n].name
			if Shop.pShop[pid][i][n].type == 'feed' then
				name = 'feed'
			end
			sql_name[name] = t.amountBuy
			give[name] = Shop.pShop[pid][i][n].give or 1
			Shop.pShop[pid]["feed"] = Shop.pShop[pid]["feed"] + sql_name[name] * give[name]
		end

		if shop_type == "talant" then
			talants:sendServer({PlayerID = pid, changename = "cout", value = 2, changetype = "set", chartype = "int", win_lose = nil, heroname = Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["hero"]})
			if Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["hero"] == PlayerResource:GetSelectedHeroName(pid) then
				local tab = CustomNetTables:GetTableValue("talants", tostring(pid))
				tab["cout"] = 2
				progress[t.PlayerID] = tab
				CustomNetTables:SetTableValue("talants", tostring(pid), tab)
			end
		elseif shop_type == "gem" then
			-- print(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["give"],' ',t.amountBuy,' ',Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["give"] * t.amountBuy)
			Smithy:add_gems({PlayerID = t.PlayerID, type = Shop.pShop[pid][i][n]["gem_type"], value = Shop.pShop[pid][i][n]["give"] * t.amountBuy, shop = true})
		end
		DataBase:buyRequest({PlayerID = t.PlayerID, name = sql_name, give = give, price = price, amount = t.amountBuy, currency = currency})
		
		local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(pid))
		shopinfo['feed'] = Shop.pShop[pid]["feed"]
		shopinfo['coins'] = Shop.pShop[pid]["coins"]
		shopinfo['mmrpoints'] = Shop.pShop[pid]["mmrpoints"]
		CustomNetTables:SetTableValue("shopinfo", tostring(pid), shopinfo)
	end
	-- CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "UpdateStore", {
	-- 	shopinfo = Shop.pShop[pid], 
	-- 	updateCount = {
	-- 		{categoryKey = i, productKey = n},
	-- 	},
	-- })
end


-- петы



function GetLevel(exp)
	local level = 10
	local passed_exp = 0
	for i = 1, 10 do 
		passed_exp = passed_exp + pets_exp[i-1]
		if exp >= passed_exp and exp < passed_exp + pets_exp[i] then
			level = i-1
			break
		end
	end
	return level
end

function Shop:UpdatePetButton(t)
	local pid = t.PlayerID
	local count = t.count
	if tonumber(Shop.pShop[pid]["feed"]) < tonumber(count) then return end
	Shop.pShop[pid]["feed"] = Shop.pShop[pid]["feed"] - tonumber(count)
	local pet = nil
	for k,v in pairs(Shop.pShop[pid][1]) do
		if v.name == t.pet.name then
			if v.now == 0 then return end
			v.now = v.now + count
			pet = v
			break
		end
	end
	if not DataBase:isCheatOn() then
		DataBase:UpdatePet(t.pet.name, pid, count)
	end
	local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(pid))
	shopinfo['feed'] = Shop.pShop[pid]["feed"]
	shopinfo['coins'] = Shop.pShop[pid]["coins"]
	shopinfo['mmrpoints'] = Shop.pShop[pid]["mmrpoints"]
	CustomNetTables:SetTableValue("shopinfo", tostring(pid), shopinfo)

	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	if Shop.pet[pid] == pet.itemname then
		hero:RemoveAbility(pet.itemname)
		hero:AddAbility(pet.itemname):SetLevel(GetLevel(pet.now))
	end
end



function Shop:GetPet(t)
	local pet_name = t.pet.name
	local pid = t.PlayerID
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	if not hero then return end
	local pet = nil
	for k, v in pairs(Shop.pShop[pid][1]) do
		if type(v) == 'table' and v.type == 'pet' and v.now > 0 then
			if v.name == pet_name then 
				pet = v
			end
		end
	end
	
	if Shop.pShop[pid][1][1].now == 0 and Shop.Change_Available[pid] == false then return end

	if Shop.pet[pid] ~= nil then
		hero:RemoveAbility(Shop.pet[pid])
	end
	
	if hero:HasAbility("spell_item_pet") then
		hero:RemoveAbility("spell_item_pet")
	end

	if pet and pet.itemname ~= Shop.pet[pid]  then
		hero:AddAbility(pet.itemname):SetLevel(GetLevel(pet.now))
		Shop.pet[pid] = pet.itemname
		CustomNetTables:SetTableValue("player_pets", tostring(pid), {pet = pet.itemname})
		if Shop.pShop[pid][1][1].now == 0 then
			Shop.Change_Available[pid] = false
		end
	else
		hero:AddAbility("spell_item_pet"):SetLevel(1)
		Shop.pet[pid] = nil
		CustomNetTables:SetTableValue("player_pets", tostring(pid), {pet = "spell_item_pet"})
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "UpdatePetIcon", {can_change = Shop.Change_Available[pid]} )
	
	
end

function Shop:AutoGetPetOprion(t)
	if t.pet == nil then
		Shop.Auto_Pet[t.PlayerID] = nil
	else
		Shop.Auto_Pet[t.PlayerID] = t.pet.name
	end
	DataBase:AutoGetPetOprion(t)
end

function Shop:OpenTreasure(t)
	for categoryKey, categoryValue in pairs(Shop.pShop[t.PlayerID]) do
		if type(categoryValue) == 'table' then
			for productKey, productValue in ipairs(categoryValue) do
				if productValue.name == t.treasureName then
					thisTreasure = productValue
					thisTreasure.categoryKey = categoryKey
					thisTreasure.productKey = productKey
				elseif productValue.source and productValue.source.treasury and productValue.source.treasury == t.treasureName then
					if not awardList then awardList = {} end
					local award = productValue
					award.categoryKey = categoryKey
					award.productKey = productKey
					table.insert(awardList, award)
					if award.name == "gems_award" then
						gemsAward = award
					end
				end
			end
		end
	end
	if thisTreasure == nil or thisTreasure.now < 1 then return end
	thisTreasure.now = thisTreasure.now - 1
	thisTreasure.onStart = thisTreasure.onStart - 1
	local itemPrize = awardList[RandomInt(1, #awardList)]
	print(itemPrize.name)
	while itemPrize.name == "gems_award" do
		itemPrize = awardList[RandomInt(1, #awardList)]
	end
	if RandomFloat(1, 100) <= 1.20 then
		itemPrize = gemsAward
	end
	local compensation = thisTreasure.compensation
	local data = {
		itemPool = {},
		itemPrize = itemPrize,
		glory = 0,
		skipAnimation = false,
	}
	for _,award in pairs(awardList) do
		table.insert(data.itemPool, award)
	end
	
	local requestData = {
		sid = PlayerResource:GetSteamAccountID(t.PlayerID),
		treasureName = t.treasureName,
	}
	if itemPrize.name == "gems_award" then
		DataBase:AddCoins(t.PlayerID, 500)
		-- requestData.gemAward = 500
	elseif itemPrize.counter and itemPrize.counter == true and itemPrize.onStart > 0 then
		itemPrize.now = itemPrize.now + 1
		itemPrize.onStart = itemPrize.onStart + 1
		requestData.itemAward = itemPrize.name
	elseif itemPrize.onStart == 0 then
		itemPrize.now = 1
		itemPrize.onStart = 1
		requestData.itemAward = itemPrize.name
	elseif itemPrize.onStart > 0 then
		Shop.pShop[t.PlayerID].mmrpoints = Shop.pShop[t.PlayerID].mmrpoints + compensation
		requestData.rpAward = compensation
		data.glory = compensation
	end
	DataBase:OpenTreasure(requestData)
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "ShowWheel", data )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "UpdateStore", {
		shopinfo = Shop.pShop[t.PlayerID], 
		updateCount = {
			{categoryKey = thisTreasure.categoryKey, productKey = thisTreasure.productKey},
			{categoryKey = itemPrize.categoryKey, productKey = itemPrize.productKey},
		},
	})
	local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(t.PlayerID))
	shopinfo['feed'] = Shop.pShop[t.PlayerID]["feed"]
	shopinfo['coins'] = Shop.pShop[t.PlayerID]["coins"]
	shopinfo['mmrpoints'] = Shop.pShop[t.PlayerID]["mmrpoints"]
	CustomNetTables:SetTableValue("shopinfo", tostring(t.PlayerID), shopinfo)
end

function Shop:SprayToggleActivate(t)
	local toggleState = t.toggleState == 1
	if toggleState == false then 
		Shop.spray[t.PlayerID] = nil
	else
		Shop.spray[t.PlayerID] = Shop.pShop[t.PlayerID][tonumber(t.categoryKey)][tonumber(t.productKey)].name
	end
	DataBase:SprayToggleActivate({
		PlayerID = t.PlayerID,
		sprayName = Shop.spray[t.PlayerID],
	})
end

if ChangeHero == nil then
    _G.ChangeHero = class({})
end

function ChangeHero:init()
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( self, 'OnGameRulesStateChange'), self)
	ListenToGameEvent( 'dota_player_gained_level', Dynamic_Wrap( self, 'dota_player_gained_level'), self)
	CustomGameEventManager:RegisterListener("ChangeHeroLua",function(_, keys)
        self:ChangeHeroLua(keys)
    end)

	self.heroes = {
		npc_dota_hero_marci = {unitName = "change_hero_marci", position = Vector(-640,-9926,512), minimumTotal = 1000, trialName = "hero_marci_trial", minimumOneTimeDon = 150},
		npc_dota_hero_silencer = {unitName = "change_hero_silencer", position = Vector(-474,-10162,512), minimumTotal = 2000, trialName = "hero_silencer_trial", minimumOneTimeDon = 200},
	}
	for name, heroData in pairs(self.heroes) do
		heroData.available = {}
		heroData.selected = {}
		heroData.trialCount = {}
		heroData.heroName = name
		for i = 0, 4 do
			heroData.available[i] = false
			heroData.selected[i] = false
		end
	end
end

function ChangeHero:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(1, function()
			for heroName, heroData in pairs(self.heroes) do
				heroData.unit = CreateUnitByName(heroData.unitName , heroData.position, false, nil, nil, DOTA_TEAM_GOODGUYS)
				if heroData.unit then
					heroData.unit:AddNewModifier(heroData.unit,nil,"modifier_quest",{})
					heroData.unitIndex = heroData.unit:entindex()
					heroData.unit:SetForwardVector(heroData.unit:GetForwardVector() * -1)
				end
				for i = 0 , PlayerResource:GetPlayerCount()-1 do
					if PlayerResource:IsValidPlayer(i) then
						heroData.trialCount[i] = RATING["rating"][i+1][heroData.trialName]
						if Shop.pShop[i].totaldonate >= heroData.minimumTotal then
							heroData.trialCount[i] = -1
						end
						if Shop.pShop[i].totaldonate >= heroData.minimumTotal or DataBase:isCheatOn() or heroData.trialCount[i] > 0 then
							heroData.available[i] = true
						end
						if heroName == "npc_dota_hero_marci" and RATING["rating"][i+1]["patron"] == 1 then
							heroData.trialCount[i] = -1
							heroData.available[i] = true
						end
						if heroName == "npc_dota_hero_silencer" and RATING["rating"][i+1]["silencer_date"] ~= nil then
							heroData.trialCount[i] = -1
							heroData.available[i] = true
						end
					end
				end
			end
			
			CustomGameEventManager:Send_ServerToAllClients( "UpdateChangeHeresInfo", self.heroes )
		end)
	end
end

function ChangeHero:dota_player_gained_level(t)
	local player = EntIndexToHScript( t.player )
	local player_id = player:GetPlayerID()
	for _, heroData in pairs(self.heroes) do
		heroData.available[player_id] = false
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( player_id ), "UpdateChangeHeresInfo", self.heroes )
end

function ChangeHero:ChangeHeroLua(t)
	if self.heroes[t.heroName].available[t.PlayerID] == false then return end
	if Shop.pShop[t.PlayerID].totaldonate < self.heroes[t.heroName].minimumTotal then
		self.heroes[t.heroName].trialCount[t.PlayerID] = RATING["rating"][t.PlayerID+1][self.heroes[t.heroName].trialName] - 1
	end
	self.heroes[t.heroName].selected[t.PlayerID] = true
	for i = 0, 4 do
		if PlayerResource:IsValidPlayer(i) then
			self.heroes[t.heroName].available[i] = false
		end
	end 
	for _, heroData in pairs(self.heroes) do
		heroData.available[t.PlayerID] = false
	end
	local heroOld = PlayerResource:GetSelectedHeroName( t.PlayerID )
	local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
	GoldNow = hero:GetGold()
	PlayerResource:ReplaceHeroWith(t.PlayerID,t.heroName,0,0)
	hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
	hero:ModifyGoldFiltered(GoldNow, true, 0)
	CustomGameEventManager:Send_ServerToAllClients( "talant_replace_hero", { PlayerID = t.PlayerID, hero_name = heroOld} )
	talants:pickinfo(t.PlayerID,true)

	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "UpdateChangeHeresInfo", self.heroes )
	Shop.Change_Available[t.PlayerID] = true
	Shop.pet[t.PlayerID] = nil
	if Shop.Auto_Pet[t.PlayerID] then 
		Shop:GetPet({
			PlayerID = t.PlayerID,
			pet = {name = Shop.Auto_Pet[t.PlayerID]},
		})
	else
		Shop:GetPet({
			PlayerID = t.PlayerID,
			pet = {name = "spell_item_pet"},
		})
	end
	Shop.Change_Available[t.PlayerID] = true
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "UpdatePetIcon", {
		can_change = Shop.Change_Available[t.PlayerID]
	} )
end

Shop:init()
ChangeHero:init()