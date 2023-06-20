import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:lawyer/components/custom_drawer.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/view/View/auth/signin_screen.dart';
import 'package:lawyer/view/view/Admin/cases/add_case.dart';
import 'package:lawyer/view/view/Admin/cases/case_detail.dart';
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
  TextEditingController search = TextEditingController();
  String? username;
  String? cases;
  String? clients;
  String searchText = '';
  bool namefind = false;
  CollectionReference? alldataCollection;
  List<DocumentSnapshot> documents = [];
  bool isdata = true;

  @override
  void initState() {
    super.initState();
    getname();
  }

  void getname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    alldataCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(username)
        .collection('Cases');
    isdata = false;
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
      body: isdata
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                Container(
                  height: 42,
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26)),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: search,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      suffixIcon: search.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchText = '';
                                  namefind = false;
                                });
                                search.clear();
                              },
                              child: const Icon(Icons.close))
                          : null,
                      hintText: 'Search case by caseno',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) async {
                      setState(() {
                        searchText = value;
                        namefind = false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: alldataCollection!.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }
                        if (snapshot.data?.size == 0) {
                          return const Text('No data found');
                        }
                        documents = snapshot.data!.docs;
                        //todo Documents list added to filterTitle
                        if (searchText != '') {
                          documents = documents.where((element) {
                            return element
                                .get('caseno')
                                .toString()
                                .toLowerCase()
                                .contains(searchText.toLowerCase());
                          }).toList();
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 70),
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.blue[50],
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  text:
                                                      "Client Name: ${documents[index]['clientname']}",
                                                  size: 18,
                                                  fontWeight: FontWeight.w500,
                                                  textoverflow:
                                                      TextOverflow.visible,
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                TextWidget(
                                                  text:
                                                      "Court Name: ${documents[index]['courtname']}",
                                                  size: 16,
                                                  fontWeight: FontWeight.w300,
                                                  textoverflow:
                                                      TextOverflow.visible,
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                TextWidget(
                                                  text:
                                                      "Case No: ${documents[index]['caseno']}",
                                                  size: 16,
                                                  fontWeight: FontWeight.w300,
                                                  textoverflow:
                                                      TextOverflow.visible,
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    MyNavigation.push(
                                                        context,
                                                        AddCase(
                                                          action: 'edit',
                                                          docsid:
                                                              documents[index]
                                                                  ['docid'],
                                                        ));
                                                  },
                                                  icon: const Icon(Icons.edit)),
                                              IconButton(
                                                  color: Colors.black,
                                                  onPressed: () {
                                                    MyNavigation.push(
                                                      context,
                                                      CaseDetails(
                                                        caseDetails:
                                                            documents[index],
                                                        docid: documents[index]
                                                            ['docid'],
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.visibility,
                                                  ))
                                            ],
                                          )
                                        ]),
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
