-- Q1 - Fix or improve the implementation of the below methods

-- local function releaseStorage(player)
--     player:setStorageValue(1000, -1)
-- end
    
-- function onLogout(player)
--     if player:getStorageValue(1000) == 1 then
--         addEvent(releaseStorage, 1000, player)
--     end
--     return true
-- end 

-- Notes:
-- There are various possible issues here:
-- 1. Lots of magic numbers with no clear meaning. I've replaced the -1 / 1 since they looked like a flag, still no clue what the storage "1000" represents. Dues lua have enums?
-- The documentation for setStorageValue doesn't really explain anything either about this particular key https://github.com/otland/forgottenserver/wiki/Metatable%3APlayer#setStorageValue
-- I'm not familiar either with how Tibia storages are supposed to work
-- 2. A function that always returns true doesn't seem to make much sense to return anything? I've left it as is, since without the return value the calling code may break
-- 3. addEvent seems to be this TFS specific scripting function https://github.com/otland/forgottenserver/wiki/Functions#addEvent to performa a callback after a delay
--    It's unclear to me why releaseStorage is called after 1 second delay, I would expect it to depend on something else that is unrelated to time passing, but since I don't really know what this function is meant to do, I've left it as is

local STORAGE_STATUS = {
    Released = -1,
    Held = 1,
}
local STORAGE_MAGIC_NUMBER = 1000 -- FIXME: What does this 1000 as storage key actually mean?
local RELEASE_STORAGE_DELAY_MS = 1000


local function releaseStorage(player)
    player:setStorageValue(STORAGE_MAGIC_NUMBER, STORAGE_STATUS.Released)
end

function onLogout(player)
    if player:getStorageValue(STORAGE_MAGIC_NUMBER) == STORAGE_STATUS.Held then
        addEvent(releaseStorage, RELEASE_STORAGE_DELAY_MS, player)
    end
    return true
end