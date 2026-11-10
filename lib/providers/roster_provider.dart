import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/character.dart';

/// Holds the guild roster and notifies the UI when it changes.
class RosterProvider extends ChangeNotifier {
  RosterProvider([List<Character>? initial]) : _characters = [...?initial];

  final List<Character> _characters;

  /// Read-only view so screens can't change the list without notifying.
  UnmodifiableListView<Character> get characters =>
      UnmodifiableListView(_characters);

  /// Simple unique id for new characters (the database will assign ids later).
  static String newId() => 'c${DateTime.now().microsecondsSinceEpoch}';

  Character? byId(String id) {
    for (final character in _characters) {
      if (character.id == id) return character;
    }
    return null;
  }

  /// Case-insensitive duplicate check. [exceptId] skips the character being
  /// edited so it doesn't clash with its own name.
  bool isNameTaken(String name, {String? exceptId}) {
    final wanted = name.trim().toLowerCase();
    return _characters.any(
      (c) => c.id != exceptId && c.name.toLowerCase() == wanted,
    );
  }

  void add(Character character) {
    _characters.add(character);
    notifyListeners();
  }

  void update(Character character) {
    final index = _characters.indexWhere((c) => c.id == character.id);
    if (index == -1) return;
    _characters[index] = character;
    notifyListeners();
  }

  void remove(String id) {
    _characters.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
