import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

class LineChartContent extends StatelessWidget {
  final List<double> data;
  const LineChartContent({super.key, required this.data});

  List<LineChartBarData> _getData() {
    return [
      LineChartBarData(
        color: const Color.fromARGB(255, 45, 155, 251),
        isCurved: true,
        spots: data
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value))
            .toList(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          minX: -1,
          minY: 0,
          maxX: data.length.toDouble() + 5,
          maxY: data.reduce(max) + 10,
          lineBarsData: _getData()),
    );
  }
}
