import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaseType extends StatefulWidget {
  const CaseType({super.key});

  @override
  State<CaseType> createState() => _CaseTypeState();
}

class _CaseTypeState extends State<CaseType> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController name = TextEditingController();
  TextEditingController updatename = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? adminname;
  bool edit = false;
  String? editid;

  @override
  void initState() {
    super.initState();
    getname();
  }

  void getname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    adminname = prefs.getString('username');
    setState(() {});
  }

  void addcase() {
    String id = _firestore
        .collection('Users')
        .doc(adminname)
        .collection('Casestype')
        .doc()
        .id;

    _firestore
        .collection('Users')
        .doc(adminname)
        .collection('Casestype')
        .doc(edit ? editid : id)
        .set({
      'casename': name.text,
      'docid': edit ? editid : id,
    });
    name.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: const Text('Add Case Type'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.65,
                  // height: 45,
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: name,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          labelText: 'Case Type',
                          labelStyle: TextStyle(
                            color: Color(0xff328695),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter the type',
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Colors.black))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field cannot be empty";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        final isValid = formKey.currentState!.validate();
                        if (!isValid) {
                          return;
                        }
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff328695)),
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    formKey.currentState!.save();
                    addcase();
                  },
                  child: const Text('Save'),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
                        text: 'Case Type',
                        size: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(
                    width: width * 0.3,
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
                    .collection('Casestype')
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
                        text: 'no data',
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
                      int no = index + 1;
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
                                        text: no.toString(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.45,
                                    child: Center(
                                      child: TextWidget(
                                        text: snapshot.data!.docs[index]
                                            ['casename'],
                                        size: 20,
                                        textoverflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              updatename.text = snapshot.data!
                                                  .docs[index]['casename'];
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Case Type Name'),
                                                      content: TextField(
                                                        onChanged: (value) {
                                                          setState(() {});
                                                        },
                                                        controller: updatename,
                                                        decoration:
                                                            const InputDecoration(
                                                                hintText:
                                                                    "update the name"),
                                                      ),
                                                      actions: <Widget>[
                                                        MaterialButton(
                                                          color: Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                          child: const Text(
                                                              'Cancel'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        MaterialButton(
                                                          color: const Color(
                                                              0xff328695),
                                                          textColor:
                                                              Colors.white,
                                                          child: const Text(
                                                              'Update'),
                                                          onPressed: () {
                                                            setState(() {
                                                              if (updatename
                                                                  .text
                                                                  .isNotEmpty) {
                                                                _firestore
                                                                    .collection(
                                                                        'Users')
                                                                    .doc(
                                                                        adminname)
                                                                    .collection(
                                                                        'Casestype')
                                                                    .doc(snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'docid'])
                                                                    .set({
                                                                  'casename':
                                                                      updatename
                                                                          .text,
                                                                  'docid': snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      ['docid'],
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                            color: Colors.red,
                                            onPressed: () {
                                              _firestore
                                                  .collection('Users')
                                                  .doc(adminname)
                                                  .collection('Casestype')
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
