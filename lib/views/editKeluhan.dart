import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myklu_flutter/modal/api.dart';
import 'package:myklu_flutter/modal/keluhanModel.dart';
import 'package:http/http.dart' as http;

class EditKeluhan extends StatefulWidget {
  final KeluhanModel model;
  final VoidCallback reload;
  EditKeluhan(this.model, this.reload);
  @override
  _EditKeluhanState createState() => _EditKeluhanState();
}

class _EditKeluhanState extends State<EditKeluhan> {
  final _key = new GlobalKey<FormState>();
  String keluhan, fakultas, penerima, tipe, tindakan, stat, feedback;

  TextEditingController txtKeluhan, txtFakultas, txtPenerima, txtTipe, txtTindakan, txtStat, txtFeedback;

  setup(){
    txtKeluhan = TextEditingController(text: widget.model.keluhan);
    txtFakultas = TextEditingController(text: widget.model.fakultas);
    txtPenerima = TextEditingController(text: widget.model.penerima);
    txtTipe = TextEditingController(text: widget.model.tipe);
    txtTindakan = TextEditingController(text: widget.model.tindakan);
    txtStat = TextEditingController(text: widget.model.stat);
    txtFeedback = TextEditingController(text: widget.model.feedback);
  }

  check(){
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {
    }
  }

  var url = Uri.parse(BaseUrl.editKeluhan);
  submit()async{
    final response = await http.post(url, body: {
      "keluhan" : keluhan,
      "fakultas" : fakultas,
      "penerima" : penerima,
      "tipe" : tipe,
      "tindakan" : tindakan,
      "stat" : stat,
      "feedback" : feedback,
      "idKeluhan" : widget.model.id
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
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
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(13.0),
          children: <Widget>[
            TextFormField(
              enabled: false,
              controller: txtKeluhan,
              onSaved: (e)=>keluhan=e,
              decoration: InputDecoration(
                labelText: 'Keluhan'
              ),
            ),
            Visibility(
              child: TextFormField(
                enabled: false,
                controller: txtFakultas,
                onSaved: (e)=>fakultas=e,
                decoration: InputDecoration(
                  labelText: 'Fakultas'
                ),
              ),
              visible: false,
            ),
            TextFormField(
              enabled: false,
              controller: txtPenerima,
              onSaved: (e)=>penerima=e,
              decoration: InputDecoration(
                labelText: 'Penerima'
              ),
            ),
            Visibility(
              child: TextFormField(
                enabled: false,
                controller: txtTipe,
                onSaved: (e)=>tipe=e,
                decoration: InputDecoration(
                  labelText: 'Tipe'
                ),
              ),
              visible: false,
            ),
            TextFormField(
              enabled: false,
              controller: txtTindakan,
              onSaved: (e)=>tindakan=e,
              decoration: InputDecoration(
                labelText: 'Tindakan'
              ),
            ),
            TextFormField(
              controller: txtStat,
              onSaved: (e)=>stat=e,
              decoration: InputDecoration(
                labelText: 'Status'
              ),
            ),
            TextFormField(
              controller: txtFeedback,
              onSaved: (e)=>feedback=e,
              decoration: InputDecoration(
                labelText: 'Feedback'
              ),
            ),
            MaterialButton(
              onPressed: (){
                check();
              },
              child: Text("Input"),
            )
          ],
        ),
      ),    
    );
  }
}