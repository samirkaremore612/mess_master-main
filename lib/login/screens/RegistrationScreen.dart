
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sub_mgmt/login/screens/otp_screen.dart';

import '../provider/auth_provider.dart';
import '../widgets/button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  String otpCode = '';
  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "",
  );


  @override
  Widget build(BuildContext context) {

    phoneController.selection = TextSelection.fromPosition(TextPosition(offset: phoneController.text.length));
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 35),
            child: Column(

              children: [
                Container(
                  height: 200,
                  width: 200,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade50,

                  ),
                  child: Image.asset("assets/images/image2.png",height: 300),

                ),
                const SizedBox(height: 30),
                const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  // textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your Phone number we will send you verification code",
                  style: TextStyle(

                    fontSize: 14,
                    color: Colors.black38 ,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height:20),
                TextFormField(
                  cursorColor: Colors.blue.shade500,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: phoneController,
                  onChanged: (value) {
                    setState(() {
                      phoneController.text = value;
                    });
                  },
                  keyboardType:TextInputType.number,
                  decoration: InputDecoration(

                    hintText: "Enter your Phone Number",
                    hintStyle: TextStyle(fontWeight: FontWeight.w400,
                    fontSize: 15),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black12),


                    ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),


                    prefixIcon: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          showCountryPicker(
                            countryListTheme: CountryListThemeData(bottomSheetHeight: 500),
                            context: context,
                            onSelect: (value) {
                            setState(() {
                              selectedCountry=value;
                            });

                          },);
                        },
                        child: Text(
                          "${ selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ),
                    ),
                    suffixIcon: phoneController.text.length > 9 ? Container(
                      height: 30,
                      width: 25,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Icon(Icons.done,color: Colors.white,size: 20,),
                    ):null,
                  ),
                ),
                const SizedBox(height:30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: customButton(
                     text: 'Login',
                    onPressed: ()=>sendPhoneNumber(),
                  ),
                )

              ],
            ),
          ),
        ),
      ),

    );
  }
  // void sendphonenumber(){
  //   final ap = Provider.of<AuthProvider>(context,listen: false);
  //   String phoneNumber = phoneController.text.trim();
  //   ap.signInWithPhone(context, "+${selectedCountry.phoneCode} $phoneNumber");
  //
  // }

  void sendPhoneNumber() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    String fullPhoneNumber = "+${selectedCountry.phoneCode + phoneNumber}";

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-handling if the verification is completed automatically
          // e.g., on Android devices
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Save the verification ID for future reference
          setState(() {
            this.verificationId = verificationId;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => otpScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Called when the automatic code retrieval timeout has expired
          // Not commonly used in Flutter apps
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

}


