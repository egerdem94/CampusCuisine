import 'package:flutter/material.dart';
import '../models/ordermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerSpendingsPage extends StatefulWidget {
  @override
  _CustomerSpendingsPageState createState() => _CustomerSpendingsPageState();
}

class _CustomerSpendingsPageState extends State<CustomerSpendingsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double totalSpendings = 0;

  void calculateTotalSpendings(List<OrderModel> orders) {
    totalSpendings = orders
        .where((order) => order.isConfirmed)
        .fold(0, (sum, order) => sum + order.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Spendings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('orders')
            .where('customerId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            List<OrderModel> orders = snapshot.data!.docs
                .map((doc) => OrderModel.fromJson(
                    doc.data() as Map<String, dynamic>, doc.id))
                .toList();
            calculateTotalSpendings(orders);
          }

          return Center(
            child:
                Text('Total Spendings: ₺${totalSpendings.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
