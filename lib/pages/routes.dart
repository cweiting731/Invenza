import 'package:flutter/cupertino.dart';
import 'package:invenza/pages/home_page.dart';
import 'package:invenza/pages/login_page.dart';

final Map<String, WidgetBuilder> routes = {
  '/' : (context) => const LoginPage(),
  '/home' : (context) => const HomePage(),
};