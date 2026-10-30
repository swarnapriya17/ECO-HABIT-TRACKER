import 'package:flutter/material.dart';
import '../../models/habit.dart';
import '../../theme/app_colors.dart';

class HabitItemTile extends StatefulWidget {
  final Habit habit;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onInfoTap;

  const HabitItemTile({
    super.key,
    required this.habit,
    required this.onToggle,
    this.onInfoTap,
  });

  @override
  State<HabitItemTile> createState() => _HabitItemTileState();
}

class _HabitItemTileState extends State<HabitItemTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final isDone = habit.isCompleted;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDone
              ? const Color(0xFFF6FAF7)
              : (_isHovered ? const Color(0xFFFAFCFA) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDone
                ? const Color(0xFFDCEDE0)
                : (_isHovered ? const Color(0xFFD4E6D7) : AppColors.border),
          ),
        ),
        child: Row(
          children: [
            // Checkbox Button with smooth green checkmark animation
            InkWell(
              onTap: () => widget.onToggle(!isDone),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isDone ? AppColors.primaryVibrant : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDone ? AppColors.primaryVibrant : AppColors.sage,
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 14),

            // Category Icon Badge
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: habit.category.bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                habit.category.icon,
                color: habit.category.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Title & Description & Impact pill
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          habit.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDone
                                ? AppColors.textMuted
                                : AppColors.textPrimary,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: AppColors.textMuted,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: habit.category.bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          habit.category.displayName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: habit.category.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    habit.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.eco_rounded,
                        size: 12,
                        color: AppColors.primaryVibrant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          habit.impactText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '🔥 ${habit.streakDays}d',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.streak,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Trailing action / status
            IconButton(
              icon: Icon(
                isDone ? Icons.check_circle_rounded : Icons.more_horiz_rounded,
                color: isDone ? AppColors.primaryVibrant : AppColors.textMuted,
                size: 20,
              ),
              onPressed: widget.onInfoTap,
              tooltip: isDone ? 'Completed' : 'Habit Options',
            ),
          ],
        ),
      ),
    );
  }
}
