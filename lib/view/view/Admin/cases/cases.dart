import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/button_widget.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/components/textfield_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/view/view/Admin/cases/add_case.dart';
// import 'package:lawyer/view/view/Admin/cases/case_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../client/clients.dart';
import '../home_screen.dart';
import 'case_detail.dart';

class Cases extends StatefulWidget {
  const Cases({super.key});

  @override
  State<Cases> createState() => _CasesState();
}

class _CasesState extends State<Cases> {
  int selectedItem = 2;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController search = TextEditingController();

  bool namefind = false;

  List<DocumentSnapshot> documents = [];
  CollectionReference? alldataCollection;

  String searchText = '';

  bool isdata = true;

  String? username;
  @override
  void initState() {
    super.initState();
    getname();
  }

// this is used for sending data to firebase

  void getname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    alldataCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(username)
        .collection('Cases');
    isdata = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: const Text('Cases'),
        centerTitle: true,
      ),
      body: isdata
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 42,
                  margin: const EdgeInsets.all(25),
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
                                                      "Defender Name: ${documents[index]['petname']}",
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
                                                      "Judge Name: ${documents[index]['judgename']}",
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
                                                TextWidget(
                                                  text:
                                                      "Case Date: ${documents[index]['date']}",
                                                  size: 16,
                                                  fontWeight: FontWeight.w300,
                                                  textoverflow:
                                                      TextOverflow.visible,
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
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    _firestore
                                                        .collection('Users')
                                                        .doc(username)
                                                        .collection('Cases')
                                                        .doc(
                                                            documents[index].id)
                                                        .delete();
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete)),
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
                                                  icon: Icon(
                                                    Icons.visibility,
                                                  ))
                                            ],
                                          )
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff328695).withOpacity(0.8),
        onPressed: () {
          MyNavigation.push(
              context,
              const AddCase(
                action: 'add',
                docsid: '',
              ));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
    ;
  }
}
