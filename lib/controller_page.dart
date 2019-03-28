import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

String url = 'https://ucc.edu.gh';  // initial url

class ControllerPage extends StatefulWidget {
  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {

  // web view controller
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController webViewController;
  TextEditingController controller = TextEditingController(text: url);

  // instance of web view controller
  final TextEditingController txt_edit_controller = new TextEditingController();

  String myUrl = "";

  bool _isWebLoaded = false;  // to change state when web view is loaded
  bool _canControlCamera = false; // unused var

  // not necessary
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  } // end of  not necessary

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robot Car Controller'),
        actions: <Widget>[  // add action to icon at top right
          IconButton(   // icon
            icon: Icon(Icons.camera),
            color: Colors.white,
            onPressed: _lookAround,   // action is bellow
          )
        ],
      ),
      floatingActionButton: _isWebLoaded
          ? _fab()  // floating fab appear after page loaded for reset state
          : Container(
              height: 1.0,
            ),  // is not loaded...do not appear, ie height = 1, invisible
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[ // all actions invoked here
            _cameraView(),
            SizedBox(   // buttom padding
              height: 10.0,
            ),
            _isWebLoaded ? Container(height: 1.0) : _ipInput(),   // if page loaded, form and button disappear
            SizedBox(
              height: 5.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            _directionController()
          ],
        ),
      ),
    );
  }


  Widget _directionController() { // up, down, right, left positioning
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
          child: _stopBotton(),
        ),
      ],
    );
  }

  // method for each direction control
  Widget _upButton() {
    return RaisedButton(
      onPressed: _goForward,
      child: Icon(Icons.arrow_upward),
    );
  }

  Widget _leftButton() {
    return RaisedButton(
      onPressed: _goLeft,
      child: Icon(Icons.arrow_back),
    );
  }

  Widget _rightButton() {
    return RaisedButton(
      child: Icon(Icons.arrow_forward),
      onPressed: _goRight,
    );
  }

  Widget _downButton() {
    return RaisedButton(
      onPressed: _goReverse,
      child: Icon(Icons.arrow_downward),
    );
  }

  Widget _stopBotton() {
    return RaisedButton(
      child: Text("Stop",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: Colors.red,
      onPressed: _stop,
    );
  }

  // method for the camera view
  void _lookAround() {
    var up = "http://192.168.6.1:5050/servo";     // camera endpoint on server
    http.get(up).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });
  }

  // url input plus connect button
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
                hintText: "http://ip address",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),    // rounds input form edge
            keyboardType: TextInputType.url),    // input type, url
        new Text(myUrl),     // for debugging

        RaisedButton(       // connect button
            child: Text("Connect"), // title
            color: Theme.of(context).primaryColor,      // button color
            textColor: Colors.white,     // text on button collor
            onPressed: () {     // action
              setState(() {
                myUrl = "http://" + txt_edit_controller.text;     // appending url to https://
                    _isWebLoaded = true;  // when pressed, changes bool of var
              });
              webViewController.loadUrl(myUrl); 
            })
        // )
      ],
    );
  }

  Widget _cameraView() {
    return Container(
        height: _isWebLoaded     // if-else statement to increase camera space
            ? (MediaQuery.of(context).size.height / 2) + 110.0  // increases height of camera when loaded
            : MediaQuery.of(context).size.height / 2 - 80.0,
        width: double.infinity,     // auto width
        decoration: BoxDecoration(     // applying style
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.grey,
            boxShadow: [
              new BoxShadow(
                color: Colors.black,
                blurRadius: 5.0,
              ),
            ]),
        child: WebView(    // web view embedded in container space
            initialUrl: myUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController wb) {
              _controller.complete(wb);
              webViewController = wb;
            }));
  }
  
  // floating widget to reset state for url+button to appear 
  Widget _fab() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _isWebLoaded = false;
        });
      },
      child: Icon(Icons.refresh),   // icon
    );
  }
}

///////////////////////// control actions to hit server endpoints //////////////////////////
void _goForward() {
  var up = "http://192.168.6.1:5050/forward";
  http.get(up).then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}

void _goReverse() {
  var reverse = "http://192.168.6.1:5050/backward";
  http.get(reverse).then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}

void _goLeft() {
  var left = "http://192.168.6.1:5050/left";
  http.get(left).then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}

void _goRight() {
  var right = "http://192.168.6.1:5050/right";
  http.get(right).then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}

void _stop() {
  var stop = "http://192.168.6.1:5050/stop";
  http.get(stop).then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}

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

// Widget _onOffInputController() {
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
