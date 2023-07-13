import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IklanPelanggan extends StatefulWidget {
  static const routeName = "/iklanPelanggan";
  const IklanPelanggan({Key? key}) : super(key: key);

  @override
  State<IklanPelanggan> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<IklanPelanggan> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  Set<String> likedItems = {}; // Set to store the liked item document IDs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Products'),
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
                labelText: 'Search',
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
                  'Price: RM ${item['itemPrice']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Description: ${item['description']}',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color: likedItems.contains(item.id) ? Colors.blue : null,
                    ),
                    onPressed: () {
                      likeItem(item.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      showCommentDialog(item.id);
                    },
                  ),
                ],
              ),
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
                    final comments = commentsSnapshot.data?.docs;
                    return Column(
                      children: comments!.map((commentDoc) {
                        final comment = commentDoc['comment'];
                        return ListTile(
                          title: Text(comment),
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
      if (likedItems.contains(documentId)) {
        likedItems.remove(documentId);
      } else {
        likedItems.add(documentId);
      }
    });
  }

  void showCommentDialog(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String comment = '';

        return AlertDialog(
          title: Text('Add Comment'),
          content: TextField(
            onChanged: (value) {
              comment = value;
            },
            decoration: InputDecoration(
              labelText: 'Comment',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                saveComment(documentId, comment);
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void saveComment(String documentId, String comment) {
    firestore.collection('sukakomen').add({
      'documentId': documentId,
      'comment': comment,
    });
  }
}
