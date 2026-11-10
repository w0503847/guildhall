/// A 5-player dungeon and its recommended level range.
class Dungeon {
  const Dungeon({
    required this.id,
    required this.name,
    required this.zone,
    required this.minLevel,
    required this.maxLevel,
    this.notableLoot = const [],
  });

  /// Builds a dungeon from one entry of assets/dungeons.json.
  factory Dungeon.fromJson(Map<String, dynamic> json) {
    return Dungeon(
      id: json['id'] as String,
      name: json['name'] as String,
      zone: json['zone'] as String,
      minLevel: json['minLevel'] as int,
      maxLevel: json['maxLevel'] as int,
      notableLoot:
          (json['notableLoot'] as List<dynamic>? ?? const []).cast<String>(),
    );
  }

  final String id;
  final String name;
  final String zone;
  final int minLevel;
  final int maxLevel;
  final List<String> notableLoot;

  /// Midpoint of the range; characters near it get the best experience.
  double get midLevel => (minLevel + maxLevel) / 2;

  String get levelRange => '$minLevel–$maxLevel';

  /// Whether [level] is inside the range. [grace] lets characters a few
  /// levels under the minimum still count (they can usually keep up).
  bool fitsLevel(int level, {int grace = 0}) =>
      level >= minLevel - grace && level <= maxLevel;
}
