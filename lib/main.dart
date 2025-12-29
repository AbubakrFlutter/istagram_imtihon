import 'package:flutter/material.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:provider/provider.dart';
import 'screens/instagram_login_screen.dart';
import 'screens/instagram_home_screen.dart';
import 'services/auth_service.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final credentials = await _authService.loadCredentials();
    setState(() {
      _isLoggedIn = credentials['username']?.isNotEmpty ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          theme: themeProvider.currentTheme,
          home: _isLoggedIn ? const InstagramHomeScreen() : const InstagramLoginScreen(),
        );
      },
    );
  }
}
