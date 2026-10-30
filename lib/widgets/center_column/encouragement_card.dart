import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../state/habit_state.dart';
import '../custom_painters/glowing_seedling_painter.dart';

class EncouragementCard extends StatelessWidget {
  final HabitState state;

  const EncouragementCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.featureCardTop, AppColors.featureCardBottom],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E5235), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0A2014),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tag Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E5434),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2E754E)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars_rounded, size: 14, color: Color(0xFF4ADE80)),
                SizedBox(width: 6),
                Text(
                  'ENVIRONMENTAL IMPACT',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: Color(0xFF86EFAC),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Glowing seedling / plant illustration
          SizedBox(
            width: 160,
            height: 140,
            child: CustomPaint(painter: GlowingSeedlingPainter()),
          ),

          const SizedBox(height: 12),

          // Title
          const Text(
            "You're Making a Real Difference!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),

          // Supporting text
          Text(
            "Your sustainable choices this week reduced carbon emissions equal to taking a car off the road for 45 miles.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textOnDarkMuted,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 20),

          // Prominent Green "View Progress" button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => state.setNavIndex(2), // Navigate to Progress
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryVibrant,
                foregroundColor: const Color(0xFF062815),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('View Progress'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
