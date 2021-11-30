// import 'package:myklu_flutter/animation/FadeAnimation.dart';
// import 'package:flutter/material.dart';

// void main() => runApp(
//   MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: Login(),
//   )
// );

// class Login extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//           body: Form(
//             key: _key,
//             child: ListView(
//               padding: EdgeInsets.all(13.0),
//               children: <Widget>[
//                 TextFormField(
//                   validator: (e) {
//                     if (e.isEmpty) {
//                       return "Please insert username";
//                     }
//                   },
//                   onSaved: (e) => username = e,
//                   decoration: InputDecoration(labelText: "Username"),
//                 ),
//                 TextFormField(
//                   obscureText: _secureText,
//                   onSaved: (e) => password = e,
//                   decoration: InputDecoration(
//                       labelText: "Password",
//                       suffixIcon: IconButton(
//                         onPressed: showHide,
//                         icon: Icon(
//                             _secureText ? Icons.visibility : Icons.visibility_off),
//                       )),
//                 ),
//                 MaterialButton(
//                   onPressed: () {
//                     check();
//                   },
//                   child: Text("Login"),
//                 ),
//                 InkWell(
//                   onTap: (){
//                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Register()));
//                   },
//                   child: Text("Create a new account", textAlign: TextAlign.center,)
//                 )
//               ],
//             ),
//           ),
//         );
    
//   }
// }



