import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add client'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_business_rounded), label: 'Add cases')
      ],
      currentIndex: selectedItem,
      onTap: (setValue) {
        setState(() {
          selectedItem = setValue;
        });
      },
    );
  }
}
