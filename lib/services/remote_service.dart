import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteService{

  static Future<List?> fetchEmployees() async{
    final uri= Uri.parse('https://dummy.restapiexample.com/api/v1/employees');
    final response = await http.get(uri);
    print(response.body);
    if(response.statusCode==200){
      final jsonData = jsonDecode(response.body) as Map;
      final employeeData = jsonData['data'] as List;
      return employeeData;
    }
    else{
      return null;
    }
  }

  static Future<bool> addEmployee(Map body) async{
    final uri= Uri.parse('https://dummy.restapiexample.com/api/v1/create');
    final response = await http.post(uri,body: jsonEncode(body),headers: {'Content-Type': 'application/json'});
    print(response.body);
    return response.statusCode==200;
  }

  static Future<bool> editEmployee(String id,Map body) async{
    final uri= Uri.parse('https://dummy.restapiexample.com/api/v1/update/$id');
    final response = await http.put(uri,body: jsonEncode(body),headers: {'Content-Type': 'application/json'});
    print(response.body);
    return response.statusCode==200;
  }

  static Future<bool> deleteEmployee(String id) async{
    final uri= Uri.parse('https://dummy.restapiexample.com/api/v1/delete/${id}');
    final response = await http.delete(uri);
    print(response.body);
    return response.statusCode==200;
  }

}