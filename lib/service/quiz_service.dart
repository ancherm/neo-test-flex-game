import 'package:floor/floor.dart';
import 'database_helper.dart';
import '../entity/user.dart';

Future<void> checkAnswer(int selectedIndex, int correctAnswer) async {
  final db = await DatabaseHelper.database;
  final user = await db.userDao.getUser();
  if (user != null && user.energy >= 10) {
    user.energy -= 10;
    if (selectedIndex == correctAnswer) {
      user.points += 10;
    }
    await db.userDao.updateUser(user);
  }
}

Future<void> buyEnergy() async {
  final db = await DatabaseHelper.database;
  final user = await db.userDao.getUser();
  if (user != null && user.points >= 10) {
    user.points -= 10;
    user.energy += 20;
    await db.userDao.updateUser(user);
  }
}