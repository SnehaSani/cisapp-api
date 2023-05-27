import 'dart:isolate';

import 'package:csiapp/models/employee.dart';
import 'package:csiapp/services/remote_service.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Employee>? employees;
  Employee? employee;
  var isLoaded=false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    employees= await RemoteService().getEmployees('/employees');
    if(employees!=null){
      setState(() {
        isLoaded=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xff153c59),
        elevation: 0,
        centerTitle: true,
        title: Text('E M P L O Y E E S',style: TextStyle(fontSize: 18),),
      ),
      body: Visibility(
        visible: isLoaded,
        child: ListView.builder(
          itemCount: employees?.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 7),
              child: Container(
                padding: EdgeInsets.only(left: 30,top: 20,bottom: 20,right: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(
                    color: Color(0xA1A5A6A7),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${employees![index].employeeName}',style: TextStyle(color: Color(0xff153c59),fontWeight: FontWeight.w600,fontSize: 16),),
                        SizedBox(height: 5,),
                        Text('${employees![index].employeeAge.toString()} years of wisdom!',style: TextStyle(color: Color(0xff153c59),fontSize: 14),),
                        SizedBox(height: 5,),
                        Text('Earning ${employees![index].employeeSalary.toString()} INR',style: TextStyle(color: Color(0xff153c59),fontWeight: FontWeight.w500,fontSize: 14),),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async{
                            var id=employees![index].id;
                            var newEmployee= Employee(employeeName: 'Sneha Sani', employeeSalary: 123065, employeeAge: 21);
                            employee= await RemoteService().editEmployee('/update/$id', newEmployee);
                            if(employee==null){
                              print('employees=nulllll');
                              return;
                            }
                            print(employee);
                          },
                          icon: Icon(Icons.edit, color: Color(0xFF153C59), size: 20),
                        ),
                        IconButton(
                          onPressed: () async{
                            var id=employees![index].id;
                            employee= await RemoteService().deleteEmployee('/delete/$id');
                            if(employee==null){
                              return;
                            }
                            print('Successsfulll');
                          },
                          icon: Icon(Icons.delete, color: Color(0xFF153C59), size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        replacement: const Center(child: CircularProgressIndicator(),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          var newEmployee= Employee(employeeName: 'Sneha Sani', employeeSalary: 123065, employeeAge: 21);
          employee= await RemoteService().addEmployee('/create', newEmployee);
          if(employee==null){
            return;
          }
          print(employee);
        },
        backgroundColor: Color(0xff153c59),
        child: Icon(Icons.add,color: Color(0xffffffff),),
      ),
    );
  }
}
