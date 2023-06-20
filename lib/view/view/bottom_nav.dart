import 'package:flutter/material.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/view/view/Admin/cases/cases.dart';
import 'package:lawyer/view/view/Admin/client/clients.dart';
import 'package:lawyer/view/view/Admin/home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedItem = 0;
  List<Widget> widgetOption = <Widget>[
    const AdminHome(),
    const Cases(),
    const Clients(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title:  Text('Bottom Navigation bar'),
      // ),
      body: Center(child: widgetOption.elementAt(_selectedItem)),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: MyColors.primarycolor,
          selectedItemColor: Colors.white,
          // iconSize: 35,
          selectedFontSize: 18,
          unselectedFontSize: 15,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            // BottomNavigationBarItem(icon: Icon(Icons.contact_emergency), label: 'Contact',),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_copy), label: 'Cases'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Clients',
                backgroundColor: Colors.black),
          ],
          currentIndex: _selectedItem,
          onTap: (setValue) {
            setState(() {
              _selectedItem = setValue;
            });
          }),
    );
  }
}
