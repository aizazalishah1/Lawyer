// import 'dart:html';
import 'Client_Detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/view/view/Admin/client/ad_clients.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'client_Detils.dart';

class Clients extends StatefulWidget {
  final Function? onClientadded;
  const Clients({super.key, this.onClientadded});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  int selectedItem = 1;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController search = TextEditingController();
  String? username;
  bool namefind = false;
  bool isdata = true;

  List<DocumentSnapshot> documents = [];
  CollectionReference? alldataCollection;

  String searchText = '';

  get client => null;

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
        .collection('Clients');
    isdata = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: const Text('Clients'),
        centerTitle: true,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
      //     BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'Cases'),
      //   ],
      //   currentIndex: selectedItem,
      //   onTap: (int setValue) {
      //     setState(() {
      //       selectedItem = setValue;
      //     });

      //     if (setValue == 0) {
      //       // Navigate to Home screen
      //     } else if (setValue == 1) {
      //       Navigator.push(
      //           context, MaterialPageRoute(builder: (context) => Clients()));
      //     } else if (setValue == 2) {
      //       Navigator.push(
      //           context, MaterialPageRoute(builder: (context) => Cases()));
      //     }
      //   },
      //   selectedItemColor: Colors.blue, // Set the selected item color
      //   unselectedItemColor: Colors.grey, // Set the unselected item color
      // ),
      body: isdata
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
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
                      hintText: 'Search Clients by name, Cnic No,Email',
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
                          return const Text("");
                        }
                        if (snapshot.data?.size == 0) {
                          return const Text('no data');
                        }
                        documents = snapshot.data!.docs;
                        //todo Documents list added to filterTitle
                        if (searchText != '') {
                          documents = documents.where((element) {
                            final name =
                                element['name'].toString().toLowerCase();
                            final cnic =
                                element['cnic'].toString().toLowerCase();
                            final email =
                                element['email'].toString().toLowerCase();

                            final searchLower = searchText.toLowerCase();
                            return name.contains(searchLower) ||
                                cnic.contains(searchLower) ||
                                email.contains(searchLower);
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
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const CircleAvatar(
                                            radius: 45,
                                            backgroundImage:
                                                AssetImage('assets/avator.png'),
                                          ),
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
                                                  text: documents[index]
                                                      ['name'],
                                                  size: 20,
                                                  fontWeight: FontWeight.w500,
                                                  textoverflow:
                                                      TextOverflow.visible,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextWidget(
                                                  text: documents[index]
                                                      ['mobileno'],
                                                  size: 15,
                                                  fontWeight: FontWeight.w400,
                                                  textoverflow:
                                                      TextOverflow.visible,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextWidget(
                                                  text: documents[index]
                                                      ['email'],
                                                  size: 15,
                                                  fontWeight: FontWeight.w400,
                                                  textoverflow:
                                                      TextOverflow.visible,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                // TextWidget(
                                                //   text: documents[index]
                                                //       ['Fathername'],
                                                //   size: 15,
                                                //   fontWeight: FontWeight.w400,
                                                //   textoverflow: TextOverflow.visible,
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    MyNavigation.push(
                                                        context,
                                                        AdClients(
                                                          action: 'edit',
                                                          email:
                                                              documents[index]
                                                                  ['email'],
                                                        ));
                                                  },
                                                  icon: const Icon(Icons.edit)),
                                              IconButton(
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    _firestore
                                                        .collection('Users')
                                                        .doc(username)
                                                        .collection('Clients')
                                                        .doc(documents[index]
                                                            ['email'])
                                                        .delete();
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete)),
                                              IconButton(
                                                  onPressed: () {
                                                    MyNavigation.push(
                                                        context,
                                                        ClientDetail(
                                                            clientDetail:
                                                                documents[
                                                                    index]));
                                                  },
                                                  icon: const Icon(
                                                      Icons.visibility))
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
              const AdClients(
                action: 'add',
                email: '',
              ));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
