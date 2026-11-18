-- Gem Lady Trade: once quest 80 (Gem Lady) is cleared in this world, taking it again from the
-- quest list offers to trade a Jewel for a Forbidden Talent at once, without playing the quest.
-- API reference: https://rq-modding.github.io/rq-modding-docs/reference/
--
-- The list's Take runs rq.quests.on_take (loader
-- 2.23.0), before the game's "Take Quest@<name>?" question, which the mod answers with the game's
-- dialog and a third choice (rq.ui.ask, loader 2.19.0), and the game's "don't ask again" row for
-- its "Take Quest" switch (remember = 11, loader 2.28.0).

local MOD = "Gem Lady Trade"

local QUEST = 80
local JEWEL = 258
local TALENT = 304            -- Forbidden Talent
local TAKE_SOUND = 5012       -- the game's sound for Yes on that question
local YES, NO, TRADE = 1, 2, 3

-- Cleared in this world: the game's own state, which a world transfer resets (Ｑ初期化).
local function cleared()
  return rq.quests.state(QUEST) == 2
end

-- A Jewel the trade may take: unlocked, in the vault first, then the storage. Never a worn one.
local function jewel()
  return rq.item.find(JEWEL, { place = { "vault", "storage" }, lock = false })[1]
end

-- The game's condition for taking the quest: any Jewel at all (Ｑ参加条件 kind 5).
local function takeable()
  return rq.quests.can_take(QUEST)
end

-- With the last Jewel gone the list's "Take this quest" would stay lit: the list is drawn again,
-- with Gem Lady's buttons as the game draws them, so Take greys (rq.quests.refresh, 2.23.0).
local function refresh_list()
  pcall(rq.quests.refresh)
end

local function trade(ii)
  local got, err = rq.item.give(TALENT)
  if not got then
    rq.ui.notice("The vault cannot take a Forbidden Talent.")
    rq.log(MOD .. ": give " .. TALENT .. " failed: " .. tostring(err))
    return false
  end
  rq.item.remove(ii)
  rq.ui.notice("Andelmille took a Jewel.\nForbidden Talent is in the vault.")
  refresh_list()
  rq.log(string.format("%s: Jewel %d traded for Forbidden Talent %d", MOD, ii, got))
  return true
end

-- The game's "Take Quest" question with a third choice. The text is the game's own, with its @.
-- "Don't ask again" is the game's switch 11 ("Take Quest" in Config's Confirmations tab), as on the
-- game's own question: while it is off, Yes at once, so Gem Lady is taken like any quest.
local function ask(text)
  return rq.ui.ask(text, {
    { id = YES, text = "Yes", sound = TAKE_SOUND },
    { id = TRADE, text = "Trade a Jewel" },
    { id = NO, text = "No" },
  }, { game = true, cursor = YES, remember = 11 })
end

-- Take on Gem Lady: nil leaves the game's own question, true takes the quest, false does not.
rq.quests.on_take(function(ctx)
  if ctx.quest ~= QUEST then return nil end
  if not takeable() then
    -- A stale Take with no Jewel left: the quest would start without one.
    rq.ui.notice("You have no Jewel.")
    return false
  end
  if not cleared() then return nil end
  local ii = jewel()
  if not ii then return nil end -- the game's own question, untouched
  local choice = ask(ctx.text)
  if choice == TRADE then trade(ii) end
  return choice == YES
end)

rq.log(MOD .. " loaded")

-- For the Lab scenario and other mods: what the trade would take now (nil when it is not offered).
return {
  jewel = jewel,
  offered = function() return cleared() and jewel() ~= nil end,
}
