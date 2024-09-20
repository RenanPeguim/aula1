import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  double? currentTemperature;
  double? currentHumidity;
  String errorMessage = '';

  Future<void> getWeatherData() async {
    String latitude = _latitudeController.text;
    String longitude = _longitudeController.text;
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relativehumidity_2m&forecast_days=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final currentWeather = data['current_weather'];
        setState(() {
          currentTemperature = currentWeather['temperature_2m'];
          currentHumidity = currentWeather['relativehumidity_2m'];
          errorMessage = ''; // Clear error message on success
        });
      } else {
        setState(() {
          errorMessage =
              'Erro ao buscar dados climáticos: código ${response.statusCode}';
          currentTemperature = null;
          currentHumidity = null;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro na rede: $e';
        currentTemperature = null;
        currentHumidity = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dados Climáticos'),
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
              ),
              TextButton(
                onPressed: getWeatherData,
                child: const Text('Buscar Dados Climáticos'),
              ),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              if (currentTemperature != null && currentHumidity != null)
                Column(
                  children: [
                    Text(
                      'Temperatura atual: ${currentTemperature!.toStringAsFixed(1)}°C',
                      style: const TextStyle(fontSize: 24),
                    ),
                    Text(
                      'Umidade relativa: ${currentHumidity!.toInt()}%',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
