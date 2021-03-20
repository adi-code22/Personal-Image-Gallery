import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:internship_main/home.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:internship_main/loading.dart';
import 'package:internship_main/signup.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email, password;
  bool loading = false;
  bool screen = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // final User _user = _auth.currentUser;
    // final checkmail = _user.email;

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return loading
        ? Loading()
        : screen
            ? SignUp()
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
                          SizedBox(height: 40.0),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: new NetworkImage(
                                'png.pngtree.com/png-vector/20190710/ourmid/pngtree-user-vector-avatar-png-image_1541962.jpg'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "M E M B E R    L O G I N",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty || !(val.contains('@'))
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
                          FlatButton.icon(
                            splashColor: Colors.orange,
                            icon: Icon(
                              Icons.login,
                              color: Colors.white,
                              size: 25,
                            ),
                            color: Colors.blue,
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                                  Navigator.pushNamed(context, '/home');
                                } catch (e) {
                                  print(e.message);
                                  String error = e.message.toString();

                                  // Navigator.pushNamed(context, '/signup');
                                  setState(() {
                                    loading = false;
                                    screen = true;
                                  });
                                  final loginerror =
                                      SnackBar(content: Text(error));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(loginerror);
                                }
                              }
                            },
                            label: Text(
                              "LogIn",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                //Navigator.pushNamed((context), '/signup');
                                setState(() {
                                  screen = true;
                                });
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
