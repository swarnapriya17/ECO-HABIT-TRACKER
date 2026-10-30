import 'package:flutter/material.dart';
import '../state/habit_state.dart';
import '../widgets/welcome_banner.dart';
import '../widgets/summary_cards/summary_cards_row.dart';
import '../widgets/habit/daily_habit_tracker_card.dart';
import '../widgets/achievements/achievements_card.dart';
import '../widgets/center_column/encouragement_card.dart';
import '../widgets/center_column/streak_progress_card.dart';
import '../widgets/right_column/weekly_progress_chart_card.dart';
import '../widgets/right_column/environmental_impact_card.dart';
import '../widgets/right_column/recent_activity_card.dart';
import '../widgets/right_column/eco_banner_card.dart';

class DashboardScreen extends StatelessWidget {
  final HabitState state;

  const DashboardScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isDesktop = screenWidth >= 1200;
        final isTablet = screenWidth >= 768 && screenWidth < 1200;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // C. Welcome Banner
              WelcomeBanner(state: state),
              const SizedBox(height: 24),

              // D. Five Summary Cards Row
              SummaryCardsRow(state: state),
              const SizedBox(height: 24),

              // E. Main Content Grid (3 Columns on Desktop, 2 or 1 on Tablet/Mobile)
              if (isDesktop)
                _buildThreeColumnDesktopGrid()
              else if (isTablet)
                _buildTabletGrid()
              else
                _buildMobileSingleColumnGrid(),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  // Desktop 3-Column Layout: Left (3.6 flex), Center (3.0 flex), Right (3.4 flex)
  Widget _buildThreeColumnDesktopGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT COLUMN (Daily Habit Tracker + Achievements)
        Expanded(
          flex: 36,
          child: Column(
            children: [
              DailyHabitTrackerCard(state: state),
              const SizedBox(height: 24),
              AchievementsCard(state: state),
            ],
          ),
        ),
        const SizedBox(width: 24),

        // CENTER COLUMN (Feature Encouragement Card + Streak Card)
        Expanded(
          flex: 30,
          child: Column(
            children: [
              EncouragementCard(state: state),
              const SizedBox(height: 24),
              StreakProgressCard(state: state),
            ],
          ),
        ),
        const SizedBox(width: 24),

        // RIGHT COLUMN (Weekly Progress + Impact + Recent Activity + Eco Banner)
        Expanded(
          flex: 34,
          child: Column(
            children: [
              WeeklyProgressChartCard(state: state),
              const SizedBox(height: 24),
              EnvironmentalImpactCard(state: state),
              const SizedBox(height: 24),
              RecentActivityCard(state: state),
              const SizedBox(height: 24),
              EcoBannerCard(state: state),
            ],
          ),
        ),
      ],
    );
  }

  // Tablet 2-Column Layout
  Widget _buildTabletGrid() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  DailyHabitTrackerCard(state: state),
                  const SizedBox(height: 20),
                  AchievementsCard(state: state),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  EncouragementCard(state: state),
                  const SizedBox(height: 20),
                  StreakProgressCard(state: state),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: WeeklyProgressChartCard(state: state)),
            const SizedBox(width: 20),
            Expanded(child: EnvironmentalImpactCard(state: state)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: RecentActivityCard(state: state)),
            const SizedBox(width: 20),
            Expanded(child: EcoBannerCard(state: state)),
          ],
        ),
      ],
    );
  }

  // Mobile Single-Column Stack
  Widget _buildMobileSingleColumnGrid() {
    return Column(
      children: [
        DailyHabitTrackerCard(state: state),
        const SizedBox(height: 18),
        EncouragementCard(state: state),
        const SizedBox(height: 18),
        StreakProgressCard(state: state),
        const SizedBox(height: 18),
        WeeklyProgressChartCard(state: state),
        const SizedBox(height: 18),
        EnvironmentalImpactCard(state: state),
        const SizedBox(height: 18),
        AchievementsCard(state: state),
        const SizedBox(height: 18),
        RecentActivityCard(state: state),
        const SizedBox(height: 18),
        EcoBannerCard(state: state),
      ],
    );
  }
}
