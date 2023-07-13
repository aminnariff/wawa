import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/screenPelanggan/homePelanggan.dart';

class DisplayIklanPelanggan extends StatefulWidget {
  static const routeName = "/DisplayIklanPelanggan";
  const DisplayIklanPelanggan({Key? key}) : super(key: key);

  @override
  State<DisplayIklanPelanggan> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<DisplayIklanPelanggan> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  Map<String, int> likedItems =
      {}; // Map to store the liked item document IDs and their counts

  String currentUserEmail = ''; // Replace with actual current user's email
  String currentUsername = ''; // To store the username

  void getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserEmail = user.email!;
        fetchUsername(currentUserEmail);
      });
    }
  }

  Future<void> fetchUsername(String email) async {
    try {
      final snapshot = await firestore
          .collection('PelangganUsahawan')
          .where('Email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final username = snapshot.docs.first['Username'];
        setState(() {
          currentUsername = username;
        });
      }
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iklan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePelanggan(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Carian',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: firestore.collection('iklan').snapshots(),
              builder: ((context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  final filteredDocs = snapshot.data.docs.where((doc) {
                    final itemName = doc['itemName'].toString().toLowerCase();
                    return itemName.contains(searchTerm.toLowerCase());
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(
                      child: Text(
                        'No item found',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    );
                  }

                  return LayoutBuilder(builder: (context, constraints) {
                    return constraints.maxWidth < 600
                        ? Container(
                            child: ListView.builder(
                              itemCount: filteredDocs.length,
                              itemBuilder: ((context, index) {
                                return cartItemWidget(
                                  context,
                                  filteredDocs[index],
                                );
                              }),
                            ),
                          )
                        : Container(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 0.02,
                                crossAxisSpacing: 0.02,
                              ),
                              itemCount: filteredDocs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cartItemWidget(
                                  context,
                                  filteredDocs[index],
                                );
                              },
                            ),
                          );
                  });
                } else {
                  return Container();
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Card cartItemWidget(BuildContext context, DocumentSnapshot item) {
    var itemImageUrl =
        'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.flaticon.com%2Ffree-icon%2Fprofile_3135715&psig=AOvVaw1EjtQMVD7SOZvSp3GOgGMf&ust=1685437716614000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCIDMovWWmv8CFQAAAAAdAAAAABAE';
    //snapshot.data.docs[index]['itemImageUrl']; // Get the itemImageUrl
    // Print the itemImageUrl
    return Card(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Container(
                child: Text('${item['email']}'),
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height *
                    0.3, // Adjust the height as needed
                child: SingleChildScrollView(
                  child: CarouselSlider(
                    options: CarouselOptions(),
                    items: List<String>.from(
                      item['itemImageUrl'],
                    ).map((i) {
                      return Image.network(i);
                    }).toList(),
                  ),
                ),
              ),
              Container(
                child: Text('${item['itemName']}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Harga: RM ${item['itemPrice']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Penerangan: ${item['description']}',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color:
                          likedItems.containsKey(item.id) ? Colors.blue : null,
                    ),
                    onPressed: () {
                      likeItem(item.id);
                    },
                  ),
                  Text(
                    '${likedItems[item.id] ?? 0}', // Display the like count
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      showCommentDialog(item.id);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Komen produk:'),
              SizedBox(height: 10),
              StreamBuilder(
                stream: firestore
                    .collection('sukakomen')
                    .where('documentId', isEqualTo: item.id)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> commentsSnapshot) {
                  if (commentsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (commentsSnapshot.hasData) {
                    final comments = commentsSnapshot.data!.docs;
                    return Column(
                      children: comments.map((commentDoc) {
                        final UserUsername = commentDoc['currentUserUsername'];
                        final comment = commentDoc['comment'];

                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                '$UserUsername',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(comment),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void likeItem(String documentId) {
    setState(() {
      if (likedItems.containsKey(documentId)) {
        // Item is already liked, so unlike it
        likedItems.remove(documentId); // Remove from liked items
      } else {
        // Item is not liked, so like it
        likedItems[documentId] = 1; // Add to liked items with count 1
      }
    });
  }

  void showCommentDialog(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String comment = '';

        return AlertDialog(
          title: Text('Tambah komen'),
          content: TextField(
            onChanged: (value) {
              comment = value;
            },
            decoration: InputDecoration(
              labelText: 'Komen',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                saveComment(
                    documentId, comment, currentUserEmail, currentUsername);
                Navigator.of(context).pop();
              },
              child: Text('Hantar'),
            ),
          ],
        );
      },
    );
  }

  void saveComment(String documentId, String comment, String currentUserEmail,
      String currentUserUsername) {
    firestore.collection('sukakomen').add({
      'documentId': documentId,
      'comment': comment,
      'currentUserEmail': currentUserEmail,
      'currentUserUsername': currentUserUsername,
    });
  }
}
