import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget chart(List<PointHist> data) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    crosshairBehavior: CrosshairBehavior(
      enable: true,
      lineColor: Colors.red,
      lineDashArray: <double>[5, 5],
      lineWidth: 2,
      lineType: CrosshairLineType.vertical,
    ),
    //title: ChartTitle(text: "Histograma"),
    //legend: Legend(isVisible: true),
    series: <ChartSeries>[
      LineSeries<PointHist, int>(
        dataSource: data,
        xValueMapper: (PointHist dat, _) => dat.pixel,
        yValueMapper: (PointHist dat, _) => dat.cant,
      )
    ],
    trackballBehavior: TrackballBehavior(
      enable: true,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        color: Colors.red,
      ),
    ),
  );
}

class PointHist {
  int cant;
  int pixel;
  PointHist(this.pixel, this.cant);
}