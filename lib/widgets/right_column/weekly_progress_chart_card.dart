import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../state/habit_state.dart';

class WeeklyProgressChartCard extends StatefulWidget {
  final HabitState? state;

  const WeeklyProgressChartCard({super.key, this.state});

  @override
  State<WeeklyProgressChartCard> createState() =>
      _WeeklyProgressChartCardState();
}

class _WeeklyProgressChartCardState extends State<WeeklyProgressChartCard> {
  int? _hoveredIndex;

  static const List<Map<String, dynamic>> _fallbackWeekData = [
    {'day': 'Mon', 'percent': 0.85, 'done': 6, 'total': 7},
    {'day': 'Tue', 'percent': 0.72, 'done': 5, 'total': 7},
    {'day': 'Wed', 'percent': 0.90, 'done': 7, 'total': 7},
    {'day': 'Thu', 'percent': 0.80, 'done': 6, 'total': 7},
    {'day': 'Fri', 'percent': 0.75, 'done': 5, 'total': 7},
    {'day': 'Sat', 'percent': 0.65, 'done': 4, 'total': 7},
    {'day': 'Sun', 'percent': 0.88, 'done': 6, 'total': 7, 'isToday': true},
  ];

  List<Map<String, dynamic>> get _weekData {
    if (widget.state != null) {
      return widget.state!.weeklyProgressData;
    }
    return _fallbackWeekData;
  }

  int get _averagePercent {
    final data = _weekData;
    if (data.isEmpty) return 81;
    double sum = 0;
    for (var d in data) {
      sum += (d['percent'] as num).toDouble();
    }
    return ((sum / data.length) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final weekData = _weekData;

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Progress',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$_averagePercent% Average completion this week',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
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
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mintLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 14,
                      color: AppColors.primaryDark,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+12%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Bar Chart with Target Guide Line
          SizedBox(
            height: 140,
            child: Stack(
              children: [
                // 80% Target line across chart
                Positioned(
                  top: 140 * (1.0 - 0.80),
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color(0xFFD1D5DB).withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '80% Goal',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bars
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < weekData.length; i++)
                      _buildBar(i, weekData[i]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(int index, Map<String, dynamic> data) {
    final double percent = (data['percent'] as num).toDouble();
    final String day = data['day'] as String;
    final bool isToday = (data['isToday'] as bool?) ?? false;
    final bool isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      cursor: SystemMouseCursors.click,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Percentage tooltip on hover or today
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: isHovered || isToday ? 1.0 : 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: isToday ? AppColors.primaryDark : AppColors.textPrimary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${(percent * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Main vertical bar
          Container(
            width: 28,
            height: (percent * 90).clamp(6.0, 90.0),
            decoration: BoxDecoration(
              gradient: isToday
                  ? const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xFF059669), Color(0xFF34D399)],
                    )
                  : LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: isHovered
                          ? [const Color(0xFF10B981), const Color(0xFF6EE7B7)]
                          : [AppColors.mint, const Color(0xFFA7F3D0)],
                    ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: isToday
                  ? [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 8),

          // Day Label below bar
          Text(
            day,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
              color: isToday ? AppColors.primaryDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
