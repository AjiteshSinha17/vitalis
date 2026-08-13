import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onOpenProfileSwitcher;

  const AppHeader({
    super.key,
    required this.onOpenProfileSwitcher,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeProfile = appState.activeProfile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (appState.activeScreen == ActiveScreen.login ||
        appState.activeScreen == ActiveScreen.signup) {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.lightOliveContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.monitor_heart_outlined,
                color: AppTheme.primaryOlive,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Vitalis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: isDark ? Colors.white : AppTheme.textDark,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              appState.darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: isDark ? Colors.white70 : AppTheme.textDark,
            ),
            onPressed: () => appState.toggleDarkMode(),
            tooltip: 'Toggle Theme',
          ),
          const SizedBox(width: 8),
        ],
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      shadowColor: Colors.black.withAlpha(15),
      titleSpacing: 16,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Active Profile Chip
          InkWell(
            onTap: onOpenProfileSwitcher,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.borderDark : const Color(0xFFF0F4EA),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isDark ? Colors.white12 : AppTheme.primaryOlive.withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppTheme.primaryOlive,
                    backgroundImage: activeProfile.avatar.isNotEmpty
                        ? NetworkImage(activeProfile.avatar)
                        : null,
                    child: activeProfile.avatar.isEmpty
                        ? Text(
                            activeProfile.name.isNotEmpty
                                ? activeProfile.name[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    activeProfile.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: isDark ? Colors.white60 : AppTheme.textMuted,
                  ),
                ],
              ),
            ),
          ),

          // Brand Center Logo
          GestureDetector(
            onTap: () => appState.setActiveScreen(ActiveScreen.dashboard),
            child: Row(
              children: [
                const Icon(
                  Icons.monitor_heart,
                  color: AppTheme.primaryOlive,
                  size: 26,
                ),
                const SizedBox(width: 6),
                Text(
                  'Vitalis',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark ? Colors.white : AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),

          // Right Controls: Profile switch + Theme switch (NO CODE BUTTON)
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.group_outlined,
                  color: isDark ? Colors.white70 : AppTheme.textDark,
                  size: 22,
                ),
                onPressed: onOpenProfileSwitcher,
                tooltip: 'Switch Profile',
              ),
              IconButton(
                icon: Icon(
                  appState.darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: isDark ? Colors.white70 : AppTheme.textDark,
                  size: 22,
                ),
                onPressed: () => appState.toggleDarkMode(),
                tooltip: 'Toggle Theme',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
