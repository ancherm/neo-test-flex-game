import 'package:flutter/material.dart';
import 'service/database_helper.dart';
import 'service/energy_manager.dart';
import 'screen/main_screen.dart';
import 'app_database.dart';
import 'screen/profile_screen.dart';


Future<void> printDatabaseContents(AppDatabase database) async {
    final user = await database.userDao.getUser();
    print('Пользователь: $user');

    final tests = await database.testDao.getAllTests();
    print('Тесты: $tests');

    final shopItems = await database.shopDao.getAllShopItems();
    print('Магазин: $shopItems');
  }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await DatabaseHelper.database;
  await printDatabaseContents(database);
  await DatabaseHelper.insertInitialData();
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
      initialRoute: '/main',
      routes: {
        '/main': (context) => MainScreen(database: database),
        '/profile': (context) => ProfileScreen(database: database),
        // '/tests': (context) => TestsScreen(database: database),
        // '/shop': (context) => ShopScreen(database: database),
        // '/history': (context) => HistoryScreen(database: database),
      },
    );
  }
}