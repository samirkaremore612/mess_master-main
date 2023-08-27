import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sub_mgmt/components/my_button.dart';
import 'package:sub_mgmt/components/my_textfield.dart';
import 'package:sub_mgmt/components/square_tile.dart';
import 'package:sub_mgmt/main.dart';
import 'package:sub_mgmt/page/expensetracker.dart';
import 'package:sub_mgmt/page/homepage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // Commenting below function to skip login page
    void signUserIn() async{
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.push(context, MaterialPageRoute(builder: (context) => myApp()));
      } on FirebaseAuthException catch (e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid email or password"),backgroundColor: Colors.red,));
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                // const Icon(
                //   Icons.lock,
                //   size: 100,
                // ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/login5.png',
                      width: 500,
                      height: 190,
                    ),
                  ],
                ),

                // SquareTile(imagePath: 'lib/images/login.png'),

                const SizedBox(height: 50),

                // welcome back, you've been missed
                Text(
                  'login'.tr,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => myApp())),
                    onTap: signUserIn,
                ),


                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // google button
                    // SquareTile(imagePath: 'lib/images/google.png'),

                    // apple button
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
