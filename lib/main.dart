import 'dart:async';
import 'dart:convert';

// import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myklu_flutter/animation/FadeAnimation.dart';
import 'package:myklu_flutter/modal/api.dart';
import 'package:myklu_flutter/modal/keluhanModel.dart';
import 'package:myklu_flutter/views/addcomplaint.dart';
import 'package:myklu_flutter/views/home.dart';
import 'package:myklu_flutter/views/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myklu_flutter/animation/launcher.dart';
import 'package:iconsax/iconsax.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
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
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, namaAPI, nimAPI, id);
      });
      print(pesan);
    } else {
      _showAlertDialog(context);
    }
  }

  _showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );
    AlertDialog alert = AlertDialog(
      title: Text("Warning!"),
      content: Text("Username atau password salah"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
    setState(() {
      preferences.remove("value");
      Navigator.pop(context);
      // ignore: deprecated_member_use
      preferences.commit();
      _loginStatus = LoginStatus.notSignIN;
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
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.red[700],
                Colors.red,
                Colors.red[300]
              ])),
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
                                      color: Colors.red),
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
                              FadeAnimation(
                                  1.7,
                                  InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Register()));
                                      },
                                      child: Text(
                                        "Create a new account",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey),
                                      ))),
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

  String idUsers;
  var loading = false;

  // ignore: deprecated_member_use
  final list = new List<KeluhanModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  // final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();

  
  Future<void> _lihatData() async {
    var url = Uri.parse(BaseUrl.lihatKeluhan + idUsers);
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(url);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new KeluhanModel(
          api['id'],
          api['keluhan'],
          api['fakultas'],
          api['penerima'],
          api['tipe'],
          api['tindakan'],
          api['stat'],
          api['feedback'],
          api['createDate'],
          api['idUsers'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

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
    _lihatData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    Home()
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        label: const Text('Complaint', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        icon: const Icon(Icons.add, color: Colors.white,),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddComplaint(_lihatData)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        // shape: CircularNotchedRectangle(),
        // notchMargin: 1,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Home(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon( currentTab == 0 ? Iconsax.home5 : Iconsax.home, color: Colors.white,
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          'Home',
                          style: TextStyle(
                              color:
                                  currentTab == 0 ? Colors.white : Colors.white,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 1.0,),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Profile(
                            signOut); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          currentTab == 0 ? Iconsax.profile_circle : Iconsax.profile_circle5, color: Colors.white,
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: currentTab == 1 ? Colors.white : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//             // actions: <Widget>[
//             //   IconButton(
//             //     onPressed: () {
//             //       signOut();
//             //     },
//             //     icon: Icon(Icons.lock_open),
//             //   )
//             // ],
//             ),
//         body: TabBarView(
//           children: <Widget>[
//             Home(),
//             Profile(signOut),
//           ],
//         ),
//         bottomNavigationBar: TabBar(
//           labelColor: Colors.blue,
//           unselectedLabelColor: Colors.black,
//           indicator: UnderlineTabIndicator(
//               borderSide: BorderSide(style: BorderStyle.none)),
//           tabs: <Widget>[
//             Tab(
//               icon: Icon(Icons.home),
//               text: "Home",
//             ),
//             Tab(
//               icon: Icon(Icons.account_circle),
//               text: "Profile",
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
