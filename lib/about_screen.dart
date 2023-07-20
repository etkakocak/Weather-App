import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Weather App ver. 1.0.0',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 18),
                children: <TextSpan>[
                  TextSpan(text: 'This application was developed by '),
                  TextSpan(
                      text: 'ek223zf',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' for course 1DV535 at '),
                  TextSpan(
                      text: 'LNU',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          ' and it shows the weather conditions of the city of Växjö in detail.'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.wb_sunny,
              size: 100,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
