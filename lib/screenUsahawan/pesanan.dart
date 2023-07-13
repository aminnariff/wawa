// x hold data bila log out
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Pesanan extends StatelessWidget {
  static const routeName = "/pesanan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan'),
      ),
      body: OrderDetailsList(),
    );
  }
}

class OrderDetailsList extends StatefulWidget {
  @override
  _OrderDetailsListState createState() => _OrderDetailsListState();
}

class _OrderDetailsListState extends State<OrderDetailsList> {
  // Map to store the status of each order
  Map<String, bool> orderStatusMap = {};
  List<Map<String, dynamic>> orderDetails = [];

  @override
  void initState() {
    super.initState();
    getOrderDetails().then((orderDetails) {
      setState(() {
        this.orderDetails = orderDetails;
        orderDetails.forEach((order) {
          String orderId = order['orderId'];
          bool orderStatus = order['status'] ?? false; // Default status
          orderStatusMap[orderId] = orderStatus;
        });
      });
    });
  }

  Future<List<Map<String, dynamic>>> getOrderDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    String currentUserEmail = user.email;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orderDetail')
        .where('email', isEqualTo: currentUserEmail)
        .get();

    List<Map<String, dynamic>> orderDetails = [];
    querySnapshot.docs.forEach((doc) {
      orderDetails.add(doc.data());
    });

    return orderDetails;
  }

  Future<void> _updateStatus(String orderId, bool newStatus) async {
    if (newStatus) {
      await FirebaseFirestore.instance
          .collection('statusPesanan')
          .doc(orderId)
          .set({'orderId': orderId, 'status': newStatus});
    } else {
      await FirebaseFirestore.instance
          .collection('statusPesanan')
          .doc(orderId)
          .delete();
    }

    setState(() {
      orderStatusMap[orderId] = newStatus;
    });

    Fluttertoast.showToast(
      msg: newStatus ? 'Barang telah dihantar' : 'Barang belum dihantar',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: newStatus ? Colors.green : Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    int count = orderDetails.length; // Get the count of orderDetails

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'Jumlah pesanan: $count',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              Map<String, dynamic> order = orderDetails[index];
              String orderId = order['orderId'];

              bool orderStatus = orderStatusMap[orderId] ?? false;

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    'Order ID: $orderId',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${order['date']}'),
                      Text('Time: ${order['time']}'),
                      Text('Email pelanggan: ${order['currentUser']}'),
                      Text('Items: ${order['items']}'),
                      Text('Total Price: ${order['totalPrice']}'),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: orderStatus ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Text(
                              orderStatus ? 'Telah dihantar' : 'Belum dihantar',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Spacer(),
                          Checkbox(
                            value: orderStatus,
                            onChanged: (bool value) async {
                              setState(() {
                                orderStatusMap[orderId] = value;
                              });
                              await _updateStatus(orderId, value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pesanan extends StatelessWidget {
  static const routeName = "/pesanan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan'),
      ),
      body: OrderDetailsList(),
    );
  }
}

class OrderDetailsList extends StatefulWidget {
  @override
  _OrderDetailsListState createState() => _OrderDetailsListState();
}

class _OrderDetailsListState extends State<OrderDetailsList> {
  // Map to store the status of each order
  Map<String, bool> orderStatusMap = {};
  List<Map<String, dynamic>> orderDetails = [];

  @override
  void initState() {
    super.initState();
    getOrderDetails().then((orderDetails) {
      setState(() {
        this.orderDetails = orderDetails;
        orderDetails.forEach((order) {
          String orderId = order['orderId'];
          bool orderStatus = order['status'] ?? false; // Default status
          orderStatusMap[orderId] = orderStatus;
        });
        loadStatusFromStorage();
      });
    });
  }

  Future<List<Map<String, dynamic>>> getOrderDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user?.email;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('orderDetail').where('email', isEqualTo: currentUserEmail).get();

    List<Map<String, dynamic>> orderDetails = [];
    querySnapshot.docs.forEach((doc) {
      orderDetails.add(doc.data());
    });

    return orderDetails;
  }

  Future<void> _updateStatus(String orderId, bool newStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (newStatus) {
      await FirebaseFirestore.instance
          .collection('statusPesanan')
          .doc(orderId)
          .set({'orderId': orderId, 'status': newStatus});

      // Store the status in local storage
      await prefs.setBool(orderId, newStatus);
    } else {
      await FirebaseFirestore.instance.collection('statusPesanan').doc(orderId).delete();

      // Remove the status from local storage
      await prefs.remove(orderId);
    }

    setState(() {
      orderStatusMap[orderId] = newStatus;
    });

    Fluttertoast.showToast(
      msg: newStatus ? 'Barang telah dihantar' : 'Barang belum dihantar',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: newStatus ? Colors.green : Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> loadStatusFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    orderDetails.forEach((order) {
      String orderId = order['orderId'];
      bool orderStatus = prefs.getBool(orderId) ?? false;
      setState(() {
        orderStatusMap[orderId] = orderStatus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int count = orderDetails.length; // Get the count of orderDetails

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'Jumlah pesanan: $count',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              Map<String, dynamic> order = orderDetails[index];
              String orderId = order['orderId'];

              bool orderStatus = orderStatusMap[orderId] ?? false;

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    'Order ID: $orderId',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${order['date']}'),
                      Text('Time: ${order['time']}'),
                      Text('Email pelanggan: ${order['currentUser']}'),
                      Text('Items: ${order['items']}'),
                      Text('Total Price: ${order['totalPrice']}'),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: orderStatus ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Text(
                              orderStatus ? 'Telah dihantar' : 'Belum dihantar',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Spacer(),
                          Checkbox(
                            value: orderStatus,
                            onChanged: (bool? value) async {
                              setState(() {
                                orderStatusMap[orderId] = value!;
                              });
                              await _updateStatus(orderId, value!);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
