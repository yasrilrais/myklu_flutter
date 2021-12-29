import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myklu_flutter/animation/FadeAnimation.dart';
import 'package:iconsax/iconsax.dart';

class Profile extends StatefulWidget {
  final VoidCallback signOut;
  Profile(this.signOut);
  @override
  _ProfileState createState() => _ProfileState();
}

enum LoginStatus { notSignIN, signIn }

class _ProfileState extends State<Profile> {
  List<List> _settings = [
    ['Privacy', 'Privacy settings', Iconsax.lock_1, Colors.green[400]],
    ['Help', 'Help and feedback', Icons.help_outline, Colors.blue[400]],
    ['Logout', 'Logout', Icons.exit_to_app, Colors.red[400]],
  ];
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  // LoginStatus _loginStatus = LoginStatus.notSignIN;
  String nama = "";
  String nim = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
      nim = preferences.getString("nim");
    });
  }

  showLogoutDealog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                onPressed: () {
                  signOut();
                },
              ),
            ],
          );
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                Colors.red[600],
                Color(0xfff96060),
                Colors.red[300]
              ])),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  FadeAnimation(
                      1,
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.transparent,
                        child: 
                        Icon(Icons.account_circle, size: 85, color: Colors.grey[400],),
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeAnimation(
                            1,
                            Text(
                              '$nama',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        FadeAnimation(
                            1,
                            Text(
                              "$nim",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            )),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: IconButton(
                  //       onPressed: () {
                  //         // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                  //       },
                  //       icon: FadeAnimation(1, Icon(Icons.mode_edit_outline_outlined, color: Colors.grey,)),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FadeAnimation(
                0.5,
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Settings',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 500,
              child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: _settings.length,
                  itemBuilder: (context, index) {
                    return FadeAnimation(
                        (0.5 + index) / 4,
                        settingsOption(_settings[index][0], _settings[index][1],
                            _settings[index][2], _settings[index][3]));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  settingsOption(String title, String subtitle, IconData icon, Color color) {
    return ListTile(
      onTap: () {
        if (title == 'Logout') {
          showLogoutDealog();
        }
        if (title == 'Privacy'){

        }
        if (title == 'Help'){

        }
      },
      subtitle: Text(subtitle),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: Colors.grey.shade400,
      ),
    );
  }
}
