-- SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
-- Copyright (c) 2022-2026 Thomas Floeren

local _, ns = ...

--[[===========================================================================
	Defaults
===========================================================================]]--

local function merge_defaults(src, dst)
	for k, v in pairs(src) do
		local src_type = type(v)
		if src_type == 'table' then
			if type(dst[k]) ~= 'table' then dst[k] = {} end
			merge_defaults(v, dst[k])
		elseif type(dst[k]) ~= src_type then
			dst[k] = v
		end
	end
end

-- 1: v2.6, Nov 2025: currentPet/previousPet --> recentPets ==> reset specific
local DB_VERSION_CURRENT = 2

local defaults_global = {
	dbVersion = DB_VERSION_CURRENT,
	autoEnabled = true,
	newPetTimer = 720,
	remainingTimer = 360,
	favsOnly = true,
	verbosityLevel = 3,
	drSummoning = true,
	numRecents = 4,
	recentPets = {},
	eventAlt = nil,
	debugMode = false,
}

local defaults_perchar = {
	charFavsEnabled = false,
	charFavs = {},
	recentPets = {},
}

if type(_G.PetWalkerDB) ~= 'table' then
	_G.PetWalkerDB = {}
end
if type(_G.PetWalkerPerCharDB) ~= 'table' then
	_G.PetWalkerPerCharDB = {}
end


merge_defaults(defaults_global, _G.PetWalkerDB)
merge_defaults(defaults_perchar, _G.PetWalkerPerCharDB)
local db, dbc = _G.PetWalkerDB, _G.PetWalkerPerCharDB
ns.db, ns.dbc = db, dbc


--[[----------------------------------------------------------------------------
	DB Update
----------------------------------------------------------------------------]]--

local protected_tables = {
	recentPets = true,
	charFavs = true,
}

-- Reverse nil cleanup
local function clean_removed(trg, ref)
	for k, v in pairs(trg) do
		if ref[k] == nil then
			trg[k] = nil
		elseif not protected_tables[k] and type(v) == 'table' then
			clean_removed(v, ref[k])
		end
	end
end

local ver = db.dbVersion or 0 -- Apply to versions n or lower
if ver == DB_VERSION_CURRENT then return end

-- Do the modifications in descending order, in case we have historically overlapping changes!
if ver < 2 then
	table.insert(db.recentPets, db.currentPet)
	table.insert(db.recentPets, db.previousPet)
	table.insert(dbc.recentPets, dbc.currentPet)
	table.insert(dbc.recentPets, dbc.previousPet)
end

clean_removed(db, defaults_global)
clean_removed(dbc, defaults_perchar)

db.dbVersion = DB_VERSION_CURRENT
ns.db_updated = true

--[[===========================================================================
	Some variables and early stuff
===========================================================================]]--

