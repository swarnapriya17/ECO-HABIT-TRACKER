import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../state/habit_state.dart';
import 'custom_painters/scenic_landscape_painter.dart';

class WelcomeBanner extends StatelessWidget {
  final HabitState? state;

  const WelcomeBanner({super.key, this.state});

  String get _dateString {
    return DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final displayName = state?.userDisplayName ?? 'Eco Champion';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEFF8F1), Color(0xFFE4F3E8), Color(0xFFD6EDE0)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD5E8DA), width: 1),
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
              // Scenic Nature Illustration on right side
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: isNarrow
                    ? constraints.maxWidth * 0.45
                    : constraints.maxWidth * 0.52,
                child: Opacity(
                  opacity: 0.95,
                  child: CustomPaint(
                    painter: ScenicLandscapePainter(),
                    size: Size.infinite,
                  ),
                ),
              ),

              // Soft gradient overlay so text is 100% readable
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.45, 0.85],
                      colors: [
                        const Color(0xFFEFF8F1).withValues(alpha: 0.98),
                        const Color(0xFFEFF8F1).withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Content text & badges
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 18 : 32,
                  vertical: isNarrow ? 20 : 28,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isNarrow
                        ? constraints.maxWidth * 0.8
                        : constraints.maxWidth * 0.55,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Greeting Pill Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFC7E2CE)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wb_sunny_rounded,
                              size: 14,
                              color: Color(0xFFEAB308),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'DAILY ECO INSPIRATION',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: Color(0xFF2E6547),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Large Greeting
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Good Morning, $displayName!',
                              style: TextStyle(
                                fontSize: isNarrow ? 22 : 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('🌿', style: TextStyle(fontSize: 24)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _dateString,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E6547),
                        ),
                      ),

                      // Supporting message
                      const Text(
                        'Every small action counts. Keep going towards a greener tomorrow!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
