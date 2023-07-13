import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monkey_app_demo/screenUsahawan/addKosmetik.dart';
import 'package:monkey_app_demo/screenUsahawan/addMakanan.dart';
import 'package:monkey_app_demo/screenUsahawan/addPakaian.dart';
import 'package:monkey_app_demo/screenUsahawan/homeScreenUsahawan.dart';

import 'package:flutter/material.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayKosmetik extends StatefulWidget {
  static const routeName = "/displayKosmetik";
  const DisplayKosmetik({Key? key}) : super(key: key);

  @override
  State<DisplayKosmetik> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<DisplayKosmetik> {
  // Add a variable to store the current item being edited/deleted
  late DocumentSnapshot currentItem;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    String? currentEmail = currentUser?.email; //hold email current user
    return Scaffold(
      appBar: AppBar(
        title: Text('Senarai Produk'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreenUsahawan(),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('kosmetik').snapshots(),
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
                          // Check if the email matches the current user's email
                          if (snapshot.data.docs[index]['email'] ==
                              currentEmail) {
                            return cartItemWidget(context, snapshot, index);
                          } else {
                            return Container(); // Return an empty container if email doesn't match
                          }
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
                                return cartItemWidget(context, snapshot, index);
                              })
                          : Container(
                              child: Center(
                                child: Text(
                                  'Tiada',
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
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) => AddKosmetik())),
            );
          },
          child: Text(
            'Tambah',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Card cartItemWidget(
      BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                '${snapshot.data.docs[index]['email']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
                'Harga : RM ${snapshot.data.docs[index]['itemPrice']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Penerangan : ${snapshot.data.docs[index]['description']}',
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: GestureDetector(
            //     onTap: () {
            //       _launchURL(snapshot.data.docs[index]['link']);
            //     },
            //     child: Text(
            //       'Link Pautan : ${snapshot.data.docs[index]['link']}',
            //       style: TextStyle(
            //         decoration: TextDecoration.underline,
            //         color: Colors.blue,
            //       ),
            //     ),
            //   ),
            // ),
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
                    _confirmDelete();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pengesahan'),
          content: Text('Anda yakin ingin memadam produk ini?'),
          actions: [
            TextButton(
              child: Text('Teruskan'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteItem(); // Proceed with item deletion
              },
            ),
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _editItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(currentItem: currentItem),
      ),
    );
  }

  void _deleteItem() {
    currentItem.reference.delete().then((_) {
      // Item deleted successfully
    }).catchError((error) {
      // Handle any errors that occurred during the delete
      print('Ralat memadam data: $error');
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
  late TextEditingController shopNameController;
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController linkController;

  @override
  void initState() {
    super.initState();

    shopNameController =
        TextEditingController(text: widget.currentItem['shopName']);
    nameController =
        TextEditingController(text: widget.currentItem['itemName']);
    priceController =
        TextEditingController(text: widget.currentItem['itemPrice'].toString());
    descriptionController =
        TextEditingController(text: widget.currentItem['description']);
    linkController = TextEditingController(text: widget.currentItem['link']);
  }

  @override
  void dispose() {
    shopNameController.dispose();
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kemaskini'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Penerangan'),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _updateItem(
                    shopNameController.text,
                    nameController.text,
                    double.parse(priceController.text),
                    descriptionController.text,
                    linkController.text,
                  );
                },
                child: Text('Kemaskini'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateItem(
    String shopName,
    String name,
    double price,
    String description,
    String link,
  ) {
    String priceString = price.toStringAsFixed(
        2); // Convert the price to a string with 2 decimal places
    widget.currentItem.reference.update({
      'shopName': shopName,
      'itemName': name,
      'itemPrice': priceString,
      'description': description,
      'link': link,
    }).then((_) {
      Fluttertoast.showToast(
        msg: 'Maklumat telah dikemaskini',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pop(context);
    }).catchError((error) {
      print('Ralat kemaskini data: $error');
    });
  }
}
