import 'package:flutter/material.dart';
import '../models/ordermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerEarningsPage extends StatefulWidget {
  @override
  _OwnerEarningsPageState createState() => _OwnerEarningsPageState();
}

class _OwnerEarningsPageState extends State<OwnerEarningsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double totalEarnings = 0;

  void calculateTotalEarnings(List<OrderModel> orders) {
    totalEarnings = orders
        .where((order) => order.isConfirmed)
        .fold(0, (sum, order) => sum + order.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Earnings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('orders')
            .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            List<OrderModel> orders = snapshot.data!.docs
                .map((doc) => OrderModel.fromJson(
                    doc.data() as Map<String, dynamic>, doc.id))
                .toList();
            calculateTotalEarnings(orders);
          }

          return Center(
            child: Text('Total Earnings: ₺${totalEarnings.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
