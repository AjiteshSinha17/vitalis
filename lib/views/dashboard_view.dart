import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/weight_log.dart';
import '../models/user_profile.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/log_weight_modal.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final profile = appState.activeProfile;
    final logs = appState.activeLogs;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bmiResult = calculateBmi(profile.weightKg, profile.heightCm);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Banner Card: Profile Overview & Vitality Score
                _buildWelcomeHeader(context, profile, isDark),
                const SizedBox(height: 24),

                // Top Metrics Row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 650;
                    return isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildBmiCard(context, profile, bmiResult, isDark)),
                              const SizedBox(width: 20),
                              Expanded(child: _buildTargetGoalCard(context, profile, appState, isDark)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildBmiCard(context, profile, bmiResult, isDark),
                              const SizedBox(height: 20),
                              _buildTargetGoalCard(context, profile, appState, isDark),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 24),

                // Weight Progress Line Chart Card
                _buildChartCard(context, logs, isDark),
                const SizedBox(height: 24),

                // Recent Logs & Quick Action
                _buildRecentLogsSection(context, logs, appState, isDark),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const LogWeightModal(),
          );
        },
        backgroundColor: AppTheme.primaryOlive,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Log Weight',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, UserProfile profile, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8D8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 480;

          final userDetails = Column(
            crossAxisAlignment:
                isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: isCompact ? WrapAlignment.center : WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Text(
                    'Hello, ${profile.name}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.lightOliveContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      profile.tier,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOlive,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${profile.heightCm.toInt()} cm • ${profile.weightKg} kg • Age ${profile.age}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : AppTheme.textMuted,
                ),
              ),
            ],
          );

          final vitalityBadge = Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF28341A) : AppTheme.lightOliveContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, color: AppTheme.primaryOlive, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Vitality Score',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOlive,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${profile.vitalityScore.toInt()}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryOlive,
                  ),
                ),
              ],
            ),
          );

          if (isCompact) {
            return Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryOlive,
                  backgroundImage:
                      profile.avatar.isNotEmpty ? NetworkImage(profile.avatar) : null,
                  child: profile.avatar.isEmpty
                      ? Text(
                          profile.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                userDetails,
                const SizedBox(height: 14),
                vitalityBadge,
              ],
            );
          }

          return Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.primaryOlive,
                backgroundImage:
                    profile.avatar.isNotEmpty ? NetworkImage(profile.avatar) : null,
                child: profile.avatar.isEmpty
                    ? Text(
                        profile.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(child: userDetails),
              const SizedBox(width: 12),
              vitalityBadge,
            ],
          );
        },
      ),
    );
  }

  Widget _buildBmiCard(
      BuildContext context, UserProfile profile, BmiResult bmiResult, bool isDark) {
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppTheme.lightOliveContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.speed_rounded,
                      color: AppTheme.primaryOlive,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Body Mass Index',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<AppState>(context, listen: false)
                      .setActiveScreen(ActiveScreen.bmiResult);
                },
                child: const Text(
                  'View Breakdown →',
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
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                bmiResult.bmi.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppTheme.textDark,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.lightOliveContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  bmiResult.categoryLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryOlive,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar Gauge
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (bmiResult.bmi / 40.0).clamp(0.1, 1.0),
              minHeight: 10,
              backgroundColor: isDark ? AppTheme.borderDark : const Color(0xFFECEFE6),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryOlive),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '18.5 (Min)',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : AppTheme.textMuted,
                ),
              ),
              Text(
                '24.9 (Max Normal)',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetGoalCard(
      BuildContext context, UserProfile profile, AppState appState, bool isDark) {
    String goalText = 'Maintain Weight';
    IconData goalIcon = Icons.balance_rounded;

    if (profile.targetGoal == TargetGoal.lose) {
      goalText = 'Weight Loss';
      goalIcon = Icons.trending_down_rounded;
    } else if (profile.targetGoal == TargetGoal.gain) {
      goalText = 'Gain Muscle';
      goalIcon = Icons.trending_up_rounded;
    }

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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppTheme.lightOliveContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      goalIcon,
                      color: AppTheme.primaryOlive,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Target Goal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => appState.setActiveScreen(ActiveScreen.settings),
                child: const Text(
                  'Change Goal',
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
          Text(
            goalText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Optimal target weight range for height ${profile.heightCm.toInt()} cm is 60.0 kg – 78.5 kg.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF28341A) : AppTheme.lightOliveContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppTheme.primaryOlive,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Current weight: ${profile.weightValue} ${profile.weightUnit.name.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryOlive,
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

  Widget _buildChartCard(BuildContext context, List<WeightLog> logs, bool isDark) {
    if (logs.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = <FlSpot>[];
    final reversedLogs = logs.reversed.toList();
    for (int i = 0; i < reversedLogs.length; i++) {
      spots.add(FlSpot(i.toDouble(), reversedLogs[i].weightKg));
    }

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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppTheme.lightOliveContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.show_chart_rounded,
                      color: AppTheme.primaryOlive,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Weight Progress Visualizer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              Text(
                '${logs.length} Entries',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white54 : AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? Colors.white10 : const Color(0xFFECEFE6),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < reversedLogs.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              reversedLogs[index].dateLabel,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white54 : AppTheme.textMuted,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppTheme.primaryOlive,
                    barWidth: 3.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryOlive.withAlpha(30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLogsSection(
      BuildContext context, List<WeightLog> logs, AppState appState, bool isDark) {
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
              Text(
                'Recent Weigh-In Records',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.textDark,
                ),
              ),
              GestureDetector(
                onTap: () => appState.setActiveScreen(ActiveScreen.history),
                child: const Text(
                  'View All Logs →',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryOlive,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (logs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No weight logs recorded yet.',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : AppTheme.textMuted,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length > 4 ? 4 : logs.length,
              separatorBuilder: (context, index) => Divider(
                color: isDark ? Colors.white10 : const Color(0xFFEFF3EA),
              ),
              itemBuilder: (context, index) {
                final log = logs[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppTheme.lightOliveContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.monitor_weight_outlined,
                      color: AppTheme.primaryOlive,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '${log.weightDisplay} ${log.unit.name.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                  subtitle: Text(
                    '${log.dateLabel} • BMI ${log.bmi}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : AppTheme.textMuted,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: log.changeKg <= 0
                          ? AppTheme.lightOliveContainer
                          : const Color(0xFFFDE8E8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${log.changeKg > 0 ? '+' : ''}${log.changeKg} kg',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: log.changeKg <= 0
                            ? AppTheme.primaryOlive
                            : const Color(0xFFE02424),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
