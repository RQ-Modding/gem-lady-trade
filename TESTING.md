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
| `dont-ask` | DON'T ASK AGAIN | The game's switch 11 ("Take Quest"); the window stays, its row now the "on" look (1.3.0) |

- **When it is offered:** `rq.quests.state(80) == 2` (cleared in this world) and an unlocked Jewel
  (item 258) in the vault (place 7) or the storage (place 11). The party does not matter.
- **Otherwise** the game's own two-choice question shows, `yes` and `no`, with its "don't ask
  again" row. Both questions share the game's switch 11: while `rq.ain.call("確認なし", 11)` is true,
  neither shows, and Take on Gem Lady takes the quest at once (no trade). Turn it back on with
  `rq.ain.call("確認なし_ＯＦＦ", 11)` or Config's Confirmations tab.
- **No Jewel at all** (a Take button left lit): the mod refuses with the notice "You have no Jewel."
  instead of letting the quest start without one.

## How to check it

1. On the town hub, set up: `rq.quests.set_state(80, 2)` and `rq.item.give(258)` twice.
2. Quests → find Gem Lady. The list scrolls with `rq.ain.call("scrollQuestList", top)` (the game's own
   global).
3. Press its row, then `take`. Three choices show.
4. Press `select-trade-a-jewel`, then the notice's button. One Jewel is gone, one more Forbidden Talent (304) is in
   the vault, the screen is `quests`, and `rq.quests.current()` is 0.
5. With the last Jewel traded, the list is drawn again (`rq.quests.refresh`): `take` is listed with
   `enabled` false.

While a quest is chosen, the game reads none of the list's rows (`rq.ui.get` shows them not
`enabled`, loader 2.28.0), and it stays chosen after a question answered No. Cancel (a right click)
lets it go; going back to the hub and pressing `quests` does too.
`rq.quests.set_state(80, 1)` stands for a new world (since loader 2.23.0 it writes 1 on a cleared
quest).

## Forcing it for a test

- `rq.mod.get("gem-lady-trade")` returns `jewel()` (the item instance the trade would take, or nil)
  and `offered()`.
- `rq.item.lock(ii)` locks a Jewel; a locked one is never taken.

## Test Lab

`test-lab/scenarios/gem-lady-trade.lua`: the three choices and the "don't ask again" row, the trade
(one Jewel, one Forbidden Talent, the notice, the list stays, no quest, no autosave), No, a locked
Jewel only, not cleared, Crook in the party, the last Jewel greying `take`, "You have no Jewel." on a
Take left lit, Yes starting the quest after the "don't ask again" row was pressed, and the next Take
starting the quest with no question.
Shots: `gem-ask.png`, `gem-notice.png`.
