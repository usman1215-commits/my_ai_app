// Basic smoke test — just verifies the app builds and boots without
// throwing, landing on the Splash screen. Expand with real widget
// tests as features are finalized.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_ai_app/main.dart';

import 'package:my_ai_app/navigation/main_shell.dart';

void main() {
  testWidgets('App builds and shows the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // The app should build without throwing and produce a MaterialApp.
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Main shell shows the Home screen content', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainShell(initialIndex: 0)));

    expect(find.text('welcome'), findsOneWidget);
  });
}