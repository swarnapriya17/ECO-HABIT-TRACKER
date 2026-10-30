import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum HabitCategory {
  water,
  energy,
  plastic,
  food,
  transport;

  String get displayName {
    switch (this) {
      case HabitCategory.water:
        return 'Water';
      case HabitCategory.energy:
        return 'Energy';
      case HabitCategory.plastic:
        return 'Waste';
      case HabitCategory.food:
        return 'Food';
      case HabitCategory.transport:
        return 'Commute';
    }
  }

  IconData get icon {
    switch (this) {
      case HabitCategory.water:
        return Icons.water_drop_rounded;
      case HabitCategory.energy:
        return Icons.bolt_rounded;
      case HabitCategory.plastic:
        return Icons.recycling_rounded;
      case HabitCategory.food:
        return Icons.eco_rounded;
      case HabitCategory.transport:
        return Icons.pedal_bike_rounded;
    }
  }

  Color get color {
    switch (this) {
      case HabitCategory.water:
        return AppColors.water;
      case HabitCategory.energy:
        return AppColors.energy;
      case HabitCategory.plastic:
        return AppColors.plastic;
      case HabitCategory.food:
        return const Color(0xFF16A34A);
      case HabitCategory.transport:
        return const Color(0xFF0D9488);
    }
  }

  Color get bgColor {
    switch (this) {
      case HabitCategory.water:
        return AppColors.waterLight;
      case HabitCategory.energy:
        return AppColors.energyLight;
      case HabitCategory.plastic:
        return AppColors.plasticLight;
      case HabitCategory.food:
        return const Color(0xFFDCFCE7);
      case HabitCategory.transport:
        return const Color(0xFFCCFBF1);
    }
  }
}

class Habit {
  final String id;
  final String title;
  final String description;
  final HabitCategory category;
  final String impactText;
  final int points;
  final double co2ImpactKg;
  final double waterImpactL;
  final double plasticImpactItems;
  bool isCompleted;
  int streakDays;
  final String targetFrequency;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.impactText,
    required this.points,
    this.co2ImpactKg = 0.5,
    this.waterImpactL = 10.0,
    this.plasticImpactItems = 1.0,
    this.isCompleted = false,
    this.streakDays = 5,
    this.targetFrequency = 'daily',
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'impactText': impactText,
      'points': points,
      'co2ImpactKg': co2ImpactKg,
      'waterImpactL': waterImpactL,
      'plasticImpactItems': plasticImpactItems,
      'streakDays': streakDays,
      'targetFrequency': targetFrequency,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory Habit.fromMap(
    Map<String, dynamic> map,
    String id, {
    bool isCompleted = false,
  }) {
    HabitCategory parseCategory(dynamic val) {
      if (val is String) {
        return HabitCategory.values.firstWhere(
          (c) => c.name.toLowerCase() == val.toLowerCase(),
          orElse: () => HabitCategory.water,
        );
      }
      return HabitCategory.water;
    }

    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return null;
    }

    return Habit(
      id: id,
      title: map['title'] as String? ?? 'Untitled Habit',
      description: map['description'] as String? ?? '',
      category: parseCategory(map['category']),
      impactText: map['impactText'] as String? ?? '',
      points: (map['points'] as num?)?.toInt() ?? 10,
      co2ImpactKg: (map['co2ImpactKg'] as num?)?.toDouble() ?? 0.5,
      waterImpactL: (map['waterImpactL'] as num?)?.toDouble() ?? 10.0,
      plasticImpactItems:
          (map['plasticImpactItems'] as num?)?.toDouble() ?? 1.0,
      isCompleted: isCompleted,
      streakDays: (map['streakDays'] as num?)?.toInt() ?? 1,
      targetFrequency: map['targetFrequency'] as String? ?? 'daily',
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  factory Habit.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    bool isCompleted = false,
  }) {
    final data = doc.data() ?? {};
    return Habit.fromMap(data, doc.id, isCompleted: isCompleted);
  }

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    HabitCategory? category,
    String? impactText,
    int? points,
    double? co2ImpactKg,
    double? waterImpactL,
    double? plasticImpactItems,
    bool? isCompleted,
    int? streakDays,
    String? targetFrequency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      impactText: impactText ?? this.impactText,
      points: points ?? this.points,
      co2ImpactKg: co2ImpactKg ?? this.co2ImpactKg,
      waterImpactL: waterImpactL ?? this.waterImpactL,
      plasticImpactItems: plasticImpactItems ?? this.plasticImpactItems,
      isCompleted: isCompleted ?? this.isCompleted,
      streakDays: streakDays ?? this.streakDays,
      targetFrequency: targetFrequency ?? this.targetFrequency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
