import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Evidence extends StatefulWidget {
  final String? docsid;
  const Evidence({super.key, required this.docsid});

  @override
  State<Evidence> createState() => _EvidenceState();
}

class _EvidenceState extends State<Evidence> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? adminname;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getname();
  }

  Future openfile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);

    if (file == null) return;
    print(file);

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    // final appStorage = await getApplicationDocumentsDirectory();
    final file = File('/sdcard/Download/$name');

    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        // receiveTimeout: 0,
      ),
    );

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;
  }

  void getname() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
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
        title: const Text('Evidence'),
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
                    width: width * 0.1,
                    child: const Center(
                      child: TextWidget(
                        text: 'S.no',
                        size: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(
                    width: width * 0.45,
                    child: const Center(
                      child: TextWidget(
                        text: 'File Name',
                        size: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(
                    width: width * 0.25,
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
                    .collection('Evidence')
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
                      int indexx = index + 1;
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: width * 0.1,
                                    child: Center(
                                      child: TextWidget(
                                        text: indexx.toString(),
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
                                            ['name'],
                                        size: 16,
                                        textoverflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.25,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            color: MyColors.primarycolor,
                                            onPressed: () async {
                                              final documentSnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Users')
                                                      .doc(adminname)
                                                      .collection('Cases')
                                                      .doc(widget.docsid)
                                                      .collection('Evidence')
                                                      .doc(snapshot.data!
                                                          .docs[index]['docid'])
                                                      .get();
                                              final fileUrl = documentSnapshot
                                                  .data()!['url'];
                                              final filename = documentSnapshot
                                                  .data()!['name'];

                                              openfile(
                                                  url: fileUrl,
                                                  fileName: filename);
                                            },
                                            icon: const Icon(Icons.visibility)),
                                        IconButton(
                                            color: Colors.red,
                                            onPressed: () {
                                              _firestore
                                                  .collection('Users')
                                                  .doc(adminname)
                                                  .collection('Cases')
                                                  .doc(widget.docsid)
                                                  .collection('Evidence')
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
