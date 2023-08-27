import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sub_mgmt/widget/navigation_drawer.dart';
import 'package:intl/intl.dart';
import 'package:sub_mgmt/globals.dart';

import 'package:sub_mgmt/globals.dart';

import 'model/user.dart';

class ExpiringPage extends StatefulWidget {
  const ExpiringPage({Key? key}) : super(key: key);

  @override
  State<ExpiringPage> createState() => _ExpiringPageState();
}

class _ExpiringPageState extends State<ExpiringPage> {
  final df = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 30),
            //   child: Center(
            //     child: Text(
            //       "Exp_today".tr,
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 22,
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: StreamBuilder<List<User>>(
                stream: readUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong! ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;
                    if (users.isEmpty) {
                      return Center(child: Text("No expiring subscriptions for today."));
                    }

                    return ListView(
                      children: users.map((user) => buildUser(user, context)).toList(),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      );
  }

  void _sendSMS(String message, List<String> recipents, BuildContext context) async {
    String _result = await sendSMS(message: message, recipients: recipents, sendDirect: true).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send message")));
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Message sent")));
  }

  Widget buildUser(User user, BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(0, 0, 0, 0.6),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone: ${user.phone.toString()}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Registered on: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(user.reg))}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                  icon: Icon(Icons.mail),
                  onPressed: () async {
                    if (await Permission.sms.request().isGranted) {
                      String message = "Dear ${user.name},\nYour subscription at the Mess is expiring today.";
                      List<String> recipents = [user.phone.toString()];
                      _sendSMS(message, recipents, context);
                    }
                  }),
            ),
          ),
        ),
      );

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      // HERE
      // .collection('users').where('Expiry Date', isEqualTo: df.format(DateTime.now()))
      .collection('${currentUser?.uid}').where('Expiry Date', isEqualTo: df.format(DateTime.now()))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

}
