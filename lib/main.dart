import 'dart:async';
import 'dart:convert';

// import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myklu_flutter/animation/FadeAnimation.dart';
import 'package:myklu_flutter/modal/api.dart';
import 'package:myklu_flutter/views/addcomplaint.dart';
import 'package:myklu_flutter/views/home.dart';
import 'package:myklu_flutter/views/notifications.dart';
import 'package:myklu_flutter/views/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myklu_flutter/animation/launcher.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';
import 'package:overlay_support/overlay_support.dart';


Future<void> _handleBGNotification(RemoteMessage message) async {
  print("Background Notification Listening");
  print(message.notification.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await requestPermission();
  FirebaseMessaging.onBackgroundMessage(_handleBGNotification);
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  runApp(MyApp());
  configLoading();
}

Future<void> requestPermission() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
);

if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  print('User granted permission');
} else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  print('User granted provisional permission');
} else {
  print('User declined or has not accepted permission');
}
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.black
    ..backgroundColor = Color.fromARGB(255, 76, 78, 77)
    ..indicatorColor = Colors.white
    ..textColor = Color.fromARGB(255, 255, 255, 255)
    ..maskColor = Color.fromARGB(255, 244, 244, 245)
    ..userInteractions = true
    ..toastPosition = EasyLoadingToastPosition.bottom
    ..dismissOnTap = true;
    //..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    //ketika notif di klik dan keadaannya terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        print(message.data);
        print(message.notification.title);
      }
    });

    //ketika notif di klik dan keadaannya on background
    FirebaseMessaging.onMessageOpenedApp.listen((event) { });

    //ketika on foreground
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null){
        print(event.notification.title);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      builder: EasyLoading.init(),
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          fontFamily: 'roboto',
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.blueGrey,
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIN, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIN;
  String username, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  var url = Uri.parse(BaseUrl.login);

  login() async {
    final response = await http
        .post(url, body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String namaAPI = data['nama'];
    String nimAPI = data['nim'];
    String id = data['id'];
    EasyLoading.show(status: 'loading...');
    if (value == 1) {
      EasyLoading.showToast('Logged in');
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, namaAPI, nimAPI, id);
        EasyLoading.dismiss();
      });
      print(pesan);
    } else {
      EasyLoading.dismiss();
      _showAlertDialog(context);
    }
  }

  var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.normal),
      descTextAlign: TextAlign.center,
      animationDuration: Duration(milliseconds: 200),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
      alertAlignment: Alignment.center,
    );

  _showAlertDialog(BuildContext context) {
      Alert(
      context: context,
      type: AlertType.error,
      style: alertStyle,
      title: "Warning!",
      desc: "Username atau password salah",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  savePref(int value, String nama, String nim, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("nim", nim);
      preferences.setString("id", id);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIN;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    EasyLoading.show(status: 'loading...');
    setState(() {
      preferences.remove("value");
      Navigator.pop(context);
      // ignore: deprecated_member_use
      preferences.commit();
      _loginStatus = LoginStatus.notSignIN;
      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIN:
        return Scaffold(
          body: Form(
            key: _key,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/gkuedit.jpg"),
                  fit: BoxFit.cover,
                ),
                // gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                //   Colors.red[700],
                //   Color(0xfff96060),
                //   Colors.red[300]
                // ])
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(
                            1,
                            Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                            1.3,
                            Text(
                              "Welcome Back",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 60,
                              ),
                              FadeAnimation(
                                  1.4,
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  225, 95, 27, .3),
                                              blurRadius: 20,
                                              offset: Offset(0, 10))
                                        ]),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextFormField(
                                            validator: (e) {
                                              if (e.isEmpty) {
                                                return "Please insert username";
                                              }
                                              return null;
                                            },
                                            onSaved: (e) => username = e,
                                            decoration: InputDecoration(
                                                hintText: "Username",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextFormField(
                                            obscureText: _secureText,
                                            validator: (e) {
                                              if (e.isEmpty) {
                                                return "Please insert password";
                                              }
                                              return null;
                                            },
                                            onSaved: (e) => password = e,
                                            decoration: InputDecoration(
                                                hintText: "Password",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none,
                                                suffixIcon: IconButton(
                                                  onPressed: showHide,
                                                  icon: Icon(_secureText
                                                      ? Icons.visibility
                                                      : Icons.visibility_off),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: 40,
                              ),
                              // FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Colors.grey),)),
                              // SizedBox(height: 40,),
                              FadeAnimation(
                                1.6,
                                Container(
                                  height: 50,
                                  width: 250,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.redAccent),
                                  child: MaterialButton(
                                    onPressed: () {
                                      check();
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              // FadeAnimation(
                              //     1.7,
                              //     InkWell(
                              //         onTap: () {
                              //           Navigator.of(context).push(
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       Register()));
                              //         },
                              //         child: Text(
                              //           "Create a new account",
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(color: Colors.grey),
                              //         )
                              //       )
                              //     ),
                              SizedBox(
                                height: 30,
                              ),
                              // Row(
                              //   children: <Widget>[
                              //     Expanded(
                              //       child: FadeAnimation(1.8, Container(
                              //         height: 50,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(50),
                              //           color: Colors.blue
                              //         ),
                              //         child: Center(
                              //           child: Text("Facebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              //         ),
                              //       )),
                              //     ),
                              //     SizedBox(width: 30,),
                              //     Expanded(
                              //       child: FadeAnimation(1.9, Container(
                              //         height: 50,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(50),
                              //           color: Colors.black
                              //         ),
                              //         child: Center(
                              //           child: Text("Github", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              //         ),
                              //       )),
                              //     )
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username, password, nama, nim;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  var url = Uri.parse(BaseUrl.register);

  save() async {
    final response = await http.post(url, body: {
      "nama": nama,
      "nim": nim,
      "username": username,
      "password": password
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(13.0),
            children: <Widget>[
              TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please insert fullname";
                  }
                  return null;
                },
                onSaved: (e) => nama = e,
                decoration: InputDecoration(labelText: "Nama Lengkap"),
              ),
              TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please insert NIM";
                  }
                  return null;
                },
                onSaved: (e) => nim = e,
                decoration: InputDecoration(labelText: "NIM"),
              ),
              TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Please insert username";
                  }
                  return null;
                },
                onSaved: (e) => username = e,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextFormField(
                obscureText: _secureText,
                onSaved: (e) => password = e,
                decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: showHide,
                      icon: Icon(_secureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                    )),
              ),
              MaterialButton(
                onPressed: () {
                  check();
                },
                child: Text("Register"),
              )
            ],
          ),
        ));
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
    signOut() {
    setState(() {
      widget.signOut();
    });
  }
  Timer _timer;

  String idUsers;
  var loading = false;

  String nama = "";
  String nim = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
      nim = preferences.getString("nim");
      idUsers = preferences.getString("id");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    //EasyLoading.showSuccess('Use in initState');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.43,
                width: MediaQuery.of(context).size.width,
                color: Colors.red[400],
                child: Container(
                  margin: EdgeInsets.only(right: 120, top: 20, bottom: 20),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/path.png'),
                          fit: BoxFit.contain)),
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(15),
                child: Text(
                  "MyKlu",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "Welcome, \n$nama",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w200,
                              color: Colors.white),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40))),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: Offset(0, 10),
                            )
                          ]),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddComplaint()));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/file.png'),
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain)),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Input Complaint",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: Offset(0, 10),
                            )
                          ]),
                      child: InkWell(
                        onTap: () {Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home()));},
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/repeat.png'),
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain)),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "History",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: Offset(0, 10),
                            )
                          ]),
                      child: InkWell(
                        onTap: () {Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Profile(signOut)));},
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/user1.png'),
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain)),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Profile",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: Offset(0, 10),
                            )
                          ]),
                      child: InkWell(
                        onTap: () {Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Notifications()));},
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/bell.png'),
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain)),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Notifications",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   height: 70,
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   color: Colors.black.withOpacity(0.8),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [],
              //   ),
              // )
            ],
          )
        ],
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.grey[200],
//     body: PageStorage(
//       child: currentScreen,
//       bucket: bucket,
//     ),
//     floatingActionButton: FloatingActionButton.extended(
//       backgroundColor: Colors.red,
//       label: const Text(
//         'Complaint',
//         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//       icon: const Icon(
//         Icons.add,
//         color: Colors.white,
//       ),
//       onPressed: () {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => AddComplaint(_lihatData)));
//       },
//     ),
//     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     bottomNavigationBar: BottomAppBar(
//       color: Colors.grey[900],
//       // shape: CircularNotchedRectangle(),
//       // notchMargin: 1,
//       child: Container(
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 MaterialButton(
//                   minWidth: 40,
//                   onPressed: () {
//                     setState(() {
//                       currentScreen =
//                           Home(); // if user taps on this dashboard tab will be active
//                       currentTab = 0;
//                     });
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Icon(
//                         currentTab == 0 ? Iconsax.home5 : Iconsax.home,
//                         color: Colors.white,
//                       ),
//                       SizedBox(height: 3.0),
//                       Text(
//                         'Home',
//                         style: TextStyle(
//                           color:
//                               currentTab == 0 ? Colors.white : Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: 1.0,
//             ),

//             // Right Tab bar icons

//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 MaterialButton(
//                   minWidth: 40,
//                   onPressed: () {
//                     setState(() {
//                       currentScreen = Profile(
//                           signOut); // if user taps on this dashboard tab will be active
//                       currentTab = 1;
//                     });
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Icon(
//                         currentTab == 0
//                             ? Iconsax.profile_circle
//                             : Iconsax.profile_circle5,
//                         color: Colors.white,
//                       ),
//                       SizedBox(height: 3.0),
//                       Text(
//                         'Profile',
//                         style: TextStyle(
//                           color:
//                               currentTab == 1 ? Colors.white : Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }
}