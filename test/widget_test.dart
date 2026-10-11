import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coloring_game/screens/home_screen.dart';

void main() {
  testWidgets('Home screen displays title and categories', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    expect(find.text('Coloring World'), findsOneWidget);
    expect(find.text('Start Coloring'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Animals'), findsOneWidget);
    expect(find.text('Dinosaurs'), findsOneWidget);
    expect(find.text('Vehicles'), findsOneWidget);
    expect(find.text('Space'), findsOneWidget);
  });
}
