# Changelog

Each section is a version of the mod, the `version` in `mod.json`. The release workflow copies the
section of a tagged version into the release notes.

## 1.2.0

- After the last Jewel is traded, the list keeps Gem Lady's buttons with "Take this quest" greyed;
  they were hidden until the row was picked again.
- Works through the loader's calls (`rq.quests.on_take`, `can_take`, `refresh`, `rq.item.find`)
  instead of the game's code by name.
- Needs loader 2.23.0.

## 1.1.0

- The question and the notices are the loader's `rq.ui.ask` and `rq.ui.notice` (loader 2.19.0)
  instead of the game's dialog functions by name. They look the same.
- For agents: the question's Yes and No are now `select-yes` and `select-no` (the notices' OK is
  still `yes`), and `rq.ui.get` gives its text in `select.message`.

## 1.0.0

First version.
- Gem Lady's "Take Quest" question on the quest list gets a third choice, Trade a Jewel, once the
  quest is cleared in this world: one unlocked Jewel (vault first, then storage) for a Forbidden
  Talent in the vault, without entering the quest.
