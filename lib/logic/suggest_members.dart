import 'dart:math' as math;

import '../models/character.dart';
import '../models/dungeon.dart';
import '../models/dungeon_post.dart';
import '../models/role.dart';

/// One suggested guild member for a dungeon post.
class Suggestion {
  const Suggestion({
    required this.character,
    required this.role,
    required this.score,
    required this.reason,
  });

  final Character character;

  /// The open role this character would fill.
  final Role role;

  /// Higher is a better fit. Only used for sorting.
  final double score;

  /// Short explanation shown in the UI, e.g. "Healer · Lv 22 · fills open slot".
  final String reason;
}

/// Ranks guild characters who could join [post].
///
/// A character is eligible when they:
///  * are not already signed up,
///  * are within the dungeon's level range (up to [levelGrace] levels under
///    the minimum is allowed), and
///  * can fill at least one role the party still needs.
///
/// Scoring (higher is better):
///  * tank/healer slots score higher than DPS, because they are scarcer,
///  * a level close to the middle of the dungeon's range scores higher,
///  * mains get a small bonus over alts.
///
/// This is plain Dart with no Flutter imports so it can be unit tested.
List<Suggestion> suggestMembers({
  required DungeonPost post,
  required Dungeon dungeon,
  required List<Character> roster,
  int levelGrace = 2,
  int limit = 5,
}) {
  final openRoles = post.openRoles;
  if (openRoles.isEmpty) return const [];

  final suggestions = <Suggestion>[];

  for (final character in roster) {
    if (post.hasMember(character.id)) continue;
    if (!dungeon.fitsLevel(character.level, grace: levelGrace)) continue;

    // openRoles is in priority order, so the first match is the most needed.
    final fillable = openRoles.where(character.canFill).toList();
    if (fillable.isEmpty) continue;
    final role = fillable.first;

    final levelDistance = (character.level - dungeon.midLevel).abs();
    final levelScore = math.max(0.0, 10.0 - levelDistance);
    final roleScore = role == Role.dps ? 5.0 : 10.0;
    final mainBonus = character.isMain ? 1.0 : 0.0;

    final underLevel = character.level < dungeon.minLevel;
    final reason = '${role.label} · Lv ${character.level} · '
        '${underLevel ? 'slightly under level' : 'fills open slot'}';

    suggestions.add(Suggestion(
      character: character,
      role: role,
      score: levelScore + roleScore + mainBonus,
      reason: reason,
    ));
  }

  suggestions.sort((a, b) => b.score.compareTo(a.score));
  return suggestions.take(limit).toList();
}
