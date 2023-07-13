import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DisplayImage extends StatelessWidget {
  static const routeName = '/displayImage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ABC'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('testtest').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snapshot.data?.docs;
          return ListView.builder(
            itemCount: documents?.length,
            itemBuilder: (context, index) {
              final document = documents?[index];
              final name = document?['name'];
              final price = document?['price'];
              final description = document?['description'];
              final imageUrl = document?['imageUrl'];

              return ListTile(
                title: Text(name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price: $price'),
                    Text('Description: $description'),
                  ],
                ),
                leading: Image.network(imageUrl),
              );
            },
          );
        },
      ),
    );
  }
}

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  String _name = '';
  String _price = '';
  String _description = '';
  late Uint8List _imageBytes;

  Future<void> _uploadData() async {
    if (_imageBytes == null) {
      // Image not selected
      return;
    }

    try {
      // Upload image to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
      final uploadTask = storageRef.putData(_imageBytes);
      final storageSnapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await storageSnapshot.ref.getDownloadURL();

      // Save data to Firestore
      await FirebaseFirestore.instance.collection('testtest').add({
        'name': _name,
        'price': _price,
        'description': _description,
        'imageUrl': imageUrl,
      });

      // Reset fields after successful upload
      setState(() {
        _name = '';
        _price = '';
        _description = '';
        _imageBytes = null!;
      });

      // Show success message or navigate to a different screen
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Image and data uploaded successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      print('Upload failed: $error');
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to upload image and data.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Select image from gallery
                // Example: Use an image picker plugin like `image_picker`
                // to choose an image and get its `Uint8List` representation
                // as `_imageBytes`.
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              onChanged: (value) {
                setState(() {
                  _price = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadData,
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
