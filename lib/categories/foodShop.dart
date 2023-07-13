/*import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/myOrderScreen.dart';

class FoodShop extends StatefulWidget {
  static const routeName = "/foodShop";

  const FoodShop({Key? key}) : super(key: key);

  @override
  State<FoodShop> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<FoodShop> {
  List<Map<String, dynamic>> cartItems = [];

  // void addToCart(Map<String, dynamic> item, int quantity) {
  //   setState(() {
  //     item['itemPrice'] =
  //         double.parse(item['itemPrice']); // Convert itemPrice to a number
  //     item['quantity'] = quantity;
  //     cartItems.add(item);
  //   });
  // }

  void addToCart(Map<String, dynamic> item, int quantity) {
    setState(() {
      item['itemPrice'] = double.parse(item['itemPrice']);
      item['quantity'] = quantity;
      cartItems.add(item);

      // Add the item to the Firestore "cart" collection
      FirebaseFirestore.instance.collection('cart').add(item);

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Products'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('productList').snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return LayoutBuilder(builder: (context, constraints) {
              return constraints.maxWidth < 600
                  ? Container(
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: ((context, index) {
                          return cartItemWidget(
                              context, snapshot.data.docs[index], addToCart);
                        }),
                      ),
                    )
                  : Container(
                      child: snapshot.data.docs.length > 0
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 0.02,
                                crossAxisSpacing: 0.02,
                              ),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cartItemWidget(context,
                                    snapshot.data.docs[index], addToCart);
                              })
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
              ),
            ),
          );
        },
        label: Text('Cart'),
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }

  Card cartItemWidget(
      BuildContext context, DocumentSnapshot snapshot, Function addToCart) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                'Price : RM ${snapshot['itemPrice']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Description : ${snapshot['description']}',
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
                          title: Text('Enter Quantity'),
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
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Add to Cart'),
                              onPressed: () {
                                addToCart({
                                  'itemName': snapshot['itemName'],
                                  'itemPrice': snapshot['itemPrice'],
                                }, quantity);

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons
                      .shopping_cart), // Replace this with the desired cart icon
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

  const CartScreen({Key? key, this.cartItems, this.total}) : super(key: key);

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
                  subtitle: Text('Price: RM ${cartItems[index]['itemPrice']}'),
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

class Payment extends StatelessWidget {
  static const routeName = "/payment";
  final List<Map<String, dynamic>> cartItems;
  final double total;

  const Payment({Key? key, this.cartItems, this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cartItems[index]['itemName']),
                  subtitle: Text('Price: RM ${cartItems[index]['itemPrice']}'),
                  trailing: Text('Quantity: ${cartItems[index]['quantity']}'),
                );
              },
            ),
          ),
          ListTile(
            title: Text('Total Price'),
            subtitle: Text('RM $total'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceScreen(
                    cartItems: cartItems,
                    total: total,
                  ),
                ),
              );
            },
            child: Text('Bayar secara tunai'),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
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
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}

class InvoiceScreen extends StatelessWidget {
  static const routeName = "/invoice";
  final List<Map<String, dynamic>> cartItems;
  final double total;

  const InvoiceScreen({Key? key, this.cartItems, this.total}) : super(key: key);

  Widget build(BuildContext context) {
    double subtotal = 0.0;
    cartItems.forEach((item) {
      double price = item['itemPrice'];
      subtotal += price;
    });

    double tax = subtotal * 0.07;
    double deliveryCharge = 3.0; // Set the delivery charge amount here
    double total = subtotal + tax + deliveryCharge;

    String formatPrice(double price) {
      return price.toStringAsFixed(2);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cartItems[index]['itemName']),
                  subtitle: Text(
                      'Price: RM ${formatPrice(cartItems[index]['itemPrice'])}'),
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Subtotal'),
            subtitle: Text('RM ${formatPrice(subtotal)}'),
          ),
          ListTile(
            title: Text('Tax (7%)'),
            subtitle: Text('RM ${formatPrice(tax)}'),
          ),
          ListTile(
            title: Text('Delivery Charge'),
            subtitle: Text('RM ${formatPrice(deliveryCharge)}'),
          ),
          Divider(),
          ListTile(
            title: Text('Total Price'),
            subtitle: Text('RM ${formatPrice(total)}'),
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text('Jenis transaksi'),
            subtitle: Text('Dibayar secara tunai'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Food Shop',
    initialRoute: FoodShop.routeName,
    routes: {
      FoodShop.routeName: (context) => FoodShop(),
      Payment.routeName: (context) => Payment(),
      InvoiceScreen.routeName: (context) => InvoiceScreen(),
    },
  ));
}

class OnlinePaymentPage extends StatelessWidget {
  final double totalPrice;

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
            // Text(
            //   'Jumlah yang perlu anda bayar ialah:',
            // ),
            // SizedBox(height: 20.0),
            // Text(
            //   'Instruction for Online Payment',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // Text(
            //   '1. Sila masukkan jumlah harga yang betul seperti dipaparkan.',
            // ),
            // Text(
            //   '2. Sila tangkap layar bukti pembayaran dan hantar kepada peniaga.',
            // ),
            // Text(
            //   '3. Kerjasama anda amat dihargai.',
            // ),
            // SizedBox(height: 30.0),
            Text(
              'Sila pilih akaun anda.',
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Image.asset(
                  'assets/images/real/bank_islam_icon.png'), // Replace with your bank icon
              title: Text('Bank Islam'),
              onTap: () {
                _launchURL('https://www.bankislam.biz');
              },
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Image.asset(
                  'assets/images/real/rhb_icon.png'), // Replace with your bank icon
              title: Text('RHB'),
              onTap: () {
                _launchURL('https://onlinebanking.rhbgroup.com/my/login');
              },
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Image.asset(
                  'assets/images/real/maybank_icon.png'), // Replace with your bank icon
              title: Text('Maybank'),
              onTap: () {
                _launchURL(
                    'https://www.maybank2u.com.my/home/m2u/common/login.do');
              },
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Image.asset(
                  'assets/images/real/bsn_icon.png'), // Replace with your bank icon
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => InvoiceScreen(),
                    ),
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
*/