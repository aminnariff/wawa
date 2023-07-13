import 'package:flutter/material.dart';
import 'package:monkey_app_demo/screenPelanggan/homePelanggan.dart';

class KaedahGunaPelanggan extends StatelessWidget {
  static const routeName = "/kaedahGunaPelanggan";

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
                builder: (context) => HomePelanggan(),
              ),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          Padding(
            padding: EdgeInsets.all(16.0), // Add padding around the text
            child: Text(
              'Panduan penggunaan aplikasi :',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
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
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Pilih kategori produk sama ada makanan, kesihatan, pakaian, kosmetik atau set penjagaan kulit dan wajah, atau gajet.', // Replace with actual instructions
              style: TextStyle(
                fontSize: 16,
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
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Pilih kedai di bawah kategori tersebut.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
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
              'Langkah 3:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Pilih produk yang diinginkan dalam kedai tersebut. Anda boleh membuat carian nama produk pada tempat carian.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
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
              'Langkah 4:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih dan masukkan produk ke dalam bakul dan membuat pembayaran.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Nota:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Anda boleh memasukkan produk ke dalam bakul jika dalam kedai yang sama sahaja.',
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
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
              'Langkah 5:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Periksa status penghantaran produk yang dipesan pada senarai pesanan.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 180,
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.blue,
            ),
            title: Text(
              'Info',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Jika berlaku sebarang masalah kelewatan penghantaran, sila hubungi kedai yang berkenaan.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
