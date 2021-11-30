import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myklu_flutter/main.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  void initState() {
    super.initState();
    splashscreenStart();
  }

  splashscreenStart() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return Login() ;
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/telu.jpg",
              height: 200.0,
              width: 400.0,
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';
// import 'package:myklu_flutter/main.dart';

// class LauncherPage extends StatefulWidget {
//   @override
//   _LauncherPageState createState() => new _LauncherPageState();
// }

// class _LauncherPageState extends State<LauncherPage> {
//   @override
//   void initState() {
//     super.initState();
//     startLaunching();
//   }
  // startLaunching() async {
  //   var duration = const Duration(seconds: 10);
  //   return new Timer(duration, () {
  //     Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (_) {
  //       return new Login() ;
  //     }));
  //   });
  // }
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent
//     ));
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//             boxShadow: <BoxShadow>[
//               BoxShadow(
//                   color: Colors.grey.shade200,
//                   offset: Offset(2, 4),
//                   blurRadius: 5,
//                   spreadRadius: 2)
//             ],
//             gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.white])),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             new Center(
//               child: new Image.asset(
//                 "assets/telu.jpg",
//                 height: 70.0,
//                 width: 200.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

