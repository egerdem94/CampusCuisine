import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/menuItem.dart';

class MenuScreen extends StatefulWidget {
  final String
      userId; // You'll pass the owner's userId instead of the whole restaurant map

  MenuScreen({required this.userId});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Map<String, int> selectedItems = {};
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Function to calculate total price
  double getTotalPrice() {
    double total = 0.0;
    selectedItems.forEach((itemName, quantity) {
      // You'll need to get the price from the menu item model
      // For now, we'll assume a dummy price
      double price = 10.0; // Replace with actual price from menu item model

      total += quantity * price;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Menu'), // You can set a proper title based on the owner's name
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('menuItems')
            .where('userId', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          List<MenuItemModel> menuItems = snapshot.data!.docs.map((doc) {
            return MenuItemModel.fromJson(
                doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView(
            children: menuItems.map((menuItem) {
              return ListTile(
                title: Text(menuItem.name),
                trailing: Text('${menuItem.price} TL'),
                subtitle: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _changeQuantity(menuItem.name, -1),
                    ),
                    Text('${selectedItems[menuItem.name] ?? 0}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _changeQuantity(menuItem.name, 1),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () => _showOrderConfirmation(getTotalPrice()),
      ),
    );
  }

  void _changeQuantity(String itemName, int delta) {
    setState(() {
      selectedItems[itemName] = (selectedItems[itemName] ?? 0) + delta;
      if (selectedItems[itemName]! < 0) selectedItems[itemName] = 0;
    });
  }

  void _showOrderConfirmation(double totalPrice) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Your Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Total Price: ₺${totalPrice.toStringAsFixed(2)}'),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(hintText: 'Enter your address'),
                ),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(hintText: 'Any notes?'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () =>
                  _confirmOrder(widget.userId), // Pass ownerId here
            ),
          ],
        );
      },
    );
  }

  void _confirmOrder(String ownerId) async {
    Navigator.pop(context); // Close the confirmation dialog

    String customerId = FirebaseAuth.instance.currentUser!.uid;

    Map<String, dynamic> orderData = {
      'customerId': customerId,
      'ownerId': ownerId,
      'customerName': '<Customer Name>',
      'address': _addressController.text,
      'note': _noteController.text,
      'items': selectedItems,
      'totalPrice': getTotalPrice(),
      'isConfirmed': false,
    };

    FirebaseFirestore.instance
        .collection('orders')
        .add(orderData)
        .then((docRef) {
      print("Order added with ID: ${docRef.id}");
    }).catchError((error) {
      print("Error adding order: $error");
    });
  }
}
