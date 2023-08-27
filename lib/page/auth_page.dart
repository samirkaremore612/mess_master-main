import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sub_mgmt/page/homepage.dart';
import 'package:sub_mgmt/page/login_page.dart';
// import 'package:flutter/src/widgets/async.dart';

class Authpage extends StatelessWidget {
  const Authpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          return LoginPage();
        },
      )
    );
  }
}
