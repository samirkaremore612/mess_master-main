import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sub_mgmt/main.dart';
import 'package:sub_mgmt/page/homepage.dart';
import 'package:sub_mgmt/page/splash.dart';
import 'package:sub_mgmt/widget/navigation_drawer.dart';
import '../component/expense_summary.dart';
import '../component/expense_title.dart';
import '../data/expense_data.dart';
import '../modules/expense_item.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({Key? key}) : super(key: key);

  @override
  State<ExpenseTracker> createState() => ExpenseTrackerState();
}

class ExpenseTrackerState extends State<ExpenseTracker> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ExpenseData(),
        builder: (context, child) => const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
        ),
    );
  }
}
