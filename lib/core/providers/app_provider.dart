import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { student, provider }

class CardItem {
  final String id;
  final String holder;
  final String last4;
  final String brand;
  CardItem({required this.id, required this.holder, required this.last4, required this.brand});
}

class AppState extends ChangeNotifier {
  bool _isAuthenticated = false;
  UserRole _role = UserRole.student;
  String? _userEmail;
  String? _userName;
  double wallet = 25.0;
  String? profilePhotoPath;
  final List<CardItem> _cards = [];

  bool get isAuthenticated => _isAuthenticated;
  UserRole get role => _role;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  List<CardItem> get cards => List.unmodifiable(_cards);

  // Load authentication state from SharedPreferences
  Future<void> loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
      final roleString = prefs.getString('userRole');
      if (roleString != null) {
        _role = roleString == 'provider' ? UserRole.provider : UserRole.student;
      }
      _userEmail = prefs.getString('userEmail');
      _userName = prefs.getString('userName');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading auth state: $e');
    }
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    // Simple validation - in production, this would check against Firebase/backend
    if (email.isNotEmpty && password.length >= 6) {
      try {
        final prefs = await SharedPreferences.getInstance();
        _isAuthenticated = true;
        _userEmail = email;
        _userName = prefs.getString('userName_$email') ?? email.split('@')[0];
        
        // Load role from storage
        final roleString = prefs.getString('userRole_$email');
        if (roleString != null) {
          _role = roleString == 'provider' ? UserRole.provider : UserRole.student;
        }
        
        // Save auth state
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userName', _userName!);
        if (roleString != null) {
          await prefs.setString('userRole', roleString);
        }
        
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint('Error signing in: $e');
        return false;
      }
    }
    return false;
  }

  // Sign up with email, password, and role
  Future<bool> signUp(String email, String password, String name, UserRole role) async {
    if (email.isNotEmpty && password.length >= 8 && name.isNotEmpty) {
      try {
        final prefs = await SharedPreferences.getInstance();
        _isAuthenticated = true;
        _userEmail = email;
        _userName = name;
        _role = role;
        
        // Save user data
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userName', name);
        await prefs.setString('userName_$email', name);
        await prefs.setString('userRole', role == UserRole.provider ? 'provider' : 'student');
        await prefs.setString('userRole_$email', role == UserRole.provider ? 'provider' : 'student');
        
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint('Error signing up: $e');
        return false;
      }
    }
    return false;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', false);
      await prefs.remove('userEmail');
      await prefs.remove('userName');
      await prefs.remove('userRole');
      
      _isAuthenticated = false;
      _userEmail = null;
      _userName = null;
      _role = UserRole.student;
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  void setRole(UserRole r){ 
    _role = r; 
    notifyListeners();
    // Save to storage
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('userRole', r == UserRole.provider ? 'provider' : 'student');
      if (_userEmail != null) {
        prefs.setString('userRole_$_userEmail', r == UserRole.provider ? 'provider' : 'student');
      }
    });
  }
  
  void setProfilePhoto(String path){ profilePhotoPath = path; notifyListeners(); }
  void topUp(double v){ wallet += v; notifyListeners(); }
  bool deduct(double v){ if(wallet >= v){ wallet -= v; notifyListeners(); return true; } return false; }
  void addCard(CardItem c){ _cards.add(c); notifyListeners(); }
}
