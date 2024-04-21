-- Q2 - Fix or improve the implementation of the below method

-- function printSmallGuildNames(memberCount)
--     --this method is supposed to print names of all guilds that have less than memberCount max members
--     local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
--     local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
--     local guildName = result.getString("name")
--     print(guildName)
-- end

-- Notes:
-- After some digging in the forgotten server scripts to figure out the actual syntax of the db call, it seems the function was wrong in the following:
-- 1. Not checking for invalid resultId
-- 2. Not passing the resultId to the call to result
-- 3. Not iterating over results via result.next

-- this method is supposed to print names of all guilds that have less than memberCount max members
function printSmallGuildNames(memberCount)
    local selectGuildQuery = string.format("SELECT name FROM guilds WHERE max_members < %d;", memberCount)
    local resultId = db.storeQuery(selectGuildQuery)

    if resultId ~= false then
        print(resultId)
        repeat
            local guildName = result.getString(resultId, "name")
            print(guildName)
        until not result.next(resultId)
    end
end