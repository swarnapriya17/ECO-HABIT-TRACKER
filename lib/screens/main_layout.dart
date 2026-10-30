import 'package:flutter/material.dart';
import '../state/habit_state.dart';
import '../theme/app_colors.dart';
import '../widgets/navigation/sidebar.dart';
import '../widgets/navigation/top_header.dart';
import '../widgets/navigation/bottom_nav_bar.dart';
import 'dashboard_screen.dart';
import 'habits_screen.dart';
import 'progress_screen.dart';
import 'achievements_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  final HabitState state;

  const MainLayout({super.key, required this.state});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final state = widget.state;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            final screens = [
              DashboardScreen(state: state),
              HabitsScreen(state: state),
              ProgressScreen(state: state),
              AchievementsScreen(state: state),
              HistoryScreen(state: state),
              ProfileScreen(state: state),
            ];

            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppColors.background,
              drawer: isMobile
                  ? Drawer(
                      child: EcoSidebar(
                        selectedIndex: state.currentNavIndex,
                        onItemSelected: (idx) {
                          state.setNavIndex(idx);
                          Navigator.pop(context); // Close drawer
                        },
                      ),
                    )
                  : null,
              bottomNavigationBar: isMobile
                  ? EcoBottomNavBar(
                      selectedIndex: state.currentNavIndex.clamp(0, 4),
                      onItemSelected: (idx) => state.setNavIndex(idx),
                    )
                  : null,
              body: Row(
                children: [
                  // Desktop / Tablet Sidebar
                  if (!isMobile)
                    EcoSidebar(
                      selectedIndex: state.currentNavIndex,
                      onItemSelected: (idx) => state.setNavIndex(idx),
                    ),

                  // Main Content Area (Header + Active Screen)
                  Expanded(
                    child: Column(
                      children: [
                        EcoTopHeader(
                          state: state,
                          isMobile: isMobile,
                          onMenuPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: state.currentNavIndex,
                            children: screens,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
