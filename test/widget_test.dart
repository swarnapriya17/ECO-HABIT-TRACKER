import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_habit_tracker/main.dart';

void main() {
  testWidgets('EcoHabitTrackerApp desktop layout renders and toggles habits', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1536, 960);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const EcoHabitTrackerApp());
    await tester.pumpAndSettle();

    // Verify Brand Logo and Sidebar
    expect(find.textContaining('Eco Habit'), findsWidgets);
    expect(find.text('Small Habits. Big Impact.'), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('My Habits'), findsWidgets);
    expect(find.text('Progress'), findsWidgets);
    expect(find.text('Achievements'), findsWidgets);

    // Verify Welcome Banner
    expect(find.textContaining('Good Morning, Priya!'), findsOneWidget);

    // Verify 5 Summary Cards
    expect(find.text("Today's Progress"), findsOneWidget);
    expect(find.text('Current Streak'), findsOneWidget);
    expect(find.text('CO₂ Saved'), findsOneWidget);
    expect(find.text('Water Saved'), findsOneWidget);
    expect(find.text('Plastic Reduced'), findsOneWidget);

    // Verify 3 Column Content Cards
    expect(find.text('Daily Habits'), findsOneWidget);
    expect(find.text('Achievements & Badges'), findsOneWidget);
    expect(find.text("You're Making a Real Difference!"), findsOneWidget);
    expect(find.text('Habit Consistency'), findsOneWidget);
    expect(find.text('Weekly Progress'), findsOneWidget);
    expect(find.text('Environmental Impact'), findsOneWidget);
    expect(find.text('Recent Activity'), findsOneWidget);
    expect(find.text('Plant 1 Tree Every 100 Points'), findsOneWidget);

    // Test Toggling a Habit Checkbox
    final checkboxFinder = find.byType(InkWell).first;
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();

    // Verify Navigation to My Habits
    await tester.tap(find.text('My Habits').first);
    await tester.pumpAndSettle();
    expect(find.text('My Eco Habits'), findsOneWidget);

    // Verify Navigation to Progress
    await tester.tap(find.text('Progress').first);
    await tester.pumpAndSettle();
    expect(find.text('Sustainability Analytics'), findsOneWidget);

    // Verify Navigation to Achievements
    await tester.tap(find.text('Achievements').first);
    await tester.pumpAndSettle();
    expect(find.text('Eco Achievements & Badges'), findsOneWidget);

    // Verify Navigation to Profile
    await tester.tap(find.text('Profile').first);
    await tester.pumpAndSettle();
    expect(find.text('User Profile & Eco Goals'), findsOneWidget);
  });

  testWidgets(
    'EcoHabitTrackerApp mobile viewport renders cleanly without overflow',
    (WidgetTester tester) async {
      // Standard mobile viewport
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const EcoHabitTrackerApp());
      await tester.pumpAndSettle();

      // Verify mobile header and bottom navigation
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
      expect(find.text('Dashboard'), findsWidgets);
      expect(find.textContaining('Good Morning, Priya!'), findsOneWidget);
      expect(find.text('Daily Habits'), findsOneWidget);
    },
  );
}
