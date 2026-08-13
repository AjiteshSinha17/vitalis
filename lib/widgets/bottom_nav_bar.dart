import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Do not show navigation bar on Auth or Onboarding screens
    if (appState.activeScreen == ActiveScreen.login ||
        appState.activeScreen == ActiveScreen.signup ||
        appState.activeScreen == ActiveScreen.onboarding) {
      return const SizedBox.shrink();
    }

    int currentIndex = 0;
    switch (appState.activeScreen) {
      case ActiveScreen.dashboard:
        currentIndex = 0;
        break;
      case ActiveScreen.history:
        currentIndex = 1;
        break;
      case ActiveScreen.bmiResult:
        currentIndex = 2;
        break;
      case ActiveScreen.settings:
        currentIndex = 3;
        break;
      default:
        currentIndex = 0;
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark ? AppTheme.borderDark : const Color(0xFFE5ECD9),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: Icons.dashboard_rounded,
                label: 'Overview',
                isSelected: currentIndex == 0,
                onTap: () => appState.setActiveScreen(ActiveScreen.dashboard),
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: Icons.history_toggle_off_rounded,
                label: 'History',
                isSelected: currentIndex == 1,
                onTap: () => appState.setActiveScreen(ActiveScreen.history),
              ),
              _buildNavItem(
                context,
                index: 2,
                icon: Icons.monitor_weight_outlined,
                label: 'BMI Breakdown',
                isSelected: currentIndex == 2,
                onTap: () => appState.setActiveScreen(ActiveScreen.bmiResult),
              ),
              _buildNavItem(
                context,
                index: 3,
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isSelected: currentIndex == 3,
                onTap: () => appState.setActiveScreen(ActiveScreen.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppTheme.secondaryOlive : AppTheme.primaryOlive;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF2B361B) : AppTheme.lightOliveContainer)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? activeColor
                  : (isDark ? Colors.white54 : AppTheme.textMuted),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: activeColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
