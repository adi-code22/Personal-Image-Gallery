import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:internship_main/home.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email, password;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "LogIn",
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 100.0),
                TextFormField(
                  validator: (val) => val.isEmpty || !(val.contains('@'))
                      ? 'Enter a valid email address'
                      : null,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (val) => setState(() => email = val),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  validator: (val) => val.isEmpty || val.length < 6
                      ? 'Enter a password greater than 6 characters'
                      : null,
                  decoration: InputDecoration(labelText: 'Password'),
                  onChanged: (val) => setState(() => password = val),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        try {
                          UserCredential user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          print(user);
                          Navigator.pushNamed(context, '/home');
                        } catch (e) {
                          print(e.message);
                        }
                      }
                    },
                    child: Text("LogIn")),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed((context), '/signup');
                    },
                    child: Text("New User? Sign Up"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
