import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../state/habit_state.dart';
import '../custom_painters/decorative_leaves_painter.dart';

class StreakProgressCard extends StatelessWidget {
  final HabitState state;

  const StreakProgressCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F6ED), Color(0xFFF2F9F4)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCDE8D5), width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background decorative leaves
          const Positioned.fill(
            child: CustomPaint(
              painter: DecorativeLeavesPainter(leafColor: Color(0xFF16A34A)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Habit Consistency',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFED7AA)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 14,
                            color: AppColors.streak,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'On Fire!',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.streak,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Circular streak indicator
                Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 105,
                        height: 105,
                        child: CircularProgressIndicator(
                          value: 14 / 21,
                          strokeWidth: 6,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.streak,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: AppColors.streak,
                            size: 22,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${state.currentStreak}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'DAYS STREAK',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Next milestone text & progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Next Milestone: 21 Days',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '7 days left',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.streak,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 14 / 21,
                    minHeight: 7,
                    backgroundColor: Color(0xFFDCEFE2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryVibrant,
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                const Divider(color: Color(0xFFCCE8D4), height: 1),
                const SizedBox(height: 14),

                // Milestone steps
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: 280,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _milestoneStep('Day 7', 'Sprout', true),
                        _milestoneDivider(true),
                        _milestoneStep('Day 14', 'Warrior', true),
                        _milestoneDivider(false),
                        _milestoneStep('Day 21', 'Guardian', false),
                        _milestoneDivider(false),
                        _milestoneStep('Day 30', 'Legend', false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _milestoneStep(String day, String title, bool achieved) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: achieved ? AppColors.primaryVibrant : Colors.white,
            border: Border.all(
              color: achieved
                  ? AppColors.primaryVibrant
                  : const Color(0xFFCBD5E1),
              width: 1.5,
            ),
          ),
          child: Icon(
            achieved ? Icons.check_rounded : Icons.lock_outline_rounded,
            size: 14,
            color: achieved ? Colors.white : const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: achieved ? AppColors.primaryDark : const Color(0xFF64748B),
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _milestoneDivider(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24),
        color: active ? AppColors.primaryVibrant : const Color(0xFFCBD5E1),
      ),
    );
  }
}
