import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Remarks extends StatefulWidget {
  final String? docsid;
  const Remarks({super.key, required this.docsid});

  @override
  State<Remarks> createState() => _RemarksState();
}

class _RemarksState extends State<Remarks> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? adminname;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getname();
  }

  void getname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    adminname = prefs.getString('username');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: const Text('Judge Remarks'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: width * 0.20,
                    child: const Center(
                      child: TextWidget(
                        text: 'R.Date',
                        size: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(
                    width: width * 0.45,
                    child: const Center(
                      child: TextWidget(
                        text: 'Remarks',
                        size: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(
                    width: width * 0.16,
                    child: const Center(
                      child: TextWidget(
                        text: 'Action',
                        size: 18,
                        fontWeight: FontWeight.bold,
                        letterspacing: 1,
                      ),
                    ))
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: _firestore
                    .collection('Users')
                    .doc(adminname)
                    .collection('Cases')
                    .doc(widget.docsid)
                    .collection('Remarks')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("");
                  }
                  if (snapshot.data?.size == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: TextWidget(
                        text: 'no data found',
                        size: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }

                  //todo Documents list added to filterTitle

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 70),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: width * 0.20,
                                    child: Center(
                                      child: TextWidget(
                                        text: snapshot.data!.docs[index]
                                            ['date'],
                                        size: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.45,
                                    child: Center(
                                      child: TextWidget(
                                        text: snapshot.data!.docs[index]
                                            ['remarks'],
                                        size: 16,
                                        textoverflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.16,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            color: Colors.red,
                                            onPressed: () {
                                              _firestore
                                                  .collection('Users')
                                                  .doc(adminname)
                                                  .collection('Cases')
                                                  .doc(widget.docsid)
                                                  .collection('Remarks')
                                                  .doc(snapshot.data!
                                                      .docs[index]['docid'])
                                                  .delete();
                                            },
                                            icon: const Icon(Icons.delete))
                                      ],
                                    ),
                                  )
                                ]),
                          ],
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
