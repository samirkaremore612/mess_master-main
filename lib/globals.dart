library globals.dart;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
List<String?> Notifications=['Sameer today is your last day'];
var currentUser = FirebaseAuth.instance.currentUser;
var doc = FirebaseFirestore.instance.collection('${currentUser?.uid}');

var scheduledate='1';
void ReturnNotification(){
  if(DateTime.now().day==2){
    Notifications.add("Today is first  day of mess");
    Notifications=Notifications;
  }
}