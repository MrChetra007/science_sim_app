import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'ui/home_screen.dart';

class NewtonsLabApp extends StatelessWidget {
  const NewtonsLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NewtonLab",
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
