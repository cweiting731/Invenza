import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/pages/home_page.dart';
import 'package:invenza/pages/login_page.dart';
import 'package:invenza/pages/routes.dart';
import 'package:invenza/providers/auth_provider.dart';
import 'package:invenza/theme/theme.dart';

void main() {
  final colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF51B5FF));
  printColorScheme(colorScheme);
  runApp(
      ProviderScope(
        child: Invenza(),
      ),
  );
}

class Invenza extends ConsumerWidget {
  const Invenza({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Invenza',
      initialRoute: '/login',
      theme: customTheme,
      routes: routes,
    );
  }
}