import 'package:flutter/material.dart';

import '../models/character.dart';
import '../models/dungeon.dart';
import '../models/dungeon_post.dart';
import '../utils/formatters.dart';

/// Summary card for a post on the Dungeon Board.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.dungeon,
    required this.organizer,
    this.onTap,
  });

  final DungeonPost post;

  /// Null while the dungeon list is still loading.
  final Dungeon? dungeon;
  final Character? organizer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final needsColor =
        post.isFull ? theme.colorScheme.primary : theme.colorScheme.tertiary;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(dungeon?.name ?? 'Loading…', style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${formatPostTime(post.dateTime)}\n'
          'Organizer: ${organizer?.name ?? 'Unknown'}',
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${post.signUps.length}/${post.totalSlots}',
              style: theme.textTheme.titleLarge,
            ),
            Text(post.summary,
                style: theme.textTheme.labelSmall?.copyWith(color: needsColor)),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
