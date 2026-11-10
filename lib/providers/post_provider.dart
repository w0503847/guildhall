import 'package:flutter/foundation.dart';

import '../models/dungeon_post.dart';
import '../models/role.dart';

/// Holds dungeon posts and handles sign-ups.
class PostProvider extends ChangeNotifier {
  PostProvider([List<DungeonPost>? initial]) : _posts = [...?initial];

  final List<DungeonPost> _posts;

  /// Open posts, soonest first.
  List<DungeonPost> get upcoming => _posts
      .where((p) => p.status == PostStatus.open)
      .toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  DungeonPost? byId(String id) {
    for (final post in _posts) {
      if (post.id == id) return post;
    }
    return null;
  }

  void _replace(DungeonPost updated) {
    final index = _posts.indexWhere((p) => p.id == updated.id);
    if (index == -1) return;
    _posts[index] = updated;
    notifyListeners();
  }

  /// Adds [characterId] to the party as [role].
  /// Returns false if the post is missing, they're already in, or the role is full.
  bool signUp(String postId, String characterId, Role role) {
    final post = byId(postId);
    if (post == null || post.hasMember(characterId)) return false;
    if (post.filledCount(role) >= post.neededCount(role)) return false;

    _replace(post.copyWith(signUps: {...post.signUps, characterId: role}));
    return true;
  }

  /// Removes [characterId] from the party. The organizer can't leave their
  /// own post (they would cancel it instead), so this returns false for them.
  bool leave(String postId, String characterId) {
    final post = byId(postId);
    if (post == null || post.organizerId == characterId) return false;

    final updated = {...post.signUps}..remove(characterId);
    _replace(post.copyWith(signUps: updated));
    return true;
  }

  /// Called when a character is deleted from the roster: removes their
  /// sign-ups and cancels any post they were organizing.
  void removeCharacterEverywhere(String characterId) {
    for (var i = 0; i < _posts.length; i++) {
      final post = _posts[i];
      if (post.organizerId == characterId) {
        _posts[i] = post.copyWith(status: PostStatus.cancelled);
      } else if (post.hasMember(characterId)) {
        _posts[i] = post.copyWith(
          signUps: {...post.signUps}..remove(characterId),
        );
      }
    }
    notifyListeners();
  }
}
