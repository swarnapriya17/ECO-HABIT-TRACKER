import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_habit_tracker/screens/auth/auth_screen.dart';
import 'package:eco_habit_tracker/state/habit_state.dart';

void main() {
  testWidgets(
    'AuthScreen renders SignIn form, validates email/password and switches to Create Account',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1100);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final habitState = HabitState();

      await tester.pumpWidget(MaterialApp(home: AuthScreen(state: habitState)));
      await tester.pumpAndSettle();

      // Verify Brand Logo and Title
      expect(find.text('Eco Habit Tracker'), findsOneWidget);
      expect(find.text('Small Habits. Big Impact.'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);

      // Verify Sign In fields
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.text('Sign In to Dashboard'), findsOneWidget);

      // Test form validation: tap submit with empty inputs
      await tester.tap(find.text('Sign In to Dashboard'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);

      // Switch to Create Account mode
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Verify Full Name and Confirm Password fields appear
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Create Account'), findsWidgets);

      // Test registration validation
      final createAccountBtn = find.widgetWithText(
        ElevatedButton,
        'Create Account',
      );
      await tester.ensureVisible(createAccountBtn);
      await tester.tap(createAccountBtn);
      await tester.pumpAndSettle();
      expect(find.text('Please enter your name'), findsOneWidget);

      // Test Forgot Password Dialog
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();

      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);

      // Close Dialog
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Reset Password'), findsNothing);
    },
  );
}
