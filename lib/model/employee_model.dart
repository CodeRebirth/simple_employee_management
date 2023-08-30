import 'dart:convert';

class EmployeeModel {
  int? id;
  String empName;
  String role;
  String joining_date;
  String ending_date;
  EmployeeModel({
    this.id,
    required this.empName,
    required this.role,
    required this.joining_date,
    required this.ending_date,
  });

  EmployeeModel copyWith({
    int? id,
    String? empName,
    String? role,
    String? joining_date,
    String? ending_date,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      empName: empName ?? this.empName,
      role: role ?? this.role,
      joining_date: joining_date ?? this.joining_date,
      ending_date: ending_date ?? this.ending_date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'empName': empName,
      'role': role,
      'joining_date': joining_date,
      'ending_date': ending_date,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map["id"] ?? '',
      empName: map['empName'] ?? '',
      role: map['role'] ?? '',
      joining_date: map['joining_date'] ?? '',
      ending_date: map['ending_date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromJson(String source) => EmployeeModel.fromMap(json.decode(source));
}
