# Testing Gem Lady Trade

For people and agents who test the mod in the game. Read it before you use anything the mod adds.
Assume nothing about the mod when it is not installed: check `logs\rqmod.log` for
`Gem Lady Trade loaded`.

## What it adds

No widget of its own. It replaces one game question:

- On the quest list, select Gem Lady (quest 80; its row `quest-N` has `value` `"80"`) and press
  `take`. When the trade is offered, the screen becomes `select` with three choices (`select.message`
  holds the question's text):

| id | label | what |
| --- | --- | --- |
| `select-yes` | Yes | Takes the quest as the game's Yes does (autosave, then the quest) |
| `select-trade-a-jewel` | Trade a Jewel | The trade; then the game's notice (`select` with one button), and the list again |
| `select-no` | No | Back to the list |

- **When it is offered:** `rq.quests.state(80) == 2` (cleared in this world) and an unlocked Jewel
  (item 258) in the vault (place 7) or the storage (place 11). The party does not matter.
- **Otherwise** the game's own two-choice question shows, `yes` and `no`, including its "don't ask
  again" setting. The mod's question has no "don't ask again" row: it always asks.
- **No Jewel at all** (a Take button left lit): the mod refuses with the notice "You have no Jewel."
  instead of letting the quest start without one.

## How to check it

1. On the town hub, set up: `rq.quests.set_state(80, 2)` and `rq.item.give(258)` twice.
2. Quests → find Gem Lady. The list scrolls with `rq.ain.call("scrollQuestList", top)`.
3. Press its row, then `take`. Three choices show.
4. Press `select-trade-a-jewel`, then the notice's button. One Jewel is gone, one more Forbidden Talent (304) is in
   the vault, the screen is `quests`, and `rq.quests.current()` is 0.
5. With the last Jewel traded, the list is as a wheel scroll leaves it: `take` is not listed. Press
   Gem Lady's row again (twice: the first press lets go of the row) and `take` is `enabled` false.

After any question over the quest list, its rows report no hover to an agent until the list is
opened again (the game's own question does it too): go back to the hub and press `quests`.
`rq.quests.set_state(80, 1)` does nothing on a cleared quest (the game's `Ｑ状態` takes 1 only from
0); write `rq.ain.set_global("Ｑ", 80, "状態", 1)` to stand for a new world.

## Forcing it for a test

- `rq.mod.get("gem-lady-trade")` returns `jewel()` (the item instance the trade would take, or nil)
  and `offered()`.
- `rq.item.lock(ii)` locks a Jewel; a locked one is never taken.

## Test Lab

`test-lab/scenarios/gem-lady-trade.lua`: the three choices, the trade (one Jewel, one Forbidden
Talent, the notice, the list stays, no quest, no autosave), No, a locked Jewel only, not cleared,
Crook in the party, the last Jewel greying `take`, and Yes starting the quest.
Shots: `gem-ask.png`, `gem-notice.png`.
