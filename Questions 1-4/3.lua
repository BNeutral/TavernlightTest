-- Q3 - Fix or improve the name and the implementation of the below method

-- function do_sth_with_PlayerParty(playerId, membername)
--     player = Player(playerId)
--     local party = player:getParty()

--     for k,v in pairs(party:getMembers()) do
--         if v == Player(membername) then
--             party:removeMember(Player(membername))
--         end
--     end
-- end

---Removes one player from the party of the player id, searching by name. Does nothing if the player is not in the party.
---@param playerIdWithParty integer Player by id from which we are fetching the party.
---@param playerNameToRemove string Player by name to find and remove.
function removePlayerFromParty(playerIdWithParty, playerNameToRemove)

    local player = Player(playerIdWithParty)
    -- FIXME: Discuss with dev team if asserts are the expected way to handle invalid input in these scripts
    --        Also, is there a non hardcoded way to print the scope's function name in lua?
    assert(player, "Provided invalid playerIdWithParty to function 'removePlayerFromParty'. Might be a bug on the calling function.")

    local party = player:getParty()
    if not party then -- Unknown: Can this return nil or do players always have a party?
        return
    end

    local playerToRemove = Player(playerNameToRemove);
    -- FIXME: Discuss with dev team if asserts are the expected way to handle invalid input in these scripts
    --        Also, is there a non hardcoded way to print the scope's function name in lua?
    assert(player, "Provided invalid playerNameToRemove to function 'removePlayerFromParty'. Might be a bug on the calling function.")

    for key, partyPlayer in pairs(party:getMembers()) do
        if partyPlayer == playerToRemove then
            party:removeMember(playerToRemove)
        end
    end

end