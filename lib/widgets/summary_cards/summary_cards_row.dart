import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../state/habit_state.dart';
import 'summary_stat_card.dart';

class SummaryCardsRow extends StatelessWidget {
  final HabitState state;

  const SummaryCardsRow({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          // 1. Today's Progress
          SummaryStatCard(
            title: "Today's Progress",
            value: "${state.todayProgressPercent}%",
            subtitle:
                "${state.completedCount} of ${state.totalCount} completed",
            icon: Icons.pie_chart_rounded,
            iconColor: AppColors.primaryVibrant,
            iconBgColor: AppColors.mintLight,
            circularProgress: state.todayProgress,
          ),

          // 2. Current Streak
          SummaryStatCard(
            title: "Current Streak",
            value: "${state.currentStreak} Days",
            subtitle: "Personal record: 21 days",
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.streak,
            iconBgColor: AppColors.streakLight,
            trailingBadge: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.streakLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '🔥 Active',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.streak,
                ),
              ),
            ),
          ),

          // 3. CO₂ Saved
          SummaryStatCard(
            title: "CO₂ Saved",
            value: "${state.totalCo2Saved.toStringAsFixed(1)} kg",
            subtitle: "Equal to 3 seedling trees",
            icon: Icons.cloud_done_rounded,
            iconColor: AppColors.co2,
            iconBgColor: AppColors.co2Light,
            deltaText: "+1.4 kg",
          ),

          // 4. Water Saved
          SummaryStatCard(
            title: "Water Saved",
            value: "${state.totalWaterSaved.toStringAsFixed(0)} L",
            subtitle: "Saved 4 average showers",
            icon: Icons.water_drop_rounded,
            iconColor: AppColors.water,
            iconBgColor: AppColors.waterLight,
            deltaText: "+25 L",
          ),

          // 5. Plastic Reduced
          SummaryStatCard(
            title: "Plastic Reduced",
            value: "${state.totalPlasticReduced.toStringAsFixed(0)} items",
            subtitle: "18 packaging items spared",
            icon: Icons.recycling_rounded,
            iconColor: AppColors.plastic,
            iconBgColor: AppColors.plasticLight,
            deltaText: "+3 items",
          ),
        ];

        // Wide desktop (>= 1180px): all 5 cards in 1 row
        if (constraints.maxWidth >= 1180) {
          return Row(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(width: 14),
                Expanded(child: cards[i]),
              ],
            ],
          );
        }

        // Medium desktop / tablet (720px - 1179px): 2 or 3 columns grid
        if (constraints.maxWidth >= 720) {
          return Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (var card in cards)
                SizedBox(width: (constraints.maxWidth - 28) / 3, child: card),
            ],
          );
        }

        // Mobile (< 720px): 2 columns or full width
        if (constraints.maxWidth >= 440) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var card in cards)
                SizedBox(width: (constraints.maxWidth - 12) / 2, child: card),
            ],
          );
        }

        // Very narrow mobile: 1 column
        return Column(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              cards[i],
            ],
          ],
        );
      },
    );
  }
}
