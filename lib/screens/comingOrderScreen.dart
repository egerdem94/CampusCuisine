import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutroial/widgets/ownerbottomwidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ordermodel.dart';

class ComingOrdersScreen extends StatefulWidget {
  @override
  _ComingOrdersScreenState createState() => _ComingOrdersScreenState();
}

class _ComingOrdersScreenState extends State<ComingOrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatOrderItems(Map<String, int> items) {
    return items.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(', ');
  }

  void _confirmOrderDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Order'),
          content: Text('Are you sure you want to confirm this order?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                _confirmOrder(order.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmOrder(String orderId) async {
    await _firestore
        .collection('orders')
        .doc(orderId)
        .update({'isConfirmed': true})
        .then((_) => print('Order confirmed'))
        .catchError((error) => print('Error updating order: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Coming Orders'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('orders')
              .where('ownerId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No orders found'));
            }

            List<OrderModel> orders = snapshot.data!.docs
                .map((doc) => OrderModel.fromJson(
                    doc.data() as Map<String, dynamic>, doc.id))
                .toList();

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                OrderModel order = orders[index];
                String orderItems = _formatOrderItems(order.items);

                return ListTile(
                  title: Text('Address: ${order.address}'),
                  subtitle: Text('Items: $orderItems\nNote: ${order.note}'),
                  trailing: Icon(Icons.circle,
                      color: order.isConfirmed ? Colors.green : Colors.red),
                  onTap: () {
                    if (!order.isConfirmed) {
                      _confirmOrderDialog(order);
                    }
                  },
                );
              },
            );
          },
        ),
        bottomNavigationBar: BottomNavigationWidget());
  }
}
