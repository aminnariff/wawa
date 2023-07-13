/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayProduct extends StatelessWidget {
  static const routeName = "/displayProduct";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('products').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name']),
              subtitle: Text(data['price'].toString()),
            );
          }).toList(),
        );
      },
    );
  }
}*/

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:monkey_app_demo/screens/user_provider.dart';
import 'package:provider/provider.dart';

class DisplayProduct extends StatefulWidget {
  static const routeName = "/displayProduct";
  final String username;

  DisplayProduct({Key? key, required this.username}) : super(key: key);

  @override
  State<DisplayProduct> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<DisplayProduct> {
  // Add a variable to store the current item being edited/deleted
  DocumentSnapshot? currentItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Products'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('productList').snapshots(),
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return LayoutBuilder(builder: (context, constraints) {
              return constraints.maxWidth < 600
                  ? Container(
                      child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: ((context, index) {
                          return cartItemWidget(
                              context, snapshot, index, widget.username);
                        }),
                      ),
                    )
                  : Container(
                      child: snapshot.data.docs.length > 0
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 0.02,
                                crossAxisSpacing: 0.02,
                              ),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cartItemWidget(
                                    context, snapshot, index, widget.username);
                              })
                          : Container(
                              child: Center(
                                child: Text(
                                  'No item found',
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ),
                    );
            });
          } else {
            return Container();
          }
        }),
      ),
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(
            25,
          ),
        ),
        child: TextButton(
          // onPressed: () {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(builder: ((context) => AddProduct())),
          //   );
          // },
          onPressed: () {},
          child: Text(
            'Tambah',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Card cartItemWidget(
    BuildContext context,
    AsyncSnapshot<dynamic> snapshot,
    int index,
    String username, // Add username parameter
  ) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: $username'), // Display the username
            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                items: new List<String>.from(
                  snapshot.data.docs[index]['itemImageUrl'],
                ).map(
                  (i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(i)),
                          ),
                        );
                      },
                    );
                  },
                ).toList(),
              ),
            ),
            Container(
              child: Text('${snapshot.data.docs[index]['itemName']}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Price : RM ${snapshot.data.docs[index]['itemPrice']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Description : ${snapshot.data.docs[index]['description']}',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Set the currentItem to the selected item
                    setState(() {
                      currentItem = snapshot.data.docs[index];
                    });
                    // Call the edit function
                    _editItem();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Set the currentItem to the selected item
                    setState(() {
                      currentItem = snapshot.data.docs[index];
                    });
                    // Call the delete function
                    _deleteItem();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(currentItem: currentItem!),
      ),
    );
  }

  void _deleteItem() {
    currentItem?.reference.delete().then((_) {
      // Item deleted successfully
    }).catchError((error) {
      // Handle any errors that occurred during the delete
      print('Error deleting item: $error');
    });
  }
}

class EditItemPage extends StatefulWidget {
  final DocumentSnapshot currentItem;

  EditItemPage({Key? key, required this.currentItem}) : super(key: key);

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.currentItem['itemName']);
    priceController =
        TextEditingController(text: widget.currentItem['itemPrice'].toString());
    descriptionController =
        TextEditingController(text: widget.currentItem['description']);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateItem(
                  nameController.text,
                  double.parse(priceController.text),
                  descriptionController.text,
                );
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateItem(String name, double price, String description) {
    widget.currentItem.reference.update({
      'itemName': name,
      'itemPrice': price,
      'description': description,
    }).then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      print('Error updating item: $error');
    });
  }
}
