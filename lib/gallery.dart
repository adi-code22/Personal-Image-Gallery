import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/rendering.dart';
import 'package:internship_main/loading.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool flag = false;
  int _selectedIndex = 1;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User _auth = auth.currentUser;
    String _email = _auth.email;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
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
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Gallery",
            style: TextStyle(color: Colors.orange),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection(_email).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else {
                print("The email is" + _email);
                return ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      print("Hi");
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          child: SingleChildScrollView(
                            // scrollDirection: Axis.horizontal,
                            child: ListTile(
                              tileColor: Colors.orange,
                              title: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: document.data()['img_url'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill)),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Caption: " +
                                                document.data()['caption'],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Divider(
                                            height: 20,
                                            thickness: 0,
                                            color: Colors.red,
                                          ),
                                          Text(
                                            "Location: " +
                                                document.data()['location'],
                                          ),
                                        ],
                                      )
                                      //Image.network(document.data()['img_url']),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                // enlargedImage(
                                //     document.data()['caption'],
                                //     document.data()['location'],
                                //     document.data()['img_url']);
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        title: Text(
                                          "Image Details",
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Caption: " +
                                                    document.data()['caption'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "Location: " +
                                                    document.data()['location'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              CachedNetworkImage(
                                                imageUrl:
                                                    document.data()['img_url'],
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 400,
                                                  width: 900,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit
                                                              .scaleDown)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList());
              }
            },
          ),
        ),
      ),
    );
  }
}
