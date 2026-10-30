import 'package:flutter/material.dart';
import 'state/habit_state.dart';
import 'theme/app_theme.dart';
import 'screens/auth_gate.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const EcoHabitTrackerApp());
}

class EcoHabitTrackerApp extends StatefulWidget {
  final bool bypassAuthForTesting;

  const EcoHabitTrackerApp({super.key, this.bypassAuthForTesting = false});

  @override
  State<EcoHabitTrackerApp> createState() => _EcoHabitTrackerAppState();
}

class _EcoHabitTrackerAppState extends State<EcoHabitTrackerApp> {
  late final HabitState _habitState;

  @override
  void initState() {
    super.initState();
    _habitState = HabitState();
  }

  @override
  void dispose() {
    _habitState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Habit Tracker - Small Habits. Big Impact.',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AuthGate(
        state: _habitState,
        initialBypass: widget.bypassAuthForTesting,
      ),
    );
  }
}
