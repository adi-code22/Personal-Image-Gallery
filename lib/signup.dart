import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_main/loading.dart';
import 'package:internship_main/login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password, _passwordv;
  bool loading = false;
  bool screen = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : screen
            ? LogIn()
            : Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  title: Text(
                    "SignUp",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Form(
                        key: _formKey,
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
                              "N E W    M E M B E R    L O G I N",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              validator: (val) =>
                                  val.isEmpty || !(val.contains('@'))
                                      ? 'Enter a valid email address'
                                      : null,
                              decoration: InputDecoration(labelText: 'Email'),
                              onChanged: (val) => setState(() => _email = val),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              obscureText: true,
                              validator: (val) => val.isEmpty || val.length < 6
                                  ? 'Enter a password greater than 6 characters'
                                  : null,
                              decoration:
                                  InputDecoration(labelText: 'Password'),
                              onChanged: (val) =>
                                  setState(() => _password = val),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password'),
                              onChanged: (val) =>
                                  setState(() => _passwordv = val),
                              validator: (val) => _password == _passwordv
                                  ? null
                                  : "Passwords doesn't match",
                            ),
                            SizedBox(height: 20.0),
                            FlatButton.icon(
                              splashColor: Colors.orange,
                              color: Colors.blue,
                              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                              icon: Icon(Icons.arrow_circle_up,
                                  color: Colors.white, size: 25),
                              onPressed: () async {
                                if (_password == _passwordv) {}
                                if (_formKey.currentState.validate() &&
                                    _password == _passwordv) {
                                  try {
                                    setState(() {
                                      loading = true;
                                    });

                                    UserCredential user = await FirebaseAuth
                                        .instance
                                        .createUserWithEmailAndPassword(
                                            email: _email, password: _password);
                                    print(user);
                                    Navigator.pushNamed((context), '/home');
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
                              label: Text(
                                "SignUp",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                  //Navigator.pushNamed(context, '/login');
                                  setState(() {
                                    screen = true;
                                  });
                                },
                                child: Text("Already have an Account? LogIn"))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
  }
}
