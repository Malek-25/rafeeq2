import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Load authentication state
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.loadAuthState();
    
    // Wait a bit for splash screen
    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (!mounted) return;
    
    // Navigate based on authentication state
    if (appState.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      Navigator.pushReplacementNamed(context, '/language');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: const [
          Icon(Icons.school, size: 72),
          SizedBox(height: 12),
          Text('RAFEEQ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
