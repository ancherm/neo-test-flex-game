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

    final hasBottle = shopItems.any((item) => item.name == 'Спортивная бутылка');
    if (!hasBottle) {
      await db.shopDao.insertShopItem(Shop(
        name: 'Спортивная бутылка',
        cost: 30,
        type: 'item',
        imageUrl: 'assets/images/bottle.png',
        description: 'Спортивная бутылка для ваших напитков',
      ));
    }

    final hasNote = shopItems.any((item) => item.name == 'Блокнот');
    if (!hasNote) {
      await db.shopDao.insertShopItem(Shop(
        name: 'Блокнот',
        cost: 20,
        type: 'item',
        imageUrl: 'assets/images/note.png',
        description: 'Блокнот с маскотом Neoflex',
      ));
    }

    final hasPowerbank = shopItems.any((item) => item.name == 'Powerbank');
    if (!hasPowerbank) {
      await db.shopDao.insertShopItem(Shop(
        name: 'Powerbank',
        cost: 20,
        type: 'item',
        imageUrl: 'assets/images/powerbank.png',
        description: 'Powerbank для зарядки ваших устройств',
      ));
    }

    final hasSoundpad = shopItems.any((item) => item.name == 'Мини-колонка');
    if (!hasSoundpad) {
      await db.shopDao.insertShopItem(Shop(
        name: 'Мини-колонка',
        cost: 20,
        type: 'item',
        imageUrl: 'assets/images/soundpad_mini.png',
        description: 'Мини-колонка',
      ));
    }
  }
}