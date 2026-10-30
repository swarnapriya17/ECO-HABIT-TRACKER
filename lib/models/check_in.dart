import 'package:cloud_firestore/cloud_firestore.dart';
import 'habit.dart';

class CheckIn {
  final String id;
  final String habitId;
  final String habitTitle;
  final HabitCategory category;
  final String date; // YYYY-MM-DD
  final DateTime completedAt;
  final int points;
  final double co2ImpactKg;
  final double waterImpactL;
  final double plasticImpactItems;

  const CheckIn({
    required this.id,
    required this.habitId,
    required this.habitTitle,
    required this.category,
    required this.date,
    required this.completedAt,
    required this.points,
    this.co2ImpactKg = 0.5,
    this.waterImpactL = 10.0,
    this.plasticImpactItems = 1.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'habitTitle': habitTitle,
      'category': category.name,
      'date': date,
      'completedAt': Timestamp.fromDate(completedAt),
      'points': points,
      'co2ImpactKg': co2ImpactKg,
      'waterImpactL': waterImpactL,
      'plasticImpactItems': plasticImpactItems,
    };
  }

  factory CheckIn.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseCompletedAt(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      } else if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      return DateTime.now();
    }

    HabitCategory parseCategory(dynamic val) {
      if (val is String) {
        return HabitCategory.values.firstWhere(
          (c) => c.name.toLowerCase() == val.toLowerCase(),
          orElse: () => HabitCategory.water,
        );
      }
      return HabitCategory.water;
    }

    return CheckIn(
      id: id,
      habitId: map['habitId'] as String? ?? '',
      habitTitle: map['habitTitle'] as String? ?? '',
      category: parseCategory(map['category']),
      date: map['date'] as String? ?? '',
      completedAt: parseCompletedAt(map['completedAt']),
      points: (map['points'] as num?)?.toInt() ?? 0,
      co2ImpactKg: (map['co2ImpactKg'] as num?)?.toDouble() ?? 0.0,
      waterImpactL: (map['waterImpactL'] as num?)?.toDouble() ?? 0.0,
      plasticImpactItems:
          (map['plasticImpactItems'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory CheckIn.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return CheckIn.fromMap(data, doc.id);
  }
}
