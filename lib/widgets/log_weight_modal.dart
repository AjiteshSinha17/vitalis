import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class LogWeightModal extends StatefulWidget {
  const LogWeightModal({super.key});

  @override
  State<LogWeightModal> createState() => _LogWeightModalState();
}

class _LogWeightModalState extends State<LogWeightModal> {
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _notesController;
  late WeightUnit _selectedWeightUnit;
  late HeightUnit _selectedHeightUnit;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    final profile = appState.activeProfile;
    _selectedWeightUnit = profile.weightUnit;
    _selectedHeightUnit = profile.heightUnit;
    _weightController = TextEditingController(text: profile.weightValue.toString());
    _heightController = TextEditingController(text: profile.heightCm.toInt().toString());
    _notesController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
        _selectedDate = picked;
      });
    }
  }

  void _handleSubmit() {
    final weightVal = double.tryParse(_weightController.text.trim());
    if (weightVal == null || weightVal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight number.')),
      );
      return;
    }

    final heightVal = double.tryParse(_heightController.text.trim());
    if (heightVal == null || heightVal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid height number.')),
      );
      return;
    }

    final appState = Provider.of<AppState>(context, listen: false);
    appState.addWeightLog(
      newWeight: weightVal,
      unit: _selectedWeightUnit,
      newHeight: heightVal,
      heightUnit: _selectedHeightUnit,
      date: _selectedDate,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                          Icons.add_chart_rounded,
                          color: AppTheme.primaryOlive,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Log Weight & Height Entry',
                        style: TextStyle(
                          fontSize: 20,
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
              const SizedBox(height: 20),

              // Weight Input
              Text(
                'Body Weight',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.textDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'e.g. 74.5',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Unit Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.borderDark : const Color(0xFFEFF3EA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _buildWeightUnitBtn(WeightUnit.kg, 'KG', isDark),
                        _buildWeightUnitBtn(WeightUnit.lbs, 'LBS', isDark),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Height Input Selection
              Text(
                'Height',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _heightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.textDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'e.g. 178',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Unit Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.borderDark : const Color(0xFFEFF3EA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _buildHeightUnitBtn(HeightUnit.cm, 'CM', isDark),
                        _buildHeightUnitBtn(HeightUnit.ft, 'FT', isDark),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Date Picker
              Text(
                'Log Date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.borderDark : const Color(0xFFF6F8F3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white12 : const Color(0xFFD6DEC9),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppTheme.textDark,
                        ),
                      ),
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: AppTheme.primaryOlive,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Notes Input
              Text(
                'Notes (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'e.g. Morning measurement, post-fasting...',
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOlive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Save Log Entry',
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
    );
  }

  Widget _buildWeightUnitBtn(WeightUnit unit, String label, bool isDark) {
    final isSelected = _selectedWeightUnit == unit;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedWeightUnit = unit;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryOlive : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white60 : AppTheme.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _buildHeightUnitBtn(HeightUnit unit, String label, bool isDark) {
    final isSelected = _selectedHeightUnit == unit;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedHeightUnit = unit;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryOlive : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white60 : AppTheme.textMuted),
          ),
        ),
      ),
    );
  }
}
