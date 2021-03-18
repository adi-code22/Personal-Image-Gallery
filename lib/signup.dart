import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "SignUp",
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 100.0),
                TextFormField(
                  validator: (val) => val.isEmpty || !(val.contains('@'))
                      ? 'Enter a valid email address'
                      : null,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (val) => setState(() => _email = val),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  validator: (val) => val.isEmpty || val.length < 6
                      ? 'Enter a password greater than 6 characters'
                      : null,
                  decoration: InputDecoration(labelText: 'Password'),
                  onChanged: (val) => setState(() => _password = val),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          UserCredential user = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _email, password: _password);
                          print(user);
                          Navigator.pushNamed((context), '/home');
                        } catch (e) {
                          print(e.message);
                        }
                      }
                    },
                    child: Text("SignUp")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Already have an Account? LogIn"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
