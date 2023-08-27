import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sub_mgmt/page/utils/admin_preferences.dart';
import 'package:sub_mgmt/widget/appbarwidget.dart';
import 'package:sub_mgmt/widget/profilewidget.dart';

import '../widget/buttonwidget.dart';
import '../widget/textfieldwidget.dart';
import 'model/admin.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Admin admin = AdminPreferences.myAdmin;
  Admin admin = AdminPreferences.getAdmin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 8,
        toolbarHeight: 70,
        title: Text(
          "edit_profile".tr,
          style: TextStyle(fontFamily: GoogleFonts.rubik().fontFamily
              // fontWeight: FontWeight.bold
              ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: Color.fromARGB(170,25, 55, 109),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
              imagePath: admin.imagePath,
              isEdit: true,
              onClicked: () async {
                final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                if(image == null) return;
                final directory = await getApplicationDocumentsDirectory();
                final name = basename(image.path);
                final imageFile = File('${directory.path}/$name');

                final newImage = await File(image.path).copy(imageFile.path);

                setState(() => admin = admin.copy(imagePath: newImage.path));
              }
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
              label: 'name'.tr,
              text: admin.name,
              onChanged: (name) => admin = admin.copy(name: name),
            ),
          const SizedBox(height: 32),
          TextFieldWidget(
              label: 'E-mail'.tr,
              text: admin.email,
              onChanged: (email) => admin = admin.copy(email: email),
              ),
          const SizedBox(height: 32),
          ButtonWidget(
            text: 'Save',
            onClicked: () {
              AdminPreferences.setAdmin(admin);
              Navigator.of(context).pop();

            },
          )
        ],
      ),
    );
  }
}
