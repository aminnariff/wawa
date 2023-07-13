/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../utils/helper.dart';
import '../widgets/customNavBar.dart';
import 'landingScreen.dart';

class DisplayProfile extends StatefulWidget {
  static const routeName = "/displayProfile";

  @override
  _DisplayProfileState createState() => _DisplayProfileState();
}

class _DisplayProfileState extends State<DisplayProfile> {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('PelangganUsahawan');
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    alamatController.dispose();
    phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              height: Helper.getScreenHeight(context),
              width: Helper.getScreenWidth(context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ClipOval(
                        child: Stack(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              child: Image.asset(
                                Helper.getAssetName(
                                  "profilepicture.jpg",
                                  "real",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 20,
                                width: 80,
                                color: Colors.black.withOpacity(0.3),
                                child: Image.asset(
                                  Helper.getAssetName("camera.png", "virtual"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Helper.getAssetName("edit_filled.png", "virtual"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Edit Profile",
                            style: TextStyle(color: AppColor.orange),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Hi there!",
                        style: Helper.getTheme(context)
                            .headline4
                            .copyWith(color: AppColor.primary),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: userCollection
                              .where('Email',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser.email)
                              .where('Role', isEqualTo: 'Usahawan'
                                  //   .where('Role', whereIn: [
                                  // 'Pelanggan',
                                  // 'Usahawan'
                                  // ]
                                  ) // Modify this line to filter by role
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Loading...');
                            }

                            if (snapshot.hasData) {
                              final documents = snapshot.data.docs;
                              if (documents.isEmpty) {
                                return Text('Tiada dalam pangkalan data.');
                              }

                              final documentData =
                                  documents[0].data() as Map<String, dynamic>;
                              usernameController.text =
                                  documentData['Username'];
                              emailController.text = documentData['Email'];
                              alamatController.text = documentData['Alamat'];
                              phoneNoController.text = documentData['PhoneNo'];

                              // // Add this condition to check for the role
                              // if (documentData.containsKey('Role')) {
                              //   String role = documentData[''];
                              //   // Do something with the role if needed
                              // }
                              return Form(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: usernameController,
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                      ),
                                    ),
                                    TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                      ),
                                    ),
                                    TextFormField(
                                      controller: alamatController,
                                      decoration: InputDecoration(
                                        labelText: 'Alamat',
                                      ),
                                    ),
                                    TextFormField(
                                      controller: phoneNoController,
                                      decoration: InputDecoration(
                                        labelText: 'No Telefon',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 150,
                                    ),
                                    SizedBox(
                                        height: 40,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Save the updated details here
                                            String username =
                                                usernameController.text;
                                            String email = emailController.text;
                                            String alamat =
                                                alamatController.text;
                                            String phoneNo =
                                                phoneNoController.text;

                                            // Get the reference to the user's document
                                            final userDocRef =
                                                userCollection.doc(FirebaseAuth
                                                    .instance
                                                    .currentUser
                                                    .email);

                                            // Perform the update using the update() method
                                            userDocRef.update({
                                              'Username': username,
                                              'Email': email,
                                              'Alamat': alamat,
                                              'PhoneNo': phoneNo,
                                            }).then((_) {
                                              // Update successful
                                              print(
                                                  'Profile updated successfully');
                                            }).catchError((error) {
                                              // Error occurred during update
                                              print(
                                                  'Error updating profile: $error');
                                            });
                                          },
                                          child: Text('Kemaskini'),
                                        )),
                                  ],
                                ),
                              );
                            }

                            return Text('Tiada dalam pangkalan data.');
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => LandingScreen(),
                              ),
                            );
                          },
                          child: Text("Log Keluar"),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomNavBar(
              profile: true,
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../utils/helper.dart';
import '../widgets/customNavBar.dart';
import 'landingScreen.dart';

class DisplayProfile extends StatefulWidget {
  static const routeName = "/displayProfile";

  @override
  _DisplayProfileState createState() => _DisplayProfileState();
}

class _DisplayProfileState extends State<DisplayProfile> {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('PelangganUsahawan');
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    alamatController.dispose();
    phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              height: Helper.getScreenHeight(context),
              width: Helper.getScreenWidth(context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ClipOval(
                        child: Stack(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              child: Image.asset(
                                Helper.getAssetName(
                                  "profilepicture.jpg",
                                  "real",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 20,
                                width: 80,
                                color: Colors.black.withOpacity(0.3),
                                child: Image.asset(
                                  Helper.getAssetName("camera.png", "virtual"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Helper.getAssetName("edit_filled.png", "virtual"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Kedai",
                            style: TextStyle(color: AppColor.orange),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Selamat Datang!",
                        style: Helper.getTheme(context)
                            .headline4
                            ?.copyWith(color: AppColor.primary),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: userCollection
                              .where('Email',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser?.email)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Loading...');
                            }

                            if (snapshot.hasData) {
                              final documents = snapshot.data?.docs;
                              if (documents!.isEmpty) {
                                return Text('Tiada dalam pangkalan data.');
                              }

                              final documentData =
                                  documents[0].data() as Map<String, dynamic>;
                              final role = documentData['Role'];

                              // Display specific details based on role
                              if (role == 'Usahawan') {
                                usernameController.text =
                                    documentData['Username'];
                                emailController.text = documentData['Email'];
                                alamatController.text = documentData['Alamat'];
                                phoneNoController.text =
                                    documentData['PhoneNo'];
                              }
                              if (role == 'Pelanggan') {
                                usernameController.text =
                                    documentData['Username'];
                                emailController.text = documentData['Email'];
                                alamatController.text = documentData['Alamat'];
                                phoneNoController.text =
                                    documentData['PhoneNo'];
                              }
                              if (role == 'UsahawanUKM') {
                                usernameController.text =
                                    documentData['Username'];
                                emailController.text = documentData['Email'];
                                alamatController.text = documentData['Alamat'];
                                phoneNoController.text =
                                    documentData['PhoneNo'];
                              }

                              return Form(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: usernameController,
                                      decoration: InputDecoration(
                                        labelText: 'Nama Kedai :',
                                      ),
                                    ),
                                    TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        labelText: 'E-mel :',
                                      ),
                                    ),
                                    TextFormField(
                                      controller: alamatController,
                                      decoration: InputDecoration(
                                        labelText: 'Alamat :',
                                      ),
                                    ),
                                    TextFormField(
                                      controller: phoneNoController,
                                      decoration: InputDecoration(
                                        labelText: 'No Telefon :',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 150,
                                    ),
                                    // SizedBox(
                                    //   height: 40,
                                    //   width: double.infinity,
                                    //   child: ElevatedButton(
                                    //     onPressed: () {
                                    //       // Save the updated details here
                                    //       String username =
                                    //           usernameController.text;
                                    //       String email = emailController.text;
                                    //       String alamat = alamatController.text;
                                    //       String phoneNo =
                                    //           phoneNoController.text;

                                    //       // Get the reference to the user's document
                                    //       final userDocRef = userCollection.doc(
                                    //           FirebaseAuth
                                    //               .instance.currentUser.email);

                                    //       // Perform the update using the update() method
                                    //       userDocRef.update({
                                    //         'Username': username,
                                    //         'Email': email,
                                    //         'Alamat': alamat,
                                    //         'PhoneNo': phoneNo,
                                    //       }).then((_) {
                                    //         // Update successful
                                    //         print(
                                    //             'Profile updated successfully');
                                    //       }).catchError((error) {
                                    //         // Error occurred during update
                                    //         print(
                                    //             'Error updating profile: $error');
                                    //       });
                                    //     },
                                    //     child: Text('Kemaskini'),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              );
                            }

                            return Text('Tiada dalam pangkalan data.');
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // SizedBox(
                      //   height: 40,
                      //   width: double.infinity,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.of(context).pushReplacement(
                      //         MaterialPageRoute(
                      //           builder: (_) => LandingScreen(),
                      //         ),
                      //       );
                      //     },
                      //     child: Text("Log Keluar"),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 40,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomNavBar(
              profile: true,
            ),
          ),
        ],
      ),
    );
  }
}
