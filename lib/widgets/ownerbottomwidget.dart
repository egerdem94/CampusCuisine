import 'package:firebase_tutroial/screens/comingOrderScreen.dart';
import 'package:firebase_tutroial/screens/ownerEarning.dart';
import 'package:flutter/material.dart';
import '../screens/ownerMenuScreen.dart';

class BottomNavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OwnerMenuScreen()),
            );
            break;
          case 1:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ComingOrdersScreen()),
            );
            break;
          case 2:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OwnerEarningsPage()),
            );
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Manage Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate),
          label: 'Earnings',
        ),
      ],
    );
  }
}
