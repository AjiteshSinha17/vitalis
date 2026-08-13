import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/log_weight_modal.dart';

class WeightHistoryView extends StatefulWidget {
  const WeightHistoryView({super.key});

  @override
  State<WeightHistoryView> createState() => _WeightHistoryViewState();
}

class _WeightHistoryViewState extends State<WeightHistoryView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final profile = appState.activeProfile;
    final logs = appState.activeLogs;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredLogs = logs.where((l) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return l.dateLabel.toLowerCase().contains(q) ||
          l.date.contains(q) ||
          (l.notes != null && l.notes!.toLowerCase().contains(q));
    }).toList();

    // Stats calculations
    double highest = logs.isNotEmpty ? logs.first.weightKg : 0.0;
    double lowest = logs.isNotEmpty ? logs.first.weightKg : 0.0;
    for (var l in logs) {
      if (l.weightKg > highest) highest = l.weightKg;
      if (l.weightKg < lowest) lowest = l.weightKg;
    }

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weight Logs & History',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.textDark,
                          ),
                        ),
                        Text(
                          'Detailed history log for ${profile.name}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const LogWeightModal(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOlive,
                      ),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add Entry'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Key Statistics Row
                Row(
                  children: [
                    Expanded(
                      child: _statCard('Highest Weight', '$highest kg', isDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard('Lowest Weight', '$lowest kg', isDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard('Total Records', '${logs.length}', isDark),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Search / Filter Input
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryOlive),
                    hintText: 'Search weight records by date or note...',
                    fillColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
                  ),
                ),
                const SizedBox(height: 20),

                // Logs List Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8D8),
                    ),
                  ),
                  child: filteredLogs.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 36),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.history_rounded,
                                  size: 40,
                                  color: AppTheme.primaryOlive,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No matching weight logs found.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white70 : AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredLogs.length,
                          separatorBuilder: (context, index) => Divider(
                            color: isDark ? Colors.white10 : const Color(0xFFEFF3EA),
                          ),
                          itemBuilder: (context, index) {
                            final log = filteredLogs[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: AppTheme.lightOliveContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.monitor_weight_outlined,
                                  color: AppTheme.primaryOlive,
                                  size: 22,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    '${log.weightDisplay} ${log.unit.name.toUpperCase()}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: log.changeKg <= 0
                                          ? AppTheme.lightOliveContainer
                                          : const Color(0xFFFDE8E8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${log.changeKg > 0 ? '+' : ''}${log.changeKg} kg',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: log.changeKg <= 0
                                            ? AppTheme.primaryOlive
                                            : const Color(0xFFE02424),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${log.dateLabel} • BMI ${log.bmi} (${log.category})',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.white60 : AppTheme.textMuted,
                                    ),
                                  ),
                                  if (log.notes != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Note: ${log.notes}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          color: isDark ? Colors.white54 : AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Color(0xFFE02424),
                                  size: 20,
                                ),
                                onPressed: () {
                                  _confirmDelete(context, appState, log.id);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8D8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white54 : AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppState appState, String logId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Weight Record?'),
          content: const Text('Are you sure you want to remove this weight log entry?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                appState.deleteWeightLog(logId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE02424),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
