-- Probably not the best implementation, but the documentation is lacking
-- useful reference https://tibia.fandom.com/wiki/Effects

local duration = 4000
local interval = 500
local fullArea = AREA_FRIGO_BASE
local combats = {}

-- Important note: These should actually be precalculated and only cycle to a few patterns as to not fill the server with pointless calculations and garbage
-- But for this test I'm leaving it like this
local function randomizeArea()
    local randomizedArea = {}
    for i = 1, #fullArea do
        randomizedArea[i] = {}
        for j = 1, #fullArea[i] do
            if fullArea[i][j] == 1 then
                randomizedArea[i][j] = math.random(0, 1) -- Make it 0 or 1 randomly
            else
                randomizedArea[i][j] = fullArea[i][j]
            end
        end
    end
    return randomizedArea
end

for _=0, duration, interval do
	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
	local area = createCombatArea(randomizeArea())
	combat:setArea(area)
	table.insert(combats, combat)
end

function onCastSpell(creature, variant)
    for i, combat in ipairs(combats) do
		local function exec()
			return combat:execute(creature, variant)
		end
		addEvent(exec, interval*i - interval) -- lua arrays start from 1, but we want the first one to start at 0
	end
	return nil -- is this fine?
end
