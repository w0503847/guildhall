import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/sample_data.dart';
import 'models/dungeon.dart';
import 'providers/dungeon_provider.dart';
import 'providers/post_provider.dart';
import 'providers/roster_provider.dart';
import 'screens/home_shell.dart';

void main() {
  runApp(const GuildhallApp());
}

/// App root: creates the providers and the theme.
class GuildhallApp extends StatelessWidget {
  const GuildhallApp({super.key, this.initialDungeons});

  /// Tests pass dungeons here to skip loading the JSON asset.
  final List<Dungeon>? initialDungeons;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => initialDungeons != null
              ? DungeonProvider.withDungeons(initialDungeons!)
              : (DungeonProvider()..load()),
        ),
        ChangeNotifierProvider(
          create: (_) => RosterProvider(sampleCharacters),
        ),
        ChangeNotifierProvider(
          create: (_) => PostProvider(buildSamplePosts()),
        ),
      ],
      child: MaterialApp(
        title: 'Guildhall',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC79C3E), // guild-banner gold
            brightness: Brightness.dark,
          ),
        ),
        home: const HomeShell(),
      ),
    );
  }
}
