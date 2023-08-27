import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar buildAppBar(BuildContext context, String title) {
  // return AppBar(
    // backgroundColor: Colors.transparent,
    // elevation: 0,
    // actions: [
    //
    // ],
  // );
  return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 8,
      toolbarHeight: 70,
      title: Text(
        title,
        style: TextStyle(
            fontFamily: GoogleFonts.rubik().fontFamily
          // fontWeight: FontWeight.bold
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          color: Color.fromARGB(170,25, 55, 109),
        ),
      )
  );
}