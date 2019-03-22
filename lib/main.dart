import 'package:flutter/material.dart';
import 'package:helloflutter/controller_page.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:webview_flutter/webview_flutter.dart';

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


