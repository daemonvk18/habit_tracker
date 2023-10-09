import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_storage/pages/homepage.dart';

void main() async {
  //initalize the hive
  await Hive.initFlutter();

  //open the box("a sample database")
  // ignore: unused_local_variable
  var box = await Hive.openBox("DataBase");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
