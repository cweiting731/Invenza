import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invenza/pages/routes.dart';
import 'package:invenza/theme/theme.dart';

void main() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Invenza',
      initialRoute: '/login',
      theme: customTheme,
      routes: routes,
    );
  }
}