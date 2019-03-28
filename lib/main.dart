// by John pk Erbynn
// March 26, 2019
// john.erbynn@gmail.com

import 'package:flutter/material.dart';
import 'package:helloflutter/controller_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Robot Controller App",
      routes: {
        '/': (_) => ControllerPage(),
      
      },
      // home: ControllerPage(),
    );
  }
}


