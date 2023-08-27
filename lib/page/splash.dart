import 'dart:async';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:sub_mgmt/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sub_mgmt/page/login_page.dart';
import 'package:sub_mgmt/page/router.dart';

import '../login/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds:2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoutingPage())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('MESSMASTER',style: TextStyle(fontWeight: FontWeight.bold,fontSize:30,color: Colors.black87)),
            SizedBox(height: 20,),
            Lottie.asset('assets/images/2splashscreen.json'),

            SizedBox(height: 10,),
            SpinKitFoldingCube(
              color: Color.fromARGB(170,25, 55, 109),
              size: 50.0,
            )
          ],
        ),
      ),
    );
  }
}