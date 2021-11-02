// ignore_for_file: must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseauth/Pages/add_product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hai"),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var database = FirebaseFirestore.instance.collection('Product').snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Data'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: database,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LinearProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        // leading: Icon(Icons.arrow_drop_down_circle),
                        title: Text(
                          snapshot.data!.docs[index]['ProductName'],
                          style: GoogleFonts.cabin(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                        subtitle: Text(
                          "Season: ${snapshot.data!.docs[index]['ProductCategory']}",
                          style: GoogleFonts.cabin(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('Product')
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                          },
                          icon: Icon(Icons.delete_sweep_rounded),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: AutoSizeText(
                          snapshot.data!.docs[index]['ProductDescription'],
                          style: GoogleFonts.cabin(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 240, top: 10, bottom: 10),
                        child: AutoSizeText(
                          " Rate: ${snapshot.data!.docs[index]['ProductRate'].toString()}",
                          style: GoogleFonts.cabin(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddProduct();
          })).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
