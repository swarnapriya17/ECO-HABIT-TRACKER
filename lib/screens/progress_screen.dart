import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/habit_state.dart';
import '../widgets/right_column/weekly_progress_chart_card.dart';
import '../widgets/right_column/environmental_impact_card.dart';

class ProgressScreen extends StatelessWidget {
  final HabitState state;

  const ProgressScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 768;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 18 : 32,
            vertical: isNarrow ? 20 : 28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Sustainability Analytics',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Detailed metrics and long-term environmental impact from your habits.',
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Top Stats Grid
              if (isNarrow)
                Column(
                  children: [
                    _statPill(
                      title: 'Total Eco Points',
                      value: '${state.totalPoints}',
                      subtitle: 'Top 5% of community',
                      icon: Icons.emoji_events_rounded,
                      color: const Color(0xFFEAB308),
                      bgColor: const Color(0xFFFEF9C3),
                    ),
                    const SizedBox(height: 12),
                    _statPill(
                      title: 'Longest Streak',
                      value: '21 Days',
                      subtitle: 'Active streak: ${state.currentStreak}d',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.streak,
                      bgColor: AppColors.streakLight,
                    ),
                    const SizedBox(height: 12),
                    _statPill(
                      title: 'Carbon Offset',
                      value: '${state.totalCo2Saved.toStringAsFixed(1)} kg',
                      subtitle: 'Equivalent to 4 trees',
                      icon: Icons.cloud_done_rounded,
                      color: AppColors.co2,
                      bgColor: AppColors.co2Light,
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _statPill(
                        title: 'Total Eco Points',
                        value: '${state.totalPoints}',
                        subtitle: 'Top 5% of community',
                        icon: Icons.emoji_events_rounded,
                        color: const Color(0xFFEAB308),
                        bgColor: const Color(0xFFFEF9C3),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _statPill(
                        title: 'Longest Streak',
                        value: '21 Days',
                        subtitle: 'Active streak: ${state.currentStreak}d',
                        icon: Icons.local_fire_department_rounded,
                        color: AppColors.streak,
                        bgColor: AppColors.streakLight,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _statPill(
                        title: 'Carbon Offset',
                        value: '${state.totalCo2Saved.toStringAsFixed(1)} kg',
                        subtitle: 'Equivalent to 4 trees',
                        icon: Icons.cloud_done_rounded,
                        color: AppColors.co2,
                        bgColor: AppColors.co2Light,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 24),

              // Charts Row / Column
              if (isNarrow)
                Column(
                  children: [
                    WeeklyProgressChartCard(state: state),
                    const SizedBox(height: 20),
                    EnvironmentalImpactCard(state: state),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: WeeklyProgressChartCard(state: state),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 5,
                      child: EnvironmentalImpactCard(state: state),
                    ),
                  ],
                ),

              const SizedBox(height: 24),

              // Community Benchmark Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Community Comparison',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'How your habits compare to the city average in Bangalore, India',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _benchmarkRow(
                      'Plastic Reduction Rate',
                      0.88,
                      'You: 88%',
                      'City Avg: 45%',
                    ),
                    const SizedBox(height: 14),
                    _benchmarkRow(
                      'Public/Active Commute',
                      0.72,
                      'You: 72%',
                      'City Avg: 52%',
                    ),
                    const SizedBox(height: 14),
                    _benchmarkRow(
                      'Water Conservation',
                      0.82,
                      'You: 82%',
                      'City Avg: 60%',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statPill({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _benchmarkRow(
    String title,
    double value,
    String youLabel,
    String avgLabel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$youLabel  vs  $avgLabel',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: const Color(0xFFF1F5F2),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryVibrant,
            ),
          ),
        ),
      ],
    );
  }
}
