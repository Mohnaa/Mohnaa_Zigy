import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var allusersglobal = [];
  TextEditingController namecontroller = TextEditingController();
  TextEditingController jobcontroller = TextEditingController();

  Future<void> AddNewUser() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                  controller: namecontroller,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Job Description',
                  ),
                  // onChanged: (text) {
                  //   print(text);
                  // },
                  controller: jobcontroller,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('AddUser'),
              onPressed: () async {
                var issuccess = await createNewUser();
                if (issuccess) {
                  Fluttertoast.showToast(
                      msg: "User Added SuccessFully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(
                      msg: "Text Fields Cant Be Empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
            ),
          ],
        );
      },
    );
  }

  createNewUser() async {
    var url = Uri.https("reqres.in", "/api/users");
    var random = new Random();

    if (namecontroller.text.length >= 1 && jobcontroller.text.length >= 1) {
      var data = await http.post(url, body: {
        "name": namecontroller.text,
        "job": jobcontroller.text,
        "createdAt": DateTime.now().toString(),
        "id": random.nextInt(100000).toString()
      });
      print(data.body);
      var obje = {'name': "", 'id': "", 'year': ""};
      obje['name'] = jsonDecode(data.body)['name'].toString();
      obje['id'] = jsonDecode(data.body)['id'].toString();
      obje['year'] = DateTime.now().year.toString();

      setState(() {
        allusersglobal.add(obje);
      });

      print(obje);
      return true;
    }
    return false;
  }

  void getAllUsers() async {
    var url = Uri.https("reqres.in", "/api/users?pge=2");
    var users = await http.get(url);
    print(users.body);
    setState(() {
      allusersglobal = jsonDecode(users.body)['data'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: allusersglobal.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8,right: 8),
            child: Card(
              child: Container(
              height: 100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${allusersglobal[index]['name']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Color.fromARGB(255, 112, 111, 111)),),
                    SizedBox(height: 20,),
                    Text("${allusersglobal[index]['year']}",style: TextStyle(color: Color.fromARGB(255, 113, 175, 115),fontSize: 15,fontWeight: FontWeight.w700))
                  ],
                )
              ),
            ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: AddNewUser,
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }
}



// {"id":1,"name":"cerulean","year":2000,"color":"#98B2D1","pantone_value":"15-4020"}
