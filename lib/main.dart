import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MudiwaHoodApp());
}

class MudiwaHoodApp extends StatefulWidget {
  const MudiwaHoodApp({super.key});

  @override
  State<MudiwaHoodApp> createState() => _MudiwaHoodAppState();
}

class _MudiwaHoodAppState extends State<MudiwaHoodApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _appState,
      child: MaterialApp(
        title: 'Mudiwa Hood',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}
