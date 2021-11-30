import 'dart:async';
import 'dart:convert';
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:myklu_flutter/modal/api.dart';
// import 'package:myklu_flutter/modal/keluhanModel.dart';
// import 'package:myklu_flutter/views/addcomplaint.dart';
// import 'package:http/http.dart' as http;
// import 'package:myklu_flutter/views/editKeluhan.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:myklu_flutter/animation/FadeAnimation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:expansion_tile_card/expansion_tile_card.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueGrey,
      ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("notif"),
    ),
    );
  }
}
