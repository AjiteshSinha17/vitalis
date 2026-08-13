import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final profile = appState.activeProfile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Page Title
                Text(
                  'Profile & App Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage account preferences, biometrics, and target goals.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 24),

                // User Identity Card
                _buildUserIdentityCard(context, profile, isDark),
                const SizedBox(height: 24),

                // Target Goal Card
                _buildTargetGoalCard(context, profile, appState, isDark),
                const SizedBox(height: 24),

                // Biometrics Detail Card
                _buildBiometricsCard(context, profile, appState, isDark),
                const SizedBox(height: 24),

                // Preferences Card
                _buildPreferencesCard(context, profile, appState, isDark),
                const SizedBox(height: 32),

                // Firebase Auth Sign Out Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => appState.signOut(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE02424),
                      side: const BorderSide(color: Color(0xFFF8B4B4), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserIdentityCard(BuildContext context, UserProfile profile, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8D8),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: AppTheme.primaryOlive,
                backgroundImage:
                    profile.avatar.isNotEmpty ? NetworkImage(profile.avatar) : null,
                child: profile.avatar.isEmpty
                    ? Text(
                        profile.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryOlive,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.lightOliveContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    profile.tier.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOlive,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetGoalCard(
      BuildContext context, UserProfile profile, AppState appState, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8D8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_rounded, color: AppTheme.primaryOlive),
              const SizedBox(width: 10),
              Text(
                'Target Weight Goal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _goalPill(
                context,
                appState,
                profile,
                TargetGoal.lose,
                'Weight Loss',
                isDark,
              ),
              const SizedBox(width: 10),
              _goalPill(
                context,
                appState,
                profile,
                TargetGoal.maintain,
                'Maintain Weight',
                isDark,
              ),
              const SizedBox(width: 10),
              _goalPill(
                context,
                appState,
                profile,
                TargetGoal.gain,
                'Gain Muscle',
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _goalPill(
    BuildContext context,
    AppState appState,
    UserProfile profile,
    TargetGoal goal,
    String label,
    bool isDark,
  ) {
    final isSelected = profile.targetGoal == goal;
    return Expanded(
      child: InkWell(
        onTap: () {
          appState.updateActiveProfile(profile.copyWith(targetGoal: goal));
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryOlive
                : (isDark ? AppTheme.borderDark : const Color(0xFFF2F6ED)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppTheme.primaryOlive : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : AppTheme.textDark),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricsCard(
      BuildContext context, UserProfile profile, AppState appState, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8D8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.fitness_center_rounded, color: AppTheme.primaryOlive),
                  const SizedBox(width: 10),
                  Text(
                    'Biometrics & User Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => appState.setActiveScreen(ActiveScreen.onboarding),
                child: const Text(
                  'Edit Details',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryOlive,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _metricTile(
                  'Sex',
                  profile.biologicalSex.name.toUpperCase(),
                  isDark,
                ),
              ),
              Expanded(
                child: _metricTile(
                  'Age',
                  '${profile.age} yrs',
                  isDark,
                ),
              ),
              Expanded(
                child: _metricTile(
                  'Height',
                  '${profile.heightCm.toInt()} cm',
                  isDark,
                ),
              ),
              Expanded(
                child: _metricTile(
                  'Weight',
                  '${profile.weightKg} kg',
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricTile(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesCard(
      BuildContext context, UserProfile profile, AppState appState, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8D8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, color: AppTheme.primaryOlive),
              const SizedBox(width: 10),
              Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppTheme.primaryOlive,
            title: Text(
              'App Theme',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.textDark,
              ),
            ),
            subtitle: Text(
              appState.darkMode ? 'Dark Mode' : 'Light Mode (Terra Lux White + Olive)',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : AppTheme.textMuted,
              ),
            ),
            value: appState.darkMode,
            onChanged: (val) => appState.toggleDarkMode(),
          ),
          Divider(color: isDark ? Colors.white10 : const Color(0xFFEFF3EA)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppTheme.primaryOlive,
            title: Text(
              'Daily Weigh-In Reminders',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.textDark,
              ),
            ),
            subtitle: Text(
              'Receive morning push notifications to track body weight.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : AppTheme.textMuted,
              ),
            ),
            value: profile.pushNotifications,
            onChanged: (val) {
              appState.updateActiveProfile(
                profile.copyWith(pushNotifications: val),
              );
            },
          ),
        ],
      ),
    );
  }
}
