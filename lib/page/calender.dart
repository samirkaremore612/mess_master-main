
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widget/navigation_drawer.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState(() {
      today =day;

    });

  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavigationDrawerWidget(),
      body: Column(
          children: [
      Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        // child: Text(
        //   "Calender".tr,
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 22,
        //   ),
        // ),
      ),
    ),
            Container(
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle:HeaderStyle(formatButtonVisible: false,
                titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day)=>isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2010,10,10) ,
                lastDay: DateTime.utc(2030 ,10,10),
                onDaySelected: _onDaySelected,

              ),
            )
  ]


    ),


    );

  }
}
