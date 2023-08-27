import 'package:sub_mgmt/bar%20graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;






  const MyBarGraph({Key? key, required this.maxY,
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    BarData myBarData =BarData(
        sunAmount: sunAmount,
        monAmount: monAmount,
        tueAmount: tueAmount,
        wedAmount: wedAmount,
        thuAmount: thuAmount,
        friAmount: friAmount,
        satAmount: satAmount,);

    myBarData.initializeBarData();




    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,
          getTitlesWidget: getBottomTitles,)),





        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: myBarData.barData.map((data) =>
            BarChartGroupData(x: data.x,
            barRods: [

              BarChartRodData(
                toY: data.y,
                // color: Color(0xFFFD6844)
                  color:Color.fromARGB(170,25, 55, 109),
                width: 25,
                borderRadius: BorderRadius.circular(4),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: Color.fromARGB(20,25, 55, 109),

                )


              ),

            ],
            ),
      )
          .toList(),
      )
   );
  }
}

Widget getBottomTitles(double value,TitleMeta Meta){
  const style =TextStyle(color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch(value.toInt()) {
    case 0:
      text = const Text('Sun', style: style,);
      break;
    case 1:
      text = const Text('M', style: style,);
      break;

    case 2:
      text = const Text('T', style: style,);
      break;


    case 3:
      text = const Text('W', style: style,);
      break;


    case 4:
      text = const Text('Th', style: style,);
      break;


    case 5:
      text = const Text('F', style: style,);
      break;


    case 6:
      text = const Text('Sat', style: style,);
      break;
    default:
      text = const Text(' ', style: style,);
      break;
  }

      return SideTitleWidget(
        child: text,
        axisSide: Meta.axisSide,
      );

}