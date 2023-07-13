//CHECK OUT
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Invoice extends StatefulWidget {
  static const routeName = "/foodShop";

  const Invoice({Key? key}) : super(key: key);

  @override
  State<Invoice> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<Invoice> {
  List<dynamic> cartItems = [];
  double totalPrice = 0.0;

  void calculateTotalPrice() {
    totalPrice = cartItems.fold(0, (sum, item) => sum + item['price']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: ((context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return LayoutBuilder(builder: (context, constraints) {
              return constraints.maxWidth < 600
                  ? Container(
                      child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: ((context, index) {
                          return cartItemWidget(context, snapshot, index);
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
                                return cartItemWidget(context, snapshot, index);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(
                cartItems: cartItems,
                totalPrice: totalPrice,
              ),
            ),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  Card cartItemWidget(
      BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    var item = snapshot.data.docs[index];

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text('${item['name']}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Price : RM ${item['price']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Description : ${item['description']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                cartItems.add(item);
                calculateTotalPrice();
              });

              Fluttertoast.showToast(
                msg: 'Added to Cart',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey[800],
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            child: Text('Add to Cart'),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<dynamic> cartItems;
  final double totalPrice;

  const CartPage({Key? key, required this.cartItems, required this.totalPrice})
      : super(key: key);

  void payWithBankIslam(BuildContext context) {
// Implement the necessary logic to handle the Bank Islam payment flow
// Example code for navigation:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BankIslamPaymentPage(totalPrice: totalPrice),
      ),
    );
  }

  void payWithMaybank(BuildContext context) {
// Implement the necessary logic to handle the Maybank payment flow
// Example code for navigation:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MaybankPaymentPage(totalPrice: totalPrice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          var item = cartItems[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Price: RM ${item['price']}'),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total Price: RM ${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                payWithBankIslam(context);
              },
              child: Text('Pay with cash'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                payWithMaybank(context);
              },
              child: Text('Pay with online banking'),
            ),
          ],
        ),
      ),
    );
  }
}

class BankIslamPaymentPage extends StatelessWidget {
  final double totalPrice;

  const BankIslamPaymentPage({Key? key, required this.totalPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
// Implement the UI and logic for Bank Islam payment page
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Price: RM ${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
// Add Bank Islam payment form or any other relevant components
          ],
        ),
      ),
    );
  }
}

class MaybankPaymentPage extends StatelessWidget {
  final double totalPrice;

  const MaybankPaymentPage({Key? key, required this.totalPrice})
      : super(key: key);

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
              'Jumlah yang perlu anda bayar ialah: ',
            ),
            Text(
              'Total Price: RM ${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Instruction for Online Payment',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '1. Sila masukkan jumlah harga yang betul seperti dipaparkan.',
            ),
            Text(
              '2. Sila tangkap layar bukti pembayaran dan hantar kepada peniaga.',
            ),
            Text(
              '3. Kerjasama anda amat dihargai.',
            ),
            SizedBox(height: 30.0),
            Text(
              'Sila pilih akaun anda.',
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _launchURL('https://www.bankislam.biz');
              },
              child: Text('Bank Islam'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _launchURL('https://onlinebanking.rhbgroup.com/my/login');
              },
              child: Text('RHB'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _launchURL(
                    'https://www.maybank2u.com.my/home/m2u/common/login.do');
              },
              child: Text('Maybank'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _launchURL('https://www.mybsn.com.my/mybsn/login/login.do');
              },
              child: Text('Bank Simpanan Nasional'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _launchURL('https://www.mybsn.com.my/mybsn/login/login.do');
              },
              child: Text('Generate invoice'),
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
}

void main() {
  runApp(MaterialApp(
    title: 'Food Shop',
    initialRoute: Invoice.routeName,
    routes: {
      Invoice.routeName: (context) => Invoice(),
    },
  ));
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
