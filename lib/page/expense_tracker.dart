import 'package:flutter/material.dart';

import '../component/expense_summary.dart';
import '../component/expense_title.dart';

// class expense_track extends StatefulWidget {
//   const expense_track({Key? key}) : super(key: key);
//
//   @override
//   State<expense_track> createState() => _expense_trackState();
// }
//
// class _expense_trackState extends State<expense_track> {
//   @override
//   Widget build(BuildContext context) {
//      return
//



import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_mgmt/component/expense_summary.dart';
import 'package:sub_mgmt/component/expense_title.dart';
import 'package:sub_mgmt/data/expense_data.dart';
import 'package:sub_mgmt/data_time/date_time_helper.dart';
import 'package:sub_mgmt/modules/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sub_mgmt/page/expensetracker.dart';
import 'package:sub_mgmt/widget/navigation_drawer.dart';

import '../main.dart';
import 'calender.dart';
import 'expense_tracker.dart';

class expense_track extends StatefulWidget {
  const expense_track({Key? key}) : super(key: key);

  @override
  State<expense_track> createState() => _expense_track();
}

class _expense_track extends State<expense_track> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('expense_add_new'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //expense name
              TextField(
                controller: newExpenseNameController,
                decoration:  InputDecoration(
                  hintText: 'name_exp'.tr,
                ),
              ),

              //expense amount

              TextField(
                controller: newExpenseAmountController,
                keyboardType: TextInputType.number,
                decoration:  InputDecoration(
                  hintText: "enter_amount".tr,
                ),
              ),
            ],
          ),
          actions: [

            MaterialButton(
              onPressed: cancle,
              child: Text('Cancel'),
            ),
            //save button
            MaterialButton(
              onPressed: save,
              child: Text('Save'),
            ),

            //cancel Button


          ],
        ));
  }

  //delete Expense

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseAmountController.text.isNotEmpty) {
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: newExpenseAmountController.text,
        dateTime: DateTime.now(),
      );

      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }

    // ExpenseItem newExpense = ExpenseItem(
    //     name: newExpenseNameController.text,
    //     amount: newExpenseAmountController.text,
    //     dateTime: DateTime.now(),);
    //
    // Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    Navigator.of(context, rootNavigator: true).pop();
    clear();
  }

  void cancle() {
    Navigator.of(context, rootNavigator: true).pop();
    clear();
  }

  //clear controller

  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //     backgroundColor: Colors.transparent,
        //     elevation: 8,
        //     toolbarHeight: 70,
        //     title: Text(
        //       "home".tr,
        //       style: TextStyle(
        //           fontFamily: GoogleFonts.rubik().fontFamily
        //         // fontWeight: FontWeight.bold
        //       ),
        //     ),
        //     flexibleSpace: Container(
        //       decoration: const BoxDecoration(
        //           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        //           color: Colors.blue,
        //       ),
        //     )
        // ),
        // drawer: NavigationDrawerWidget(),
        backgroundColor: Colors.white,





    // return DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //     // drawer: NavigationDrawerWidget(),
    //     appBar: AppBar(
    //       centerTitle: true,
    //       backgroundColor: Colors.blue,
    //       elevation: 8,
    //       toolbarHeight: 70,
    //       title: Text(
    //         "notification".tr,
    //         style: TextStyle(
    //             fontFamily: GoogleFonts.rubik().fontFamily
    //           // fontWeight: FontWeight.bold
    //         ),
    //       ),
    //       bottom: TabBar(
    //           tabs: [
    //             Tab(icon: Icon(Icons.timelapse), child: Text("Exire_mem".tr)),
    //             Tab(icon: Icon(Icons.warning_amber), child: Text("Expired_mem".tr))
    //           ]
    //       ),
    //     ),
    //     body: TabBarView(
    //       children: [
    //         Calender(),
    //         expense_track(),
    //       ],
    //     ),
    //   ),
    //
    // );




    // TabBarView(
    //   children: [
    //     Calender(),
    //     expense_track(),
    //   ],
    // ),






    body:ListView(
      children: [
        //weekly summary

        ExpenseSummary(startofWeek: value.startofWeekDate()),

        //expense list
        ListView.builder(
            shrinkWrap: true,
            itemCount: value.getAllExpenseList().length,
            padding: EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
            itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped: (p0) =>
                      deleteExpense(value.getAllExpenseList()[index]),
                )),
      ],
    ),

    floatingActionButton: FloatingActionButton(
      onPressed: addNewExpense,
      backgroundColor: Color.fromARGB(170,25, 55, 109),
      child: Icon(Icons.add),
    ),
      ),
    );
  }
}




