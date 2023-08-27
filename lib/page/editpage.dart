import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sub_mgmt/main.dart';
import 'dart:io';
import 'package:sub_mgmt/page/model/user.dart';
import 'package:sub_mgmt/page/sortablepage.dart';

import '../globals.dart';
import '../widget/profilewidget.dart';
import 'addnewpage.dart';

class EditPage extends StatefulWidget {
  final String id;
  final String name;
  final int phone;
  final int fee;
  final int plan;
  final String reg;
  final String expiry;
  final String image;

  const EditPage(this.id, this.name, this.phone, this.plan, this.fee, this.reg, this.expiry, this.image,
      {super.key});

  @override
  State<EditPage> createState() =>
      EditPageState(id, name, phone, plan, fee, reg, expiry, image);
}

class EditPageState extends State<EditPage> {
  final controllerName = TextEditingController();
  final controllerPhone = TextEditingController();
  // final controllerReg = TextEditingController();
  final controllerPlan = TextEditingController();
  final controllerFee = TextEditingController();

  // Required to update
  String id;

  // Required for text-hint
  String name;
  int phone;
  int plan;
  int fee;
  String reg;
  String expiry;
  String image;

  // Deadline controller
  final controllerDays = TextEditingController();

  EditPageState(this.id, this.name, this.phone, this.plan, this.fee, this.reg, this.expiry, this.image);

  @override
  void initState() {
    super.initState();
    controllerName.text = name;
    controllerPhone.text = phone.toString();
    controllerPlan.text = plan.toString();
    controllerFee.text = fee.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 8,
        toolbarHeight: 70,
        title: Text(
          "Edit",
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
              imagePath: image,
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
                  setState(() async {
                    image = await referenceImageToUpload.getDownloadURL();
                  });
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
          TextField(
             controller: controllerName,
              decoration: decoration('name'.tr),



          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerPhone,
            decoration: decoration('phone'.tr),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerPlan,
            decoration: decoration('Plan'.tr),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerFee,
            decoration: decoration('fee'.tr),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              child: Text('Edit'),
              style: ElevatedButton.styleFrom(    primary: Color.fromARGB(170,25, 55, 109)),
              onPressed: () {
                // HERE
                // final docUser =
                    // FirebaseFirestore.instance.collection('users').doc(id);
                final docUser =
                FirebaseFirestore.instance.collection('${currentUser?.uid}').doc(id);
                docUser.update({
                  'Name': controllerName.text,
                  'Phone': int.parse(controllerPhone.text),
                  'Plan': int.parse(controllerPlan.text),
                  'Fee Paid': int.parse(controllerFee.text),
                  'Expiry Date': DateFormat('yyyy-MM-dd').format(calculateExp(
                      DateTime.parse(reg), int.parse(controllerPlan.text))),
                  'Image': image
                });
                Navigator.pop(context);
              }),
          SizedBox(height: 24),
          ElevatedButton(
              child: Text('Extend Plan'),
              style: ElevatedButton.styleFrom(    primary:Color.fromARGB(170,25, 55, 109)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Extend Plan?"),
                        content: SizedBox(
                          height: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Enter days: "),
                              TextField(
                                controller: controllerDays,
                                keyboardType: TextInputType.number,
                              )
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel")),
                          TextButton(
                              onPressed: () {
                                // HERE
                                // final docUser = FirebaseFirestore.instance.collection('users').doc(id);
                                final docUser = FirebaseFirestore.instance.collection('${currentUser?.uid}').doc(id);
                                docUser.update({
                                  'Expiry Date': DateFormat('yyyy-MM-dd').format(calculateExp(
                                      DateTime.parse(expiry), int.parse(controllerDays.text)+1)),
                                  'Plan': int.parse(controllerDays.text)+plan,
                                });
                                controllerPlan.text = (int.parse(controllerDays.text)+plan).toString();
                                Navigator.pop(context);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                  MainPage.currentIndex = 1;
                                  return myApp();
                                    })
                                );
                              },
                              child: Text("Ok"))
                        ],
                      );
                    });
              })
        ],
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  DateTime calculateExp(DateTime start, int plan) {
    return start.add(Duration(days: plan - 1));
  }

  String toDMY(String date) {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
  }

  Future createUser(User user) async {
    // HERE
    // final docUser = FirebaseFirestore.instance.collection('users').doc();
    final docUser = FirebaseFirestore.instance.collection('${currentUser?.uid}').doc();

    final json = user.toJson();
    await docUser.set(json);
  }
}
