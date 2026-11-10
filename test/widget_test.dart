import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:guildhall/main.dart';
import 'package:guildhall/models/dungeon.dart';

const _testDungeons = [
  Dungeon(id: 'deadmines', name: 'The Deadmines', zone: 'Westfall', minLevel: 17, maxLevel: 26),
  Dungeon(id: 'wailing-caverns', name: 'Wailing Caverns', zone: 'The Barrens', minLevel: 17, maxLevel: 24),
  Dungeon(id: 'shadowfang-keep', name: 'Shadowfang Keep', zone: 'Silverpine Forest', minLevel: 22, maxLevel: 30),
];

void main() {
  testWidgets('starts on the board and switches to the roster tab',
      (tester) async {
    await tester.pumpWidget(const GuildhallApp(initialDungeons: _testDungeons));
    await tester.pumpAndSettle();

    expect(find.text('Dungeon Board'), findsOneWidget);
    expect(find.text('The Deadmines'), findsOneWidget);

    await tester.tap(find.text('Roster'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Guild Roster'), findsOneWidget);
  });

  testWidgets('character form rejects an invalid level', (tester) async {
    await tester.pumpWidget(const GuildhallApp(initialDungeons: _testDungeons));
    await tester.tap(find.text('Roster'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add character'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Character name'), 'Testy');
    await tester.enterText(find.widgetWithText(TextFormField, 'Level (1–60)'), '75');
    await tester.ensureVisible(find.text('Add to roster'));
    await tester.tap(find.text('Add to roster'));
    await tester.pumpAndSettle();

    expect(find.text('Level must be between 1 and 60'), findsOneWidget);
    expect(find.text('Pick at least one role'), findsOneWidget);
  });
}
