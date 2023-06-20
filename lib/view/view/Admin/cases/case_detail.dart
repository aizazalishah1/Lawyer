import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/view/view/Admin/cases/evidence.dart';
import 'package:lawyer/view/view/Admin/cases/remarks.dart';

class CaseDetails extends StatefulWidget {
  final DocumentSnapshot caseDetails;
  final String docid;
  const CaseDetails(
      {super.key, required this.caseDetails, required this.docid});

  @override
  State<CaseDetails> createState() => _CaseDetailsState();
}

class _CaseDetailsState extends State<CaseDetails> {
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
          // color: Colors.amber,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: "Admin Name: ${widget.caseDetails['adminname']}",
                size: 20,
                fontWeight: FontWeight.w500,
                textoverflow: TextOverflow.visible,
              ),
              SizedBox(
                height: 15,
              ),
              TextWidget(
                text: "Client Name: ${widget.caseDetails['clientname']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 15),
              TextWidget(
                text: "Case Type: ${widget.caseDetails['casetype']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 15,
              ),
              TextWidget(
                text: "Client Email: ${widget.caseDetails['clientemail']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 15,
              ),
              TextWidget(
                text: "Case No: ${widget.caseDetails['caseno']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 15,
              ),
              TextWidget(
                text: "Court Name: ${widget.caseDetails['courtname']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 15,
              ),
              TextWidget(
                text: "Date: ${widget.caseDetails['date']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 15,
              ),
              TextWidget(
                text: "Hearing: ${widget.caseDetails['hearing']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 15,
              ),
              TextWidget(
                text: "Judge Name: ${widget.caseDetails['judgename']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 15),
              TextWidget(
                text: "On Behalf Of: ${widget.caseDetails['onbehave']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 15),
              TextWidget(
                text: "Pet/Def Name: ${widget.caseDetails['petname']}",
                size: 20,
                fontWeight: FontWeight.w500,
                textoverflow: TextOverflow.visible,
              ),
              const SizedBox(
                height: 15,
              ),
              TextWidget(
                text: "On behalf of: ${widget.caseDetails['onbehave']}",
                size: 20,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWidget(
                    text: 'Remarks',
                    size: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  TextButton(
                      onPressed: () {
                        MyNavigation.push(
                            context, Remarks(docsid: widget.docid));
                      },
                      child: const Text('See All'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWidget(
                    text: 'Evidence',
                    size: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  TextButton(
                      onPressed: () {
                        MyNavigation.push(
                            context, Evidence(docsid: widget.docid));
                      },
                      child: const Text('See All'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
