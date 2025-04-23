import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'energy_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.insertInitialData();
  EnergyManager().startEnergyRecovery();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Приложение с Floor ORM')),
        body: Center(child: Text('Добро пожаловать!')),
      ),
    );
  }
}