// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productIdController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productRateController = TextEditingController();
  TextEditingController productSeasonController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    productRateController.dispose();
    productSeasonController.dispose();
    productDescriptionController.dispose();

    productIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add and Update Products'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: productIdController,
                    decoration: InputDecoration(labelText: "Product Id"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: productNameController,
                    decoration: InputDecoration(labelText: "Product Name"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: productRateController,
                    decoration: InputDecoration(labelText: "Product Rate"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: productSeasonController,
                    decoration: InputDecoration(labelText: "Product Season"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: productDescriptionController,
                    decoration:
                        InputDecoration(labelText: "Product Description"),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
              child: ElevatedButton(
                child: Text("Add Product"),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('Product')
                      .doc(productIdController.text)
                      .set({
                    'ProductName': productNameController.text,
                    'ProductRate': int.parse(productRateController.text),
                    'ProductCategory': productSeasonController.text,
                    'ProductDescription': productDescriptionController.text,
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SizedBox(
            width: 100,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
              child: ElevatedButton(
                child: Text("Update Product"),
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('Product')
                        .doc(productIdController.text)
                        .set({
                      'ProductName': productNameController.text,
                      'ProductRate': int.parse(productRateController.text),
                      'ProductCategory': productSeasonController.text,
                      'ProductDescription': productDescriptionController.text,
                    }, SetOptions(merge: true));
                  } catch (e) {
                    print(e);
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
