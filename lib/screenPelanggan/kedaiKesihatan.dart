import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monkey_app_demo/screenPelanggan/displayKedaiKesihatan.dart';
import 'package:url_launcher/url_launcher.dart';

class KedaiKesihatan extends StatefulWidget {
  static const routeName = "/KedaiKesihatan";

  final String? userEmail;

  const KedaiKesihatan({Key? key, this.userEmail}) : super(key: key);

  @override
  State<KedaiKesihatan> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<KedaiKesihatan> {
  List<Map<String, dynamic>> cartItems = [];
  TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  void addToCart(Map<String, dynamic> item, int quantity) {
    setState(() {
      item['itemPrice'] = double.parse(item['itemPrice']);
      item['quantity'] = quantity;
      cartItems.add(item);

      // Add the item to the Firestore "cart" collection
      //FirebaseFirestore.instance.collection('cart').add(item);

      Fluttertoast.showToast(
        msg: 'Added to Cart',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 236, 160, 110),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item['itemPrice'] * item['quantity'];
    }
    return totalPrice;
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    bool removeItems = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pengesahan'),
          content: Text('Anda yakin ingin memadam produk di dalam bakul? '),
          actions: [
            TextButton(
              child: Text('Teruskan'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );

    if (removeItems == true) {
      // Navigate to DisplayKedai class
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => DisplayKedaiKesihatan(),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _showConfirmationDialog(context);
          },
        ),
        title: TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              searchTerm = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Carian',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('kesihatan').where('email', isEqualTo: widget.userEmail).snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final filteredDocs = snapshot.data?.docs.where((doc) {
              final itemName = doc['itemName'].toString().toLowerCase();
              return itemName.contains(searchTerm.toLowerCase());
            }).toList();

            return LayoutBuilder(builder: (context, constraints) {
              return constraints.maxWidth < 600
                  ? Container(
                      child: ListView.builder(
                        itemCount: filteredDocs?.length,
                        itemBuilder: ((context, index) {
                          return cartItemWidget(context, filteredDocs![index], addToCart);
                        }),
                      ),
                    )
                  : Container(
                      child: filteredDocs!.length > 0
                          ? GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 0.02,
                                crossAxisSpacing: 0.02,
                              ),
                              itemCount: filteredDocs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cartItemWidget(context, filteredDocs[index], addToCart);
                              },
                            )
                          : Container(
                              child: Center(
                                child: Text(
                                  'No item found',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Payment(
                cartItems: cartItems,
                total: calculateTotalPrice(),
                email: widget.userEmail,
              ),
            ),
          );
        },
        label: Text('Bakul'),
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }

  Card cartItemWidget(BuildContext context, DocumentSnapshot snapshot, Function addToCart) {
    void launchLink(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text('${snapshot['email']}'),
            ),
            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                items: List<String>.from(snapshot['itemImageUrl']).map(
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
              child: Text('${snapshot['itemName']}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Harga : RM ${snapshot['itemPrice']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Penerangan : ${snapshot['description']}',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        int quantity = 1;
                        return AlertDialog(
                          title: Text('Pilih Kuantiti'),
                          content: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  initialValue: '1',
                                  onChanged: (value) {
                                    quantity = int.tryParse(value) ?? 1;
                                  },
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text('Batal'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Simpan ke dalam bakul'),
                              onPressed: () {
                                addToCart({
                                  'itemName': snapshot['itemName'],
                                  'itemPrice': snapshot['itemPrice'].toString(), // Convert to String
                                }, quantity);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.shopping_cart), // Replace this with the desired cart icon
                  tooltip: 'Add to Cart',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;

  const CartScreen({Key? key, required this.cartItems, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cartItems[index]['itemName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: RM ${cartItems[index]['itemPrice']}'),
                      Text('Link: ${cartItems[index]['link']}'),
                    ],
                  ),
                );
              },
            ),
          ),
          ListTile(
            title: Text('Total Price'),
            subtitle: Text('RM $total'),
          ),
        ],
      ),
    );
  }
}

class Payment extends StatefulWidget {
  static const routeName = "/payment";
  final List<Map<String, dynamic>>? cartItems;
  double? total;
  final String? email; // Add email parameter

  Payment({Key? key, this.cartItems, this.total, this.email}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late List<Map<String, dynamic>> cartItems;
  late String email; // Add email variable
  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems!;
    email = widget.email!; // Assign widget.email to the local variable
  }

  void deleteCartItem(int index) {
    setState(() {
      cartItems.removeAt(index);
      calculateTotalPrice();
    });
  }

  void calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item['itemPrice'] * item['quantity'];
    }
    widget.total = totalPrice;
  }

  String formatPrice(double price) {
    return price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUser = user?.email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            'Senarai produk', // Text before each ListTile
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '   Kedai: $email', // Display the email
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '   Email: $currentUser', // Display the email
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(cartItems[index]['itemName']),
                  onDismissed: (direction) {
                    deleteCartItem(index);
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                  ),
                  child: ListTile(
                    title: Text(cartItems[index]['itemName']),
                    subtitle: Text('Harga per unit: RM ${formatPrice(cartItems[index]['itemPrice'])}'),
                    trailing: Text('Kuantiti: ${cartItems[index]['quantity']}'),
                  ),
                );
              },
            ),
          ),
          ListTile(
            title: Text('Jumlah harga'),
            subtitle: Text('RM ${formatPrice(widget.total!)}'),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoiceScreen(
                        cartItems: cartItems, total: widget.total, email: email, currentUser: currentUser!),
                  ),
                );
              },
              child: Text('Bayar secara tunai'),
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnlinePaymentPage(),
                  ),
                );
              },
              child: Text('Bayar secara atas talian'),
            ),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}

class InvoiceScreen extends StatelessWidget {
  static const routeName = "/invoice";
  final List<Map<String, dynamic>>? cartItems;
  final double? total;
  List<int>? quantities;
  final String? email;
  final String? currentUser; // Add this line

  InvoiceScreen({Key? key, this.cartItems, this.total, this.email, this.currentUser}) // Update the constructor
      : super(key: key) {
    quantities = cartItems!.map<int>((item) => item['quantity'] as int).toList();
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terima kasih'),
          content: Text('Klik "OK" untuk membuat belian seterusnya.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                // Get current date and time
                DateTime now = DateTime.now();
                String date = now.toString().split(' ')[0];
                String time = now.toString().split(' ')[1].split('.')[0];

                // Generate a unique order ID
                String orderId = FirebaseFirestore.instance.collection('orderDetail').doc().id;

                // Create an order detail document in Firestore
                await FirebaseFirestore.instance.collection('orderDetail').doc(orderId).set({
                  'orderId': orderId,
                  'date': date,
                  'time': time,
                  'email': email,
                  'currentUser': currentUser,
                  'items': cartItems,
                  'quantities': quantities,
                  'totalPrice': total,
                });

                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, DisplayKedaiKesihatan.routeName);
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUser = user?.email; // Move this line here

    double subtotal = 0.0;
    for (int i = 0; i < cartItems!.length; i++) {
      double price = cartItems![i]['itemPrice'];
      int quantity = quantities![i];
      subtotal += price * quantity;
    }

    double deliveryCharge = 2.0;
    double total = subtotal + deliveryCharge;

    String formatPrice(double price) {
      return price.toStringAsFixed(2);
    }

    Future<DocumentSnapshot> getUserDetails() {
      return FirebaseFirestore.instance
          .collection('PelangganUsahawan')
          .where('Email', isEqualTo: currentUser)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first;
        } else {
          return null!;
        }
      });
    }

    return FutureBuilder<DocumentSnapshot>(
      future: getUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Invoice'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Invois'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Invoice'),
            ),
            body: Center(
              child: Text(
                'User details not found.',
              ),
            ),
          );
        } else {
          String username = snapshot.data?['Username'] ?? 'N/A';
          String phoneNo = snapshot.data?['PhoneNo'] ?? 'N/A';
          String alamat = snapshot.data?['Alamat'] ?? 'N/A';

          return Scaffold(
            appBar: AppBar(
              title: Text('Invoice'),
            ),
            body: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        '  Maklumat Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('  Kedai: $email'),
                      SizedBox(height: 10),
                      Text('  Email Pelanggan: $currentUser'),
                      Text('  Nama: $username'),
                      Text('  No Telefon: $phoneNo'),
                      Text('  Alamat: $alamat'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(cartItems![index]['itemName']),
                        subtitle: Text(
                          'Harga per unit: RM ${formatPrice(cartItems![index]['itemPrice'])}',
                        ),
                        trailing: Text('Kuantiti: ${quantities![index]}'),
                      );
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Subjumlah'),
                  subtitle: Text('RM ${formatPrice(subtotal)}'),
                ),
                ListTile(
                  title: Text('Caj Penghantaran'),
                  subtitle: Text('RM ${formatPrice(deliveryCharge)}'),
                ),
                Divider(),
                ListTile(
                  title: Text('Jumlah harga'),
                  subtitle: Text('RM ${formatPrice(total)}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Jenis transaksi'),
                  subtitle: Text('Dibayar secara tunai'),
                ),
                ListTile(
                  title: Text(''),
                  subtitle: Text('Terima kasih menggunakan Aplikasi Pos2Pos2 UKM. '),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Beli sekarang'),
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        }
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'KedaiKesihatan',
    initialRoute: KedaiKesihatan.routeName,
    routes: {
      KedaiKesihatan.routeName: (context) => KedaiKesihatan(),
      Payment.routeName: (context) => Payment(),
      InvoiceScreen.routeName: (context) => InvoiceScreen(),
    },
  ));
}

class OnlinePaymentPage extends StatelessWidget {
  final double? totalPrice;

  const OnlinePaymentPage({Key? key, this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sila pilih akaun anda.',
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Image.asset('assets/images/real/bank_islam_icon.png'), // Replace with your bank icon
              title: Text('Bank Islam'),
              onTap: () {
                _launchURL('https://www.bankislam.biz');
              },
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Image.asset('assets/images/real/rhb_icon.png'), // Replace with your bank icon
              title: Text('RHB'),
              onTap: () {
                _launchURL('https://onlinebanking.rhbgroup.com/my/login');
              },
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Image.asset('assets/images/real/maybank_icon.png'), // Replace with your bank icon
              title: Text('Maybank'),
              onTap: () {
                _launchURL('https://www.maybank2u.com.my/home/m2u/common/login.do');
              },
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Image.asset('assets/images/real/bsn_icon.png'), // Replace with your bank icon
              title: Text('Bank Simpanan Nasional'),
              onTap: () {
                _launchURL('https://www.mybsn.com.my/mybsn/login/login.do');
              },
            ),
            SizedBox(height: 250.0),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InvoiceScreen()),
                  );
                },
                child: Text("Generate Invoice"),
              ),
            ),
            SizedBox(height: 20.0),
            TextButton.icon(
              onPressed: () {
                _launchURL('https://example.com/faq');
              },
              icon: Icon(Icons.help),
              label: Text('Need help?'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Enjoy a seamless and secure payment experience!',
              style: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
