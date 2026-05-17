import 'package:flutter/material.dart';
import 'lessons/screens/home_screen.dart';

class InductionApp extends StatelessWidget {
  const InductionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electromagnetic Induction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD2691E),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
