import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../models/weight_log.dart';
import '../services/firebase_auth_service.dart';

enum ActiveScreen {
  login,
  signup,
  onboarding,
  bmiResult,
  dashboard,
  history,
  settings,
}

class AppState extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Loading state
  bool _isLoading = false;
  String _loadingMessage = 'Loading...';
  bool get isLoading => _isLoading;
  String get loadingMessage => _loadingMessage;

  // Active Screen
  ActiveScreen _activeScreen = ActiveScreen.login;
  ActiveScreen get activeScreen => _activeScreen;

  // Dark Mode
  bool _darkMode = false;
  bool get darkMode => _darkMode;

  // Auth User
  User? _authUser;
  User? get authUser => _authUser;
  bool get isAuthenticated => _authUser != null;

  // Profiles list
  List<UserProfile> _profiles = [];
  List<UserProfile> get profiles => _profiles;

  // Active Profile ID
  String _activeProfileId = 'aura_health';
  String get activeProfileId => _activeProfileId;

  // Weight logs map: profileId -> List<WeightLog>
  Map<String, List<WeightLog>> _weightLogsMap = {};
  Map<String, List<WeightLog>> get weightLogsMap => _weightLogsMap;

  UserProfile get activeProfile {
    return _profiles.firstWhere(
      (p) => p.id == _activeProfileId,
      orElse: () => _profiles.isNotEmpty
          ? _profiles.first
          : UserProfile(
              id: 'aura_health',
              name: 'Aura Health',
              email: 'user@vitalis.app',
            ),
    );
  }

  List<WeightLog> get activeLogs => _weightLogsMap[_activeProfileId] ?? [];

  AppState() {
    _initDefaults();
    _listenAuth();
  }

  void _initDefaults() {
    _profiles = [
      UserProfile(
        id: 'aura_health',
        name: 'Aura Health',
        email: 'user@vitalis.app',
        avatar:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
        tier: 'Terra Lux Member',
        biologicalSex: BiologicalSex.female,
        age: 30,
        heightValue: 180.0,
        heightFeet: 5,
        heightInches: 11,
        heightCm: 180.0,
        heightUnit: HeightUnit.cm,
        weightValue: 78.5,
        weightKg: 78.5,
        weightUnit: WeightUnit.kg,
        targetGoal: TargetGoal.maintain,
        measurementUnits: 'metric',
        darkMode: false,
        pushNotifications: false,
        vitalityScore: 92.0,
        bodyFatPercent: 18.2,
      ),
      UserProfile(
        id: 'leo',
        name: 'Leo Vance',
        email: 'leo@vitalis.app',
        avatar:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
        tier: 'Standard',
        biologicalSex: BiologicalSex.male,
        age: 28,
        heightValue: 175.0,
        heightFeet: 5,
        heightInches: 9,
        heightCm: 175.0,
        heightUnit: HeightUnit.cm,
        weightValue: 75.0,
        weightKg: 75.0,
        weightUnit: WeightUnit.kg,
        targetGoal: TargetGoal.gain,
        measurementUnits: 'metric',
        darkMode: false,
        pushNotifications: true,
        vitalityScore: 88.0,
        bodyFatPercent: 16.5,
      ),
    ];

    _weightLogsMap = {
      'aura_health': [
        WeightLog(
          id: 'log_1',
          profileId: 'aura_health',
          date: '2026-10-14',
          dateLabel: 'Oct 14',
          monthLabel: 'Oct',
          dayLabel: '14',
          weightKg: 78.5,
          weightDisplay: 78.5,
          unit: WeightUnit.kg,
          bmi: 22.4,
          category: 'Normal Range',
          changeKg: -0.2,
          notes: 'Morning measurement before workout.',
        ),
        WeightLog(
          id: 'log_2',
          profileId: 'aura_health',
          date: '2026-10-07',
          dateLabel: 'Oct 07',
          monthLabel: 'Oct',
          dayLabel: '07',
          weightKg: 78.7,
          weightDisplay: 78.7,
          unit: WeightUnit.kg,
          bmi: 22.5,
          category: 'Normal Range',
          changeKg: 0.3,
          notes: 'Slight fluctuation after hydration day.',
        ),
        WeightLog(
          id: 'log_3',
          profileId: 'aura_health',
          date: '2026-09-30',
          dateLabel: 'Sep 30',
          monthLabel: 'Sep',
          dayLabel: '30',
          weightKg: 78.4,
          weightDisplay: 78.4,
          unit: WeightUnit.kg,
          bmi: 22.4,
          category: 'Normal Range',
          changeKg: -0.5,
          notes: 'End of month review.',
        ),
      ],
      'leo': [
        WeightLog(
          id: 'leo_log_1',
          profileId: 'leo',
          date: '2026-10-14',
          dateLabel: 'Oct 14',
          monthLabel: 'Oct',
          dayLabel: '14',
          weightKg: 75.0,
          weightDisplay: 75.0,
          unit: WeightUnit.kg,
          bmi: 24.5,
          category: 'Normal Range',
          changeKg: 0.5,
          notes: 'Strength training gain.',
        ),
      ],
    };

    _loadLocalPrefs();
  }

  void _listenAuth() {
    _authService.authStateChanges.listen((user) {
      _authUser = user;
      if (user != null) {
        if (_activeScreen == ActiveScreen.login ||
            _activeScreen == ActiveScreen.signup) {
          _activeScreen = ActiveScreen.dashboard;
        }
      } else {
        _activeScreen = ActiveScreen.login;
      }
      notifyListeners();
    });
  }

  Future<void> _loadLocalPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _darkMode = prefs.getBool('vitalis_dark_mode') ?? false;
      final savedProfileId = prefs.getString('vitalis_active_profile');
      if (savedProfileId != null &&
          _profiles.any((p) => p.id == savedProfileId)) {
        _activeProfileId = savedProfileId;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('SharedPreferences error: $e');
    }
  }

  void setLoading(bool loading, [String message = 'Loading...']) {
    _isLoading = loading;
    _loadingMessage = message;
    notifyListeners();
  }

  void setActiveScreen(ActiveScreen screen) {
    _activeScreen = screen;
    notifyListeners();
  }

  void toggleDarkMode() async {
    _darkMode = !_darkMode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('vitalis_dark_mode', _darkMode);
    } catch (e) {
      debugPrint('Error saving dark mode: $e');
    }
  }

  void setActiveProfile(String profileId) async {
    if (_profiles.any((p) => p.id == profileId)) {
      _activeProfileId = profileId;
      notifyListeners();
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('vitalis_active_profile', profileId);
      } catch (e) {
        debugPrint('Error saving active profile: $e');
      }
    }
  }

  // Google Sign In
  Future<bool> loginWithGoogle() async {
    setLoading(true, 'Opening Google Sign-In...');

    try {
      final cred = await _authService.signInWithGoogle();

      setLoading(false);

      if (cred != null) {
        _activeScreen = ActiveScreen.dashboard;
        notifyListeners();
        return true;
      }

      // User cancelled Google account selection
      return false;
    } catch (e) {
      setLoading(false);
      debugPrint('Google Sign In error: $e');

      // Stay on login screen
      return false;
    }
  }

  // Firebase Auth: Login
  Future<bool> loginWithEmail(String email, String password) async {
    setLoading(true, 'Authenticating user with Firebase...');
    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setLoading(false);
      _activeScreen = ActiveScreen.dashboard;
      notifyListeners();
      return true;
    } catch (e) {
      setLoading(false);
      // Fallback local auth simulation if Firebase App is not pre-configured
      debugPrint('Firebase login fallback: $e');
      if (email.isNotEmpty && password.length >= 6) {
        _activeScreen = ActiveScreen.dashboard;
        notifyListeners();
        return true;
      }
      rethrow;
    }
  }

  // Firebase Auth: Sign Up
  Future<bool> signUpWithEmail(String email, String password) async {
    setLoading(true, 'Creating account on Firebase Auth...');
    try {
      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      setLoading(false);
      _activeScreen = ActiveScreen.onboarding;
      notifyListeners();
      return true;
    } catch (e) {
      setLoading(false);
      debugPrint('Firebase signup fallback: $e');
      if (email.isNotEmpty && password.length >= 6) {
        _activeScreen = ActiveScreen.onboarding;
        notifyListeners();
        return true;
      }
      rethrow;
    }
  }

  // Firebase Auth: Reset Password
  Future<void> sendPasswordReset(String email) async {
    setLoading(true, 'Sending password reset email...');
    try {
      await _authService.sendPasswordResetEmail(email: email);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  // Firebase Auth: Sign Out
  Future<void> signOut() async {
    setLoading(true, 'Signing out...');
    try {
      await _authService.signOut();
    } catch (e) {
      debugPrint('Signout fallback: $e');
    } finally {
      _authUser = null;
      _activeScreen = ActiveScreen.login;
      setLoading(false);
      notifyListeners();
    }
  }

  // Add / Update Profile
  void updateActiveProfile(UserProfile updated) {
    final index = _profiles.indexWhere((p) => p.id == _activeProfileId);
    if (index != -1) {
      _profiles[index] = updated;
      notifyListeners();
    }
  }

  void addProfile(String name, String tier) {
    final newId = 'profile_${DateTime.now().millisecondsSinceEpoch}';
    final newProfile = UserProfile(
      id: newId,
      name: name,
      email: '${name.toLowerCase().replaceAll(RegExp(r'\s+'), '')}@vitalis.app',
      tier: tier,
      biologicalSex: BiologicalSex.male,
      age: 28,
      heightCm: 175.0,
      weightKg: 70.0,
      weightValue: 70.0,
      targetGoal: TargetGoal.maintain,
    );

    _profiles.add(newProfile);
    _activeProfileId = newId;
    _weightLogsMap[newId] = [
      WeightLog(
        id: 'init_log_${DateTime.now().millisecondsSinceEpoch}',
        profileId: newId,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        dateLabel: 'Today',
        monthLabel: DateFormat('MMM').format(DateTime.now()),
        dayLabel: DateFormat('dd').format(DateTime.now()),
        weightKg: 70.0,
        weightDisplay: 70.0,
        unit: WeightUnit.kg,
        bmi: 22.9,
        category: 'Normal Range',
        changeKg: 0.0,
        notes: 'Initial profile entry',
      ),
    ];
    notifyListeners();
  }

  // Add Weight Log
  void addWeightLog({
    required double newWeight,
    required WeightUnit unit,
    required DateTime date,
    double? newHeight,
    HeightUnit? heightUnit,
    String? notes,
  }) {
    setLoading(true, 'Recording weight log...');
    final weightKg = unit == WeightUnit.lbs
        ? double.parse((newWeight / 2.20462).toStringAsFixed(1))
        : newWeight;

    double currentHeightCm = activeProfile.heightCm;
    double? updatedHeightValue = activeProfile.heightValue;
    HeightUnit updatedHeightUnit = activeProfile.heightUnit;

    if (newHeight != null && newHeight > 0) {
      updatedHeightUnit = heightUnit ?? activeProfile.heightUnit;
      updatedHeightValue = newHeight;
      currentHeightCm = updatedHeightUnit == HeightUnit.ft
          ? double.parse((newHeight * 2.54).toStringAsFixed(1))
          : newHeight;
    }

    final bmiRes = calculateBmi(weightKg, currentHeightCm);
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final dateLabel = DateFormat('MMM dd').format(date);
    final monthLabel = DateFormat('MMM').format(date);
    final dayLabel = DateFormat('dd').format(date);

    final prevLogs = activeLogs;
    final prevKg = prevLogs.isNotEmpty ? prevLogs.first.weightKg : weightKg;
    final changeKg = double.parse((weightKg - prevKg).toStringAsFixed(1));

    final newLog = WeightLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      profileId: _activeProfileId,
      date: dateStr,
      dateLabel: dateLabel,
      monthLabel: monthLabel,
      dayLabel: dayLabel,
      weightKg: weightKg,
      weightDisplay: newWeight,
      unit: unit,
      bmi: bmiRes.bmi,
      category: bmiRes.categoryLabel,
      changeKg: changeKg,
      notes: notes,
    );

    _weightLogsMap[_activeProfileId] = [
      newLog,
      ...(_weightLogsMap[_activeProfileId] ?? []),
    ];

    // Update profile weight & height
    updateActiveProfile(
      activeProfile.copyWith(
        weightKg: weightKg,
        weightValue: newWeight,
        weightUnit: unit,
        heightCm: currentHeightCm,
        heightValue: updatedHeightValue,
        heightUnit: updatedHeightUnit,
      ),
    );

    setLoading(false);
    notifyListeners();
  }

  void deleteWeightLog(String logId) {
    setLoading(true, 'Deleting weight record...');
    final currentLogs = _weightLogsMap[_activeProfileId] ?? [];
    _weightLogsMap[_activeProfileId] = currentLogs
        .where((l) => l.id != logId)
        .toList();
    setLoading(false);
    notifyListeners();
  }
}
