import 'package:flutter/material.dart';

import '../models/character.dart';
import 'class_avatar.dart';
import 'display_extensions.dart';

/// One roster row: class avatar, name, level/race/class, role icons.
class CharacterTile extends StatelessWidget {
  const CharacterTile({
    super.key,
    required this.character,
    this.onTap,
    this.trailing,
  });

  final Character character;
  final VoidCallback? onTap;

  /// Replaces the default role icons when set.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = character;
    return ListTile(
      leading: ClassAvatar(character: c),
      title: Text(c.isMain ? c.name : '${c.name} (alt)'),
      subtitle: Text('Lv ${c.level} ${c.race.label} ${c.wowClass.label}'),
      trailing: trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final role in c.roles)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(role.icon, size: 20, semanticLabel: role.label),
                ),
            ],
          ),
      onTap: onTap,
    );
  }
}
