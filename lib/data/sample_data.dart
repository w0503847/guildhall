import '../models/character.dart';
import '../models/dungeon_post.dart';
import '../models/race.dart';
import '../models/role.dart';
import '../models/wow_class.dart';

/// Starter data so the prototype has something to show.
/// Week 3 replaces this with records loaded from the sqflite database.

const List<Character> sampleCharacters = [
  Character(id: 'c1', name: 'Brannoc', wowClass: WowClass.warrior, race: Race.dwarf, roles: {Role.tank, Role.dps}, level: 24),
  Character(id: 'c2', name: 'Liriel', wowClass: WowClass.priest, race: Race.nightElf, roles: {Role.healer}, level: 22),
  Character(id: 'c3', name: 'Kazzik', wowClass: WowClass.rogue, race: Race.gnome, roles: {Role.dps}, level: 25),
  Character(id: 'c4', name: 'Mavren', wowClass: WowClass.mage, race: Race.human, roles: {Role.dps}, level: 19),
  Character(id: 'c5', name: 'Oakhollow', wowClass: WowClass.druid, race: Race.nightElf, roles: {Role.tank, Role.healer, Role.dps}, level: 27),
  Character(id: 'c6', name: 'Thessa', wowClass: WowClass.paladin, race: Race.human, roles: {Role.healer, Role.tank}, level: 18),
  Character(id: 'c7', name: 'Fenwick', wowClass: WowClass.hunter, race: Race.dwarf, roles: {Role.dps}, level: 16),
  Character(id: 'c8', name: 'Aeloria', wowClass: WowClass.druid, race: Race.skyborne, roles: {Role.healer}, level: 23),
  Character(id: 'c9', name: 'Corvin', wowClass: WowClass.warlock, race: Race.human, roles: {Role.dps}, level: 29),
  Character(id: 'c10', name: 'Dagny', wowClass: WowClass.warrior, race: Race.dwarf, roles: {Role.tank}, level: 35),
  Character(id: 'c11', name: 'Pip', wowClass: WowClass.priest, race: Race.gnome, roles: {Role.healer, Role.dps}, level: 13),
  Character(id: 'c12', name: 'Rowan', wowClass: WowClass.paladin, race: Race.human, roles: {Role.tank, Role.healer, Role.dps}, level: 21, isMain: false),
];

/// Posts are dated relative to today so they always appear as upcoming.
List<DungeonPost> buildSamplePosts() {
  final now = DateTime.now();
  DateTime at(int daysFromNow, int hour) =>
      DateTime(now.year, now.month, now.day + daysFromNow, hour);

  return [
    DungeonPost(
      id: 'p1',
      dungeonId: 'deadmines',
      organizerId: 'c3',
      dateTime: at(1, 20),
      signUps: const {'c3': Role.dps, 'c1': Role.tank},
      gearWants: const ['Cruel Barb'],
      notes: 'Full clear. Bring water and bandages.',
    ),
    DungeonPost(
      id: 'p2',
      dungeonId: 'wailing-caverns',
      organizerId: 'c6',
      dateTime: at(2, 19),
      signUps: const {'c6': Role.healer},
      notes: 'Quest run, first time for most of us.',
    ),
    DungeonPost(
      id: 'p3',
      dungeonId: 'shadowfang-keep',
      organizerId: 'c5',
      dateTime: at(3, 21),
      signUps: const {'c5': Role.tank, 'c2': Role.healer, 'c9': Role.dps},
      gearWants: const ['Shadowfang'],
    ),
  ];
}
