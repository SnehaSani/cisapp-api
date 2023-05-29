import 'package:csiapp/services/remote_service.dart';
import 'package:csiapp/views/add_screen.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List employees=[];
  var isLoading=true;

  @override
  void initState() {
    super.initState();
    fetchData();
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
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView.builder(
            itemCount: employees?.length,
            itemBuilder: (context,index){
              final employee = employees[index] as Map;
              final id =employee['id'].toString();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                child: Container(
                  padding: EdgeInsets.only(left: 10,top: 20,bottom: 20,right: 0),
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
                      Row(
                        children: [
                          CircleAvatar(child: Text('${index+1}',style: TextStyle(color: Colors.white),),backgroundColor: Color(0xff153c59),),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${employee['employee_name']}',style: TextStyle(color: Color(0xff153c59),fontWeight: FontWeight.w600,fontSize: 16),),
                              SizedBox(height: 5,),
                              Text('${employee['employee_age']} years of wisdom!',style: TextStyle(color: Color(0xff153c59),fontSize: 14),),
                              SizedBox(height: 5,),
                              Text('Earning ${employee['employee_salary']} INR',style: TextStyle(color: Color(0xff153c59),fontWeight: FontWeight.w500,fontSize: 14),),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: (){navtoedit(employee);},
                            icon: Icon(Icons.edit, color: Color(0xFF153C59), size: 20),
                          ),
                          IconButton(
                            onPressed: () async{
                              await deleteEmployee(id);
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navtoadd,
        backgroundColor: Color(0xff153c59),
        child: Icon(Icons.add,color: Color(0xffffffff),),
      ),
    );
  }

  Future<void> navtoadd() async{
    await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Create()));
    setState(() {
      isLoading=true;
    });
    fetchData();
  }

  Future<void> navtoedit(Map employee) async{
    await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Create(emp:employee)));
    setState(() {
      isLoading=true;
    });
    fetchData();
  }

  void showErrorMsg(String msg){
    final snackBar=SnackBar(content: Text(msg,style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> fetchData() async{
    final response= await RemoteService.fetchEmployees();
    if(response!=null){
      setState(() {
        employees=response;
      });
    }
    else{
      showErrorMsg('Unable to Fetch Data');
    }
    setState(() {
      isLoading=false;
    });
  }

  Future<void> deleteEmployee(String id) async {
    final isSuccess=await RemoteService.deleteEmployee(id);
    if(isSuccess){
      final filtered=employees.where((element) => element['id'].toString()!=id).toList();
      setState(() {
        employees=filtered;
      });
    }
    else{
      showErrorMsg('Unable to Delete');
    }
  }
}