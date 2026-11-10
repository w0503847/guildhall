# Guildhall: Dungeon Board

A Flutter app for World of Warcraft: Forever guilds to plan 5-player dungeon runs. Members post a run (dungeon, time, party slots, gear wanted), and the app suggests guildmates whose characters are the right level and fill the open roles.

Flutter Innovation Capstone · INFT3075 · Alex Knapp

## Status: Week 2 prototype

Working now:
- Bottom navigation: **Board**, **Roster**, **Dungeons**
- Board → **Post Detail**, with party slots, join/remove, and suggested members ranked by level and open role
- Roster: search, filter by role, swipe to delete (with confirmation), tap to edit
- **Add/Edit Character** form with validation (name required, 2–12 letters, unique; level 1–60; at least one role)
- Dungeon list loaded from `assets/dungeons.json`, with the number of guild characters in range

Planned for Weeks 3–4: create/edit post form, local storage with sqflite, a two-pane tablet layout, and more tests.

## How to run

1. Install Flutter (stable) and Android Studio with an Android emulator.
2. In the project folder, run:
   ```
   flutter pub get
   flutter run
   ```
3. Run the tests with `flutter test`.

Tested on: Android phone emulator, Android tablet emulator (to be logged in Week 4).

## Project structure

```
lib/
  main.dart            app root, providers, theme
  models/              Character, Dungeon, DungeonPost, enums
  logic/               suggest_members.dart (pure Dart, unit tested)
  providers/           Roster, Post and Dungeon state (Provider + ChangeNotifier)
  data/                sample data (replaced by sqflite in Week 3)
  screens/             one file per screen
  widgets/             reusable UI pieces
  utils/               date formatting
assets/dungeons.json   starter dungeon list
test/                  widget tests and suggestion unit tests
```

## Known limitations

- Data is in memory only until sqflite is added in Week 3, so it resets on restart.
- Single device; there is no multi-user sync.
- Dungeon level ranges are approximate Classic-era values and may differ in WoW: Forever. They can be edited in `assets/dungeons.json`.

## Credits

- Packages: [provider](https://pub.dev/packages/provider), [intl](https://pub.dev/packages/intl)
- Initial project scaffolding and prototype code were drafted with help from Claude (Anthropic's AI assistant) and reviewed and modified by me.
- World of Warcraft is a trademark of Blizzard Entertainment. This is an unofficial student project.
