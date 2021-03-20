import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _image;
  String caption = "", location = "";

  int _selectedIndex = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  //firebase_storage.UploadTask uploadTask =

  FirebaseFirestore firestore1 = FirebaseFirestore.instance;

  Future<void> upload(String caption, String location) async {
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = _image.path;
    print(filePath);
    //'${appDocDir.absolute}/file-to-upload.png';
    await uploadFile(filePath, caption, location);
  }

  Future<void> uploadFile(String filePath, caption, location) async {
    File file = File(filePath);
    final User user = auth.currentUser;
    final email = user.email;
    CollectionReference firestore =
        FirebaseFirestore.instance.collection(email);
    String dt = DateTime.now().toString();

    try {
      firebase_storage.UploadTask task = firebase_storage
          .FirebaseStorage.instance
          .ref('$email/$dt.png')
          .putFile(file);
      firebase_storage.TaskSnapshot snapshot = await task;
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('$email/$dt.png')
          .getDownloadURL();

      firestore.add({
        'img_url': downloadURL,
        'caption': caption,
        'location': location,
      });
    } catch (e) {
      print(e);
      String error = e.message.toString();

      final loginerror = SnackBar(content: Text(error));
      ScaffoldMessenger.of(context).showSnackBar(loginerror);
      // e.g, e.code == 'canceled'
    }
  }

  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = image;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.pushNamed(context, '/gallery');
    }
  }

  captureImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = image;
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controlcaption = TextEditingController();
  final TextEditingController controllocation = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(content: Text('Please Upload an Image!'));
    final snackBarSuccess =
        SnackBar(content: Text('File Successfully Uploaded'));
    final User user = auth.currentUser;
    final uid = user.email;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        //elevation: 300.0,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Gallery',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Text(
                "Log Out",
                style: TextStyle(color: Colors.orange),
              ),
              IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  }),
            ],
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Upload",
          style: TextStyle(color: Colors.orange),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text("Hi, $uid"),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Upload Image",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            content: Container(
                              height: 150,
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FlatButton(
                                      onPressed: () {
                                        captureImage();
                                        Navigator.pop(context);
                                      },
                                      splashColor: Colors.orange,
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Text(
                                        "Photo with Camera",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  FlatButton(
                                      onPressed: () {
                                        pickImage();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Photo from Gallery",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.black),
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      "Upload",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    color: Colors.orange,
                    padding: EdgeInsets.fromLTRB(65, 15, 65, 15),
                  ),
                ],
              ),
              _image != null
                  ? IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () {
                        setState(() {
                          _image = null;
                          caption = null;
                          location = null;
                          controlcaption.clear();
                          controllocation.clear();
                        });
                      })
                  : SizedBox(
                      height: 0,
                    ),
              _image == null
                  ? Container()
                  : Container(
                      height: 335,
                      width: 335,
                      child: Image.file(
                        _image,
                        // scale: 3,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controlcaption,
                        decoration:
                            InputDecoration(labelText: "Write a caption"),
                        onChanged: (val) => setState(() {
                          //save this to firestore
                          caption = val;
                        }),
                        validator: (val) =>
                            val.isEmpty ? "Please provide a caption" : null,
                      ),
                      TextFormField(
                        controller: controllocation,
                        decoration: InputDecoration(
                            labelText: "Where was this photo taken?"),
                        onChanged: (val) => setState(() {
                          //save this to firestore
                          location = val;
                        }),
                        validator: (val) =>
                            val.isEmpty ? "Please provide a location" : null,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  onPressed: () {
                    if (_image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    if (formKey.currentState.validate()) {
                      upload(caption, location);
                      return ScaffoldMessenger.of(context)
                          .showSnackBar(snackBarSuccess);
                      // return showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       actions: [
                      //         Text(
                      //           "File was Successfully Uploaded",
                      //           style: TextStyle(
                      //               color: Colors.orange,
                      //               fontWeight: FontWeight.bold,
                      //               fontSize: 20),
                      //         ),
                      //       ],
                      //       content: Container(
                      //         height: 150,
                      //         width: 100,
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: [],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                    }
                  },
                  color: Colors.orange,
                  padding: EdgeInsets.fromLTRB(65, 15, 65, 15),
                  child: Text(
                    "Submit",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
