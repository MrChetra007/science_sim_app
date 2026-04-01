import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

// Since AdManager now automatically pulls from SubscriptionService,
// we don't need the sync logic anymore in main.dart.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: NewtonsLabApp(),
    ),
  );
}
