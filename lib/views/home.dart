import 'dart:async';
import 'dart:convert';
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myklu_flutter/modal/api.dart';
import 'package:myklu_flutter/modal/keluhanModel.dart';
import 'package:myklu_flutter/views/addcomplaint.dart';
import 'package:http/http.dart' as http;
import 'package:myklu_flutter/views/editKeluhan.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:myklu_flutter/animation/FadeAnimation.dart';
import 'package:myklu_flutter/views/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:expansion_tile_card/expansion_tile_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.blue,
  Colors.indigo,
];

class _HomeState extends State<Home> {
  var loading = false;
  // ignore: deprecated_member_use
  final list = new List<KeluhanModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  // final GlobalKey<ExpansionTileCardState> _cardA = new GlobalKey();

  String idUsers;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatData();
  }

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

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Are you sure?",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                        onTap: () {
                          _delete(id);
                        },
                        child: Text("Yes")),
                  ],
                )
              ],
            ),
          );
        });
  }

  var url1 = Uri.parse(BaseUrl.deleteKeluhan);

  _delete(String id) async {
    final response = await http.post(url1, body: {"idKeluhan": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    // _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xfff96060),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: (){Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Notifications()));},
              child: Icon(
                Iconsax.notification5,
                size: 25.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) => AddComplaint(_lihatData)));
      //   },
      // ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Padding(
              padding: const EdgeInsets.all(120.0),
              child: Center(
                  child: LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  colors: _kDefaultRainbowColors,
                  strokeWidth: 2,
                )),
            )
            : FadeAnimation(
                0.5,
                ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    // return Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: 20.0, vertical: 20.0),
                    //   child: ExpansionTileCard(
                    //     baseColor: Colors.cyan[50],
                    //     expandedColor: Colors.red[50],
                    //     key: _cardA,
                    //     title: Text(x.createDate),
                    //     subtitle: Text(x.tipe),
                    //     children: <Widget>[
                    //       Divider(
                    //         thickness: 1.0,
                    //         height: 1.0,
                    //       ),
                    //       Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 16.0,
                    //             vertical: 8.0,
                    //           ),
                    //           child: Text(x.keluhan),
                    //         ),
                    //       ),
                    //       ButtonBar(
                    //         alignment: MainAxisAlignment.spaceAround,
                    //         buttonHeight: 52.0,
                    //         buttonMinWidth: 90.0,
                    //         children: <Widget>[
                    //           TextButton(
                    //             style: TextButton.styleFrom(
                    //               shape: const RoundedRectangleBorder(
                    //                 borderRadius:
                    //                     BorderRadius.all(Radius.circular(4.0)),
                    //               ),
                    //             ),
                    //             onPressed: () {
                    //               _cardA.currentState?.expand();
                    //             },
                    //             child: Column(
                    //               children: [
                    //                 Icon(Icons.arrow_downward),
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       vertical: 2.0),
                    //                 ),
                    //                 Text('Open'),
                    //               ],
                    //             ),
                    //           ),
                    //           TextButton(style: TextButton.styleFrom(
                    //               shape: const RoundedRectangleBorder(
                    //                 borderRadius:
                    //                     BorderRadius.all(Radius.circular(4.0)),
                    //               ),
                    //             ),
                    //             onPressed: () {
                    //               _cardA.currentState?.collapse();
                    //             },
                    //             child: Column(
                    //               children: [
                    //                 Icon(Icons.arrow_upward),
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       vertical: 2.0),
                    //                 ),
                    //                 Text('Close'),
                    //               ],
                    //             ),
                    //           ),
                    //           TextButton(style: TextButton.styleFrom(
                    //               shape: const RoundedRectangleBorder(
                    //                 borderRadius:
                    //                     BorderRadius.all(Radius.circular(4.0)),
                    //               ),
                    //               textStyle: TextStyle(color: Colors.red),
                    //             ),
                    //             onPressed: () {},
                    //             child: Column(
                    //               children: <Widget>[
                    //                 Icon(Icons.swap_vert),
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       vertical: 2.0),
                    //                 ),
                    //                 Text('Toggle'),
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // );
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SingleChildScrollView(
                        child: Row(
                          children: <Widget>[
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text("Keluhan :"),
                            //     SizedBox(height: 5),
                            //     Text("Penerima :"),
                            //     SizedBox(height: 5),
                            //     Text("Status :"),
                            //     SizedBox(height: 5),
                            //     Text("Pengirim :")
                            //   ],
                            // ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    x.createDate,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    x.keluhan,
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 5),
                                  Text(x.penerima),
                                  SizedBox(height: 5),
                                  Text(x.stat),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditKeluhan(x, _lihatData)));
                              },
                              icon: Icon(Icons.keyboard_arrow_right),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     dialogDelete(x.id);
                            //   },
                            //   icon: Icon(Icons.delete),
                            // ),
                            Visibility(
                              child: IconButton(
                                onPressed: () {
                                  dialogDelete(x.id);
                                },
                                icon: Icon(
                                  Icons.delete,
                                ),
                              ),
                              visible: false,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
