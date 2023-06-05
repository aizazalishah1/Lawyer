import 'package:flutter/material.dart';
import 'package:lawyer/components/navigation.dart';

import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/utils/utils.dart';
import 'package:lawyer/view/view/Admin/cases/cases.dart';
import 'package:lawyer/view/view/Admin/client/clients.dart';
import 'package:lawyer/view/view/Admin/home_screen.dart';
import 'package:lawyer/view/view/Client/home.dart';
import 'package:lawyer/view/view/casetype/casetype.dart';
import 'package:lawyer/view/view/courtsname/courtname.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: screenWidth(context) * 0.65,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/court.jpg'),
            ),
            Divider(
              height: 90,
              color: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                MyNavigation.pushstatic(context, const AdminHome());
              },
              leading: Icon(
                Icons.dashboard,
                color: MyColors.primarycolor,
                size: 25,
              ),
              title: TextWidget(
                text: 'Dashboard',
                size: 20,
                textcolor: MyColors.primarycolor,
              ),
            ),
            ListTile(
              onTap: () {
                MyNavigation.pushstatic(context, const Clients());
              },
              leading: Icon(
                Icons.people,
                color: MyColors.primarycolor,
                size: 25,
              ),
              title: TextWidget(
                text: 'Clients',
                size: 20,
                textcolor: MyColors.primarycolor,
              ),
            ),
            ListTile(
              onTap: () {
                MyNavigation.pushstatic(context, const Cases());
              },
              leading: Icon(
                Icons.cases_rounded,
                color: MyColors.primarycolor,
                size: 25,
              ),
              title: TextWidget(
                text: 'Cases',
                size: 20,
                textcolor: MyColors.primarycolor,
              ),
            ),
            ListTile(
              onTap: () {
                MyNavigation.pushstatic(context, const CaseType());
              },
              leading: Icon(
                Icons.note_add,
                color: MyColors.primarycolor,
                size: 25,
              ),
              title: TextWidget(
                text: 'Case type',
                size: 20,
                textcolor: MyColors.primarycolor,
              ),
            ),
            ListTile(
              onTap: () {
                MyNavigation.pushstatic(context, const CourtName());
              },
              leading: Icon(
                Icons.add,
                color: MyColors.primarycolor,
                size: 25,
              ),
              title: TextWidget(
                text: 'Courts Name',
                size: 20,
                textcolor: MyColors.primarycolor,
              ),
            ),
            SizedBox(height: 5),
            ListTile(
              onTap: () {
                MyNavigation.push(context, Clients());
              },
              leading: Icon(
                Icons.numbers,
                size: 25,
                color: MyColors.primarycolor,
              ),
              title: TextWidget(
                text: 'Clients',
                size: 20,
                textcolor: MyColors.primarycolor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
