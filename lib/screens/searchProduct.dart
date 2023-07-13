import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  static const routeName = "/search";
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<Search> {
  String searchQuery = '';

  Future<void> searchProduct(String productName) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('iklan')
        .where('itemName', isEqualTo: productName)
        .get();

    // Access the documents in the snapshot and handle the results
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.docs;
    for (var document in documents) {
      // Access the product data
      Map<String, dynamic> data = document.data();
      // Handle the data as needed
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carian Produk"),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            onSubmitted: (value) {
              searchProduct(value);
            },
            decoration: InputDecoration(
              labelText: 'Cari Produk',
            ),
          ),
          // Rest of your widget tree
        ],
      ),
    );
  }
}
