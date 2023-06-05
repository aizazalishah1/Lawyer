import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:lawyer/components/custom_drawer.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/view/View/auth/signin_screen.dart';
import 'package:lawyer/view/view/Admin/cases/cases.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'client/clients.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? username;
  String? cases;
  String? clients;

  @override
  void initState() {
    super.initState();
    getname();
  }

  void getname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    setState(() {});
    getdata();
  }

  void getdata() async {
    await _firestore
        .collection('Users')
        .doc(username)
        .collection('Cases')
        .get()
        .then((value) => {
              cases = value.docs.length.toString(),
            });

    await _firestore
        .collection('Users')
        .doc(username)
        .collection('Clients')
        .get()
        .then((value) => {
              clients = value.docs.length.toString(),
            });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut();
                MyNavigation.pushRemove(context, const SigninScreen());
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/justice.jpeg'),
              fit: BoxFit.fill,
            )),
          ),
          const SizedBox(
            height: 20,
          ),
          // const TextWidget(
          //   text: 'Dashboard',
          //   size: 25,
          // ),
          Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      MyNavigation.push(context, const Clients());
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                TextWidget(
                                  text: 'Clients',
                                  size: 22,
                                  fontWeight: FontWeight.w400,
                                ),
                                Icon(
                                  Icons.people,
                                  size: 28,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextWidget(
                              text: clients ?? '0',
                              size: 20,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      MyNavigation.push(context, const Cases());
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                TextWidget(
                                  text: 'Cases',
                                  size: 22,
                                  fontWeight: FontWeight.w400,
                                ),
                                Icon(
                                  Icons.file_copy,
                                  size: 28,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextWidget(
                              text: cases ?? '0',
                              size: 20,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
