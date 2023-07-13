import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HistoryPesanan extends StatelessWidget {
  static const routeName = "/HistoryPesanan";

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
  Future<List<Map<String, dynamic>>> getOrderDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? currentUserEmail = user?.email;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('orderDetail')
        .where('currentUser', isEqualTo: currentUserEmail)
        .get();

    List<Map<String, dynamic>> orderDetails = [];
    querySnapshot.docs.forEach((doc) {
      orderDetails.add(doc.data());
    });

    return orderDetails;
  }

  Future<bool> getOrderStatus(String orderId) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('statusPesanan').doc(orderId).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> statusData = documentSnapshot.data()!;
      return statusData['status'] == true;
    }

    return false;
  }

  void deleteOrder(String orderId) {
    FirebaseFirestore.instance.collection('orderDetail').doc(orderId).delete().then((value) {
      Fluttertoast.showToast(
        msg: 'Pesanan telah dipadam.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Pesanan gagal dipadam: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getOrderDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> orderDetails = snapshot.data!;

          return ListView.builder(
            itemCount: orderDetails.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> order = orderDetails[index];
              bool orderStatus = false; // Default status

              return FutureBuilder<bool>(
                future: getOrderStatus(order['orderId']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Order ID: ${order['orderId']}'),
                      subtitle: Text('Loading status...'),
                    );
                  } else if (snapshot.hasError) {
                    return ListTile(
                      leading: Icon(Icons.error, color: Colors.red),
                      title: Text('Order ID: ${order['orderId']}'),
                      subtitle: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    bool? status = snapshot.data ?? false;

                    IconData iconData = status ? Icons.check_circle_outline : Icons.pending;

                    Color iconColor = status ? Colors.green : Colors.orange;

                    return Dismissible(
                      key: Key(order['orderId']),
                      direction: status ? DismissDirection.horizontal : DismissDirection.endToStart,
                      onDismissed: (direction) {
                        if (!status) {
                          deleteOrder(order['orderId']);
                        }
                      },
                      background: status
                          ? null
                          : Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 16.0),
                              color: Colors.red,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                      child: ListTile(
                        leading: Icon(iconData, color: iconColor),
                        title: Text('Order ID: ${order['orderId']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${order['date']}'),
                            Text('Time: ${order['time']}'),
                            Text('Kedai: ${order['email']}'),
                            Text('Items: ${order['items']}'),
                            Text('Total Price: ${order['totalPrice']}'),
                            Text(
                              status ? 'Status: Telah dihantar' : 'Status: Belum dihantar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: status ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
