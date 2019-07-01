import 'package:flutter/material.dart';
import 'package:mydb_todo/screens/NoteList.dart';
import 'package:mydb_todo/screens/SplashScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TODO",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFb92b27),
        accentColor: Colors.black,
      ),
      home: SplashScreen(),
    );
  }
}