import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HeatMap(),
    );
  }
}

class HeatMap extends StatefulWidget {
  const HeatMap({super.key});

  @override
  HeatMapState createState() => HeatMapState();
}

class HeatMapState extends State<HeatMap> {
  List<_HeatMapData>? _heatMapData;

  @override
  void initState() {
    _heatMapData = <_HeatMapData>[
      _HeatMapData('59%', 0.694, 0.277, 0.285, 0.76, 0.375, 0.53),
      _HeatMapData('70%', 68.9, 43.2, 40.8, 69.5, 49.5, 53.7),
      _HeatMapData('71%', 1.64, 1.68, 1.64, 1.61, 1.75, 1.68),
      _HeatMapData('72%', 0.632, 0.973, 1.01, 0.747, 0.948, 0.956),
    ];
    super.initState();
  }

  Color _buildColor(num value) {
    if (value >= 50.0) return Colors.yellow.shade500;
    if (value >= 40.0) return Colors.green.shade700;
    if (value >= 30.0) return Colors.green.shade500;
    if (value >= 5.0) return Colors.green.shade300;
    if (value > 0.0) return Colors.green.shade200;
    return Colors.red.shade800;
  }

  List<CategoricalMultiLevelLabel> _buildCategoryLabels() {
    return [
      CategoricalMultiLevelLabel(
          start: '59%', end: '59%', text: 'T cell number'),
      CategoricalMultiLevelLabel(start: '70%', end: '70%', text: 'T cells'),
      CategoricalMultiLevelLabel(start: '71%', end: '71%', text: 'TRAIL'),
      CategoricalMultiLevelLabel(start: '72%', end: '72%', text: 'TGFa'),
    ];
  }

  List<NumericMultiLevelLabel> _buildNumericLabels() {
    return [
      NumericMultiLevelLabel(
        start: 0,
        end: 15,
        text: '6/277',
      ),
      NumericMultiLevelLabel(start: 0, end: 15, text: 'HCW', level: 1),
      NumericMultiLevelLabel(start: 15, end: 35, text: '41/61'),
      NumericMultiLevelLabel(start: 15, end: 35, text: 'Non-ICU', level: 1),
      NumericMultiLevelLabel(start: 35, end: 48, text: '65/11'),
      NumericMultiLevelLabel(start: 35, end: 48, text: 'ICU', level: 1),
      NumericMultiLevelLabel(start: 48, end: 68, text: '28/87', level: 1),
      NumericMultiLevelLabel(start: 48, end: 68, text: 'HCW'),
      NumericMultiLevelLabel(start: 68, end: 80, text: '53/71', level: 1),
      NumericMultiLevelLabel(start: 68, end: 80, text: 'Non-ICU'),
      NumericMultiLevelLabel(start: 80, end: 102, text: '112/182'),
      NumericMultiLevelLabel(start: 80, end: 102, text: 'ICU', level: 1),
    ];
  }

  ChartAxisLabel _formatLabel(MultiLevelLabelRenderDetails details) {
    return ChartAxisLabel(details.text,
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHeatmapChart(),
    );
  }

  SfCartesianChart _buildHeatmapChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
        multiLevelLabelStyle:
            MultiLevelLabelStyle(borderColor: Colors.transparent),
        multiLevelLabels: _buildCategoryLabels(),
        multiLevelLabelFormatter: _formatLabel,
      ),
      primaryYAxis: NumericAxis(
        maximumLabelWidth: 0,
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        multiLevelLabelStyle:
            MultiLevelLabelStyle(borderColor: Colors.transparent),
        multiLevelLabels: _buildNumericLabels(),
        multiLevelLabelFormatter: _formatLabel,
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        legendItemBuilder: (legendText, series, point, seriesIndex) {
          return Row(
            children: [
              const Text('Zero '),
              const SizedBox(width: 5),
              SizedBox(
                  width: 400,
                  height: 20,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withValues(alpha: 0.2),
                          Colors.green.withValues(alpha: 0.9),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  )),
              const SizedBox(width: 5),
              const Text('49.5'),
            ],
          );
        },
      ),
      series: _buildHeatmapSeries(),
    );
  }

  List<CartesianSeries<_HeatMapData, String>> _buildHeatmapSeries() {
    return List.generate(6, (index) {
      return StackedBar100Series<_HeatMapData, String>(
        dataSource: _heatMapData,
        xValueMapper: (_HeatMapData data, int _) => data.percentage,
        yValueMapper: (_HeatMapData data, int _) =>
            _findValueByIndex(data, index),
        pointColorMapper: (_HeatMapData data, int _) =>
            _buildColor(_findValueByIndex(data, index)),
        isVisibleInLegend: index == 0,
        animationDuration: 0,
        width: 1,
        borderWidth: 1,
        borderColor: (index == 1 || index == 3 || index == 4)
            ? Colors.black
            : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
          textStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onCreateRenderer: (ChartSeries<_HeatMapData, String> series) {
          return _HeatmapSeriesRenderer();
        },
      );
    });
  }

  double _findValueByIndex(_HeatMapData data, int index) {
    switch (index) {
      case 0:
        return data.hcwf;
      case 1:
        return data.nonicuf;
      case 2:
        return data.icuf;
      case 3:
        return data.hcwm;
      case 4:
        return data.nonicum;
      case 5:
        return data.icum;
      default:
        return 0;
    }
  }

  @override
  void dispose() {
    _heatMapData!.clear();
    super.dispose();
  }
}

class _HeatMapData {
  final String percentage;
  final double hcwf, nonicuf, icuf, hcwm, nonicum, icum;
  _HeatMapData(this.percentage, this.hcwf, this.nonicuf, this.icuf, this.hcwm,
      this.nonicum, this.icum);
}

class _HeatmapSeriesRenderer
    extends StackedBar100SeriesRenderer<_HeatMapData, String> {
  _HeatmapSeriesRenderer();

  @override
  void populateDataSource(
      [List<ChartValueMapper<_HeatMapData, num>>? yPaths,
      List<List<num>>? chaoticYLists,
      List<List<num>>? yLists,
      List<ChartValueMapper<_HeatMapData, Object>>? fPaths,
      List<List<Object?>>? chaoticFLists,
      List<List<Object?>>? fLists]) {
    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);

    // Always keep positive 0 to 100 range even set negative value.
    yMin = 0;
    yMax = 102;

    // Calculate heatmap segment top and bottom values.
    _computeHeatMapValues();
  }

  void _computeHeatMapValues() {
    if (xAxis == null || yAxis == null) {
      return;
    }

    if (yAxis!.dependents.isEmpty) {
      return;
    }

    // Get the number of series dependent on the yAxis.
    final int seriesLength = yAxis!.dependents.length;
    // Calculate the proportional height for each series
    // (as a percentage of the total height).
    final num yValue = 100 / seriesLength;
    // Loop through each dependent series to calculate top and bottom values for
    // the heatmap.
    for (int i = 0; i < seriesLength; i++) {
      // Check if the current series is a '_HeatmapSeriesRenderer'.
      if (yAxis!.dependents[i] is _HeatmapSeriesRenderer) {
        final _HeatmapSeriesRenderer current =
            yAxis!.dependents[i] as _HeatmapSeriesRenderer;

        // Skip processing if the series is not visible or has no data.
        if (!current.controller.isVisible || current.dataCount == 0) {
          continue;
        }

        // Calculate the bottom (stack) value for the current series.
        num stackValue = 0;
        stackValue = yValue * i;

        current.topValues.clear();
        current.bottomValues.clear();

        // Loop through the data points in the current series.
        final int length = current.dataCount;
        for (int j = 0; j < length; j++) {
          // Add the bottom value (stackValue) for the current data point.
          current.bottomValues.add(stackValue.toDouble());
          // Add the top value (stackValue + yValue) for the current data point.
          current.topValues.add((stackValue + yValue).toDouble());
        }
      }
    }
  }
}
