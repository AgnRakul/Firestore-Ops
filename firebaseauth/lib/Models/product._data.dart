import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  late final String productName;
  late final int productRate;
  late final String productSeason;
  late final String productDescription;

  Product(
    this.productName,
    this.productRate,
    this.productSeason,
    this.productDescription,
  );

  Map<String, dynamic> toMap() {
    return {
      'ProductName': productName,
      'ProductRate': productRate,
      'ProductCategory': productSeason,
      'ProductDescription': productDescription,
    };
  }

  Product.fromMap(DocumentSnapshot doc)
      : productName = doc['ProductName'],
        productRate = doc['ProductRate'],
        productSeason = doc['ProductSeason'],
        productDescription = doc['ProductDescription'];
}
