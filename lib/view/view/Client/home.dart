import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/components/text_widget.dart';

import 'package:lawyer/constants.dart';
import 'package:lawyer/view/View/auth/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? email;

  @override
  void initState() {
    super.initState();
    getemail();
  }

  void getemail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('clientemail');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: const TextWidget(
              text: 'My Cases',
              size: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: _firestore
                    .collection('Clients')
                    .doc(email)
                    .collection('Cases')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("");
                  }
                  if (snapshot.data?.size == 0) {
                    return const Center(child: Text('No data found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 70),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 10,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextWidget(
                                                text:
                                                    "Lawyer Name: ${snapshot.data!.docs[index]['adminname']}",
                                                size: 18,
                                                fontWeight: FontWeight.w500,
                                                textoverflow:
                                                    TextOverflow.visible,
                                              ),
                                              TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                      'Show Details'))
                                            ],
                                          ),
                                          TextWidget(
                                            text:
                                                "Pet/Def Name: ${snapshot.data!.docs[index]['petname']}",
                                            size: 17,
                                            fontWeight: FontWeight.w300,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextWidget(
                                            text:
                                                "Judge Name: ${snapshot.data!.docs[index]['judgename']}",
                                            size: 17,
                                            fontWeight: FontWeight.w300,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextWidget(
                                            text:
                                                "Court Name: ${snapshot.data!.docs[index]['courtname']}",
                                            size: 17,
                                            fontWeight: FontWeight.w300,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextWidget(
                                            text:
                                                "Case Date: ${snapshot.data!.docs[index]['date']}",
                                            size: 17,
                                            fontWeight: FontWeight.w300,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
