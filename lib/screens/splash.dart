import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';
import '../core/providers/locale_provider.dart';
import '../core/theme/theme_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _controller.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Load language preference (defaults to English)
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    await localeProvider.loadLocale();
    
    // Load authentication state
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.loadAuthState();
    
    // Wait a bit for splash screen animation
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (!mounted) return;
    
    // Navigate based on authentication state (skip language selector)
    if (appState.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      Navigator.pushReplacementNamed(context, '/auth/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeProvider.asuNavy,
              ThemeProvider.asuNavy.withOpacity(0.9),
              ThemeProvider.asuNavy.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // RAFEEQ Logo Image
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // Return empty container if logo not found
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Tagline
                        Text(
                          'Your Student Life Companion',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Loading indicator
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ThemeProvider.asuGold,
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
