import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:internship_main/home.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:internship_main/loading.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email, password;
  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // final User _user = _auth.currentUser;
    // final checkmail = _user.email;

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return loading
        ? Loading()
        : Scaffold(
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
                              setState(() {
                                loading = true;
                              });
                              try {
                                UserCredential user = await FirebaseAuth
                                    .instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: password);
                                print(user);
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              } catch (e) {
                                print(e.message);
                                String error = e.message.toString();
                                loading = false;
                                Navigator.pushReplacementNamed(
                                    context, '/signup');
                                final loginerror =
                                    SnackBar(content: Text(error));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(loginerror);
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
