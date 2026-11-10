import 'package:flutter/material.dart';

import '../models/role.dart';
import '../models/wow_class.dart';

/// UI-only details for the models, kept out of the model files so the
/// models stay plain Dart.

extension RoleIcon on Role {
  IconData get icon => switch (this) {
        Role.tank => Icons.shield,
        Role.healer => Icons.healing,
        Role.dps => Icons.bolt,
      };
}

extension WowClassColor on WowClass {
  /// The class colours players recognise from the game's UI.
  Color get color => switch (this) {
        WowClass.druid => const Color(0xFFFF7C0A),
        WowClass.hunter => const Color(0xFFAAD372),
        WowClass.mage => const Color(0xFF3FC7EB),
        WowClass.paladin => const Color(0xFFF48CBA),
        WowClass.priest => const Color(0xFFFFFFFF),
        WowClass.rogue => const Color(0xFFFFF468),
        WowClass.shaman => const Color(0xFF0070DD),
        WowClass.warlock => const Color(0xFF8788EE),
        WowClass.warrior => const Color(0xFFC69B6D),
      };
}
