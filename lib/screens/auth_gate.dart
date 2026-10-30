import 'package:flutter/material.dart';
import '../state/habit_state.dart';
import '../services/firebase_service.dart';
import 'main_layout.dart';
import 'auth/auth_screen.dart';

class AuthGate extends StatefulWidget {
  final HabitState state;
  final bool initialBypass;

  const AuthGate({super.key, required this.state, this.initialBypass = false});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late bool _demoBypass;

  @override
  void initState() {
    super.initState();
    // Default to bypass only if Firebase is not yet configured or explicitly bypassed for testing
    _demoBypass = widget.initialBypass || !FirebaseService.isConfigured;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final state = widget.state;

        // If user is authenticated in Firebase
        if (state.isAuthenticated) {
          return MainLayout(state: state);
        }

        // If bypassed for demo / widget testing when Firebase is unconfigured
        if (_demoBypass) {
          return MainLayout(state: state);
        }

        // Otherwise show authentication screen
        return AuthScreen(
          state: state,
          onBypass: () => setState(() => _demoBypass = true),
        );
      },
    );
  }
}
