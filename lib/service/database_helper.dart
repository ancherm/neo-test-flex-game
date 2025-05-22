import '../dao/shop_dao.dart';
import '../entity/shop.dart';

class DatabaseHelper {
  static final ShopDao shopDao = ShopDao();

  /// Вставляет базовые товары в Firestore, если их ещё нет
  static Future<void> insertInitialData() async {
    final shopItems = await shopDao.getAllShopItems();

    if (!shopItems.any((i) => i.name == 'Пополнение энергии')) {
      await shopDao.insertShopItem(Shop(
        name: 'Пополнение энергии',
        cost: 10,
        type: 'energy',
        imageUrl: 'assets/images/energy.png',
        description: 'Увеличивает энергию на 5 единиц.',
      ));
    }

    if (!shopItems.any((i) => i.name == 'Спортивная бутылка')) {
      await shopDao.insertShopItem(Shop(
        name: 'Спортивная бутылка',
        cost: 30,
        type: 'item',
        imageUrl: 'assets/images/bottle.png',
        description: 'Спортивная бутылка для ваших напитков',
      ));
    }

    if (!shopItems.any((i) => i.name == 'Блокнот')) {
      await shopDao.insertShopItem(Shop(
        name: 'Блокнот',
        cost: 20,
        type: 'item',
        imageUrl: 'assets/images/note.png',
        description: 'Блокнот с маскотом Neoflex',
      ));
    }

    if (!shopItems.any((i) => i.name == 'Powerbank')) {
      await shopDao.insertShopItem(Shop(
        name: 'Powerbank',
        cost: 40,
        type: 'item',
        imageUrl: 'assets/images/powerbank.png',
        description: 'Powerbank для зарядки ваших устройств',
      ));
    }

    if (!shopItems.any((i) => i.name == 'Мини-колонка')) {
      await shopDao.insertShopItem(Shop(
        name: 'Мини-колонка',
        cost: 50,
        type: 'item',
        imageUrl: 'assets/images/soundpad_mini.png',
        description: 'Мини-колонка',
      ));
    }
  }
}
