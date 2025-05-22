import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neo_test_flex_game/screen/auth_gate.dart';
import 'package:neo_test_flex_game/service/test_seeder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_database.dart';
import 'data/initial_tests.dart';
import 'service/database_helper.dart';
import 'service/energy_manager.dart';

import 'screen/main_screen.dart';
import 'screen/profile_screen.dart';
import 'screen/test_screen.dart';
import 'screen/shop_screen.dart';
import 'screen/history_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Наш "контейнер" с DAO
  final appDatabase = AppDatabase();
  final userDao     = appDatabase.userDao;

  // Первичная загрузка товаров в Firestore (если ещё нет)
  await DatabaseHelper.insertInitialData();

  final prefs = await SharedPreferences.getInstance();
  final energyManager = EnergyManager(userDao, prefs);
  await energyManager.recoverOffline();

  energyManager.startEnergyRecovery();

  await TestSeeder.seedInitialTests(initialTests);

  runApp(MyApp(database: appDatabase));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Неофлекс Гейм',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Решаем, куда идти: на Welcome или сразу в Main
      home: AuthGate(database: database),
      routes: {
        '/main':    (_) => MainScreen(database: database),
        '/profile': (_) => ProfileScreen(database: database),
        '/tests':   (_) => LevelSelectionScreen(database: database),
        '/shop':    (_) => ShopScreen(database: database),
        '/history': (_) => HistoryScreen(),
      },
    );
  }
}
