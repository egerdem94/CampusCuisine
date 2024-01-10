import 'package:firebase_tutroial/widgets/customerBottom.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ordermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerOrdersScreen extends StatefulWidget {
  @override
  _CustomerOrdersScreenState createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUserId =
      FirebaseAuth.instance.currentUser!.uid; // Ensure the user is logged in

  String _formatOrderItems(Map<String, int> items) {
    return items.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('orders')
            // Assuming 'customerId' is stored in each order when created
            .where('customerId', isEqualTo: _currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('You have no orders yet'));
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

              return Card(
                color: order.isConfirmed
                    ? Colors.green[100]
                    : Colors.red[100], // Color indication for order status
                child: ListTile(
                  title: Text('Order ID: ${order.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Items: $orderItems'),
                      Text('Note: ${order.note}'),
                      Text(
                          'Total Price: ₺${order.totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: order.isConfirmed
                      ? Icon(Icons.check_circle_outline, color: Colors.green)
                      : Icon(Icons.hourglass_empty, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomerBottomNavigationWidget(),
    );
  }
}
