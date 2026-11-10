import 'package:flutter/material.dart';

import '../models/character.dart';
import 'display_extensions.dart';

/// Circle in the character's class colour with the class initial.
class ClassAvatar extends StatelessWidget {
  const ClassAvatar({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: character.wowClass.label,
      child: CircleAvatar(
        backgroundColor: character.wowClass.color,
        foregroundColor: Colors.black,
        child: Text(
          character.wowClass.label[0],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
