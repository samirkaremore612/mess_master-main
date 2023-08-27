import 'package:get/get.dart';
import 'package:sub_mgmt/bar%20graph/bar_garph.dart';
import 'package:sub_mgmt/data/expense_data.dart';
import 'package:sub_mgmt/data_time/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startofWeek;
  const ExpenseSummary({Key? key, required this.startofWeek}) : super(key: key);

  double calaulateMax(ExpenseData value, String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String friday,
      String saturday,){

    double? max =100;

    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    values.sort();

    max = values.last * 1.1;

    return max == 0 ? 100 : max ;

  }

  //calculate the week Total
  String calculateWeekTotal(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String friday,
      String saturday,
      ){
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    double total = 0;
    for(int i=0; i< values.length;i++ ){
      total += values[i];

    }
    return total.toStringAsFixed(2);


  }



  @override
  Widget build(BuildContext context) {

    //get yyyymmdd for each day of this week

    String sunday = convertDateTimeToString(startofWeek.add(const Duration(days: 0)));
    String monday = convertDateTimeToString(startofWeek.add(const Duration(days: 1)));
    String tuesday = convertDateTimeToString(startofWeek.add(const Duration(days: 2)));
    String wednesday = convertDateTimeToString(startofWeek.add(const Duration(days: 3)));
    String thursday = convertDateTimeToString(startofWeek.add(const Duration(days: 4)));
    String friday = convertDateTimeToString(startofWeek.add(const Duration(days: 5)));
    String saturday = convertDateTimeToString(startofWeek.add( const Duration(days: 6)));




    return Consumer<ExpenseData>(
      builder: (context,value,child) => Column(
        children: [

          //Row
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Text("week".tr,
                  style: TextStyle(fontWeight: FontWeight.bold),

                ),
                Text('\₹'+ calculateWeekTotal(value, sunday, monday, tuesday, wednesday, friday, saturday)),
              ],
            ),
          ),

          //week graph
          SizedBox(
            height: 200,
            child: MyBarGraph(
                maxY: calaulateMax(value, sunday, monday, tuesday, wednesday, friday, saturday),
                sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
                monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
                tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                wedAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                thuAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
                friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
                satAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,)
          ),
        ],
      ),
    );
  }
}
