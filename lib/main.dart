import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sub_mgmt/globals.dart';
import 'package:sub_mgmt/login/screens/welcome_screen.dart';
import 'package:sub_mgmt/page/LocalString.dart';
import 'package:sub_mgmt/page/expensetracker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sub_mgmt/page/homepage.dart';
import 'package:sub_mgmt/page/notifs_page.dart';
import 'package:sub_mgmt/page/userpage.dart';
import 'package:sub_mgmt/page/sortablepage.dart';
import 'package:sub_mgmt/page/splash.dart';
import 'package:sub_mgmt/page/utils/admin_preferences.dart';
import 'package:sub_mgmt/widget/doubleback.dart';
import 'package:sub_mgmt/widget/navigation_drawer.dart';
import 'package:get/get.dart';


import 'login/provider/auth_provider.dart';

// This is main.dart file
// ignore_for_file: prefer_const_constructors

// Color.fromARGB(170,25, 55, 109) - blue

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox("expense_database");
  await AdminPreferences.init();
  runApp(
      GetMaterialApp(
        translations: LocalString(),
    debugShowCheckedModeBanner: false,
      locale: Locale('en','US'),
      home: SplashScreen(),
  )
  );
}


class myApp extends StatefulWidget {
  myApp({Key? key}) : super(key: key);

  @override
  State<myApp> createState() => MainPage();
}

class MainPage extends State<myApp> {
  static int currentIndex = 0;
  final screens = [
    ExpenseTracker(),
    MemberList(),
    NotifsPage(),
    UserPage(),
  ];
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('images/profile_bgcrop.png'), context);
    precacheImage(AssetImage('images/dummyfood.jpg'), context);
    return Scaffold(
        body: DoubleBackExit(child: screens[currentIndex]),
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0x54000000),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: bottomNavigationBar,
        ),
    );
  }

  Widget get bottomNavigationBar {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
      ),
      child: BottomNavigationBar(
        // elevation: 1.0,
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 63, 85, 183),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        unselectedItemColor: Color.fromARGB(120, 87, 108, 188),
        selectedFontSize: 12,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items:  [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'member'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'notification'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile'.tr,
          ),
        ],
      ),
    );
  }
}
