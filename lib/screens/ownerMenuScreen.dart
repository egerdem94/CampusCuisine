import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menuItem.dart';

import '../widgets/ownerbottomwidget.dart'; // Import your BottomNavigationWidget

class OwnerMenuScreen extends StatefulWidget {
  @override
  _OwnerMenuScreenState createState() => _OwnerMenuScreenState();
}

class _OwnerMenuScreenState extends State<OwnerMenuScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();

  Future<void> _addMenuItem() async {
    String itemName = _itemNameController.text;
    String itemPrice = _itemPriceController.text;
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (itemName.isNotEmpty && itemPrice.isNotEmpty) {
      await FirebaseFirestore.instance.collection('menuItems').add({
        'name': itemName,
        'price': itemPrice,
        'userId': userId,
      });

      _itemNameController.clear();
      _itemPriceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Menu'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('menuItems')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No menu items found'));
                }
                final menuItems = snapshot.data!.docs
                    .map((doc) => MenuItemModel.fromJson(
                        doc.data() as Map<String, dynamic>, doc.id))
                    .toList();

                return ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = menuItems[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(menuItem.name),
                        subtitle: Text('${menuItem.price} TL'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _itemNameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: _itemPriceController,
                  decoration: InputDecoration(labelText: 'Price (₺)'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _addMenuItem,
                  child: Text('Add Menu Item'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          BottomNavigationWidget(), // Ensure this is correctly implemented
    );
  }
}
