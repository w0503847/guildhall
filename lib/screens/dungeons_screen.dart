import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../models/dungeon.dart';
import '../providers/dungeon_provider.dart';
import '../providers/roster_provider.dart';
import '../widgets/character_tile.dart';

/// Tab 3: dungeons by level, with how many guild characters are in range.
class DungeonsScreen extends StatelessWidget {
  const DungeonsScreen({super.key});

  void _showInRange(
      BuildContext context, Dungeon dungeon, List<Character> inRange) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(dungeon.name,
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text('Guild characters level ${dungeon.levelRange}'),
            ),
            if (inRange.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Nobody is in range yet.'),
              )
            else
              for (final c in inRange) CharacterTile(character: c),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dungeonProvider = context.watch<DungeonProvider>();
    final roster = context.watch<RosterProvider>();

    Widget body;
    if (dungeonProvider.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (dungeonProvider.error != null) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(dungeonProvider.error!, textAlign: TextAlign.center),
        ),
      );
    } else {
      final dungeons = dungeonProvider.dungeons;
      body = ListView.separated(
        itemCount: dungeons.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final dungeon = dungeons[i];
          final inRange = roster.characters
              .where((c) => dungeon.fitsLevel(c.level))
              .toList();
          return ListTile(
            title: Text(dungeon.name),
            subtitle: Text('${dungeon.zone} · Levels ${dungeon.levelRange}'),
            trailing: Text('${inRange.length} in range'),
            onTap: () => _showInRange(context, dungeon, inRange),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dungeons')),
      body: body,
    );
  }
}
