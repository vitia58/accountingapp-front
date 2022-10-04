import 'package:buking_test/helpers/fontHelper.dart';
import 'package:buking_test/helpers/requestHelper.dart';
import 'package:buking_test/widgets/FutureLoader.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/src/intl/number_format.dart';

import '../../../widgets/PeriodHorizontalView.dart';

/// State class of the spline area chart.
class ChartWidget extends StatelessWidget {
  ChartWidget({Key? key,required this.period}) : super(key: key);
  PeriodResult period;


  @override
  Widget build(BuildContext context) {
    return loader(
      future: initState(),
      loaded: _buildSplineAreaChart
    );
  }

  /// Returns the cartesian spline are chart.
  SfCartesianChart _buildSplineAreaChart(List<_ChartData> chartData) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
          interval: 1,
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelStyle: defaultTextStyle(Fonts.caption1regular,color: DefColor.gray)),
      primaryYAxis: NumericAxis(
          // name: "{value}%",
          numberFormat: NumberFormat("₴###,###,###,###"),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
        labelStyle: defaultTextStyle(Fonts.caption1regular,color: DefColor.gray)
      ),
      series: _getSplieAreaSeries(chartData),
      tooltipBehavior: TooltipBehavior(textStyle: defaultTextStyle(Fonts.caption1regular,color: DefColor.white),enable: true,color: const Color.fromRGBO(69, 107, 241, 1),canShowMarker: false, opacity: 0.8,duration: 4000),
    );
  }

  // List<_SplineAreaData>? chartData;

  Future<List<_ChartData>> initState() async =>
      axios.get("statistic/chart",period.toJson())
          .getList(_ChartData.fromJson).then((value) => value??[]);

  /// Returns the list of chart series
  /// which need to render on the spline area chart.
  List<ChartSeries<_ChartData, String>> _getSplieAreaSeries(List<_ChartData> chartData) {
    return <ChartSeries<_ChartData, String>>[
      SplineAreaSeries<_ChartData, String>(
        splineType: SplineType.monotonic,
        dataSource: chartData,
        name: "Расходы",
        animationDuration: 0,
        color: const Color.fromRGBO(193, 205, 246, 0.8),
        // borderColor: const Color.fromRGBO(193, 205, 246, 1),
        // borderWidth: 1,
        xValueMapper: (_ChartData sales, _) => sales.name,
        yValueMapper: (_ChartData sales, _) => sales.lose,
      ),
      SplineAreaSeries<_ChartData, String>(
        splineType: SplineType.monotonic,
        dataSource: chartData,
        animationDuration: 0,
        name: "Доходы",
        color: const Color.fromRGBO(69, 107, 241, 0.8),
        // borderColor: const Color.fromRGBO(69, 107, 241, 1),
        // borderWidth: 1,
        xValueMapper: (_ChartData sales, _) => sales.name,
        yValueMapper: (_ChartData sales, _) => sales.earn,
      ),
    ];
  }
}

class _ChartData {
  double? earn;
  double? lose;
  String? name;

  _ChartData.fromJson(Map<String, dynamic> json) {
    earn = json['earn'].toDouble();
    lose = json['lose'].toDouble();
    name = json['name'];
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$name: $earn -$lose";
  }
}