import 'dart:convert';
import 'user_profile.dart';

enum BmiCategory { underweight, normalRange, overweight, obese }

class BmiResult {
  final double bmi;
  final BmiCategory category;
  final String categoryLabel;
  final String statusColorHex;

  BmiResult({
    required this.bmi,
    required this.category,
    required this.categoryLabel,
    required this.statusColorHex,
  });
}

BmiResult calculateBmi(double weightKg, double heightCm) {
  if (heightCm <= 0) {
    return BmiResult(
      bmi: 0,
      category: BmiCategory.normalRange,
      categoryLabel: 'Normal Range',
      statusColorHex: '#4A5D23',
    );
  }
  final heightM = heightCm / 100.0;
  final bmi = double.parse((weightKg / (heightM * heightM)).toStringAsFixed(1));

  if (bmi < 18.5) {
    return BmiResult(
      bmi: bmi,
      category: BmiCategory.underweight,
      categoryLabel: 'Underweight',
      statusColorHex: '#E6A23C',
    );
  } else if (bmi < 25.0) {
    return BmiResult(
      bmi: bmi,
      category: BmiCategory.normalRange,
      categoryLabel: 'Normal Range',
      statusColorHex: '#4A5D23',
    );
  } else if (bmi < 30.0) {
    return BmiResult(
      bmi: bmi,
      category: BmiCategory.overweight,
      categoryLabel: 'Overweight',
      statusColorHex: '#E67E22',
    );
  } else {
    return BmiResult(
      bmi: bmi,
      category: BmiCategory.obese,
      categoryLabel: 'Obese',
      statusColorHex: '#F56C6C',
    );
  }
}

class WeightLog {
  final String id;
  final String profileId;
  final String date; // YYYY-MM-DD
  final String dateLabel;
  final String monthLabel;
  final String dayLabel;
  final double weightKg;
  final double weightDisplay;
  final WeightUnit unit;
  final double bmi;
  final String category;
  final double changeKg;
  final String? notes;

  WeightLog({
    required this.id,
    required this.profileId,
    required this.date,
    required this.dateLabel,
    required this.monthLabel,
    required this.dayLabel,
    required this.weightKg,
    required this.weightDisplay,
    required this.unit,
    required this.bmi,
    required this.category,
    required this.changeKg,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'date': date,
      'dateLabel': dateLabel,
      'monthLabel': monthLabel,
      'dayLabel': dayLabel,
      'weightKg': weightKg,
      'weightDisplay': weightDisplay,
      'unit': unit.name,
      'bmi': bmi,
      'category': category,
      'changeKg': changeKg,
      'notes': notes,
    };
  }

  factory WeightLog.fromMap(Map<String, dynamic> map) {
    return WeightLog(
      id: map['id'] ?? '',
      profileId: map['profileId'] ?? '',
      date: map['date'] ?? '',
      dateLabel: map['dateLabel'] ?? '',
      monthLabel: map['monthLabel'] ?? '',
      dayLabel: map['dayLabel'] ?? '',
      weightKg: (map['weightKg'] as num?)?.toDouble() ?? 0.0,
      weightDisplay: (map['weightDisplay'] as num?)?.toDouble() ?? 0.0,
      unit: WeightUnit.values.firstWhere(
        (e) => e.name == map['unit'],
        orElse: () => WeightUnit.kg,
      ),
      bmi: (map['bmi'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] ?? 'Normal Range',
      changeKg: (map['changeKg'] as num?)?.toDouble() ?? 0.0,
      notes: map['notes'],
    );
  }

  String toJson() => jsonEncode(toMap());
  factory WeightLog.fromJson(String source) => WeightLog.fromMap(jsonDecode(source));
}
