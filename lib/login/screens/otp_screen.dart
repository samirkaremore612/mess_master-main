import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:sub_mgmt/login/screens/user_info.dart';

import '../../main.dart';
import '../provider/auth_provider.dart';
import '../utils/utils.dart';
import '../widgets/button.dart';

class otpScreen extends StatefulWidget {
  final String verificationId;
  const otpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<otpScreen> createState() => _otpScreenState();
}

class _otpScreenState extends State<otpScreen> {
  String? otpcode;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;

    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade50,
                          ),
                          child: Image.asset("assets/images/image3.png", height: 300),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Verification",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          // textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Enter the OTP send to your phone number",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                  )),
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          onCompleted: (value) {
                            setState(() {
                              otpcode = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: customButton(
                            text: "Verify",
                            onPressed: () {
                              if (otpcode != null) {
                                verifyotp(context, otpcode!);
                              } else {
                                showsnackbar(context, "Enter 6-Digit valid code");
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Didn't receive any code?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Resend new code",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  //function to verify the otp

  void verifyotp(BuildContext context, String userotp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userotp,
        onSuccess: () {
          //checking wheather user exist in the DB

          ap.checkExistingUser().then((value) async{
            if(value == true){
              //user exist in the DB
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => myApp()));
            }else{
              //New user entry we have to take
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context)=>const userInfoScreen()),
                      (route) => false);
            }
          });
        });
  }
}
