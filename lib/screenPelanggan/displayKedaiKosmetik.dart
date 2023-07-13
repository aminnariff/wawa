import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monkey_app_demo/screenPelanggan/kedaiKosmetik.dart';
import 'package:monkey_app_demo/screenPelanggan/kedaiPakaian.dart';
import 'package:monkey_app_demo/screenPelanggan/navBarPelanggan.dart';

class DisplayKedaiKosmetik extends StatefulWidget {
  static const routeName = "/DisplayKedaiKosmetik";

  @override
  _DisplayKedaiState createState() => _DisplayKedaiState();
}

class _DisplayKedaiState extends State<DisplayKedaiKosmetik> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Senarai Kedai Kosmetik'),
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
                                KedaiKosmetik(userEmail: email),
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
              home: true,
            ),
          ),
        ],
      ),
    );
  }
}
