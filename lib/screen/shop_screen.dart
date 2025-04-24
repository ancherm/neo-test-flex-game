import 'package:flutter/material.dart';
import 'package:neo_test_flex_game/app_database.dart';
import 'package:neo_test_flex_game/entity/purchase.dart';
import 'package:neo_test_flex_game/entity/shop.dart';
import 'package:neo_test_flex_game/entity/user.dart';
import 'package:neo_test_flex_game/screen/profile_screen.dart';

class ShopScreen extends StatefulWidget {
  final AppDatabase database;

  ShopScreen({required this.database});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  User? _user;
  List<Shop>? _items;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final u = await widget.database.userDao.getUser();
    final it = await widget.database.shopDao.getAllShopItems();

    setState(() {
      _user = u;
      _items = it;
      _loading = false;
    });
  }

  Future<void> _purchaseItem(Shop item) async {
    final user = _user!;
    if (user.points < item.cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Недостаточно очков')),
      );
      return;
    }
    if (item.type == 'energy' && user.energy + 5 > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нельзя превысить 100 единиц энергии')),
      );
      return;
    }

    // 1. Обновляем модель
    user.points -= item.cost;
    if (item.type == 'energy') user.energy += 5;

    // 2. Пишем в БД
    await widget.database.userDao.updateUser(user);
    await widget.database.purchaseDao.insertPurchase(
      Purchase(shopItemId: item.id!, date: DateTime.now()),
    );

    // 3. Обновляем только состояние _user
    setState(() { /* _user уже обновлён */ });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Покупка "${item.name}" успешна!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = _user!;
    final items = _items!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Магазин',
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: const Color(0xFF150F1E),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Профиль',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(database: widget.database),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // --- компактная шапка ---
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/neoflex-logo.png',
                      width: 48,
                      height: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Добро пожаловать в магазин',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMetric('Очки', user.points.toString()),
                        const SizedBox(width: 16),
                        _buildMetric('Энергия', user.energy.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- сетка товаров ---
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (ctx, i) {
                  final item = items[i];
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _purchaseItem(item),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Container(
                        height: 260,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AspectRatio(
                                aspectRatio: 1.2,
                                child: Image.asset(item.imageUrl, fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${item.cost} очков',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label),
      ],
    );
  }
}
