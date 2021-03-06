import 'package:flutter/material.dart';
import 'dart:async';
import 'NoteList.dart';
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover),
      ),
      child: Center(
          child: Container(
        child: Image.asset(
          "images/logo.png",
          width: 300.0,
          height: 300.0,
          filterQuality:FilterQuality.high,
        ),
      )),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoteList();
  }
}
