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

 static Future<void> insertInitialData() async {
    final db = await database;

    // Получаем все товары из магазина
    final shopItems = await db.shopDao.getAllShopItems();

    // Проверка на наличие "энергии"
    final hasEnergy = shopItems.any((item) => item.name == 'Пополнение энергии');
    if (!hasEnergy) {
      await db.shopDao.insertShopItem(Shop(
        name: 'Пополнение энергии',
        cost: 10,
        type: 'energy',
        imageUrl: 'assets/images/energy.png',
        description: 'Увеличивает энергию на 5 единиц.',
      ));
    }

    final hasShirt = shopItems.any((item) => item.name == 'Футболка');
    if (!hasShirt) {
      await db.shopDao.insertShopItem(Shop(
        name: 'Футболка',
        cost: 30,
        type: 'item',
        imageUrl: 'assets/images/neoflex-logo.png',
        description: 'Стильная футболка для вашего профиля.',
      ));
    }
  }
}