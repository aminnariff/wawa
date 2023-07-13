import 'package:flutter/material.dart';
import 'package:monkey_app_demo/screenUsahawan/homeScreenUsahawan.dart';

class KaedahGuna extends StatelessWidget {
  static const routeName = "/kaedahGuna";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panduan'),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the left
          children: [
            Padding(
              padding: EdgeInsets.all(16.0), // Add padding around the text
              child: Text(
                '   Panduan penggunaan aplikasi ',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '  Panduan memuat naik produk',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Colors.green, // Use a green check icon
              ),
              title: Text(
                'Langkah 1:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Pilih kategori produk sama ada makanan, kesihatan, pakaian, kosmetik atau set penjagaan kulit dan wajah atau gajet.', // Replace with actual instructions
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700], // Use a darker gray for the subtitle
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              title: Text(
                'Langkah 2:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Klik pada butang Tambah dan isi maklumat produk. Anda boleh mengemaskini dan memadam produk.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '  Panduan memuat naik iklan',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Colors.green, // Use a green check icon
              ),
              title: Text(
                'Langkah 1:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Pilih kategori produk sama ada makanan, kesihatan, pakaian, kosmetik atau set penjagaan kulit dan wajah atau gajet.', // Replace with actual instructions
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700], // Use a darker gray for the subtitle
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              title: Text(
                'Langkah 2:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Klik pada butang Tambah dan isi maklumat iklan. Anda boleh mengemaskini dan memadam iklan.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
