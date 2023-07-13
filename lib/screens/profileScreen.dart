/*import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/customNavBar.dart';
import 'package:monkey_app_demo/widgets/customTextInput.dart';

import 'landingScreen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = "/profileScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profil",
                            style: Helper.getTheme(context).headline5,
                          ),
                          Image.asset(
                            Helper.getAssetName("cart.png", "virtual"),
                          )
                        ],
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
                                  "user.jpg",
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
                                child: Image.asset(Helper.getAssetName(
                                    "camera.png", "virtual")),
                              ),
                            )
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
                        "Hi there !",
                        style: Helper.getTheme(context).headline4.copyWith(
                              color: AppColor.primary,
                            ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => LandingScreen()),
                            );
                          },
                          child: Text("Sign Out"),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      CustomFormImput(
                        label: "Name",
                        value: "Emilia Clarke",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomFormImput(
                        label: "Email",
                        value: "emiliaclarke@email.com",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomFormImput(
                        label: "Mobile No",
                        value: "emiliaclarke@email.com",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomFormImput(
                        label: "Address",
                        value: "No 23, 6th Lane, Colombo 03",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomFormImput(
                        label: "Password",
                        value: "Emilia Clarke",
                        isPassword: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomFormImput(
                        label: "Confirm Password",
                        value: "Emilia Clarke",
                        isPassword: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Save"),
                        ),
                      )
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

class CustomFormImput extends StatelessWidget {
  const CustomFormImput({
    Key? key,
    String label,
    String value,
    bool isPassword = false,
  })  : _label = label,
        _value = value,
        _isPassword = isPassword,
        super(key: key);

  final String _label;
  final String _value;
  final bool _isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(left: 40),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.placeholderBg,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: _label,
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
        ),
        obscureText: _isPassword,
        initialValue: _value,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}*/

//x menjadi
/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profileScreen";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _imageFile;
  String _imageUrl;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  Future<void> _selectAndUploadImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<String> _uploadProfilePicture(File imageFile, String userId) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('profilePictures/$userId.jpg');

    final UploadTask uploadTask = storageRef.putFile(imageFile);

    final TaskSnapshot storageSnapshot =
        await uploadTask.whenComplete(() => null);

    final String downloadUrl = await storageSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<void> _updateUserProfile(String userId) async {
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection('profil').doc(userId);

    await userRef.update({
      'name': _nameController.text,
      'address': _addressController.text,
      'email': _emailController.text,
      'phoneNumber': _phoneNumberController.text,
    });
  }

  Future<void> _updateProfile() async {
    try {
      // Step 1: Upload the new profile picture to Firebase Storage
      if (_imageFile != null) {
        _imageUrl = await _uploadProfilePicture(_imageFile, 'userId');
      }

      // Step 2: Update the user's profile data in Firestore
      await _updateUserProfile('userId');

      print('Profile updated successfully!');
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _selectAndUploadImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile)
                      : _imageUrl != null
                          ? NetworkImage(_imageUrl)
                          : AssetImage('assets/default_profile.png'),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'landingScreen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profileScreen";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Uint8List _imageBytes;
  late String _imageUrl;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  // Future<void> _selectAndUploadImage() async {
  //   final fileUploadInputElement = FileUploadInputElement();
  //   fileUploadInputElement.accept = 'image/*';
  //   fileUploadInputElement.click();

  //   fileUploadInputElement.onChange.listen((e) {
  //     final files = fileUploadInputElement.files;
  //     if (files?.length == 1) {
  //       final reader = FileReader();
  //       reader.readAsArrayBuffer(files![0]);
  //       reader.onLoadEnd.listen((event) {
  //         final bytes = reader.result as Uint8List;
  //         setState(() {
  //           _imageBytes = bytes;
  //         });
  //       });
  //     }
  //   });
  // }

  Future<String> _uploadProfilePicture(Uint8List imageBytes, String userId) async {
    final Reference storageRef = FirebaseStorage.instance.ref().child('profilePictures/$userId.jpg');

    final UploadTask uploadTask = storageRef.putData(imageBytes);

    final TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);

    final String downloadUrl = await storageSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  /*Future<void> _updateUserProfile(String userId) async {
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.update({
      'name': _nameController.text,
      'address': _addressController.text,
      'email': _emailController.text,
      'phoneNumber': _phoneNumberController.text,
    });
  }*/

  Future<void> _updateUserProfile(String userId) async {
    final DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      await userRef.update({
        'name': _nameController.text,
        'address': _addressController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
      });
    } else {
      await userRef.set({
        'name': _nameController.text,
        'address': _addressController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      // Step 1: Upload the new profile picture to Firebase Storage
      _imageUrl = await _uploadProfilePicture(_imageBytes, 'userId');

      // Step 2: Update the user's profile data in Firestore
      await _updateUserProfile('userId');

      print('Profile updated successfully!');
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // GestureDetector(
              //   onTap: _selectAndUploadImage,
              //   child: CircleAvatar(
              //     radius: 50,
              //     backgroundImage: _imageBytes != null
              //         ? MemoryImage(_imageBytes)
              //         : _imageUrl != null
              //             ? NetworkImage(_imageUrl)
              //             : AssetImage('assets/images/real/default_profile.png'),
              //   ),
              // ),
              SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(height: 50.0),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Kemaskini'),
                ),
              ),
              SizedBox(height: 200.0),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => LandingScreen()),
                    );
                  },
                  child: Text("Sign Out"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
