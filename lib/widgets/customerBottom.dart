import 'package:firebase_tutroial/screens/customerspending.dart';
import 'package:flutter/material.dart';
import '../screens/customerHomeScreen.dart'; // Import Customer Home Screen
import '../screens/customerOrderScreen.dart';

// This is just a placeholder for the Total Spend Screen
class TotalSpendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Spend'),
      ),
      body: Center(
        child: Text('Total spend details go here'),
      ),
    );
  }
}

class CustomerBottomNavigationWidget extends StatefulWidget {
  @override
  _CustomerBottomNavigationWidgetState createState() =>
      _CustomerBottomNavigationWidgetState();
}

class _CustomerBottomNavigationWidgetState
    extends State<CustomerBottomNavigationWidget> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    CustomerHomeScreen(), // Home screen showing restaurants
    CustomerOrdersScreen(), // Screen showing customer orders
    CustomerSpendingsPage(), // Screen showing total spend
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => _children[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: 'Restaurants',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'My Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          label: 'Total Spend',
        ),
      ],
    );
  }
}
