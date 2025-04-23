import 'package:flutter/material.dart';
import '../app_database.dart';
import '../entity/user.dart';

class ProfileScreen extends StatelessWidget {
  final AppDatabase database;

  ProfileScreen({required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профиль')),
      body: FutureBuilder<User?>(
        future: database.userDao.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final user = snapshot.data;
            if (user != null) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Имя: ${user.name}', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text('Очки: ${user.points}', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text('Энергия: ${user.energy}', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text('Пройдено тестов: ${user.testsCompleted}', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: Text('Пользователь не найден'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}