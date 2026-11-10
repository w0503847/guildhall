import 'package:flutter_test/flutter_test.dart';

import 'package:guildhall/logic/suggest_members.dart';
import 'package:guildhall/models/character.dart';
import 'package:guildhall/models/dungeon.dart';
import 'package:guildhall/models/dungeon_post.dart';
import 'package:guildhall/models/race.dart';
import 'package:guildhall/models/role.dart';
import 'package:guildhall/models/wow_class.dart';

const deadmines = Dungeon(
  id: 'deadmines',
  name: 'The Deadmines',
  zone: 'Westfall',
  minLevel: 17,
  maxLevel: 26,
);

Character makeCharacter(String id, int level, Set<Role> roles,
    {bool isMain = true}) {
  return Character(
    id: id,
    name: id,
    wowClass: WowClass.druid,
    race: Race.nightElf,
    roles: roles,
    level: level,
    isMain: isMain,
  );
}

DungeonPost makePost(Map<String, Role> signUps) => DungeonPost(
      id: 'p1',
      dungeonId: 'deadmines',
      organizerId: signUps.keys.first,
      dateTime: DateTime(2030),
      signUps: signUps,
    );

void main() {
  group('DungeonPost', () {
    test('openRoles lists missing roles with tank first', () {
      final post = makePost({'a': Role.dps});
      expect(post.openRoles, [Role.tank, Role.healer, Role.dps]);
    });

    test('isFull when all five slots are taken', () {
      final post = makePost({
        'a': Role.tank, 'b': Role.healer,
        'c': Role.dps, 'd': Role.dps, 'e': Role.dps,
      });
      expect(post.isFull, isTrue);
      expect(post.summary, 'Full');
    });
  });

  group('suggestMembers', () {
    test('skips characters outside the level range', () {
      final roster = [
        makeCharacter('tooLow', 12, {Role.tank}),
        makeCharacter('tooHigh', 40, {Role.tank}),
        makeCharacter('justRight', 21, {Role.tank}),
      ];
      final result = suggestMembers(
          post: makePost({'org': Role.dps}), dungeon: deadmines, roster: roster);
      expect(result.map((s) => s.character.id), ['justRight']);
    });

    test('allows characters up to 2 levels under the minimum', () {
      final roster = [
        makeCharacter('grace', 15, {Role.healer}),
        makeCharacter('tooFar', 14, {Role.healer}),
      ];
      final result = suggestMembers(
          post: makePost({'org': Role.dps}), dungeon: deadmines, roster: roster);
      expect(result.map((s) => s.character.id), ['grace']);
      expect(result.single.reason, contains('slightly under level'));
    });

    test('skips members already signed up', () {
      final roster = [makeCharacter('org', 20, {Role.dps, Role.tank})];
      final result = suggestMembers(
          post: makePost({'org': Role.dps}), dungeon: deadmines, roster: roster);
      expect(result, isEmpty);
    });

    test('only suggests roles the party still needs', () {
      final post = makePost({'org': Role.tank, 'h': Role.healer});
      final roster = [
        makeCharacter('tankOnly', 21, {Role.tank}),
        makeCharacter('dps', 21, {Role.dps}),
      ];
      final result =
          suggestMembers(post: post, dungeon: deadmines, roster: roster);
      expect(result.single.character.id, 'dps');
      expect(result.single.role, Role.dps);
    });

    test('returns nothing when the party is full', () {
      final post = makePost({
        'a': Role.tank, 'b': Role.healer,
        'c': Role.dps, 'd': Role.dps, 'e': Role.dps,
      });
      final roster = [makeCharacter('extra', 21, {Role.dps})];
      expect(suggestMembers(post: post, dungeon: deadmines, roster: roster),
          isEmpty);
    });

    test('ranks a level near the middle of the range higher', () {
      final roster = [
        makeCharacter('edge', 26, {Role.healer}),
        makeCharacter('middle', 21, {Role.healer}),
      ];
      final result = suggestMembers(
          post: makePost({'org': Role.dps}), dungeon: deadmines, roster: roster);
      expect(result.first.character.id, 'middle');
    });
  });
}
