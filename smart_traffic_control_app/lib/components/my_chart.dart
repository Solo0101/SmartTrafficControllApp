import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_traffic_control_app/constants/style_constants.dart';

class MyChart extends StatelessWidget {
  const MyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 1),
              const FlSpot(1, 1.5),
              const FlSpot(2, 1.4),
              const FlSpot(3, 3.4),
              const FlSpot(4, 2),
              const FlSpot(5, 2.2),
              const FlSpot(6, 1.8),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => primaryTextColor,
          ),
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (!event.isInterestedForInteractions || response == null || response.lineBarSpots == null) {
              return;
            }
            // Handle touch events here
          },
          handleBuiltInTouches: true,
        ),
      ),
    );
  }
}
