import 'dart:convert';

List<Employee> employeeFromJson(String str) => List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  int? id;
  String employeeName;
  int employeeSalary;
  int employeeAge;
  String? profileImage;

  Employee({
    this.id,
    required this.employeeName,
    required this.employeeSalary,
    required this.employeeAge,
    this.profileImage,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    employeeName: json["employee_name"],
    employeeSalary: json["employee_salary"],
    employeeAge: json["employee_age"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "employee_name": employeeName,
    "employee_salary": employeeSalary,
    "employee_age": employeeAge,
  };
}
