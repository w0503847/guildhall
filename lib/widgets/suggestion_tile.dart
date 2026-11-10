import 'package:flutter/material.dart';

import '../logic/suggest_members.dart';
import 'class_avatar.dart';

/// A suggested member with the reason they fit and an Invite button.
class SuggestionTile extends StatelessWidget {
  const SuggestionTile({
    super.key,
    required this.suggestion,
    required this.onInvite,
  });

  final Suggestion suggestion;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClassAvatar(character: suggestion.character),
      title: Text(suggestion.character.name),
      subtitle: Text(suggestion.reason),
      trailing: FilledButton.tonal(
        onPressed: onInvite,
        child: const Text('Invite'),
      ),
    );
  }
}
