import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myklu_flutter/animation/FadeAnimation.dart';
import 'package:myklu_flutter/main.dart';
import 'package:myklu_flutter/modal/api.dart';
import 'package:myklu_flutter/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;

class AddComplaint extends StatefulWidget {
  final VoidCallback reload;
  AddComplaint(this.reload);
  @override
  _AddComplaintState createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  // String keluhan, fakultas, penerima, tipe, tindakan, stat, feedback, idUsers;
  String keluhan, tipe = "Keluhan", idUsers;
  final _key = new GlobalKey<FormState>();
  XFile _imageFile;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  _pilihGallery() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  _pilihKamera() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    var url = Uri.parse(BaseUrl.addKeluhan);
    try {
      var stream =
          // ignore: deprecated_member_use
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var request = http.MultipartRequest("POST", url);
      request.fields['keluhan'] = keluhan;
      request.fields['tipe'] = tipe;
      request.fields['idUsers'] = idUsers;

      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          widget.reload();
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => MainMenu()));
          Navigator.pop(context);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('./assets/placeholder.jpg'),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Input Complaint',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xfff96060),
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: 30,
              color: Color(0xfff96060),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              child: Form(
                key: _key,
                child: ListView(
                  padding: EdgeInsets.all(13.0),
                  children: <Widget>[
                    FadeAnimation(
                      1.0,
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 130.0,
                          child: TextFormField(
                            maxLines: 6,
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert complaint";
                              }
                              return null;
                            },
                            onSaved: (e) => keluhan = e,
                            decoration: InputDecoration(
                                floatingLabelStyle:
                                    TextStyle(color: Colors.black54),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey[600])),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                                labelText: 'Complaint',
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),
                    ),
                    FadeAnimation(
                      0.9,
                      Row(
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Upload File :",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    FadeAnimation(
                      0.8,
                      Container(
                        width: double.infinity,
                        height: 100.0,
                        child: InkWell(
                          onTap: () {
                            _pilihGallery();
                          },
                          child: _imageFile == null
                              ? placeholder
                              : Image.file(
                                  File(_imageFile.path),
                                  fit: BoxFit.fitHeight,
                                ),
                        ),
                      ),
                    ),
                    // Visibility(
                    //   child: TextFormField(
                    //   onSaved: (e)=>fakultas=e,
                    //   decoration: InputDecoration(
                    //     labelText: 'Fakultas'
                    //   ),
                    // ),
                    // visible: false,
                    // ),
                    // Visibility(
                    //   child: TextFormField(
                    //   onSaved: (e)=>penerima=e,
                    //   decoration: InputDecoration(
                    //     labelText: 'Penerima'
                    //   ),
                    // ),
                    // visible: false,
                    // ),
                    // ** tipe
                    // FadeAnimation(0.7,
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: TextFormField(
                    //     validator: (e) {
                    //       if (e.isEmpty) {
                    //         return "Please insert tipe";
                    //       }
                    //       return null;
                    //     },
                    //     onSaved: (e) => tipe = e,
                    //     decoration: InputDecoration(
                    //       floatingLabelStyle: TextStyle(color: Colors.blueGrey),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(20),
                    //         borderSide: BorderSide(),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(20),
                    //         borderSide: BorderSide(),
                    //       ),
                    //       labelText: 'Type',
                    //     ),
                    //   ),
                    // ),
                    // ),
                    SizedBox(height: 10.0,),
                    FadeAnimation(
                      0.7,
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Type :",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: "Keluhan",
                                groupValue: tipe,
                                onChanged: (value) {
                                  setState(() {
                                    tipe = value;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text("Keluhan"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: "Masukan",
                                groupValue: tipe,
                                onChanged: (value) {
                                  setState(() {
                                    tipe = value;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text("Masukan"),
                            ],
                          )
                        ],
                      ),
                    ),
                    // **
                    // Visibility(
                    //   child: TextFormField(
                    //   onSaved: (e)=>tindakan=e,
                    //   decoration: InputDecoration(
                    //     labelText: 'Tindakan'
                    //   ),
                    // ),
                    // visible: false,
                    // ),
                    // Visibility(
                    //   child: TextFormField(
                    //   onSaved: (e)=>stat=e,
                    //   decoration: InputDecoration(
                    //     labelText: 'Status'
                    //   ),
                    // ),
                    // visible: false,
                    // ),
                    // Visibility(
                    //   child: TextFormField(
                    //   onSaved: (e)=>feedback=e,
                    //   decoration: InputDecoration(
                    //     labelText: 'Feedback'
                    //   ),
                    // ),
                    // visible: false,
                    // ),
                    FadeAnimation(
                      0.5,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 45,
                          width: 50,
                          margin: EdgeInsets.symmetric(horizontal: 70),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.redAccent),
                          child: MaterialButton(
                            onPressed: () {
                              check();
                            },
                            child: Text(
                              "Input",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}