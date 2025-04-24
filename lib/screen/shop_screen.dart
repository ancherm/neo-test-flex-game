import 'package:flutter/material.dart';
import 'package:neo_test_flex_game/app_database.dart';
import 'package:neo_test_flex_game/entity/purchase.dart';
import 'package:neo_test_flex_game/entity/shop.dart';
import 'package:neo_test_flex_game/entity/user.dart';

class ShopScreen extends StatefulWidget {
  final AppDatabase database;

  ShopScreen({required this.database});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late Future<List<dynamic>> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadData();
  }

  Future<List<dynamic>> _loadData() {
    // загружаем одновременно пользователя и все товары
    return Future.wait([
      widget.database.userDao.getUser(),        // Future<User?>
      widget.database.shopDao.getAllShopItems() // Future<List<Shop>>
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Магазин')),
      body: FutureBuilder<List<dynamic>>(
        future: _loadFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data == null) {
            return Center(child: Text('Ошибка загрузки данных'));
          }
          final user  = snap.data![0] as User;
          final items = snap.data![1] as List<Shop>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Плашка с очками пользователя
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Ваши очки: ${user.points}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Список товаров
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: items.length,
                  itemBuilder: (ctx, i) => _buildShopItem(ctx, items[i], user),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _buildShopItem(BuildContext ctx, Shop item, User user) {
    return GestureDetector(
      onTap: () => _confirmPurchase(ctx, item, user),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          children: [
            Expanded(
              child: Image.asset(item.imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(item.name, style: const TextStyle(fontSize: 16)),
            ),
            Text('${item.cost} очков'),
          ],
        ),
      ),
    );
  }

  void _confirmPurchase(BuildContext ctx, Shop item, User user) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text('Купить "${item.name}" за ${item.cost}?'),
        content: Text(item.description),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _purchaseItem(item, user);
            },
            child: const Text('Купить'),
          ),
        ],
      ),
    );
  }

  Future<void> _purchaseItem(Shop item, User user) async {
    if (user.points < item.cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Недостаточно очков')),
      );
      return;
    }

    // 1) Снимаем очки и добавляем энергию
    user.points -= item.cost;
    if (item.type == 'energy') {
      user.energy += 5;
    }

    // 2) Сохраняем обновлённого пользователя
    await widget.database.userDao.updateUser(user);

    // 3) **Логируем покупку** в таблице Purchase
    await widget.database.purchaseDao.insertPurchase(
      Purchase(
        shopItemId: item.id!, 
        date: DateTime.now(),
      ),
    );

    // 4) Обновляем экран
    setState(() {
      _loadFuture = _loadData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Покупка "${item.name}" успешна!')),
    );
  }
}