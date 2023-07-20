import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class WeatherForecast {
  final String dateTime;
  final double tempMax;
  final double tempMin;

  WeatherForecast({
    required this.dateTime,
    required this.tempMax,
    required this.tempMin,
  });
}

class WeatherGraphicsScreen extends StatefulWidget {
  const WeatherGraphicsScreen({Key? key}) : super(key: key);

  @override
  _WeatherGraphicsScreenState createState() => _WeatherGraphicsScreenState();
}

class _WeatherGraphicsScreenState extends State<WeatherGraphicsScreen> {
  List<WeatherForecast> forecasts = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    final apiUrl =
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/växjö/next7days?unitGroup=metric&include=days%2Ccurrent%2Calerts%2Cevents&key=TF3CP35PA95R634RYLBZMGD36&contentType=json';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final days = data['days'];

      setState(() {
        forecasts = days.map<WeatherForecast>((day) {
          return WeatherForecast(
            dateTime: day['datetime'],
            tempMax: day['tempmax'].toDouble(),
            tempMin: day['tempmin'].toDouble(),
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Graphics'),
      ),
      body: forecasts.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    'Växjö City temperature change for the coming days',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: forecasts
                                .asMap()
                                .entries
                                .map((entry) => FlSpot(
                                    entry.key.toDouble(), entry.value.tempMax))
                                .toList(),
                            isCurved: true,
                            colors: [Colors.blue],
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: false,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              colors: [Colors.blue.withOpacity(0.3)],
                            ),
                          ),
                          LineChartBarData(
                            spots: forecasts
                                .asMap()
                                .entries
                                .map((entry) => FlSpot(
                                    entry.key.toDouble(), entry.value.tempMin))
                                .toList(),
                            isCurved: true,
                            colors: [Colors.red],
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: false,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              colors: [Colors.red.withOpacity(0.3)],
                            ),
                          ),
                        ],
                        axisTitleData: FlAxisTitleData(
                          leftTitle: AxisTitle(
                            showTitle: true,
                            titleText: 'Temperature',
                            margin: 8,
                          ),
                          bottomTitle: AxisTitle(
                            showTitle: true,
                            titleText: 'Day After',
                            margin: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 5),
                      const Text('Max Temperature'),
                      const SizedBox(width: 20),
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 5),
                      const Text('Min Temperature'),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
