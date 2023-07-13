/*import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodTest extends StatefulWidget {
  static const routeName = "/foodTest";

  const FoodTest({Key? key}) : super(key: key);

  @override
  State<FoodTest> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<FoodTest> {
  List<Map<String, dynamic>> cartItems = [];
  TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  // void addToCart(Map<String, dynamic> item, int quantity) {
  //   setState(() {
  //     item['itemPrice'] =
  //         double.parse(item['itemPrice']); // Convert itemPrice to a number
  //     item['quantity'] = quantity;
  //     cartItems.add(item);
  //   });
  // }

  void addToCart(Map<String, dynamic> item, int quantity) {
    if (cartItems.length > 0) {
      Fluttertoast.showToast(
        msg: 'Sila buat pembayaran terlebih dahulu',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 236, 160, 110),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      setState(() {
        item['itemPrice'] = double.parse(item['itemPrice']);
        item['quantity'] = quantity;
        cartItems.add(item);

        // Add the item to the Firestore "cart" collection
        FirebaseFirestore.instance.collection('cart').add(item);

        Fluttertoast.showToast(
          msg: 'Produk dimasukkan ke dalam bakul',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 236, 160, 110),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    }
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
        title: TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              searchTerm = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('cubatrytest').snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final filteredDocs = snapshot.data.docs.where((doc) {
              final itemName = doc['itemName'].toString().toLowerCase();
              return itemName.contains(searchTerm.toLowerCase());
            }).toList();

            return LayoutBuilder(builder: (context, constraints) {
              return constraints.maxWidth < 600
                  ? Container(
                      child: ListView.builder(
                        itemCount: filteredDocs.length,
                        itemBuilder: ((context, index) {
                          return cartItemWidget(
                              context, filteredDocs[index], addToCart);
                        }),
                      ),
                    )
                  : Container(
                      child: filteredDocs.length > 0
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 0.02,
                                crossAxisSpacing: 0.02,
                              ),
                              itemCount: filteredDocs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cartItemWidget(
                                    context, filteredDocs[index], addToCart);
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
              ),
            ),
          );
        },
        label: Text('Bakul'),
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }

  Card cartItemWidget(
      BuildContext context, DocumentSnapshot snapshot, Function addToCart) {
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
              child: Text('${snapshot['shopName']}'),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  String link = snapshot['link'];
                  launchLink(link);
                },
                child: Text(
                  'Link Pautan: ${snapshot['link']}',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
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
                                  'itemPrice': snapshot['itemPrice']
                                      .toString(), // Convert to String
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
  final List<Map<String, dynamic>> cartItems;
  final double total;

  const Payment({Key? key, this.cartItems, this.total}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
  }

  void deleteCartItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

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
                    subtitle:
                        Text('Price: RM ${cartItems[index]['itemPrice']}'),
                    trailing: Text('Quantity: ${cartItems[index]['quantity']}'),
                  ),
                );
              },
            ),
          ),
          ListTile(
            title: Text('Total Price'),
            subtitle: Text('RM ${widget.total}'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceScreen(
                    cartItems: cartItems,
                    total: widget.total,
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
  List<int> quantities; // Add this line

  InvoiceScreen({Key? key, this.cartItems, this.total}) : super(key: key) {
    quantities = cartItems.map<int>((item) => item['quantity'] as int).toList();
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
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, FoodTest.routeName);
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    double subtotal = 0.0;
    for (int i = 0; i < cartItems.length; i++) {
      double price = cartItems[i]['itemPrice'];
      int quantity = quantities[i];
      subtotal += price * quantity;
    }

    double deliveryCharge = 2.0; // Set the delivery charge amount here
    double total = subtotal + deliveryCharge;

    String formatPrice(double price) {
      return price.toStringAsFixed(2);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'NOTA: Sila tangkap layar invois skrin ini dan hantar kepada usahawan melalui link yang tertera dibawah bagi proses pembayaran secara tunai dan pembelian. Terima kasih.', // Add your desired text here
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Text(
          //   'NOTA: Sila tangkap layar invois skrin ini dan hantar kepada usahawan melalui link yang tertera dibawah bagi proses pembayaran secara tunai dan pembelian. Terima kasih.', // Add your desired text here
          //   style: TextStyle(
          //     fontSize: 12,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cartItems[index]['itemName']),
                  subtitle: Text(
                    'Price: RM ${formatPrice(cartItems[index]['itemPrice'])}',
                  ),
                  trailing:
                      Text('Quantity: ${quantities[index]}'), // Add this line
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
            title: Text('Delivery Charge'),
            subtitle: Text('RM ${formatPrice(deliveryCharge)}'),
          ),
          Divider(),
          ListTile(
            title: Text('Total Price'),
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
          ElevatedButton(
            child: Text('Beli sekarang'),
            onPressed: () {
              _showConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Food Shop',
    initialRoute: FoodTest.routeName,
    routes: {
      FoodTest.routeName: (context) => FoodTest(),
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
}*/
