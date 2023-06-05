import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';

class CaseDetails extends StatelessWidget {
  final DocumentSnapshot caseDetails;

  const CaseDetails({Key? key, required this.caseDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Add implementation for the case detail page
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: const Text('Case Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.amber,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: "Admin Name: ${caseDetails['adminname']}",
                size: 20,
                fontWeight: FontWeight.w500,
                textoverflow: TextOverflow.visible,
              ),
              SizedBox(
                height: 15,
              ),
              TextWidget(
                text: "Client Name: ${caseDetails['clientname']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),

              const SizedBox(height: 15),

              TextWidget(
                text: "Case Type: ${caseDetails['casetype']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),

              SizedBox(
                height: 15,
              ),

              TextWidget(
                text: "Client Email: ${caseDetails['clientemail']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),

              SizedBox(
                height: 15,
              ),

              TextWidget(
                text: "Case No: ${caseDetails['caseno']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),

              SizedBox(
                height: 15,
              ),

              TextWidget(
                text: "Court Name: ${caseDetails['courtname']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),

              SizedBox(
                height: 15,
              ),

              TextWidget(
                text: "Date: ${caseDetails['date']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),

              SizedBox(
                height: 15,
              ),

              TextWidget(
                text: "Hearing: ${caseDetails['hearing']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),

              SizedBox(
                height: 15,
              ),

              TextWidget(
                text: "Judge Name: ${caseDetails['judgename']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),

              const SizedBox(height: 15),
              TextWidget(
                text: "On Behalf Of: ${caseDetails['onbehave']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),

              const SizedBox(height: 15),

              TextWidget(
                text: "Pet/Def Name: ${caseDetails['petname']}",
                size: 20,
                fontWeight: FontWeight.w500,
                textoverflow: TextOverflow.visible,
              ),

              SizedBox(
                height: 15,
              ),

              TextWidget(
                text: "On behalf of: ${caseDetails['onbehave']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),

              SizedBox(
                height: 15,
              ),

              TextWidget(
                text: "Judge Remarks: ${caseDetails['remarks']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
// Add more TextWidgets to display other case details

              // Add implementation for displaying case details
            ],
          ),
        ),
      ),
    );
  }
}
