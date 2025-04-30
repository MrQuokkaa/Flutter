import 'package:flutter/material.dart';
import '../util/functions.dart';
import '../data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataBase db = DataBase();
  final Functions f = Functions();
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final name = await f.getUserName();
    setState(() => userName = name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            f.appBarText(),
            Text(
              f.getGreeting(userName),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.amber,
      body: const Center(child: Text("Home")),
    );
  }
}
