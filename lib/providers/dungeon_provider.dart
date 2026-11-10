import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/dungeon.dart';

/// Loads the dungeon list from assets/dungeons.json.
class DungeonProvider extends ChangeNotifier {
  DungeonProvider();

  /// Skips asset loading; used by tests.
  DungeonProvider.withDungeons(List<Dungeon> dungeons) {
    _dungeons = [...dungeons];
    _isLoading = false;
  }

  List<Dungeon> _dungeons = [];
  bool _isLoading = true;
  String? _error;

  List<Dungeon> get dungeons => List.unmodifiable(_dungeons);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Dungeon? byId(String id) {
    for (final dungeon in _dungeons) {
      if (dungeon.id == id) return dungeon;
    }
    return null;
  }

  Future<void> load() async {
    try {
      final raw = await rootBundle.loadString('assets/dungeons.json');
      final list = jsonDecode(raw) as List<dynamic>;
      _dungeons = list
          .map((entry) => Dungeon.fromJson(entry as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.minLevel.compareTo(b.minLevel));
      _error = null;
    } catch (e) {
      _error = 'Could not load the dungeon list ($e).';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
