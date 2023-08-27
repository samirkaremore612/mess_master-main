import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_mgmt/page/expiredpage.dart';
import 'package:sub_mgmt/widget/navigation_drawer.dart';

import 'expiringpage.dart';

class NotifsPage extends StatefulWidget {
  const NotifsPage({Key? key}) : super(key: key);

  @override
  State<NotifsPage> createState() => _NotifsPageState();
}

class _NotifsPageState extends State<NotifsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // drawer: NavigationDrawerWidget(),
          appBar: AppBar(
            automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: Color.fromARGB(170,25, 55, 109),
              elevation: 8,
              toolbarHeight: 70,
              title: Text(
                "notification".tr,
                style: TextStyle(
                    fontFamily: GoogleFonts.rubik().fontFamily
                  // fontWeight: FontWeight.bold
                ),
              ),
              bottom: TabBar(
                indicatorColor: Colors.black,
                tabs: [
                  Tab(icon: Icon(Icons.timelapse), child: Text("Exire_mem".tr)),
                  Tab(icon: Icon(Icons.warning_amber), child: Text("Expired_mem".tr))
                ]
              ),
          ),
        body: TabBarView(
            children: [
              ExpiringPage(),
              ExpiredPage(),
            ],
        ),
      ),
    );
  }
}
