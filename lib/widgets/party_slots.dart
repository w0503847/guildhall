import 'package:flutter/material.dart';

import '../models/character.dart';
import '../models/dungeon_post.dart';
import '../models/role.dart';
import 'class_avatar.dart';
import 'display_extensions.dart';

/// Lists every party slot, filled or open, grouped by role.
class PartySlots extends StatelessWidget {
  const PartySlots({
    super.key,
    required this.post,
    required this.lookup,
    required this.onLeave,
  });

  final DungeonPost post;

  /// Finds a character by id (usually RosterProvider.byId).
  final Character? Function(String id) lookup;

  /// Called with a character id when their remove button is pressed.
  final void Function(String characterId) onLeave;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (final role in Role.values) {
      final members = post.membersInRole(role);
      for (var i = 0; i < post.neededCount(role); i++) {
        rows.add(i < members.length
            ? _filledSlot(context, role, members[i])
            : _openSlot(context, role));
      }
    }
    return Column(children: rows);
  }

  Widget _filledSlot(BuildContext context, Role role, String characterId) {
    final character = lookup(characterId);
    final isOrganizer = characterId == post.organizerId;
    return ListTile(
      leading: character == null
          ? const CircleAvatar(child: Icon(Icons.person_off))
          : ClassAvatar(character: character),
      title: Text(character?.name ?? 'Removed character'),
      subtitle: Text(isOrganizer ? '${role.label} · organizer' : role.label),
      trailing: isOrganizer
          ? Icon(role.icon, semanticLabel: role.label)
          : IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              tooltip: 'Remove from party',
              onPressed: () => onLeave(characterId),
            ),
    );
  }

  Widget _openSlot(BuildContext context, Role role) {
    final muted = Theme.of(context).colorScheme.outline;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(role.icon, color: muted),
      ),
      title: Text(
        'Open ${role.label} slot',
        style: TextStyle(color: muted, fontStyle: FontStyle.italic),
      ),
    );
  }
}
