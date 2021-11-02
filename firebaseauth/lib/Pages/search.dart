// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unrelated_type_equality_checks

// import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController? searchController;
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  String? searchString;
  @override
  Widget build(BuildContext context) {
    // var database = FirebaseFirestore.instance;
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: TextField(
                    onSubmitted: (val) {
                      setState(() {
                        searchString = val;
                      });
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search Product",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          searchController?.clear();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Product')
                        .where('ProductCategory', isEqualTo: searchString)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("${snapshot.error}"),
                        );
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return LinearProgressIndicator();

                        case ConnectionState.none:
                          return Text('Error');

                        case ConnectionState.done:
                          return Text("We are Done");

                        default:
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
                                        snapshot.data!.docs[index]
                                            ['ProductName'],
                                        style: GoogleFonts.cabin(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(0.6)),
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
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .delete();
                                        },
                                        icon: Icon(Icons.delete_sweep_rounded),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: AutoSizeText(
                                        snapshot.data!.docs[index]
                                            ['ProductDescription'],
                                        style: GoogleFonts.cabin(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(0.6)),
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
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                      }
                    }),
              )
            ],
          ))
        ],
      )),
    );
  }
}
