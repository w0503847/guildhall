import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../models/race.dart';
import '../models/role.dart';
import '../models/wow_class.dart';
import '../providers/roster_provider.dart';

/// Add or edit a character. Pass [existing] to edit.
class CharacterFormScreen extends StatefulWidget {
  const CharacterFormScreen({super.key, this.existing});

  final Character? existing;

  @override
  State<CharacterFormScreen> createState() => _CharacterFormScreenState();
}

class _CharacterFormScreenState extends State<CharacterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _levelController;
  late WowClass _wowClass;
  late Race _race;
  late Set<Role> _roles;
  late bool _isMain;

  /// 2–12 letters, accented letters allowed (like in-game names).
  static final _namePattern = RegExp(r'^\p{L}{2,12}$', unicode: true);

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _levelController =
        TextEditingController(text: existing?.level.toString() ?? '');
    _wowClass = existing?.wowClass ?? WowClass.warrior;
    _race = existing?.race ?? Race.human;
    _roles = {...?existing?.roles};
    _isMain = existing?.isMain ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Name is required';
    if (!_namePattern.hasMatch(name)) {
      return 'Use 2–12 letters, with no spaces or numbers';
    }
    final taken = context
        .read<RosterProvider>()
        .isNameTaken(name, exceptId: widget.existing?.id);
    if (taken) return '$name is already on the roster';
    return null;
  }

  String? _validateLevel(String? value) {
    final level = int.tryParse(value?.trim() ?? '');
    if (level == null) return 'Enter a level';
    if (level < 1 || level > Character.maxLevel) {
      return 'Level must be between 1 and ${Character.maxLevel}';
    }
    return null;
  }

  /// "kAZZik" -> "Kazzik", matching how the game capitalises names.
  String _formatName(String raw) {
    final name = raw.trim().toLowerCase();
    return name[0].toUpperCase() + name.substring(1);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final character = Character(
      id: widget.existing?.id ?? RosterProvider.newId(),
      name: _formatName(_nameController.text),
      wowClass: _wowClass,
      race: _race,
      roles: {..._roles},
      level: int.parse(_levelController.text.trim()),
      isMain: _isMain,
    );

    final roster = context.read<RosterProvider>();
    if (_isEditing) {
      roster.update(character);
    } else {
      roster.add(character);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isEditing
          ? 'Saved changes to ${character.name}'
          : 'Added ${character.name} to the roster'),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit character' : 'Add character'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Character name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: _validateName,
                ),
                gap,
                TextFormField(
                  controller: _levelController,
                  decoration: const InputDecoration(
                    labelText: 'Level (1–60)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: _validateLevel,
                ),
                gap,
                DropdownButtonFormField<WowClass>(
                  initialValue: _wowClass,
                  decoration: const InputDecoration(
                    labelText: 'Class',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final c in WowClass.values)
                      DropdownMenuItem(value: c, child: Text(c.label)),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _wowClass = value;
                      // Drop roles the new class can't play.
                      _roles.removeWhere(
                          (r) => !value.possibleRoles.contains(r));
                    });
                  },
                ),
                gap,
                DropdownButtonFormField<Race>(
                  initialValue: _race,
                  decoration: const InputDecoration(
                    labelText: 'Race',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final r in Race.values)
                      DropdownMenuItem(value: r, child: Text(r.label)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _race = value);
                  },
                ),
                gap,
                // A custom FormField so "pick at least one role" shows an
                // error just like the text fields do.
                FormField<Set<Role>>(
                  validator: (_) =>
                      _roles.isEmpty ? 'Pick at least one role' : null,
                  builder: (field) => InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Roles',
                      errorText: field.errorText,
                      border: const OutlineInputBorder(),
                    ),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        for (final role in Role.values)
                          if (_wowClass.possibleRoles.contains(role))
                            FilterChip(
                              label: Text(role.label),
                              selected: _roles.contains(role),
                              onSelected: (selected) {
                                setState(() => selected
                                    ? _roles.add(role)
                                    : _roles.remove(role));
                                field.didChange(_roles);
                              },
                            ),
                      ],
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Main character'),
                  subtitle: const Text('Turn off for alts'),
                  value: _isMain,
                  onChanged: (value) => setState(() => _isMain = value),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(_isEditing ? 'Save changes' : 'Add to roster'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
