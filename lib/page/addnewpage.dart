import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sub_mgmt/main.dart';
import 'package:sub_mgmt/page/model/user.dart';
import 'package:sub_mgmt/page/sortablepage.dart';
import 'package:sub_mgmt/widget/profilewidget.dart';

import '../globals.dart';

class AddNewPage extends StatefulWidget {
  const AddNewPage({Key? key}) : super(key: key);

  @override
  State<AddNewPage> createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  final controllerName = TextEditingController();
  final controllerPhone = TextEditingController();
  final controllerPlan = TextEditingController();
  final controllerFee = TextEditingController();
  String imageUrl = 'assets/images/defaultphoto.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 8,
        toolbarHeight: 70,
        title: Text(
          "Add New".tr,
          style: TextStyle(
            fontFamily: GoogleFonts.rubik().fontFamily,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
                colors: [Color.fromARGB(170,25, 55, 109), Color.fromARGB(170,25, 55, 109)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          ProfileWidget(
              imagePath: imageUrl,
              onClicked: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                await imagePicker.pickImage(source: ImageSource.camera);
                print('${file?.path}');

                // Get reference to storage root
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('images');

                //  Get a reference to storage root
                Reference referenceImageToUpload =
                referenceDirImages.child(controllerPhone.text);

                try {
                  // Store the file
                  await referenceImageToUpload.putFile(File(file!.path));
                  // setState(() async {
                  //   imageUrl = await referenceImageToUpload.getDownloadURL();
                  // });
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                } catch (error) {
                  //  Handle errors
                }

                // if(imageUrl.isEmpty){
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please upload an image")));
                //   return;
                // }
              }
          ),

          const SizedBox(height: 24),
          // Inputs
          TextField(
            controller: controllerName,
            decoration: decoration('Name'),
          ),







          // TextFormField(
          //   decoration: InputDecoration(
          //     labelText: "Name",
          //     fillColor: Colors.white,
          //     enabledBorder:OutlineInputBorder(
          //       borderSide: const BorderSide(color: Colors.deepOrange, width: 2.0),
          //       borderRadius: BorderRadius.circular(25.0),
          //     ),
          //   ),
          // ),

          const SizedBox(height: 24),
          TextField(
            controller: controllerPhone,
            decoration: decoration('Phone'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerPlan,
            decoration: decoration('Plan'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerFee,
            decoration: decoration('Fee Paid'),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),
          ElevatedButton(
              child: Text('Create'),
              style: ElevatedButton.styleFrom(    primary: Color.fromARGB(170,25, 55, 109)),
              onPressed: () {
                final user = User(
                    name: controllerName.text,
                    phone: int.parse(controllerPhone.text),
                    reg: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    plan: int.parse(controllerPlan.text),
                    fee: int.parse(controllerFee.text),
                    expiry: DateFormat('yyyy-MM-dd').format(calculateExp(
                        DateTime.now(), int.parse(controllerPlan.text))),
                  image: imageUrl
                );
                MemberListState.counter = 0;
                createUser(user);
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );
  Future createUser(User user) async {
    // HERE
    // final docUser = FirebaseFirestore.instance.collection('users').doc();
    final docUser = FirebaseFirestore.instance.collection('${currentUser?.uid}').doc();

    final json = user.toJson();
    await docUser.set(json);
  }

  DateTime calculateExp(DateTime start, int plan) {
    return start.add(Duration(days: plan - 1));
  }

  // Future createUser({required String name}) async {
  //   final docUser = FirebaseFirestore.instance.collection('users').doc();
  //
  //   final user = User(
  //     id: docUser.id,
  //     sr: 10,
  //     fullName: name,
  //     phoneNumber: 9237461,
  //   );
  //   final json = user.toJson();
  //
  //   await docUser.set(json);
  // }
}
