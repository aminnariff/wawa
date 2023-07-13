import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/screenPelanggan/kedaiMakanan.dart';
import 'package:monkey_app_demo/screenPelanggan/navBarPelanggan.dart';

class DisplayKedai extends StatefulWidget {
  static const routeName = "/displayKedai";

  @override
  _DisplayKedaiState createState() => _DisplayKedaiState();
}

class _DisplayKedaiState extends State<DisplayKedai> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Senarai Kedai Makanan'),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('PelangganUsahawan')
                .where('Role', isEqualTo: 'Usahawan')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No Usahawan found'));
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot userSnapshot = snapshot.data!.docs[index];
                  String email = userSnapshot.get('Email');
                  String username = userSnapshot.get('Username');
                  String address = userSnapshot.get('Alamat');
                  String phoneNo = userSnapshot.get('PhoneNo');

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(Icons.shop), // Add an icon
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kedai: $username',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text('Alamat: $address'),
                          SizedBox(height: 3),
                          Text('No.Telefon: $phoneNo'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                KedaiMakanan(userEmail: email),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomNavBarPelanggan(
              menu: true,
            ),
          ),
        ],
      ),
    );
  }
}
