import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dungeon_provider.dart';
import '../providers/post_provider.dart';
import '../providers/roster_provider.dart';
import '../widgets/post_card.dart';
import 'post_detail_screen.dart';

/// Tab 1: upcoming dungeon runs, soonest first.
class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = context.watch<PostProvider>().upcoming;
    final dungeons = context.watch<DungeonProvider>();
    final roster = context.watch<RosterProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Dungeon Board')),
      // Week 3: FloatingActionButton here opens the new Post Form.
      body: posts.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No runs planned yet.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: posts.length,
              itemBuilder: (context, i) {
                final post = posts[i];
                return PostCard(
                  post: post,
                  dungeon: dungeons.byId(post.dungeonId),
                  organizer: roster.byId(post.organizerId),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(postId: post.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
