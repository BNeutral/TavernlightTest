// Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

/*
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }
}
*/

#include <memory>

/// @brief Adds an item to the player. Does nothing if the provided itemId or the players were invalid
/// @param recipient player name of the recipient
/// @param itemId item id
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId) {

    std::unique_ptr<Player> loadedPlayer(nullptr); // Unique_ptr so we free memory if we allocated any that we own, on scope end

    // I assume that the lifetime of the player here is handled by g_game, and we don't need to delete anything if this was fetched successfully
    Player* rawPlayer = g_game.getPlayerByName(recipient);

    if (!rawPlayer) {
        rawPlayer = new Player(nullptr);
        // I assume loading the player, if successful, still means we are the owners of this pointer and we haven't given the ownership to anything else
        loadedPlayer.reset(rawPlayer);
        if (!IOLoginData::loadPlayerByName(rawPlayer, recipient)) {
            // TODO: Add error log if loadPlayerByName doesn't already log an error. Failing to find the player points to a bad player name / bad calling code.
            return;
        }
    }

    Item* rawItem = Item::CreateItem(itemId);
    if (!rawItem) {
        // TODO: Add error log if CreateItem doesn't already log an error. Item creation failing points to a bad itemId / bad calling code.
        return;
    }

    // I'm going to assume that internalAddItem handles the lifetime of the item now, and we don't need to delete it unless there was an error
    ReturnValue ret = g_game.internalAddItem(rawPlayer->getInbox(), rawItem, INDEX_WHEREEVER, FLAG_NOLIMIT);
    if (ret != RETURNVALUE_NOERROR) {
        delete rawItem;
    }
    // FIXME: If we failed to give the player the item we should actually do something else here, not just fail silently and leave the player itemless

    if (rawPlayer->isOffline()) {
        IOLoginData::savePlayer(rawPlayer);
    }
}