import 'package:csiapp/services/remote_service.dart';
import 'package:flutter/material.dart';

class Create extends StatefulWidget {
  final Map? emp;
  const Create({Key? key, this.emp}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create>  {
  final _nameController= TextEditingController();
  final _ageAmountController=TextEditingController();
  final _salaryAmountController=TextEditingController();
  bool isEdit=false;

  @override
  void initState() {
    final emp=widget.emp;
    super.initState();
    if(emp!=null){
      isEdit=true;
      _nameController.text=emp['employee_name'];
      _ageAmountController.text=emp['employee_age'].toString();
      _salaryAmountController.text=emp['employee_salary'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff153c59),
        elevation: 0,
        centerTitle: true,
        title: Text(isEdit?'E D I T  E M P L O Y E E':'A D D  E M P L O Y E E',style: TextStyle(fontSize: 18),),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Colors.grey
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Color(0xff153c59)
                        )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: TextField(
                  controller: _ageAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Colors.grey
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Color(0xff153c59)
                        )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: TextField(
                  controller: _salaryAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Salary',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Colors.grey
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Color(0xff153c59)
                        )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isEdit? Update:Save,
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          return Colors.white;
                        },
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          return Color(0xff153c59);
                        },
                      ),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        );
                      },
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(isEdit?'UPDATE':'SAVE',style: TextStyle(fontSize: 13),),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      _nameController.clear();
                      _ageAmountController.clear();
                      _salaryAmountController.clear();
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          return Colors.white;
                        },
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          return Color(0xff153c59);
                        },
                      ),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        );
                      },
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text('CANCEL',style: TextStyle(fontSize: 13),),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> Save() async{
    final body={
      "employee_name":_nameController.text,
      "employee_age":int.parse(_ageAmountController.text),
      "employee_salary":int.parse(_salaryAmountController.text),
    };
    final isSuccess= await RemoteService.addEmployee(body);
    if(isSuccess){
      showSuccessMsg('Creation Success');
      _nameController.clear();
      _ageAmountController.clear();
      _salaryAmountController.clear();
    }
    else{
      showErrorMsg('Creation Failed');
    }
    Navigator.of(context).pop();
  }

  Future<void> Update() async{
    final emp=widget.emp;
    if(emp==null){
      print('You cannot call update without emp data');
      return;
    }
    final id=emp['id'].toString();
    final body={
      "employee_name":_nameController.text,
      "employee_age":int.parse(_ageAmountController.text),
      "employee_salary":int.parse(_salaryAmountController.text),
    };
    final isSuccess= await RemoteService.editEmployee(id, body);
    if(isSuccess){
      showSuccessMsg('Updation Success');
    }
    else{
      showErrorMsg('Updation Failed');
    }
    Navigator.of(context).pop();
  }


  void showSuccessMsg(String msg){
    final snackBar=SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMsg(String msg){
    final snackBar=SnackBar(content: Text(msg,style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}

