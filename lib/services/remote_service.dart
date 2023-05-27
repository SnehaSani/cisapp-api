import 'dart:convert';
import 'package:csiapp/models/employee.dart';
import 'package:http/http.dart' as http;

const String baseUrl= 'https://dummy.restapiexample.com/api/v1';

class RemoteService{
  var client= http.Client();

  Future<List<Employee>?> getEmployees(String api) async{
    var uri= Uri.parse(baseUrl+api);
    var response= await client.get(uri);
    if(response.statusCode==200){
      var jsonData = jsonDecode(response.body);
      List<dynamic> employeeData = jsonData['data'];
      return employeeData.map((data) => Employee.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch employees. Status code: ${response.statusCode}');
    }
  }

  Future<Employee> addEmployee(String api,Employee employee) async{
    var uri= Uri.parse(baseUrl+api);
    var body=json.encode(employee.toJson());
    var response= await client.post(uri,body: body,headers: {'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 201) {
      var jsonData = jsonDecode(response.body);
      dynamic employeeData = jsonData['data'];
      return employeeData.map((data) => Employee.fromJson(data));
    } else {
      throw Exception('Failed to add employees. Status code: ${response.statusCode}');
    }
  }

  Future<Employee> editEmployee(String api,Employee employee) async{
    var uri= Uri.parse(baseUrl+api);
    var body=json.encode(employee.toJson());
    var response= await client.put(uri,body: body,headers: {'Content-Type': 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      dynamic employeeData = jsonData['data'];
      return employeeData.map((data) => Employee.fromJson(data));
    } else {
      throw Exception('Failed to edit employees. Status code: ${response.statusCode}');
    }
  }

  Future<Employee> deleteEmployee(String api) async{
    var uri= Uri.parse(baseUrl+api);
    var response= await client.delete(uri);
    print(response.body);
    if(response.statusCode==200){
      var jsonData = jsonDecode(response.body);
      dynamic employeeData = jsonData['data'];
      print('Employee deleted successfully');
      return employeeData.map((data) => Employee.fromJson(data));
    } else {
      throw Exception('Failed to delete employees. Status code: ${response.statusCode}');
    }
  }

}