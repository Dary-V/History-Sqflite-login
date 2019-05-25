import 'package:flutter/material.dart';
import 'database.dart';


final nameController = TextEditingController();
final passController = TextEditingController();
final ageController = TextEditingController();


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    nameController.clear();
    ageController.clear();
    passController.clear();

    super.initState();
  }

// As I understood this stuff is needed when I want to show a page once in a session
//
//  @override
//  void dispose() {
//    // Clean up the controller when the Widget is disposed
//    nameController.dispose();
//    passController.dispose();
//    ageController.dispose();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loginka'),
        backgroundColor: Colors.green[300],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(17.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter your username'),
                controller: nameController,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                maxLength: 2,
                decoration: InputDecoration(labelText: 'Enter your age'),
                controller: ageController,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter your password'),
                obscureText: true,
                controller: passController,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pop(context);
            var realUser = User(2, nameController.text, ageController.text, passController.text);
            saveUser(realUser);
          }),
    );
  }
}

void saveUser(User user) async {
  var dbHelper = DBHelper();
  var dbClient = await dbHelper.db;
  await dbClient.transaction((txn) async {
    return await txn.rawInsert(
        'INSERT INTO User(name, age, password) VALUES('
             +
            '\'' +
            user.name +
            '\'' +
            ',' +
            '\'' +
            user.age +
            '\'' +
            ',' +
            '\'' +
            user.password +
            '\'' +
            ')');
  });
}
