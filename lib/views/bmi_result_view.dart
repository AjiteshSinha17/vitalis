import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weight_log.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class BmiResultView extends StatelessWidget {
  const BmiResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final profile = appState.activeProfile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bmiRes = calculateBmi(profile.weightKg, profile.heightCm);

    // Calculate normal range min & max weight for user height
    final heightM = profile.heightCm / 100.0;
    final minNormalKg = double.parse((18.5 * heightM * heightM).toStringAsFixed(1));
    final maxNormalKg = double.parse((24.9 * heightM * heightM).toStringAsFixed(1));

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Navigation Back button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => appState.setActiveScreen(ActiveScreen.dashboard),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'BMI Analysis Breakdown',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Primary BMI Result Card
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8D8),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppTheme.lightOliveContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.speed_rounded,
                          color: AppTheme.primaryOlive,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your Current BMI',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white60 : AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bmiRes.bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppTheme.textDark,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.lightOliveContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          bmiRes.categoryLabel.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryOlive,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _getCategoryRecommendation(bmiRes.category),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: isDark ? Colors.white70 : AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Healthy Weight Recommendation Card
                Container(
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
                          const Icon(Icons.verified_rounded, color: AppTheme.primaryOlive),
                          const SizedBox(width: 10),
                          Text(
                            'Recommended Weight Target',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _statTile(
                            'Ideal Range',
                            '$minNormalKg – $maxNormalKg kg',
                            isDark,
                          ),
                          _statTile(
                            'Current Height',
                            '${profile.heightCm.toInt()} cm',
                            isDark,
                          ),
                          _statTile(
                            'Current Weight',
                            '${profile.weightKg} kg',
                            isDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statTile(String label, String value, bool isDark) {
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

  String _getCategoryRecommendation(BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return 'Your BMI is below the general recommendation for your height. Focus on nutrient-rich meals and targeted strength training to build healthy weight.';
      case BmiCategory.normalRange:
        return 'Your Body Mass Index indicates a healthy weight for your height. Maintaining this baseline balance supports long-term physical vitality.';
      case BmiCategory.overweight:
        return 'Your BMI is slightly above the ideal range. Daily physical movement and standard macronutrient balance can help optimize your body composition.';
      case BmiCategory.obese:
        return 'Your BMI indicates an elevated weight range. Tailored metabolic guidance and weight tracking can help you reach a healthier state.';
    }
  }
}
