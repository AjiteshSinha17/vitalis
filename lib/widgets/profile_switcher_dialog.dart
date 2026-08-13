import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class ProfileSwitcherDialog extends StatefulWidget {
  const ProfileSwitcherDialog({super.key});

  @override
  State<ProfileSwitcherDialog> createState() => _ProfileSwitcherDialogState();
}

class _ProfileSwitcherDialogState extends State<ProfileSwitcherDialog> {
  bool _isAdding = false;
  final TextEditingController _nameController = TextEditingController();
  String _selectedTier = 'Standard';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleAddProfile() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final appState = Provider.of<AppState>(context, listen: false);
    appState.addProfile(name, _selectedTier);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppTheme.lightOliveContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.group_outlined,
                        color: AppTheme.primaryOlive,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isAdding ? 'Add Family Profile' : 'Switch Active Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (!_isAdding) ...[
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: appState.profiles.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final profile = appState.profiles[index];
                    final isSelected = profile.id == appState.activeProfileId;

                    return InkWell(
                      onTap: () {
                        appState.setActiveProfile(profile.id);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? const Color(0xFF2E3821) : AppTheme.lightOliveContainer)
                              : (isDark ? AppTheme.borderDark : const Color(0xFFF7F9F4)),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryOlive : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppTheme.primaryOlive,
                              backgroundImage: profile.avatar.isNotEmpty
                                  ? NetworkImage(profile.avatar)
                                  : null,
                              child: profile.avatar.isEmpty
                                  ? Text(
                                      profile.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${profile.weightValue} ${profile.weightUnit.name.toUpperCase()} • ${profile.tier}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? Colors.white60 : AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppTheme.primaryOlive,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _isAdding = true;
                  });
                },
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                label: const Text('Add New Family Profile'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ] else ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Profile Name',
                  hintText: 'e.g. Sarah',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedTier,
                decoration: const InputDecoration(labelText: 'Profile Tier'),
                items: const [
                  DropdownMenuItem(value: 'Standard', child: Text('Standard Member')),
                  DropdownMenuItem(value: 'Terra Lux Member', child: Text('Terra Lux Member')),
                  DropdownMenuItem(value: 'Premium Tier', child: Text('Premium Tier')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedTier = val);
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState(() => _isAdding = false),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleAddProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOlive,
                      ),
                      child: const Text('Save Profile'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
