import 'package:floor/floor.dart';
import '../app_database.dart';
import '../entity/user.dart';
import '../entity/test.dart';
import '../entity/shop.dart';

class DatabaseHelper {
  static AppDatabase? _database;

  static Future<AppDatabase> get database async {
    if (_database != null) return _database!;
    _database = await $FloorAppDatabase.databaseBuilder('app.db').build();
    print('МОЯ БД ' + database.toString());
    return _database!;
  }

  // static Future<void> insertInitialData() async {
  //   final db = await database;
  //   await db.userDao.insertUser(User(
  //     name: 'Гость',
  //     points: 0,
  //     testsCompleted: 0,
  //     energy: 100,
  //   ));
  //   await db.testDao.insertTest(Test(
  //     question: 'Когда основана Неофлекс?',
  //     answers: '["2005", "2010", "2015"]',
  //     correctAnswer: 0,
  //   ));
  //   await db.shopDao.insertShopItem(Shop(
  //     name: 'Пополнение энергии',
  //     cost: 10,
  //     type: 'energy',
  //   ));
  // }
}