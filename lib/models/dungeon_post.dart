import 'role.dart';

enum PostStatus {
  open('Open'),
  completed('Completed'),
  cancelled('Cancelled');

  const PostStatus(this.label);

  final String label;
}

/// A guild member's post looking for a group to run a dungeon.
///
/// "Full" is not stored as a status: it is calculated from [signUps] and
/// [slots], so it can never get out of sync with the actual party.
class DungeonPost {
  const DungeonPost({
    required this.id,
    required this.dungeonId,
    required this.organizerId,
    required this.dateTime,
    this.slots = defaultSlots,
    this.signUps = const {},
    this.gearWants = const [],
    this.notes = '',
    this.status = PostStatus.open,
  });

  /// Standard 5-player party: 1 tank, 1 healer, 3 damage dealers.
  static const Map<Role, int> defaultSlots = {
    Role.tank: 1,
    Role.healer: 1,
    Role.dps: 3,
  };

  final String id;
  final String dungeonId;
  final String organizerId;
  final DateTime dateTime;

  /// How many of each role the party needs.
  final Map<Role, int> slots;

  /// Who has joined: character id -> the role they are filling.
  /// (Week 3: this becomes the SignUp table in the database.)
  final Map<String, Role> signUps;

  /// Items the organizer hopes will drop.
  final List<String> gearWants;
  final String notes;
  final PostStatus status;

  int filledCount(Role role) => signUps.values.where((r) => r == role).length;

  int neededCount(Role role) => slots[role] ?? 0;

  /// Roles that still have empty slots, in priority order (tank first).
  List<Role> get openRoles => [
        for (final role in Role.values)
          if (filledCount(role) < neededCount(role)) role,
      ];

  int get totalSlots => slots.values.fold(0, (sum, n) => sum + n);

  bool get isFull => openRoles.isEmpty;

  bool hasMember(String characterId) => signUps.containsKey(characterId);

  /// Character ids filling [role], in sign-up order.
  List<String> membersInRole(Role role) => [
        for (final entry in signUps.entries)
          if (entry.value == role) entry.key,
      ];

  /// Short status line for cards, e.g. "Needs Tank, Healer" or "Full".
  String get summary => isFull
      ? 'Full'
      : 'Needs ${openRoles.map((role) => role.label).join(', ')}';

  DungeonPost copyWith({
    String? dungeonId,
    String? organizerId,
    DateTime? dateTime,
    Map<Role, int>? slots,
    Map<String, Role>? signUps,
    List<String>? gearWants,
    String? notes,
    PostStatus? status,
  }) {
    return DungeonPost(
      id: id,
      dungeonId: dungeonId ?? this.dungeonId,
      organizerId: organizerId ?? this.organizerId,
      dateTime: dateTime ?? this.dateTime,
      slots: slots ?? this.slots,
      signUps: signUps ?? this.signUps,
      gearWants: gearWants ?? this.gearWants,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}
