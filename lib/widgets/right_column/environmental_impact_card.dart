import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../state/habit_state.dart';

class EnvironmentalImpactCard extends StatelessWidget {
  final HabitState state;

  const EnvironmentalImpactCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
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
          // Header with Eco Score Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Environmental Impact',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Lifetime sustainability milestones',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${state.ecoScore}/100',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 16),

          // 1. Carbon (CO2) Metric
          _buildImpactMetric(
            title: 'Carbon Emissions Offset',
            value: '${state.totalCo2Saved.toStringAsFixed(1)} kg CO₂',
            target: 'Target: 15.0 kg',
            percent: (state.totalCo2Saved / 15.0).clamp(0.0, 1.0),
            icon: Icons.cloud_done_rounded,
            color: AppColors.co2,
            bgColor: AppColors.co2Light,
          ),

          const SizedBox(height: 14),

          // 2. Water Metric
          _buildImpactMetric(
            title: 'Freshwater Conserved',
            value: '${state.totalWaterSaved.toStringAsFixed(0)} Liters',
            target: 'Target: 200 L',
            percent: (state.totalWaterSaved / 200.0).clamp(0.0, 1.0),
            icon: Icons.water_drop_rounded,
            color: AppColors.water,
            bgColor: AppColors.waterLight,
          ),

          const SizedBox(height: 14),

          // 3. Plastic Metric
          _buildImpactMetric(
            title: 'Single-Use Plastics Avoided',
            value: '${state.totalPlasticReduced.toStringAsFixed(0)} Items',
            target: 'Target: 25 items',
            percent: (state.totalPlasticReduced / 25.0).clamp(0.0, 1.0),
            icon: Icons.recycling_rounded,
            color: AppColors.plastic,
            bgColor: AppColors.plasticLight,
          ),
        ],
      ),
    );
  }

  Widget _buildImpactMetric({
    required String title,
    required String value,
    required String target,
    required double percent,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    target,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 6,
            backgroundColor: const Color(0xFFF1F5F2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
