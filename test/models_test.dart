import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_habit_tracker/models/habit.dart';
import 'package:eco_habit_tracker/models/check_in.dart';
import 'package:eco_habit_tracker/models/activity.dart';
import 'package:eco_habit_tracker/models/user_profile.dart';

void main() {
  group('Habit Model Tests', () {
    test('Habit serialization toMap and fromMap works correctly', () {
      final now = DateTime.now();
      final habit = Habit(
        id: 'h_test_1',
        title: 'Carry Cloth Bag',
        description: 'Brought reusable cloth bag to grocery market',
        category: HabitCategory.plastic,
        impactText: '3 plastic bags saved',
        points: 20,
        co2ImpactKg: 0.4,
        waterImpactL: 5.0,
        plasticImpactItems: 3.0,
        isCompleted: true,
        streakDays: 7,
        createdAt: now,
      );

      final map = habit.toMap();
      expect(map['title'], 'Carry Cloth Bag');
      expect(map['category'], 'plastic');
      expect(map['points'], 20);

      final deserialized = Habit.fromMap(map, 'h_test_1', isCompleted: true);
      expect(deserialized.id, 'h_test_1');
      expect(deserialized.title, 'Carry Cloth Bag');
      expect(deserialized.category, HabitCategory.plastic);
      expect(deserialized.points, 20);
      expect(deserialized.isCompleted, true);
    });
  });

  group('CheckIn Model Tests', () {
    test('CheckIn serialization and stable ID', () {
      final now = DateTime(2026, 10, 27, 10, 0);
      final checkIn = CheckIn(
        id: 'h1_2026-10-27',
        habitId: 'h1',
        habitTitle: 'Reusable Water Bottle',
        category: HabitCategory.water,
        date: '2026-10-27',
        completedAt: now,
        points: 15,
        co2ImpactKg: 0.8,
        waterImpactL: 25.0,
        plasticImpactItems: 3.0,
      );

      final map = checkIn.toMap();
      expect(map['id'], 'h1_2026-10-27');
      expect(map['habitId'], 'h1');
      expect(map['category'], 'water');
      expect(map['date'], '2026-10-27');
      expect(map['points'], 15);

      final deserialized = CheckIn.fromMap(map, 'h1_2026-10-27');
      expect(deserialized.id, 'h1_2026-10-27');
      expect(deserialized.habitId, 'h1');
      expect(deserialized.category, HabitCategory.water);
      expect(deserialized.points, 15);
    });
  });

  group('UserProfile Model Tests', () {
    test('UserProfile serialization and copyWith', () {
      final now = DateTime.now();
      final profile = UserProfile(
        uid: 'user_123',
        email: 'priya.eco@greenglobe.org',
        displayName: 'Priya S.',
        totalPoints: 720,
        streakDays: 14,
        createdAt: now,
      );

      final map = profile.toMap();
      expect(map['uid'], 'user_123');
      expect(map['email'], 'priya.eco@greenglobe.org');
      expect(map['totalPoints'], 720);

      final deserialized = UserProfile.fromMap(map, 'user_123');
      expect(deserialized.uid, 'user_123');
      expect(deserialized.email, 'priya.eco@greenglobe.org');
      expect(deserialized.displayName, 'Priya S.');
      expect(deserialized.totalPoints, 720);

      final updated = profile.copyWith(totalPoints: 740, streakDays: 15);
      expect(updated.totalPoints, 740);
      expect(updated.streakDays, 15);
      expect(updated.email, profile.email);
    });
  });

  group('EcoActivity Model Tests', () {
    test('EcoActivity serialization and relative time formatting', () {
      final now = DateTime.now();
      final activity = EcoActivity(
        id: 'act_1',
        title: 'Completed Reusable Water Bottle',
        points: 15,
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF0284C7),
        timestamp: now.subtract(const Duration(minutes: 5)),
      );

      expect(activity.timeAgo, '5m ago');

      final map = activity.toMap();
      expect(map['title'], 'Completed Reusable Water Bottle');
      expect(map['points'], 15);

      final deserialized = EcoActivity.fromMap(map, 'act_1');
      expect(deserialized.id, 'act_1');
      expect(deserialized.title, 'Completed Reusable Water Bottle');
      expect(deserialized.points, 15);
    });
  });
}
