import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/button_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../components/text_widget.dart';
import '../../../../components/textfield_widget.dart';

class AdClients extends StatefulWidget {
  final String? action;
  final String? email;

  const AdClients({super.key, required this.action, this.email});

  @override
  State<AdClients> createState() => _AdClientsState();
}

class _AdClientsState extends State<AdClients> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController name = TextEditingController();
  TextEditingController fathername = TextEditingController();
  TextEditingController cnic = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobileno = TextEditingController();
  TextEditingController address = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? username;

  @override
  void initState() {
    super.initState();
    getname();
  }

  void getname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    print(username);
    getdetail();
    setState(() {});
  }

  void getdetail() async {
    widget.action == 'edit'
        ? _firestore
            .collection('Users')
            .doc(username)
            .collection('Clients')
            .doc(widget.email)
            .get()
            .then((value) {
            name.text = value['name'];
            fathername.text = value['Fathername'];
            cnic.text = value['cnic'];
            email.text = value['email'];
            mobileno.text = value['mobileno'];
            address.text = value['address'];
          })
        : null;
  }

  void addclient() {
    _firestore
        .collection('Users')
        .doc(username)
        .collection('Clients')
        .doc(email.text)
        .set({
      'name': name.text,
      'Fathername': fathername.text,
      'cnic': cnic.text,
      'email': email.text,
      'mobileno': mobileno.text,
      'address': address.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: Text(widget.action == 'edit' ? 'Edit Client' : 'Add Client'),
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
                  text: 'Client Details',
                  size: 20,
                  fontWeight: FontWeight.w500,
                ),
                const TextWidget(
                  alignment: Alignment.topLeft,
                  text: 'Name',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextFieldWidget(
                  read: false,
                  // textcolor: MyColors.white,
                  hinttext: 'Enter Name',

                  keyboardtype: TextInputType.text,
                  controller: name,
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
                  text: 'Father Name',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextFieldWidget(
                  read: false,
                  // textcolor: MyColors.white,
                  hinttext: 'Enter Father Name',

                  keyboardtype: TextInputType.text,
                  controller: fathername,
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
                  text: 'CNIC',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextFieldWidget(
                  read: false,
                  // textcolor: MyColors.white,
                  hinttext: 'Enter Cnic No',

                  keyboardtype: TextInputType.number,
                  controller: cnic,
                  border: const Border(bottom: BorderSide(width: 1)),
                  validator: (value) {
                    if (value.length < 13) {
                      return "Cnic no should not less than 13";
                    }
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
                  text: 'Email',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextFieldWidget(
                  read: widget.action == 'edit' ? true : false,
                  // textcolor: MyColors.white,
                  hinttext: 'Enter Email Address',

                  keyboardtype: TextInputType.emailAddress,
                  controller: email,
                  border: const Border(bottom: BorderSide(width: 1)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    if (!value.contains('@')) {
                      return "A valid email should contain '@'";
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value)) {
                      return "Please enter a valid email";
                    }
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
                  text: 'Mobile No',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextFieldWidget(
                  read: false,
                  // textcolor: MyColors.white,
                  hinttext: 'Enter Mobile No',

                  keyboardtype: TextInputType.number,
                  controller: mobileno,
                  border: const Border(bottom: BorderSide(width: 1)),
                  validator: (value) {
                    if (value!.length < 11) {
                      return 'Number should not less than 11 digit';
                    }
                    if (value.length > 11) {
                      return 'Number should not greater than 11 digit';
                    }
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
                  text: 'Address',
                  size: 16,
                  fontWeight: FontWeight.w500,
                ),
                TextFieldWidget(
                  read: false,
                  // textcolor: MyColors.white,
                  hinttext: 'Enter address',

                  keyboardtype: TextInputType.text,
                  controller: address,
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
                ButtonWidget(
                  onTab: () {
                    final isValid = formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    formKey.currentState!.save();
                    addclient();
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
