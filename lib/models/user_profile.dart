import 'dart:convert';

enum BiologicalSex { male, female, other }
enum HeightUnit { ft, cm }
enum WeightUnit { kg, lbs }
enum TargetGoal { maintain, lose, gain }

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String tier;
  final BiologicalSex biologicalSex;
  final int age;
  final double heightValue;
  final int heightFeet;
  final int heightInches;
  final double heightCm;
  final HeightUnit heightUnit;
  final double weightValue;
  final double weightKg;
  final WeightUnit weightUnit;
  final TargetGoal targetGoal;
  final String measurementUnits; // 'metric' or 'imperial'
  final bool darkMode;
  final bool pushNotifications;
  final double vitalityScore;
  final double bodyFatPercent;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar = '',
    this.tier = 'Terra Lux Member',
    this.biologicalSex = BiologicalSex.male,
    this.age = 28,
    this.heightValue = 178.0,
    this.heightFeet = 5,
    this.heightInches = 10,
    this.heightCm = 178.0,
    this.heightUnit = HeightUnit.cm,
    this.weightValue = 74.0,
    this.weightKg = 74.0,
    this.weightUnit = WeightUnit.kg,
    this.targetGoal = TargetGoal.maintain,
    this.measurementUnits = 'metric',
    this.darkMode = false,
    this.pushNotifications = true,
    this.vitalityScore = 85.0,
    this.bodyFatPercent = 18.0,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? tier,
    BiologicalSex? biologicalSex,
    int? age,
    double? heightValue,
    int? heightFeet,
    int? heightInches,
    double? heightCm,
    HeightUnit? heightUnit,
    double? weightValue,
    double? weightKg,
    WeightUnit? weightUnit,
    TargetGoal? targetGoal,
    String? measurementUnits,
    bool? darkMode,
    bool? pushNotifications,
    double? vitalityScore,
    double? bodyFatPercent,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      tier: tier ?? this.tier,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      age: age ?? this.age,
      heightValue: heightValue ?? this.heightValue,
      heightFeet: heightFeet ?? this.heightFeet,
      heightInches: heightInches ?? this.heightInches,
      heightCm: heightCm ?? this.heightCm,
      heightUnit: heightUnit ?? this.heightUnit,
      weightValue: weightValue ?? this.weightValue,
      weightKg: weightKg ?? this.weightKg,
      weightUnit: weightUnit ?? this.weightUnit,
      targetGoal: targetGoal ?? this.targetGoal,
      measurementUnits: measurementUnits ?? this.measurementUnits,
      darkMode: darkMode ?? this.darkMode,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      vitalityScore: vitalityScore ?? this.vitalityScore,
      bodyFatPercent: bodyFatPercent ?? this.bodyFatPercent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'tier': tier,
      'biologicalSex': biologicalSex.name,
      'age': age,
      'heightValue': heightValue,
      'heightFeet': heightFeet,
      'heightInches': heightInches,
      'heightCm': heightCm,
      'heightUnit': heightUnit.name,
      'weightValue': weightValue,
      'weightKg': weightKg,
      'weightUnit': weightUnit.name,
      'targetGoal': targetGoal.name,
      'measurementUnits': measurementUnits,
      'darkMode': darkMode,
      'pushNotifications': pushNotifications,
      'vitalityScore': vitalityScore,
      'bodyFatPercent': bodyFatPercent,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? 'user_default',
      name: map['name'] ?? 'User',
      email: map['email'] ?? 'user@vitalis.app',
      avatar: map['avatar'] ?? '',
      tier: map['tier'] ?? 'Terra Lux Member',
      biologicalSex: BiologicalSex.values.firstWhere(
        (e) => e.name == map['biologicalSex'],
        orElse: () => BiologicalSex.male,
      ),
      age: (map['age'] as num?)?.toInt() ?? 28,
      heightValue: (map['heightValue'] as num?)?.toDouble() ?? 178.0,
      heightFeet: (map['heightFeet'] as num?)?.toInt() ?? 5,
      heightInches: (map['heightInches'] as num?)?.toInt() ?? 10,
      heightCm: (map['heightCm'] as num?)?.toDouble() ?? 178.0,
      heightUnit: HeightUnit.values.firstWhere(
        (e) => e.name == map['heightUnit'],
        orElse: () => HeightUnit.cm,
      ),
      weightValue: (map['weightValue'] as num?)?.toDouble() ?? 74.0,
      weightKg: (map['weightKg'] as num?)?.toDouble() ?? 74.0,
      weightUnit: WeightUnit.values.firstWhere(
        (e) => e.name == map['weightUnit'],
        orElse: () => WeightUnit.kg,
      ),
      targetGoal: TargetGoal.values.firstWhere(
        (e) => e.name == map['targetGoal'],
        orElse: () => TargetGoal.maintain,
      ),
      measurementUnits: map['measurementUnits'] ?? 'metric',
      darkMode: map['darkMode'] ?? false,
      pushNotifications: map['pushNotifications'] ?? true,
      vitalityScore: (map['vitalityScore'] as num?)?.toDouble() ?? 85.0,
      bodyFatPercent: (map['bodyFatPercent'] as num?)?.toDouble() ?? 18.0,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory UserProfile.fromJson(String source) => UserProfile.fromMap(jsonDecode(source));
}
