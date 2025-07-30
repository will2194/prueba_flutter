import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_flutter/core/shared_prefs.dart';
import 'package:prueba_flutter/features/home/ui/views/home_view.dart';
import 'package:prueba_flutter/features/login/ui/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    token = await SharedPrefs.getToken();
    setState(() {
      isLoggedIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const HomeView() : const LoginView(),
    );
  }
}
