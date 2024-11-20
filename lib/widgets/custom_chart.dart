import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CircularChart extends StatelessWidget {
  final double incomePercentage;
  final double expensePercentage;
  final double remainingBalance; // Change to int type for better formatting

  const CircularChart({
    Key? key,
    required this.incomePercentage,
    required this.expensePercentage,
    required this.remainingBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Color(0XFFA5C6D1),
                  // color: Colors.green,
                  value: incomePercentage,
                  title: '${incomePercentage.toStringAsFixed(0)}%',
                  radius: 4,
                  titleStyle: TextStyle(color: Colors.white, fontSize: 14),
                ),
                PieChartSectionData(
                  color: Colors.white,
                  // color: Colors.red,
                  value: expensePercentage,
                  title: '${expensePercentage.toStringAsFixed(0)}%',
                  radius: 2,
                  titleStyle: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
              centerSpaceRadius: 80,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  remainingBalance.toString(),
                  //ASTAGHFIRULAAHHH ANA :'v '6.000.000', // This value should be dynamic based on data
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
