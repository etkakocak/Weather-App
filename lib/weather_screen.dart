import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:food/about_screen.dart';
import 'package:food/weather_graphics_screen.dart';
import 'package:food/weather_forecast_screen.dart';

const apiKey = '7ed887c668e9de13d796ca20958ebe54';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _currentLocation = '';
  double _currentTemperature = 0;
  double _windSpeed = 0;
  String _weatherCondition = '';
  String _weatherDescription = '';

  @override
  void initState() {
    super.initState();
    _getCurrentWeather();
  }

  Future<void> _getCurrentWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${56.8770}&lon=${14.8099}&appid=$apiKey'));

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      setState(() {
        _currentLocation = weatherData['name'];
        _currentTemperature = (weatherData['main']['temp'] - 273.15).toDouble();
        _windSpeed = weatherData['wind']['speed'];
        _weatherCondition = weatherData['weather'][0]['main'];
        _weatherDescription = weatherData['weather'][0]['description'];
      });
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  Widget getWeatherIcon(String weatherCondition) {
    switch (weatherCondition) {
      case 'Clear':
        return Icon(Icons.wb_sunny, size: 70, color: Colors.yellow);
      case 'Clouds':
        return Icon(Icons.cloud, size: 70, color: Colors.grey);
      case 'Rain':
        return Icon(Icons.umbrella, size: 70, color: Colors.blue);
      case 'Snow':
        return Icon(Icons.ac_unit, size: 70, color: Colors.lightBlueAccent);
      default:
        return Icon(Icons.wb_cloudy, size: 70, color: Colors.lightBlue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Column(
        children: [
          Spacer(),
          getWeatherIcon(_weatherCondition),
          const SizedBox(height: 16),
          Text(
            _currentLocation,
            style: const TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 16),
          Text(
            DateTime.now().toLocal().toString().split(' ')[0],
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            '${_weatherDescription[0].toUpperCase()}${_weatherDescription.substring(1)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            '${_currentTemperature.toStringAsFixed(2)}°C',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Wind: ${_windSpeed.toStringAsFixed(2)} m/s',
            style: const TextStyle(fontSize: 14),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeatherGraphicsScreen(),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.area_chart),
                      FittedBox(
                        child: const Text('Graphics'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeatherForecastScreen(),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today),
                      FittedBox(
                        child: const Text('Forecast'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info),
                      FittedBox(
                        child: const Text('About'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
