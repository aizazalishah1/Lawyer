import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/button_widget.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/components/textfield_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/utils/Dateformat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCase extends StatefulWidget {
  final String? action;
  final String? docsid;
  const AddCase({super.key, required this.action, this.docsid});

  @override
  State<AddCase> createState() => _AddCaseState();
}

class _AddCaseState extends State<AddCase> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController petname = TextEditingController();
  TextEditingController caseno = TextEditingController();
  TextEditingController uisec = TextEditingController();
  TextEditingController judgename = TextEditingController();
  TextEditingController hearing = TextEditingController();
  TextEditingController remarks = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? behalfdrop;
  String? casedrop;
  String? selectname;
  String? courtnamedrop;
  bool isdate = false;
  String? selectdate;
  String year = 'year-month-day';
  String? email;
  String? adminname;
  String? editdocid;

  DateTime startDate = DateTime.utc(2021);
  List<Map<String, dynamic>> usernames = [];
  List<Map<String, dynamic>> casetype = [];
  List<Map<String, dynamic>> courtname = [];
  bool namedrop = false;

  @override
  void initState() {
    super.initState();
    getname();
  }

  void getname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    adminname = prefs.getString('username');
    setState(() {});
    getdetail();
    getallnames();
    courtlist();
    courtnamelist();
  }

  void getdetail() async {
    widget.action == 'edit'
        ? _firestore
            .collection('Users')
            .doc(adminname)
            .collection('Cases')
            .doc(widget.docsid)
            .get()
            .then((value) {
            selectname = value['clientname'];
            petname.text = value['petname'];
            caseno.text = value['caseno'];
            behalfdrop = value['onbehave'];
            casedrop = value['casetype'];
            courtnamedrop = value['courtname'];
            // uisec.text = value['uisection'];
            judgename.text = value['judgename'];
            hearing.text = value['hearing'];
            selectdate = value['date'];
            year = value['date'];
            editdocid = value['docid'];
            email = value['clientemail'];
            remarks.text = value['remarks'];
            // setState(() {});
          })
        : null;
  }

  void getallnames() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(adminname)
        .collection('Clients')
        .get()
        .then((value) {
      for (var i in value.docs) {
        usernames.add(i.data());
      }
    });

    setState(() {});
  }

  void courtlist() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(adminname)
        .collection('Casestype')
        .get()
        .then((value) {
      for (var i in value.docs) {
        casetype.add(i.data());
      }
    });

    setState(() {});
  }

  void courtnamelist() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(adminname)
        .collection('CourtName')
        .get()
        .then((value) {
      for (var i in value.docs) {
        courtname.add(i.data());
      }
    });

    setState(() {});
  }

  void addcase() {
    String id = _firestore
        .collection('Users')
        .doc(adminname)
        .collection('Cases')
        .doc()
        .id;

    _firestore
        .collection('Users')
        .doc(adminname)
        .collection('Cases')
        .doc(widget.action == 'edit' ? editdocid : id)
        .set({
      'clientname': selectname,
      'petname': petname.text,
      'caseno': caseno.text,
      'onbehave': behalfdrop ?? 'Petitioner',
      'casetype': casedrop ?? 'Civil Case',
      'courtname': courtnamedrop ?? 'Peshawar',
      // 'uisection': uisec.text,
      'judgename': judgename.text,
      'hearing': hearing.text,
      'date': selectdate ?? '',
      'adminname': adminname,
      'docid': widget.action == 'edit' ? editdocid : id,
      'clientemail': email,
      'remarks': widget.action == 'edit' ? remarks.text : '',
    });

    _firestore
        .collection('Clients')
        .doc(email)
        .collection('Cases')
        .doc(widget.action == 'edit' ? editdocid : id)
        .set({
      'clientname': selectname,
      'petname': petname.text,
      'caseno': caseno.text,
      'onbehave': behalfdrop ?? 'Petitioner',
      'casetype': casedrop ?? 'Civil Case',
      'courtname': courtnamedrop ?? 'Peshawar',
      // 'uisection': uisec.text,
      'judgename': judgename.text,
      'hearing': hearing.text,
      'date': selectdate ?? '',
      'adminname': adminname,
      'email': email,
      'remarks': remarks,
      'docid': widget.action == 'edit' ? editdocid : id,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: Text(widget.action == 'edit' ? 'Edit Case' : 'Add Case'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const TextWidget(
                  alignment: Alignment.topCenter,
                  text: 'Case Details',
                  size: 20,
                  fontWeight: FontWeight.w500,
                ),
                const TextWidget(
                  alignment: Alignment.topLeft,
                  text: 'Client Name',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField(
                        // underline: const SizedBox(),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        hint: Text(selectname ?? "Seletctname"),
                        isExpanded: true,
                        items: usernames.map((map) {
                          return DropdownMenuItem<String>(
                              value: map['name'], child: Text(map['name']));
                        }).toList(),
                        validator: (value) {
                          if (value == null && widget.action != 'edit') {
                            setState(() {
                              namedrop = true;
                            });
                          } else {
                            setState(() {
                              namedrop = false;
                            });
                          }
                        },
                        onChanged: (val) {
                          selectname = val;

                          for (int i = 0; i < usernames.length; i++) {
                            if (usernames[i]['name'] == val) {
                              email = usernames[i]['email'];

                              setState(() {});
                            }
                          }

                          final isValid = formKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          setState(() {});
                        }),
                  ),
                ),
                namedrop
                    ? Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 5,
                            ),
                            TextWidget(
                              text: '  Field cannot be empty',
                              size: 12,
                              textcolor: Colors.red,
                            ),
                          ],
                        ))
                    : Container(),
                const SizedBox(
                  height: 15,
                ),
                const TextWidget(
                  alignment: Alignment.topLeft,
                  text: 'Defender Name',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextFieldWidget(
                  read: false,
                  // textcolor: MyColors.white,
                  hinttext: 'Enter Def Name',

                  keyboardtype: TextInputType.text,
                  controller: petname,
                  border: const Border(bottom: BorderSide(width: 1)),
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
                const SizedBox(
                  height: 15,
                ),
                const TextWidget(
                  alignment: Alignment.topLeft,
                  text: 'Case No',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextFieldWidget(
                  read: false,
                  // textcolor: MyColors.white,
                  hinttext: 'Case No',

                  keyboardtype: TextInputType.number,
                  controller: caseno,
                  border: const Border(bottom: BorderSide(width: 1)),
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
                const SizedBox(
                  height: 15,
                ),
                const TextWidget(
                  alignment: Alignment.topLeft,
                  text: 'On behalf of:',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: DropdownButton(
                      underline: const SizedBox(),
                      hint: Text(behalfdrop ?? "Petitioner"),
                      isExpanded: true,
                      items: ['Petitioner', 'Responded'].map((e) {
                        return DropdownMenuItem<String>(
                            value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) {
                        behalfdrop = val;
                        setState(() {});
                      }),
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextWidget(
                  alignment: Alignment.topLeft,
                  text: 'Case Type:',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: DropdownButton(
                      underline: const SizedBox(),
                      hint: Text(casedrop ?? "Case Name"),
                      isExpanded: true,
                      items: casetype.map((map) {
                        return DropdownMenuItem<String>(
                            value: map['casename'],
                            child: Text(map['casename']));
                      }).toList(),
                      onChanged: (val) {
                        casedrop = val;
                        setState(() {});
                      }),
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextWidget(
                  alignment: Alignment.topLeft,
                  text: 'Court Name:',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: DropdownButton(
                      underline: const SizedBox(),
                      hint: Text(courtnamedrop ?? "Court Name"),
                      isExpanded: true,
                      items: courtname.map((e) {
                        return DropdownMenuItem<String>(
                            value: e['courtname'], child: Text(e['courtname']));
                      }).toList(),
                      onChanged: (val) {
                        courtnamedrop = val;
                        setState(() {});
                      }),
                ),
                // const SizedBox(
                //   height: 15,
                // ),
                // const TextWidget(
                //   alignment: Alignment.topLeft,
                //   text: 'U/section',
                //   size: 16,
                //   fontWeight: FontWeight.w500,
                // ),
                // TextFieldWidget(
                //   read: false,
                //   // textcolor: MyColors.white,
                //   hinttext: 'Enter section',

                //   keyboardtype: TextInputType.text,
                //   controller: uisec,
                //   border: const Border(bottom: BorderSide(width: 1)),
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Field cannot be empty";
                //     }
                //     return null;
                //   },
                //   onChanged: (value) {
                //     final isValid = formKey.currentState!.validate();
                //     if (!isValid) {
                //       return;
                //     }
                //   },
                // ),
                const SizedBox(
                  height: 15,
                ),
                const TextWidget(
                  alignment: Alignment.topLeft,
                  text: 'Judge Name',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextFieldWidget(
                  read: false,
                  // textcolor: MyColors.white,
                  hinttext: 'Enter Judge Name',

                  keyboardtype: TextInputType.text,
                  controller: judgename,
                  border: const Border(bottom: BorderSide(width: 1)),
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
                const SizedBox(
                  height: 15,
                ),
                const TextWidget(
                  alignment: Alignment.topLeft,
                  text: 'Hearing',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextFieldWidget(
                  read: false,
                  // textcolor: MyColors.white,
                  hinttext: 'Hearing',

                  keyboardtype: TextInputType.text,
                  controller: hearing,
                  border: const Border(bottom: BorderSide(width: 1)),
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
                widget.action == 'edit'
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const TextWidget(
                            alignment: Alignment.topLeft,
                            text: 'Judge Remarks',
                            size: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 15),
                          TextFieldWidget(
                            read: false,
                            // textcolor: MyColors.white,
                            hinttext: 'Judge Remarks',

                            keyboardtype: TextInputType.text,
                            controller: remarks,
                            border: const Border(bottom: BorderSide(width: 1)),
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
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 15,
                ),
                const TextWidget(
                  alignment: Alignment.topLeft,
                  text: 'Case date',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextWidget(
                    alignment: Alignment.topLeft, text: 'Case Status'),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isdate ? '${CusDateFormat.getDate(startDate)}' : year,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 50, 134, 149),
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                              context: context,
                              fieldHintText: 'day-mon-year',
                              initialDate: DateTime.utc(2022),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2025));
                          if (date != null) {
                            setState(() {
                              isdate = true;
                              startDate = date;
                              selectdate = CusDateFormat.getDate(date);
                            });
                          }
                        },
                        child: const Icon(
                          Icons.calendar_month,
                          color: Color.fromARGB(255, 50, 134, 149),
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonWidget(
                  onTab: () {
                    final isValid = formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    formKey.currentState!.save();
                    addcase();
                    Navigator.pop(context);
                  },
                  text: widget.action == 'edit' ? 'Update' : 'Submit',
                  textcolor: Colors.white,
                  size: 18,
                  bgcolor: MyColors.primarycolor,
                  height: 40,
                  width: 120,
                  borderradius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
