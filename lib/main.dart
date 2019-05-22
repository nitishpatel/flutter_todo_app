import 'package:flutter/material.dart';
import 'screens/note_list.dart';
import 'screens/splashscreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"TODO",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}