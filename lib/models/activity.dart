import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EcoActivity {
  final String id;
  final String title;
  final String? _explicitTimeAgo;
  final int points;
  final IconData icon;
  final Color color;
  final DateTime? timestamp;
  final String? type;
  final String? habitId;

  const EcoActivity({
    required this.id,
    required this.title,
    String? timeAgo,
    required this.points,
    required this.icon,
    required this.color,
    this.timestamp,
    this.type,
    this.habitId,
  }) : _explicitTimeAgo = timeAgo;

  String get timeAgo {
    final explicit = _explicitTimeAgo;
    if (explicit != null && explicit.isNotEmpty) {
      return explicit;
    }
    final ts = timestamp;
    if (ts == null) return 'Recently';

    final now = DateTime.now();
    final difference = now.difference(ts);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${ts.day}/${ts.month}/${ts.year}';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'points': points,
      'iconCode': icon.codePoint,
      'colorValue': color.toARGB32(),
      'timestamp': timestamp != null
          ? Timestamp.fromDate(timestamp!)
          : FieldValue.serverTimestamp(),
      'type': type ?? 'habit_completion',
      'habitId': habitId,
    };
  }

  factory EcoActivity.fromMap(Map<String, dynamic> map, String id) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return null;
    }

    final iconCode = map['iconCode'] as int?;
    final colorVal = map['colorValue'] as int?;

    IconData resolveIcon(int? code) {
      if (code == Icons.water_drop_rounded.codePoint) {
        return Icons.water_drop_rounded;
      }
      if (code == Icons.pedal_bike_rounded.codePoint) {
        return Icons.pedal_bike_rounded;
      }
      if (code == Icons.local_fire_department_rounded.codePoint) {
        return Icons.local_fire_department_rounded;
      }
      if (code == Icons.shopping_bag_rounded.codePoint) {
        return Icons.shopping_bag_rounded;
      }
      if (code == Icons.power_settings_new_rounded.codePoint) {
        return Icons.power_settings_new_rounded;
      }
      if (code == Icons.bolt_rounded.codePoint) {
        return Icons.bolt_rounded;
      }
      if (code == Icons.recycling_rounded.codePoint) {
        return Icons.recycling_rounded;
      }
      if (code == Icons.delete_outline_rounded.codePoint) {
        return Icons.delete_outline_rounded;
      }
      return Icons.eco_rounded;
    }

    return EcoActivity(
      id: id,
      title: map['title'] as String? ?? 'Eco Action',
      points: (map['points'] as num?)?.toInt() ?? 10,
      icon: resolveIcon(iconCode),
      color: colorVal != null ? Color(colorVal) : AppColors.primaryVibrant,
      timestamp: parseDate(map['timestamp']),
      type: map['type'] as String?,
      habitId: map['habitId'] as String?,
    );
  }

  factory EcoActivity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return EcoActivity.fromMap(data, doc.id);
  }
}
