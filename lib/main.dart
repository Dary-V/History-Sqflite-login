import 'package:flutter/material.dart';

import 'login_page.dart';
import 'database.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
        backgroundColor: Colors.green[300],
      ),
      body: new UserList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
  }
}

class UserList extends StatelessWidget {
  final dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<User>>(
      future: dbHelper.getUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return new Center(child: CircularProgressIndicator());
        return new ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return new ListTile(
              onTap: () async {
                // Delete a record
//                var dbHelper = DBHelper();
                var del = await dbHelper.db;
                await del.transaction(
                  (txn) async {
                    await txn
                        .rawDelete('DELETE FROM User WHERE id = ?', [snapshot.data[index].id]);
                      print('DELETED --------------------- ');
                  },
                );
              },
              title: new Text(snapshot.data[index].name),
              subtitle: new Text(snapshot.data[index].age.toString()),
            );
          },
        );
      },
    );
  }
}
