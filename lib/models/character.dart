import 'race.dart';
import 'role.dart';
import 'wow_class.dart';

/// A single guild member's character (mains and alts are separate records).
///
/// Immutable: to change a character, create a new one with [copyWith] and
/// hand it to the RosterProvider so listeners are notified.
class Character {
  const Character({
    required this.id,
    required this.name,
    required this.wowClass,
    required this.race,
    required this.roles,
    required this.level,
    this.isMain = true,
  });

  /// Level cap in WoW: Forever.
  static const int maxLevel = 60;

  final String id;
  final String name;
  final WowClass wowClass;
  final Race race;

  /// Roles this player is willing to fill on this character.
  final Set<Role> roles;
  final int level;

  /// False for alts.
  final bool isMain;

  bool canFill(Role role) => roles.contains(role);

  Character copyWith({
    String? name,
    WowClass? wowClass,
    Race? race,
    Set<Role>? roles,
    int? level,
    bool? isMain,
  }) {
    return Character(
      id: id,
      name: name ?? this.name,
      wowClass: wowClass ?? this.wowClass,
      race: race ?? this.race,
      roles: roles ?? this.roles,
      level: level ?? this.level,
      isMain: isMain ?? this.isMain,
    );
  }
}
