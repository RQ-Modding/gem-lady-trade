-- Gem Lady Trade: once quest 80 (Gem Lady) is cleared in this world, taking it again from the
-- quest list offers to trade a Jewel for a Forbidden Talent at once, without playing the quest.
-- API reference: https://rq-modding.github.io/rq-modding-docs/reference/
--
-- It works on the game's own code through rq.ain (notes/plans/plan-gem-lady.md in the workspace):
-- a hook on the list's "Take Quest@<name>?" question (選択_確認_拡張 with id 11, asked by
-- T_Quest::execOk), answered with the game's dialog and a third choice (rq.ui.ask, loader 2.19.0).

local MOD = "Gem Lady Trade"
local call = rq.ain.call

local QUEST = 80
local JEWEL = 258
local TALENT = 304            -- Forbidden Talent
local TAKE_ID = 11            -- the "Take Quest" question's don't-ask-again id
local TAKE_SOUND = 5012       -- the game's sound for Yes on that question
local VAULT, STORAGE = 7, 11
local YES, NO, TRADE = 1, 2, 3

-- Cleared in this world: the game's own state, which a world transfer resets (Ｑ初期化).
local function cleared()
  return rq.quests.state(QUEST) == 2
end

-- A Jewel the trade may take: unlocked, in the vault first, then the storage. Never a worn one.
local function jewel()
  local stored
  for _, it in ipairs(rq.items()) do
    local ii = it.id
    if call("Ｉ固有番号", ii, -1) == JEWEL and not call("アイテム_ＬＯＣＫ中", ii) then
      local place = call("アイテム_存在", ii)
      if place == VAULT then return ii end
      if place == STORAGE and not stored then stored = ii end
    end
  end
  return stored
end

-- The game's condition for taking the quest: any Jewel at all (Ｑ参加条件 kind 5).
local function takeable()
  local v = call("クエスト_有効", QUEST)
  return v == true or v == 1
end

-- With the last Jewel gone the list's "Take this quest" would stay lit. T_Quest::scroll, which the
-- global scrollQuestList calls, draws the rows again and puts the list as a wheel scroll leaves it:
-- the big buttons hidden until the player picks a row again, which greys Take.
local function refresh_list()
  if takeable() then return end
  local ok, top = pcall(rq.ain.global, "g_sQuest", "m_sList", "m_nTopIndex")
  if ok and type(top) == "number" then pcall(call, "scrollQuestList", top) end
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
local function ask(text)
  return rq.ui.ask(text, {
    { id = YES, text = "Yes", sound = TAKE_SOUND },
    { id = TRADE, text = "Trade a Jewel" },
    { id = NO, text = "No" },
  }, { game = true, cursor = YES })
end

rq.ain.hook("選択_確認_拡張", { before = function(h)
  if h.args[1] ~= TAKE_ID then return end
  local ok, sel = pcall(rq.ain.global, "g_sQuest", "m_sList", "m_nSelectNo")
  if not ok or sel ~= QUEST then return end
  if not takeable() then
    -- A stale Take with no Jewel left: the quest would start without one.
    h.skip, h.result = true, false
    rq.ui.notice("You have no Jewel.")
    return
  end
  if not cleared() then return end
  local ii = jewel()
  if not ii then return end -- the game's own question, untouched
  h.skip = true
  local choice = ask(h.args[2])
  h.result = choice == YES
  if choice == TRADE then trade(ii) end
end })

rq.log(MOD .. " loaded")

-- For the Lab scenario and other mods: what the trade would take now (nil when it is not offered).
return {
  jewel = jewel,
  offered = function() return cleared() and jewel() ~= nil end,
}
