import 'dart:async';
import 'dart:math';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_traffic_control_app/models/intersection.dart';


class MyChart extends StatefulWidget {
  final String title;
  final List<LiveChartData> initialChartData;
  final LiveChartData? currentChartDataPoint;

  const MyChart({super.key, required this.title, required this.initialChartData, required this.currentChartDataPoint});

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  late List<LiveChartData> _chartData;
  late ZoomPanBehavior _zoomPanBehavior;
  ChartSeriesController? _chartSeriesController;

  DateTime? _axisMinimum;
  DateTime? _axisMaximum;
  DateFormat _axisFormat = DateFormat.Hms();
  double _axisInterval = const Duration(seconds: 5).inSeconds.toDouble();

  @override
  void initState()  {
    // Initialize the chart's internal data with a mutable copy of the initial data
    _chartData = List.from(widget.initialChartData);
    _updateAxisRanges();

    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.xy,
    );
    super.initState();
  }

  // This lifecycle method is key. It's called when the parent widget rebuilds.
  @override
  void didUpdateWidget(covariant MyChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the parent passes a new data point that we haven't seen before, add it.
    if (widget.currentChartDataPoint != null &&
        widget.currentChartDataPoint != oldWidget.currentChartDataPoint &&
        !_chartData.contains(widget.currentChartDataPoint)) {
      setState(() {
        _chartData.add(widget.currentChartDataPoint!);

        _updateAxisRanges();

        // Optional: Keep the chart from growing indefinitely
        // if (_chartData.length > 100) {
        //   _chartData.removeAt(0);
        //   _chartSeriesController?.updateDataSource(
        //     addedDataIndexes: <int>[_chartData.length - 1],
        //     removedDataIndexes: <int>[0],
        //   );
        // } else {
        //   _chartSeriesController?.updateDataSource(
        //     addedDataIndexes: <int>[_chartData.length - 1],
        //   );
        // }

        _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[_chartData.length - 1],
        );
      });
    }

    // This handles the case where the entire intersection is re-fetched,
    // providing a brand new initial list.
    if (widget.initialChartData != oldWidget.initialChartData) {
      setState(() {
        _chartData = List.from(widget.initialChartData);
        _updateAxisRanges();
      });
    }
  }

  void _updateAxisRanges() {
    if (_chartData.isNotEmpty) {
      _axisMinimum = _chartData.first.time;
      _axisMaximum = _chartData.last.time;
    }
  }

  void _updateAxisFormatting(double scale) {
    if (_chartData.isEmpty || scale <= 0 || _axisMinimum == null || _axisMaximum == null) return;

    final totalDurationMs = _axisMaximum!.millisecondsSinceEpoch -
        _axisMinimum!.millisecondsSinceEpoch;
    if (totalDurationMs <= 0) return;

    final visibleDurationMs = totalDurationMs / scale;
    DateFormat newFormat;
    double newInterval;

    const minuteMs = Duration.millisecondsPerMinute;
    const hourMs = Duration.millisecondsPerHour;
    const dayMs = Duration.millisecondsPerDay;

    if(visibleDurationMs < minuteMs * 3) {
      newFormat = DateFormat.Hms();
      newInterval = const Duration(seconds: 5).inSeconds.toDouble();
    } else if (visibleDurationMs < minuteMs * 15) {
      newFormat = DateFormat.Hms();
      newInterval = const Duration(seconds: 30).inSeconds.toDouble();
    } else if (visibleDurationMs < hourMs * 2) {
      newFormat = DateFormat.Hms();
      newInterval = const Duration(seconds: 15).inSeconds.toDouble();
    } else if (visibleDurationMs < hourMs * 6) {
      newFormat = DateFormat.Hm();
      newInterval = const Duration(minutes: 30).inSeconds.toDouble();
    } else if (visibleDurationMs < dayMs * 2) {
      newFormat = DateFormat.j();
      newInterval = const Duration(hours: 2).inSeconds.toDouble();
    } else if (visibleDurationMs < dayMs * 14) {
      newFormat = DateFormat.MMMd();
      newInterval = const Duration(days: 1).inSeconds.toDouble();
    } else {
      newFormat = DateFormat.MMM();
      newInterval = const Duration(days: 30).inSeconds.toDouble();
    }

    if (newFormat.pattern != _axisFormat.pattern) {
      setState(() {
        _axisFormat = newFormat;
        _axisInterval = newInterval;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SfCartesianChart(
        title: ChartTitle(text: widget.title),
        zoomPanBehavior: _zoomPanBehavior,
        onZooming: (ZoomPanArgs args) {
          // We only care about horizontal (X-axis) zoom for time formatting
          if (args.axis!.isXAxis == true) {
            _updateAxisFormatting(args.currentZoomFactor);
          }
        },
        // onDataLabelRender: (DataLabelRenderArgs args) =>  _updateAxisFormatting(args.offset),
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          dateFormat: _axisFormat,
          majorGridLines: const MajorGridLines(width: 0),
          interval: _axisInterval,
          labelRotation: 45,
          autoScrollingMode: AutoScrollingMode.start,
          autoScrollingDelta: 2,
          autoScrollingDeltaType: DateTimeIntervalType.months,
        ),

        primaryYAxis: const NumericAxis(
          labelFormat: '{value}',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
        ),

        // 6. Provide the data source to the chart series
        series: <CartesianSeries<LiveChartData, DateTime>>[
          LineSeries<LiveChartData, DateTime>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            animationDuration: 500,
            dataSource: _chartData,
            xValueMapper: (LiveChartData data, _) => data.time,
            yValueMapper: (LiveChartData data, _) => data.value,
            markerSettings:
                const MarkerSettings(isVisible: true, height: 4, width: 4),
          )
        ],

        // Optional: Add a trackball for better data inspection on touch
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: const InteractiveTooltip(
            enable: true,
            format: 'point.x : point.y',
          ),
        ),
      ),
    );
  }
}
