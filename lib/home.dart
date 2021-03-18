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
  String caption, location;

  int _selectedIndex = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  //firebase_storage.UploadTask uploadTask =

  FirebaseFirestore firestore1 = FirebaseFirestore.instance;
  CollectionReference firestore =
      FirebaseFirestore.instance.collection("user_images");

  Future<void> upload() async {
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = _image.path;
    print(filePath);
    //'${appDocDir.absolute}/file-to-upload.png';
    await uploadFile(filePath);
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    final User user = auth.currentUser;
    final email = user.email;

    try {
      firebase_storage.UploadTask task = firebase_storage
          .FirebaseStorage.instance
          .ref('$email/${DateTime.now()}.png')
          .putFile(file);
      firebase_storage.TaskSnapshot snapshot = await task;
    } catch (e) {
      // e.g, e.code == 'canceled'
    }
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('$email/${DateTime.now()}.png')
        .getDownloadURL();

    firestore.doc('iDetails').set({'uid': downloadURL});
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

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                  }),
              _image == null
                  ? Container()
                  : Image.file(
                      _image,
                      // scale: 3,
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: "Write a caption"),
                        onChanged: (val) => setState(() {
                          //save this to firestroe
                        }),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Where was this photo taken?"),
                        onChanged: (val) => setState(() {
                          //save this to firestore
                        }),
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
                    upload();
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Uploading...",
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
                              children: [],
                            ),
                          ),
                        );
                      },
                    );
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
