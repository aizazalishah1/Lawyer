import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/text_widget.dart';

import '../../../../constants.dart';

class ClientDetail extends StatelessWidget {
  // final DocumentSnapshot ClientDetail;
  const ClientDetail(
      {super.key, required DocumentSnapshot<Object?> clientDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: const Text('Case Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: "Name:${ClientDetail}['name']]",
              )
            ],
          ),
        ),
      ),
    );
  }
}











































// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:lawyer/view/view/Admin/client/clients.dart';

// import 'package:lawyer/components/custom_drawer.dart';
// import 'package:lawyer/components/navigation.dart';
// import 'package:lawyer/components/text_widget.dart';
// import 'package:lawyer/constants.dart';
// import 'package:lawyer/view/View/auth/signin_screen.dart';
// import 'package:lawyer/view/view/Admin/cases/cases.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AdminHome extends StatefulWidget {
//   const AdminHome({Key? key}) : super(key: key);

//   @override
//   State<AdminHome> createState() => _AdminHomeState();
// }

// class _AdminHomeState extends State<AdminHome> {
//   int selectedItem = 0;
//   String welcomeMessage = 'Welcome to Lawyer Admin Diary';

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String? username;
//   String? cases;
//   String? clients;

//   TextEditingController searchController = TextEditingController();
//   bool isSearching = false;
//   String searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     getname();
//   }

//   void getname() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     username = prefs.getString('username');
//     setState(() {});
//     getdata();
//   }

//   void getdata() async {
//     await _firestore
//         .collection('Users')
//         .doc(username)
//         .collection('Cases')
//         .get()
//         .then((value) => {
//               cases = value.docs.length.toString(),
//             });

//     await _firestore
//         .collection('Users')
//         .doc(username)
//         .collection('Clients')
//         .get()
//         .then((value) => {
//               clients = value.docs.length.toString(),
//             });
//     setState(() {});
//   }

//   void startSearch() {
//     setState(() {
//       isSearching = true;
//     });
//   }

//   void stopSearch() {
//     setState(() {
//       isSearching = false;
//       searchQuery = '';
//       searchController.clear();
//     });
//   }

//   void handleSearch(String value) {
//     setState(() {
//       searchQuery = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         backgroundColor: MyColors.primarycolor,
//         title: isSearching
//             ? TextField(
//                 controller: searchController,
//                 onChanged: handleSearch,
//                 autofocus: true,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration(
//                   hintText: 'Search...',
//                   border: InputBorder.none,
//                 ),
//               )
//             : (username != null
//                 ? Text('Welcome $username')
//                 : Text(welcomeMessage)),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               if (isSearching) {
//                 stopSearch();
//               } else {
//                 startSearch();
//               }
//             },
//             icon: Icon(
//               isSearching ? Icons.close : Icons.search,
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               _auth.signOut();
//               MyNavigation.pushRemove(context, const SigninScreen());
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'client'),
//           BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'case'),
//         ],
//         currentIndex: selectedItem,
//         onTap: (int setValue) {
//           setState(() {
//             selectedItem = setValue;
//           });

//           if (setValue == 0) {
//             // Home screen is already selected
//           } else if (setValue == 1) {
//             MyNavigation.push(context, Clients());
//           } else if (setValue == 2) {
//             MyNavigation.push(context, Cases());
//           }
//         },
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//       ),
//       drawer: CustomDrawer(),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextWidget(
//                 text: 'Total Clients:',
//                 size: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//               const SizedBox(height: 10),
//               TextWidget(
//                 text: clients ?? '',
//                 size: 50,
//                 fontWeight: FontWeight.w600,
//               ),
//               const SizedBox(height: 30),
//               TextWidget(
//                 text: 'Total Cases:',
//                 size: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//               const SizedBox(height: 10),
//               TextWidget(
//                 text: cases ?? '',
//                 size: 50,
//                 fontWeight: FontWeight.w600,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
