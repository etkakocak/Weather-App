import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherForecast {
  final String dateTime;
  final double tempMax;
  final double tempMin;
  final String description;
  final String icon;

  WeatherForecast({
    required this.dateTime,
    required this.tempMax,
    required this.tempMin,
    required this.description,
    required this.icon,
  });
}

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({super.key});

  @override
  _WeatherForecastScreenState createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  List<WeatherForecast>? forecasts;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl =
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/växjö/next7days?unitGroup=metric&include=days%2Ccurrent%2Calerts%2Cevents&key=TF3CP35PA95R634RYLBZMGD36&contentType=json';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        forecasts = List<WeatherForecast>.from(
          data['days'].map((forecast) => WeatherForecast(
                dateTime: forecast['datetime'],
                tempMax: forecast['tempmax'],
                tempMin: forecast['tempmin'],
                description: forecast['description'],
                icon: forecast['icon'],
              )),
        );
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Icon getWeatherIcon(String weatherIcon) {
    switch (weatherIcon) {
      case 'clear-day':
      case 'clear-night':
        return Icon(Icons.wb_sunny, size: 70, color: Colors.yellow);
      case 'rain':
        return Icon(Icons.umbrella, size: 70, color: Colors.blue);
      case 'snow':
      case 'sleet':
        return Icon(Icons.ac_unit, size: 70, color: Colors.lightBlueAccent);
      case 'wind':
        return Icon(Icons.toys, size: 70, color: Colors.grey);
      case 'fog':
        return Icon(Icons.cloud, size: 70, color: Colors.grey);
      case 'cloudy':
        return Icon(Icons.cloud, size: 70, color: Colors.grey);
      case 'partly-cloudy-day':
      case 'partly-cloudy-night':
        return Icon(Icons.wb_cloudy, size: 70, color: Colors.lightBlue);
      default:
        return Icon(Icons.wb_cloudy, size: 70, color: Colors.lightBlue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: forecasts == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: forecasts!.length,
              itemBuilder: (context, index) {
                final forecast = forecasts![index];
                return ListTile(
                  title: Text(forecast.dateTime),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Max Temp: ${forecast.tempMax.toString()}°C'),
                      Text('Min Temp: ${forecast.tempMin.toString()}°C'),
                      Text('Description: ${forecast.description}'),
                    ],
                  ),
                  leading: getWeatherIcon(forecast.icon),
                );
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WeatherForecastScreen(),
  ));
}
