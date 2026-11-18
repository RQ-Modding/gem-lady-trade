# Gem Lady Trade

Once you have cleared **Gem Lady** in this world, trade a Jewel for a Forbidden Talent from the
quest list, without playing the quest again.

## Showcase

### Trying to join Gem Lady Quest

<img width="467" height="325" alt="image" src="https://github.com/user-attachments/assets/d37b401a-71c7-481a-889b-20e09171ff5d" />

### Trading the jewel

<img width="471" height="202" alt="image" src="https://github.com/user-attachments/assets/e0eb32d6-0e00-4b13-b47c-e40a1706c6bf" />

## What it changes

- Taking **Gem Lady** from the quest list asks "Take Quest@Gem Lady?" with three choices:
  - **Yes** takes the quest as usual.
  - **Trade a Jewel**: Andelmille takes one Jewel and a **Forbidden Talent** goes to the vault. You
    stay on the quest list.
  - **No** does nothing.
  - **Don't ask again** is the game's own row: it turns off "Take Quest" in Config's Confirmations
    tab, as on the game's question. While it is off, Gem Lady is taken like any quest, with no
    question and so no trade; turn "Take Quest" on again there to trade.
- The trade takes **one** Jewel, an unlocked one from the vault first, then from the storage. It
  never takes a locked Jewel or one a character wears. (The quest itself takes every Jewel you
  have.)
- The trade is offered only when Gem Lady is cleared **in this world**. A world transfer resets the
  game's quests, so clear it again in the new world first.
- The trade is not a clear: the clear count, reputation and EXP do not change.
- Without a Jewel the trade may take, or before the quest is cleared, the game's own question shows,
  unchanged.
- After you trade your last Jewel, "Take this quest" greys at once.

## Keys and settings

None.

## Saves

The Forbidden Talents you trade for stay in the save after the mod is removed. The mod keeps no
data of its own.

## Works with

Tested with every RQ Modding mod installed. It touches no other mod's data.

## Install

Needs [RQ MOD](https://github.com/RQ-Modding/RQ-Mod) with loader **2.28.0** or newer. Extract the
release zip into the game's `mods` folder, so that you have `mods/gem-lady-trade/mod.json`.

## License

MIT, see [LICENSE](LICENSE).
