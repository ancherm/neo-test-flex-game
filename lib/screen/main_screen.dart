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
              const SizedBox(height: 20),
              _buildButtonDebug(context, 'Очистить базу данных', null, onPressed: () => _clearUserTable(context))
            ],
          ),
        ),
      ),
    );
  }

Future<void> _clearUserTable(BuildContext context) async {
    // Показать диалог подтверждения
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить базу данных'),
        content: const Text('Вы уверены, что хотите удалить данные пользователя? Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );

    // Если пользователь подтвердил
    if (confirm == true) {
      await database.database.execute('DELETE FROM User');
      // Перенаправление на WelcomeScreen
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  Widget _buildButtonDebug(BuildContext context, String text, String? route, {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed ?? (route != null ? () => Navigator.pushNamed(context, route) : null),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        textStyle: const TextStyle(fontSize: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        backgroundColor: text == 'Очистить базу данных' ? Colors.redAccent : Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      child: Text(text),
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