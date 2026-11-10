import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../models/role.dart';
import '../providers/post_provider.dart';
import '../providers/roster_provider.dart';
import '../widgets/character_tile.dart';
import 'character_form_screen.dart';

/// Tab 2: the guild roster with search, role filter, add, edit and delete.
class RosterScreen extends StatefulWidget {
  const RosterScreen({super.key});

  @override
  State<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends State<RosterScreen> {
  String _query = '';
  Role? _roleFilter;

  void _openForm({Character? existing}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CharacterFormScreen(existing: existing),
      ),
    );
  }

  Future<bool> _confirmDelete(Character character) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove ${character.name}?'),
        content: const Text(
          'They will be removed from any parties, and runs they organized '
          'will be cancelled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  void _delete(Character character) {
    context.read<PostProvider>().removeCharacterEverywhere(character.id);
    context.read<RosterProvider>().remove(character.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${character.name} removed from the roster')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roster = context.watch<RosterProvider>();
    final query = _query.trim().toLowerCase();
    final visible = roster.characters
        .where((c) => _roleFilter == null || c.canFill(_roleFilter!))
        .where((c) => c.name.toLowerCase().contains(query))
        .toList()
      ..sort((a, b) => b.level.compareTo(a.level));

    return Scaffold(
      appBar: AppBar(title: Text('Guild Roster (${roster.characters.length})')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.person_add),
        label: const Text('Add character'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _roleFilter == null,
                  onSelected: (_) => setState(() => _roleFilter = null),
                ),
                for (final role in Role.values)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(role.label),
                      selected: _roleFilter == role,
                      onSelected: (_) => setState(() =>
                          _roleFilter = _roleFilter == role ? null : role),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? const Center(child: Text('No characters match.'))
                : ListView.builder(
                    // Bottom padding so the FAB never covers the last row.
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: visible.length,
                    itemBuilder: (context, i) {
                      final character = visible[i];
                      return Dismissible(
                        key: ValueKey(character.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          child: const Icon(Icons.delete_outline),
                        ),
                        confirmDismiss: (_) => _confirmDelete(character),
                        onDismissed: (_) => _delete(character),
                        child: CharacterTile(
                          character: character,
                          onTap: () => _openForm(existing: character),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
