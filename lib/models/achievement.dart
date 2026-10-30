import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final bool isUnlocked;
  final double progress; // 0.0 to 1.0
  final String progressLabel;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.isUnlocked = false,
    this.progress = 1.0,
    required this.progressLabel,
  });
}
