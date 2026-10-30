import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../custom_painters/earth_globe_painter.dart';

class NavItemData {
  final String title;
  final IconData icon;

  const NavItemData({required this.title, required this.icon});
}

class EcoSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const EcoSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static const List<NavItemData> navItems = [
    NavItemData(title: 'Dashboard', icon: Icons.dashboard_rounded),
    NavItemData(title: 'My Habits', icon: Icons.checklist_rounded),
    NavItemData(title: 'Progress', icon: Icons.insights_rounded),
    NavItemData(title: 'Achievements', icon: Icons.military_tech_rounded),
    NavItemData(title: 'History', icon: Icons.history_rounded),
    NavItemData(title: 'Profile', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 275,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.sidebarBgTop, AppColors.sidebarBgBottom],
        ),
        border: Border(
          right: BorderSide(color: AppColors.sidebarBorder, width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Logo & Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF22C55E,
                          ).withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Eco Habit\nTracker',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Small Habits. Big Impact.',
                          style: TextStyle(
                            color: AppColors.mint.withValues(alpha: 0.85),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: AppColors.sidebarBorder, height: 1),
            const SizedBox(height: 16),

            // Navigation List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: navItems.length,
                separatorBuilder: (_, i) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final item = navItems[index];
                  final isSelected = selectedIndex == index;

                  return _NavTile(
                    title: item.title,
                    icon: item.icon,
                    isSelected: isSelected,
                    onTap: () => onItemSelected(index),
                  );
                },
              ),
            ),

            // Nature artwork & closing encouragement message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF19442C).withValues(alpha: 0.7),
                      const Color(0xFF0F2D1E).withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2E6547).withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 110,
                      height: 80,
                      child: CustomPaint(painter: EarthGlobePainter()),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'A cleaner planet starts with you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level 4 Eco Hero • 720 pts',
                      style: TextStyle(
                        color: AppColors.mint.withValues(alpha: 0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 48,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.sidebarSelected
                : (_isHovered
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: widget.isSelected
                ? Border.all(color: const Color(0xFF2E754E), width: 1)
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 21,
                color: widget.isSelected
                    ? AppColors.primaryVibrant
                    : (_isHovered
                          ? Colors.white
                          : AppColors.sidebarTextInactive),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: widget.isSelected
                        ? AppColors.sidebarTextActive
                        : (_isHovered
                              ? Colors.white
                              : AppColors.sidebarTextInactive),
                  ),
                ),
              ),
              if (widget.isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryVibrant,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
