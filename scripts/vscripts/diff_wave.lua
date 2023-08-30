if diff_wave == nil then
	_G.diff_wave = class({})
end

function diff_wave:init()
	self.rating_scale = 1
	self.info = {
		Easy = {mmr_win = 0, mmr_lose = 0, respawn = 60, rp_win = 0},
		Normal = {mmr_win = 10, mmr_lose = -10, respawn = 120, rp_win = 20},
		Hard = {mmr_win = 20, mmr_lose = -20, respawn = 120, rp_win = 40},
		Ultra = {mmr_win = 30, mmr_lose = -30, respawn = 120, rp_win = 60},
		Insane = {mmr_win = 40, mmr_lose = -40, respawn = 120, rp_win = 80},
		Hell = {mmr_win = 50, mmr_lose = -50, respawn = 120, rp_win = 100},
	}
	self.difficultyVote = {}
	CustomGameEventManager:RegisterListener("GameSettings",function(_, keys)
        self:GameSettings(keys)
    end)
	ListenToGameEvent("game_rules_state_change",function(_, keys)
        self:OnGameStateChanged(keys)
    end, self)
end

function diff_wave:GameSettings(t)
	self.difficultyVote[t.PlayerID] = t.mode
	CustomNetTables:SetTableValue( "difficultyVote", tostring(t.PlayerID), self.difficultyVote )
end

function diff_wave:OnGameStateChanged(t)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		local diff = {0,0,0,0,0,0}
		local count = 0
		for i = 0, PlayerResource:GetPlayerCount()-1 do
			if self.difficultyVote[i] ~= nil then
				local idx = self.difficultyVote[i]+1
				diff[idx] = diff[idx] + 1
				count = count + 1
			end
		end
		local diff_index = 1
		local vote_count = 0
		for i = 1, 6 do
			if diff[i] >= vote_count and diff[i] > 0 then
				diff_index = i
				vote_count = diff[i]
			end
		end
		for i, mode in pairs({"Easy", "Normal", "Hard", "Ultra", "Insane", "Hell"}) do
			if i == diff_index then
				self.wavedef = mode
				self.mmr_win = self.info[mode].mmr_win
				self.mmr_lose = self.info[mode].mmr_lose
				self.respawn = self.info[mode].respawn
				self.rp_win = self.info[mode].rp_win
			end
		end
	end
end

function diff_wave:InitGameMode()
	-- if GetMapName() == "turbo" then
	-- self.wavedef = "Easy"
	-- self.rating_scale = 0
	-- self.respawn = 60
	-- end
	
	-- if GetMapName() == "normal" then
	-- self.wavedef = "Normal"
	-- self.rating_scale = 1
	-- self.respawn = 120
	-- end
	
	-- if GetMapName() == "hard" then
	-- self.wavedef = "Hard"
	-- self.rating_scale = 2
	-- self.respawn = 120
	-- end
	
	-- if GetMapName() == "ultra" then
	-- self.wavedef = "Ultra"
	-- self.rating_scale = 3
	-- self.respawn = 120
	-- end
	
	-- if GetMapName() == "insane" then
	-- self.wavedef = "Insane"
	-- self.rating_scale = 4
	-- self.respawn = 120
	-- end
end 

diff_wave:init()