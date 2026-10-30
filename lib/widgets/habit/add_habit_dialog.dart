import 'package:flutter/material.dart';
import '../../models/habit.dart';
import '../../theme/app_colors.dart';

class AddHabitDialog extends StatefulWidget {
  final ValueChanged<Habit> onAdd;
  final Habit? initialHabit;

  const AddHabitDialog({super.key, required this.onAdd, this.initialHabit});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _impactController = TextEditingController();
  HabitCategory _selectedCategory = HabitCategory.water;
  int _points = 15;

  @override
  void initState() {
    super.initState();
    if (widget.initialHabit != null) {
      final h = widget.initialHabit!;
      _titleController.text = h.title;
      _descController.text = h.description;
      _impactController.text = h.impactText;
      _selectedCategory = h.category;
      _points = h.points;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _impactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.initialHabit != null
                            ? 'Edit Eco Habit'
                            : 'Create Eco Habit',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category Selector
                  const Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var cat in HabitCategory.values)
                        ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                cat.icon,
                                size: 14,
                                color: _selectedCategory == cat
                                    ? Colors.white
                                    : cat.color,
                              ),
                              const SizedBox(width: 6),
                              Text(cat.displayName),
                            ],
                          ),
                          selected: _selectedCategory == cat,
                          selectedColor: cat.color,
                          backgroundColor: cat.bgColor,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _selectedCategory == cat
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = cat);
                            }
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Habit Title
                  const Text(
                    'Habit Title',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Bring My Own Coffee Mug',
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please enter a title'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  // Description
                  const Text(
                    'Description / Action',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      hintText:
                          'e.g. Refilled coffee in ceramic tumbler at cafe',
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Please enter a short description'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  // Impact description
                  const Text(
                    'Environmental Impact Note',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _impactController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. 1 paper cup avoided • 15 pts',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Points slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Points Earned',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '+$_points pts',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _points.toDouble(),
                    min: 5,
                    max: 50,
                    divisions: 9,
                    activeColor: AppColors.primaryVibrant,
                    onChanged: (val) => setState(() => _points = val.round()),
                  ),

                  const SizedBox(height: 20),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.initialHabit != null
                            ? 'Save Changes'
                            : 'Add Habit',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final Habit habit;
      if (widget.initialHabit != null) {
        habit = widget.initialHabit!.copyWith(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          category: _selectedCategory,
          impactText: _impactController.text.trim().isNotEmpty
              ? _impactController.text.trim()
              : 'Eco action logged • $_points pts',
          points: _points,
          waterImpactL: _selectedCategory == HabitCategory.water
              ? 20.0
              : widget.initialHabit!.waterImpactL,
          plasticImpactItems: _selectedCategory == HabitCategory.plastic
              ? 2.0
              : widget.initialHabit!.plasticImpactItems,
        );
      } else {
        habit = Habit(
          id: 'h_${DateTime.now().millisecondsSinceEpoch}',
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          category: _selectedCategory,
          impactText: _impactController.text.trim().isNotEmpty
              ? _impactController.text.trim()
              : 'Eco action logged • $_points pts',
          points: _points,
          co2ImpactKg: 0.6,
          waterImpactL: _selectedCategory == HabitCategory.water ? 20.0 : 0.0,
          plasticImpactItems: _selectedCategory == HabitCategory.plastic
              ? 2.0
              : 0.0,
          isCompleted: false,
          streakDays: 1,
        );
      }

      widget.onAdd(habit);
      Navigator.pop(context);
    }
  }
}
