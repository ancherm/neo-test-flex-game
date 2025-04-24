import 'package:flutter/material.dart';
import 'package:neo_test_flex_game/entity/user.dart';
import 'package:neo_test_flex_game/screen/history_screen.dart';
import 'package:neo_test_flex_game/screen/main_screen.dart';
import 'package:neo_test_flex_game/screen/profile_screen.dart';
import 'package:neo_test_flex_game/screen/test_screen.dart';
import 'package:neo_test_flex_game/screen/shop_screen.dart';
import 'package:neo_test_flex_game/screen/welcome_screen.dart';
import 'package:neo_test_flex_game/service/database_helper.dart';
import 'package:neo_test_flex_game/service/energy_manager.dart';
import 'app_database.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<void> printDatabaseContents(AppDatabase database) async {
  final user = await database.userDao.getUser();
  print('Пользователь: $user');

  final tests = await database.testDao.getAllTests();
  print('Тесты: $tests');

  final shopItems = await database.shopDao.getAllShopItems();
  print('Магазин: $shopItems');

  final allUsers = await database.userDao.getAllUsers();
  print('Все пользователи: $allUsers');

  final allPurchases = await database.purchaseDao.getAllPurchases();
  print('Все покупки: $allPurchases');
}

void clearDB(AppDatabase database) {
  database.database.execute('DELETE FROM User');
  database.database.execute('DELETE FROM Shop');
  database.database.execute('DELETE FROM Tests');
  database.database.execute('DELETE FROM Purchase');
}

Future<void> deleteDatabaseFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = join(directory.path, 'app.db');

  final dbFile = File(dbPath);
  if (await dbFile.exists()) {
    await dbFile.delete();
    print('База данных удалена.');
  } else {
    print('Файл базы данных не найден.');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // deleteDatabaseFile();
  final database = await DatabaseHelper.database;
  // clearDB(database);
  await DatabaseHelper.insertInitialData();
  await printDatabaseContents(database);
  EnergyManager().startEnergyRecovery();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Неофлекс Гейм',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<User?>(
        future: database.userDao.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return WelcomeScreen(database: database);
            } else {
              return MainScreen(database: database);
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      routes: {
        '/main': (context) => MainScreen(database: database),
        '/profile': (context) => ProfileScreen(database: database),
        '/tests': (context) => TestScreen(database: database),
        // '/shop': (context) => ShopScreen(database: database),
        '/history': (context) => HistoryScreen(),
        // '/tests': (context) => TestsScreen(database: database),
        '/shop': (context) => ShopScreen(database: database),
        // '/history': (context) => HistoryScreen(database: database),
      },
    );
  }
}