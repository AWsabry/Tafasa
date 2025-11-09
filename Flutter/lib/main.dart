import 'package:flutter/material.dart';
import 'package:food_gpt/core/services/locator/service_locator.dart';

import 'core/theme/app_theme.dart';
import 'features/welcome/presentation/view/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FancyMommyMealsApp());
  final ServiceLocator _serviceAlocator = ServiceLocator();
  await _serviceAlocator.init();
}

class FancyMommyMealsApp extends StatelessWidget {
  const FancyMommyMealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fancy Mommy Meals',
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
