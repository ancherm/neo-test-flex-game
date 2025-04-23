import 'package:flutter/material.dart';
import '../app_database.dart';
import '../entity/user.dart';

class WelcomeScreen extends StatefulWidget {
  final AppDatabase database;

  WelcomeScreen({required this.database});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _nameController = TextEditingController();

  void _saveUser() async {
    final user = User(
      id: 0,
      name: _nameController.text,
      points: 0,
      energy: 100,
      testsCompleted: 0,
    );
    await widget.database.userDao.insertUser(user);
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добро пожаловать')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Введите ваше имя',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUser,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}