import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/app_header.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/loader_overlay.dart';
import 'widgets/profile_switcher_dialog.dart';
import 'views/login_view.dart';
import 'views/signup_view.dart';
import 'views/onboarding_view.dart';
import 'views/dashboard_view.dart';
import 'views/bmi_result_view.dart';
import 'views/weight_history_view.dart';
import 'views/profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase Core initialization notice: $e');
  }
  runApp(const VitalisApp());
}

class VitalisApp extends StatelessWidget {
  const VitalisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Vitalis Health & Weight Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appState.darkMode ? ThemeMode.dark : ThemeMode.light,
            home: const VitalisMainScreen(),
          );
        },
      ),
    );
  }
}

class VitalisMainScreen extends StatelessWidget {
  const VitalisMainScreen({super.key});

  void _openProfileSwitcher(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const ProfileSwitcherDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    Widget currentBody;
    switch (appState.activeScreen) {
      case ActiveScreen.login:
        currentBody = const LoginView();
        break;
      case ActiveScreen.signup:
        currentBody = const SignUpView();
        break;
      case ActiveScreen.onboarding:
        currentBody = const OnboardingView();
        break;
      case ActiveScreen.dashboard:
        currentBody = const DashboardView();
        break;
      case ActiveScreen.bmiResult:
        currentBody = const BmiResultView();
        break;
      case ActiveScreen.history:
        currentBody = const WeightHistoryView();
        break;
      case ActiveScreen.settings:
        currentBody = const ProfileView();
        break;
    }

    return LoaderOverlay(
      isLoading: appState.isLoading,
      message: appState.loadingMessage,
      child: Scaffold(
        appBar: AppHeader(
          onOpenProfileSwitcher: () => _openProfileSwitcher(context),
        ),
        body: currentBody,
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
