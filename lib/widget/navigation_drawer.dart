import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_mgmt/main.dart';
import 'package:sub_mgmt/page/expensetracker.dart';
import 'package:sub_mgmt/page/notifs_page.dart';
import 'package:sub_mgmt/page/userpage.dart';

import '../page/sortablepage.dart';

// Drawer to see profile

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({Key? key}) : super(key: key);
  final padding = EdgeInsets.symmetric(horizontal: 0);
  @override
  Widget build(BuildContext context) {
    const name = "Yes Sir";
    const email = "yessir@mess";
    const urlImage = AssetImage("assets/images/dummyfood.jpg");

    return Drawer(
      child: Material(
        color: Colors.white54,
        child: ListView(padding: padding, children: <Widget>[
          buildHeader(
            urlImage: urlImage,
            name: name,
            email: email,
            onClicked: () => {}
          ),
          SizedBox(height: 8),
          Builder(builder: (context) {
            return buildMenuItem(
              text: 'Home',
              icon: Icons.home,
              onClicked: () => selectedItem(context, 0),
            );
          }),
          Divider(thickness: 1.0),
          Builder(builder: (context) {
            return buildMenuItem(
              text: 'Members',
              icon: Icons.people,
              onClicked: () => selectedItem(context, 1),
            );
          }),
          Divider(thickness: 1.0),
          // Builder(builder: (context) {
          //   return buildMenuItem(
          //     text: 'Notifications',
          //     icon: Icons.add,
          //     onClicked: () => selectedItem(context, 2),
          //   );
          // }),
          // Builder(builder: (context) {
          //   return buildMenuItem(
          //     text: 'Profile',
          //     icon: Icons.person,
          //     onClicked: () => selectedItem(context, 3),
          //   );
          // }),
        ]),
      ),
    );
  }

  Widget buildHeader({
    required AssetImage urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
          onTap: onClicked,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile_bgcrop.png"),
                fit: BoxFit.cover,
              )
            ),
              padding: padding.add(EdgeInsets.fromLTRB(20, 80, 20,15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 46,
                      backgroundImage: AssetImage("assets/images/dummyfood.jpg"),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.rubik().fontFamily,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.rubik().fontFamily,
                        ),
                      ),
                    ],
                  )
                ],
              ),
          ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.black;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color, fontSize: 20)),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseTracker()
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => myApp(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NotifsPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserPage(),
        ));
        break;
    }
  }
}
