import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // <-- импорт для фильтра
import '../app_database.dart';
import '../entity/user.dart';

class WelcomeScreen extends StatefulWidget {
  final AppDatabase database;

  const WelcomeScreen({Key? key, required this.database}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _nameController = TextEditingController();

  void _saveUser() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, введите имя')),
      );
      return;
    }

    final user = User(
      id: null,
      name: name,
      points: 500,
      energy: 100,
      testsCompleted: 0,
    );
    await widget.database.userDao.insertUser(user);
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добро пожаловать')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                // Разрешаем только кириллические буквы и пробел
                FilteringTextInputFormatter.allow(
                  RegExp(r'[A-Za-zА-Яа-яЁё\s]'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Введите ваше имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUser,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
