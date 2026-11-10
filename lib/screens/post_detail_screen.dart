import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/suggest_members.dart';
import '../providers/dungeon_provider.dart';
import '../providers/post_provider.dart';
import '../providers/roster_provider.dart';
import '../utils/formatters.dart';
import '../widgets/party_slots.dart';
import '../widgets/section_header.dart';
import '../widgets/suggestion_tile.dart';

/// Full view of one post: details, party slots and suggested members.
///
/// Takes a post id rather than a post object, and looks the post up with
/// context.watch, so the screen rebuilds whenever someone joins or leaves.
class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.postId});

  final String postId;

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final post = context.watch<PostProvider>().byId(postId);
    if (post == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('This post no longer exists.')),
      );
    }

    final dungeon = context.watch<DungeonProvider>().byId(post.dungeonId);
    final roster = context.watch<RosterProvider>();
    final organizer = roster.byId(post.organizerId);
    final suggestions = dungeon == null
        ? const <Suggestion>[]
        : suggestMembers(post: post, dungeon: dungeon, roster: roster.characters);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(dungeon?.name ?? 'Dungeon run')),
      body: Center(
        // Keeps the content readable on wide tablet screens.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(formatPostTime(post.dateTime), style: textTheme.titleLarge),
              const SizedBox(height: 4),
              if (dungeon != null)
                Text('${dungeon.zone} · Levels ${dungeon.levelRange}'),
              Text('Organized by ${organizer?.name ?? 'Unknown'}'),
              if (post.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(post.notes),
              ],
              if (post.gearWants.isNotEmpty) ...[
                const SectionHeader('GEAR WANTED'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final item in post.gearWants)
                      Chip(
                        avatar: const Icon(Icons.star_outline, size: 18),
                        label: Text(item),
                      ),
                  ],
                ),
              ],
              SectionHeader(
                  'PARTY (${post.signUps.length}/${post.totalSlots})'),
              PartySlots(
                post: post,
                lookup: roster.byId,
                onLeave: (characterId) {
                  final name = roster.byId(characterId)?.name ?? 'Member';
                  context.read<PostProvider>().leave(post.id, characterId);
                  _showMessage(context, '$name left the party');
                },
              ),
              const SectionHeader('SUGGESTED MEMBERS'),
              if (post.isFull)
                const Text('The party is full.')
              else if (suggestions.isEmpty)
                const Text(
                    'No guild characters are in range for the open roles.')
              else
                for (final s in suggestions)
                  SuggestionTile(
                    suggestion: s,
                    onInvite: () {
                      final added = context
                          .read<PostProvider>()
                          .signUp(post.id, s.character.id, s.role);
                      _showMessage(
                        context,
                        added
                            ? '${s.character.name} joined as ${s.role.label}'
                            : 'That slot was just filled',
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
