import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:async';
// import 'dart:async';
// import 'dart:convert';
import 'package:http/http.dart' as http;

String url = 'https://portal.ucc.edu.gh';

class ControllerPage extends StatefulWidget {
  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController webViewController;
  TextEditingController controller = TextEditingController(text: url);

  final TextEditingController txt_edit_controller = new TextEditingController();

  String myUrl = "";
  String open_url;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      // url = controller.text;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // bool _isOn = false;

  // TextEditingController _url = new TextEditingController();

  // _open_url() {
  //   print('open click');
  // }

  // _launchURL() async {
  //   const url = 'http://google.com';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robot Car Controller'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            //camera view
            _cameraView(),
            SizedBox(
              height: 20.0,
            ),
            // _urlInput(),
            _ipInput(),
            SizedBox(
              height: 10.0,
            ),
            // _connectBtn(),
            // SizedBox(
            //   height: 10.0,
            // ),
            // _onOffController(),
            // SizedBox(
            //   height: 30.0,
            // ),

            _directionController(),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _directionController() {
    return Stack(
      children: <Widget>[
        Positioned(left: 70.0, child: _upButton()),
        Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 10.0),
            child: _leftButton()),
        Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 128.0), //140
          child: _rightButton(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 70.0),
          child: _downButton(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 250.0),
          child: _stop_botton(),
        )
      ],
    );
  }

        Widget _upButton() {
          return RaisedButton(
            onPressed: go_forward,
            child: Icon(Icons.arrow_upward),
                );
              }
        Widget _leftButton() {
          return RaisedButton(
            onPressed: go_forward,
            child: Icon(Icons.arrow_upward),
                );
              }
      
      
        Widget _rightButton() {
          return RaisedButton(
            child: Icon(Icons.arrow_forward),
            onPressed: go_right,
          );
        }
      
        Widget _downButton() {
          return RaisedButton(
            onPressed: go_reverse,
            child: Icon(Icons.arrow_downward),
          );
        }
      
      
        Widget _stop_botton() {
          return RaisedButton(
            child: Text("Stop",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            color: Colors.red,
            onPressed: stop,
          );
        }
      
        // Widget _onOffController() {
        //   return ListTile(
        //     onTap: () {},
        //     leading: Icon(
        //       Icons.flash_on,
        //       color: Colors.blue,
        //     ),
        //     title: Text("On/Off"),
        //     subtitle: Text("Use controller to turn on/off the robot"),
        //     trailing: Switch(
        //       value: _isOn,
        //       onChanged: (bool isChanged) {
        //         setState(() {
        //           _isOn = !_isOn;
        //         });
        //       },
        //     ),
        //   );
        // }
      
        Widget _ipInput() {
          return Column(
            children: <Widget>[
              TextField(
                  controller: txt_edit_controller,
                  // onChanged: (String url) {
                  //   // setState(() {
                  //   //   myUrl= url;
                  //   // });
                  //   // txt_edit_controller.text = '';
                  // },
                  // controller: txt_edit_controller,  this hides the data in the form
                  decoration: InputDecoration(
                      labelText: "Enter url",
                      hintText: "http://ip_address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  keyboardType: TextInputType.url),
              // new Text(myUrl),
      
              RaisedButton(
                  child: Text("Connect"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      myUrl = txt_edit_controller.text;
                    });
                    webViewController.loadUrl(myUrl);
      
                    // _launchURL();
                    // launchURL(url);
                    // Navigator.of(context).pushNamed('/webview');
                  })
              // )
            ],
          );
        }
      
        Widget _cameraView() {
          return Container(
              height: MediaQuery.of(context).size.height / 2 - 80.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey,
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black,
                      blurRadius: 5.0,
                    ),
                  ]),
              child: WebView(
                  initialUrl: myUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController wb) {
                    _controller.complete(wb);
                    webViewController = wb;
                  }));
        }


        ///////////////////////// control actions //////////////////////////
        void go_forward() {
          var up = "http://10.10.65.15:5050/forward";
          http.get(up)
          .then((response) {
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.body}");
          });
        }
        void go_reverse() {
          var reverse = "http://10.10.65.15:5050/backward";
          http.get(reverse)
          .then((response) {
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.body}");
          });
        }
        void go_left() {
          var left = "http://10.10.65.15:5050/left";
          http.get(left)
          .then((response) {
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.body}");
          });
        }
         

        void go_right() {
          var right = "http://10.10.65.15:5050/right";
          http.get(right)
          .then((response) {
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.body}");
          });
        }


        void stop() {
          var stop = "http://10.10.65.15:5050/stop";
          http.get(stop)
          .then((response) {
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.body}");
          });
        }
}
// Future<   > getData() async {
//     String url = 'https://quotes.rest/qod.json';
//     final response =
//         await http.get(url, headers: {"Accept": "application/json"});


//     if (response.statusCode == 200) {
//       return FetctData.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load post');
//     }
//   }



// class FetctData {
//   final String data;

//   FetctData({this.data});

//   factory FetctData.fromJson(Map<String, dynamic> json) {
//     return (
//         author: json['contents']['quotes'][0]['author'],
//         data: json['contents']['quotes'][0]['quote']);
//   }
// }

////////////////////////////////////////////////////  end_of_code   /////////////////////////////////////////////////////////

// Widget _connectBtn() {
//   return RaisedButton(
//       child: Text("Connect"),
//       color: Theme.of(context).primaryColor,
//       textColor: Colors.white,
//       onPressed: () {});
// }
// Widget _urlInput(){
//   return new  Column(
//     children: <Widget>[
//       new TextField(
//         controller: _url,),
//       new RaisedButton(
//         onPressed: _open_url(),
//         child: new Text('Open Url'),)
//   ],);
// }

// Widget _ipInput(String ipAdressValue) {
// var url = TextInputType.url;
//   return Container(
//       child: Column(children: <Widget>[
//     TextField(
//       decoration: InputDecoration(
//           labelText: "Enter url",
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0)))),
//       onChanged: (String ipAdress) {
//         setState(() {
//           ipAdressValue = ipAdress;
//         });
//       },
//       keyboardType: TextInputType.url,
//     ),
//     SizedBox(
//       height: 10.0,
//     ),
//     RaisedButton(
//       child: Text("Submit"),
//       color: Theme.of(context).primaryColor,
//       textColor: Colors.white,
//       onPressed: () {})
//   ]));
// }
// Widget _ipInput2(){
//   return TextFormField(
//     decoration: ,
//   )
// }}