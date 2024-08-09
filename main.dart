import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Cartão de Visitas',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Meu Cartão de Visitas'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Seu Nome', style: TextStyle(fontSize: 24)),
              Text('Seu Cargo'),
              Text('Sua Empresa'),
              Text('seu.email@exemplo.com'),
            ],
          ),
        ),
      ),
    );
  }
}
