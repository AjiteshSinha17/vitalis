import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../models/user_profile.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _dobController;

  WeightUnit _weightUnit = WeightUnit.kg;
  HeightUnit _heightUnit = HeightUnit.cm;
  BiologicalSex _sex = BiologicalSex.female;
  TargetGoal _goal = TargetGoal.maintain;
  DateTime _selectedDob = DateTime.now().subtract(const Duration(days: 365 * 28));

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    final profile = appState.activeProfile;

    _nameController = TextEditingController(text: profile.name);
    _weightController = TextEditingController(text: profile.weightValue.toString());
    _heightController = TextEditingController(text: profile.heightCm.toInt().toString());
    _dobController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(_selectedDob));
    _weightUnit = profile.weightUnit;
    _heightUnit = profile.heightUnit;
    _sex = profile.biologicalSex;
    _goal = profile.targetGoal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob,
      firstDate: DateTime(1920),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryOlive,
              onPrimary: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _handleComplete() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final weightVal = double.parse(_weightController.text.trim());
    final heightVal = double.parse(_heightController.text.trim());

    // Calculate age from DOB
    final age = DateTime.now().year - _selectedDob.year;

    // Convert weight to KG internally if LBS
    final weightKg = _weightUnit == WeightUnit.lbs
        ? double.parse((weightVal / 2.20462).toStringAsFixed(1))
        : weightVal;

    // Convert height to CM internally if inches
    final heightCm = _heightUnit == HeightUnit.ft
        ? double.parse((heightVal * 2.54).toStringAsFixed(1))
        : heightVal;

    final appState = Provider.of<AppState>(context, listen: false);
    final profile = appState.activeProfile;

    appState.updateActiveProfile(
      profile.copyWith(
        name: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : profile.name,
        biologicalSex: _sex,
        age: age,
        heightCm: heightCm,
        heightValue: heightVal,
        heightUnit: _heightUnit,
        weightKg: weightKg,
        weightValue: weightVal,
        weightUnit: _weightUnit,
        targetGoal: _goal,
      ),
    );

    appState.setActiveScreen(ActiveScreen.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Card(
                color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(
                    color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8D8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppTheme.lightOliveContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Lottie.asset(
                                'assets/lottie/health_pulse.json',
                                width: 40,
                                height: 40,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.assignment_ind_rounded,
                                    color: AppTheme.primaryOlive,
                                    size: 26,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'User Details Form',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppTheme.textDark,
                                    ),
                                  ),
                                  Text(
                                    'Enter your validated body metrics & biometric details.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.white60 : AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Full Name Field
                        Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryOlive),
                            hintText: 'e.g. Sarah Vance',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Gender / Sex Selector
                        Text(
                          'Gender / Biological Sex',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _sexOption(BiologicalSex.female, 'Female', Icons.female, isDark),
                            const SizedBox(width: 10),
                            _sexOption(BiologicalSex.male, 'Male', Icons.male, isDark),
                            const SizedBox(width: 10),
                            _sexOption(BiologicalSex.other, 'Other', Icons.transgender, isDark),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Date of Birth Field (Date Validation)
                        Text(
                          'Date of Birth',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          onTap: _pickBirthDate,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please select your birth date';
                            }
                            try {
                              DateFormat('yyyy-MM-dd').parseStrict(val.trim());
                            } catch (_) {
                              return 'Invalid date format (Use YYYY-MM-DD)';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_rounded, color: AppTheme.primaryOlive),
                            suffixIcon: Icon(Icons.arrow_drop_down, color: AppTheme.textMuted),
                            hintText: 'YYYY-MM-DD',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Weight Input Field with Unit Toggle & Numerical Validator
                        Text(
                          'Body Weight',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _weightController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Enter weight';
                                  }
                                  final numVal = double.tryParse(val.trim());
                                  if (numVal == null || numVal <= 0) {
                                    return 'Must be a valid positive number';
                                  }
                                  if (_weightUnit == WeightUnit.kg && (numVal < 20 || numVal > 350)) {
                                    return 'Enter weight between 20 - 350 kg';
                                  }
                                  if (_weightUnit == WeightUnit.lbs && (numVal < 44 || numVal > 770)) {
                                    return 'Enter weight between 44 - 770 lbs';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.monitor_weight_outlined, color: AppTheme.primaryOlive),
                                  hintText: _weightUnit == WeightUnit.kg ? 'e.g. 74.5' : 'e.g. 164.2',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Unit Toggle
                            Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: isDark ? AppTheme.borderDark : const Color(0xFFEFF3EA),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  _unitToggleBtn('KG', _weightUnit == WeightUnit.kg, () {
                                    setState(() => _weightUnit = WeightUnit.kg);
                                  }, isDark),
                                  _unitToggleBtn('LBS', _weightUnit == WeightUnit.lbs, () {
                                    setState(() => _weightUnit = WeightUnit.lbs);
                                  }, isDark),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Height Input Field with Unit Toggle & Numerical Validator
                        Text(
                          'Height',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _heightController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Enter height';
                                  }
                                  final numVal = double.tryParse(val.trim());
                                  if (numVal == null || numVal <= 0) {
                                    return 'Must be a valid positive number';
                                  }
                                  if (_heightUnit == HeightUnit.cm && (numVal < 80 || numVal > 260)) {
                                    return 'Enter height between 80 - 260 cm';
                                  }
                                  if (_heightUnit == HeightUnit.ft && (numVal < 2.5 || numVal > 8.5)) {
                                    return 'Enter height between 2.5 - 8.5 ft';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.height_rounded, color: AppTheme.primaryOlive),
                                  hintText: _heightUnit == HeightUnit.cm ? 'e.g. 178' : 'e.g. 5.10',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Unit Toggle
                            Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: isDark ? AppTheme.borderDark : const Color(0xFFEFF3EA),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  _unitToggleBtn('CM', _heightUnit == HeightUnit.cm, () {
                                    setState(() => _heightUnit = HeightUnit.cm);
                                  }, isDark),
                                  _unitToggleBtn('FT', _heightUnit == HeightUnit.ft, () {
                                    setState(() => _heightUnit = HeightUnit.ft);
                                  }, isDark),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Target Goal Selector
                        Text(
                          'Target Goal',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _goalOption(TargetGoal.lose, 'Weight Loss', isDark),
                            const SizedBox(width: 8),
                            _goalOption(TargetGoal.maintain, 'Maintain Weight', isDark),
                            const SizedBox(width: 8),
                            _goalOption(TargetGoal.gain, 'Gain Muscle', isDark),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _handleComplete,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryOlive,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Save User Details & Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _unitToggleBtn(String label, bool isSelected, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryOlive : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white60 : AppTheme.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _sexOption(BiologicalSex sex, String label, IconData icon, bool isDark) {
    final isSelected = _sex == sex;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _sex = sex),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryOlive
                : (isDark ? AppTheme.borderDark : const Color(0xFFF2F6ED)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppTheme.textMuted),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppTheme.textDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _goalOption(TargetGoal goal, String label, bool isDark) {
    final isSelected = _goal == goal;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _goal = goal),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryOlive
                : (isDark ? AppTheme.borderDark : const Color(0xFFF2F6ED)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppTheme.primaryOlive : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppTheme.textDark),
            ),
          ),
        ),
      ),
    );
  }
}
