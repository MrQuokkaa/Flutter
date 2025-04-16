import 'package:flutter/material.dart';
import '../util/functions.dart';
import '../data/database.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataBase db = DataBase();
    Functions f = Functions();

    return Scaffold(
      appBar: AppBar(
        title: f.appBarDate(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (f.checkDay),
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.amber,
      body: const Center(child: Text("Home")),
    );
  }
}
