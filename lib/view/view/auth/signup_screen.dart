import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/view/view/auth/signin_screen.dart';

import '../../../components/button_widget.dart';
import '../../../components/navigation.dart';

import '../../../components/text_widget.dart';
import '../../../components/textfield_widget.dart';
import 'package:lawyer/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String role = 'Client';

  // TextEditingController
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController mobilenumber = TextEditingController();
  TextEditingController email = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isSwitched = false;
  bool loading = false;

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        role = 'Admin';
      });
    } else {
      setState(() {
        isSwitched = false;
        role = 'Client';
      });
    }
  }

  Future<String> signup() async {
    setState(() {
      loading = true;
    });
    String response = 'some error occured';
    final snapShot =
        await _firestore.collection('Users').doc(username.text).get();

    if (!snapShot.exists) {
      //Not Exist then add these data in firestore
      try {
        // register user
        await _auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);

        _firestore.collection('Users').doc(username.text).set({
          'name': name.text,
          'phone': mobilenumber.text,
          'email': email.text,
          'username': username.text,
          'password': password.text,
          'role': role
        });

        response = 'Account Created Successfully';
      } catch (err) {
        response = 'Email is already used in another account';
      }
    } else {
      response = 'Username already exist';
    }
    setState(() {
      loading = false;
    });

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: screenHeight(context),
              width: screenWidth(context),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/court.jpg'), fit: BoxFit.fill),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  margin: const EdgeInsets.all(20),
                  elevation: 0,
                  color: Colors.grey.withOpacity(0.85),
                  child: Container(
                    height: screenHeight(context) * 0.88,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const TextWidget(
                              alignment: Alignment.topLeft,
                              text: 'Register',
                              size: 25,
                              fontWeight: FontWeight.bold,
                              letterspacing: 1.3,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const TextWidget(
                              alignment: Alignment.topLeft,
                              text: 'Name',
                              size: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            TextFieldWidget(
                              read: false,
                              height: 55,
                              // textcolor: MyColors.white,
                              hinttext: 'Enter Name',

                              keyboardtype: TextInputType.text,
                              controller: name,
                              border:
                                  const Border(bottom: BorderSide(width: 1)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                final isValid =
                                    formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const TextWidget(
                              alignment: Alignment.topLeft,
                              text: 'Mobile Number',
                              size: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            TextFieldWidget(
                              read: false,
                              height: 55,
                              // textcolor: MyColors.white,
                              hinttext: 'Enter Mobile Number',
                              keyboardtype: TextInputType.number,
                              controller: mobilenumber,
                              border:
                                  const Border(bottom: BorderSide(width: 1)),
                              validator: (value) {
                                if (value!.length < 11) {
                                  return 'Number should not less than 11 digit';
                                }
                                if (value.length > 11) {
                                  return 'Number should not greater than 11 digit';
                                }
                              },
                              onChanged: (value) {
                                final isValid =
                                    formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const TextWidget(
                              alignment: Alignment.topLeft,
                              text: 'Email',
                              size: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            TextFieldWidget(
                              read: false,
                              height: 55,
                              // textcolor: MyColors.white,
                              hinttext: 'Enter email',
                              keyboardtype: TextInputType.emailAddress,
                              controller: email,
                              border:
                                  const Border(bottom: BorderSide(width: 1)),
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
                                final isValid =
                                    formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const TextWidget(
                              alignment: Alignment.topLeft,
                              text: 'Username',
                              size: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            TextFieldWidget(
                              read: false,
                              height: 55,
                              // textcolor: MyColors.white,
                              hinttext: 'Enter Username',

                              keyboardtype: TextInputType.text,
                              controller: username,
                              border:
                                  const Border(bottom: BorderSide(width: 1)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (value) async {
                                final isValid =
                                    formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const TextWidget(
                              alignment: Alignment.topLeft,
                              text: 'Password',
                              size: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            TextFieldWidget(
                              read: false,
                              height: 55,
                              // textcolor: MyColors.white,
                              hinttext: 'Enter Password',
                              keyboardtype: TextInputType.text,
                              controller: password,
                              border:
                                  const Border(bottom: BorderSide(width: 1)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Field cannot be empty";
                                }
                                if (value.length < 6) {
                                  return 'Atleast 6 character long';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                final isValid =
                                    formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }
                              },
                            ),
                            Row(
                              children: [
                                const TextWidget(
                                  text: 'Admin',
                                  size: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                Switch(
                                  onChanged: toggleSwitch,
                                  value: isSwitched,
                                  activeColor: Colors.blue,
                                  activeTrackColor: Colors.white,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor: Colors.white,
                                ),
                              ],
                            ),
                            loading
                                ? const CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : ButtonWidget(
                                    borderradius: BorderRadius.circular(10),
                                    onTab: () async {
                                      final isValid =
                                          formKey.currentState!.validate();
                                      if (!isValid) {
                                        return;
                                      }
                                      formKey.currentState!.save();
                                      String res = await signup();

                                      if (context.mounted &&
                                          res ==
                                              'Account Created Successfully') {
                                        showSnackBar(res, context);
                                        MyNavigation.pushreplacement(
                                            context, const SigninScreen());
                                      } else {
                                        showSnackBar(res, context);
                                      }
                                    },
                                    text: 'Register',
                                    bgcolor: Colors.black,
                                    textcolor: Colors.white,
                                    height: 35,
                                    width: 130,
                                    size: 20,
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            const TextWidget(
                              text: 'Have already account?',
                              size: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            TextButton(
                                onPressed: () {
                                  MyNavigation.pushRemove(
                                      context, const SigninScreen());
                                },
                                child: const TextWidget(
                                  textcolor: Colors.black,
                                  text: 'Login',
                                  size: 19,
                                  fontWeight: FontWeight.w900,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
