import 'package:flutter/material.dart';
import '../app_database.dart';

class MainScreen extends StatelessWidget {
  final AppDatabase database;

  MainScreen({required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главное меню'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(context, 'Тесты', '/tests'),
              SizedBox(height: 20),
              _buildButton(context, 'Магазин', '/shop'),
              SizedBox(height: 20),
              _buildButton(context, 'История компании Неофлекс', '/history'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String route) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        textStyle: TextStyle(fontSize: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      child: Text(text),
    );
  }
}