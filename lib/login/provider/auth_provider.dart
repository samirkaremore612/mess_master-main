import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../screens/otp_screen.dart';
import '../utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIN = false;
  bool get isSignedIn => _isSignedIN;

  bool _isLoading = false;
  bool get isLoading => _isLoading; // error can occure here

  String? _uid;
  String get uid => _uid!;

  UserModel? _userModel;
  UserModel get userModel=> _userModel!;

  //creating constructor

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;



  AuthProvider() {
    checksignIn();
  }

  void checksignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIN = s.getBool("is_signedin") ??
        false; // key is passed here as " is_signedin "
    notifyListeners();
  }

  Future setSignIn() async{
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIN = true;
    notifyListeners();


  }

  void signInWithPhone(BuildContext context,String phoneNumber)async{
    try{
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async{
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);

          },
          verificationFailed: (error){
            throw Exception(error.message);

              },
          codeSent: (verificationId,forceResendingToken){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> otpScreen(verificationId: verificationId)));

          },
          codeAutoRetrievalTimeout: (verificationId){});

    } on FirebaseAuthException catch(e){
      showsnackbar(context, e.message.toString());

    }

    ////////////////////////////////////////////////////////////////////////////////

  }



  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  })async{
    _isLoading = true;
    notifyListeners();

    try{
      PhoneAuthCredential cred = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: userOtp);
      User? user =( await _firebaseAuth.signInWithCredential(cred)).user!;

      if(user != null){
        //carry our logic
        _uid = user.uid;
        onSuccess();
      }
      _isLoading: false;
      notifyListeners();

    }on FirebaseAuthException catch(e){
      showsnackbar(context, e.message.toString());
      _isLoading: false;
      notifyListeners();
    }

  }







  // Database Operations

Future<bool>checkExistingUser() async{
    DocumentSnapshot snapshot=await _firebaseFirestore.collection("admins").doc(_uid).get();
    if(snapshot.exists){
      print("Users Exists");
      return true;
    }else{
      print("New User");
      return false;
    }

}

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _userModel = userModel;

      // uploading to database
      await _firebaseFirestore
          .collection("admins")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showsnackbar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("admins")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot['name'],
        email: snapshot['email'],
        createdAt: snapshot['createdAt'],
        bio: snapshot['bio'],
        uid: snapshot['uid'],
        profilePic: snapshot['profilePic'],
        phoneNumber: snapshot['phoneNumber'],
      );
      _uid = userModel.uid;
    });
  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIN = false;
    notifyListeners();
    s.clear();
  }





}
