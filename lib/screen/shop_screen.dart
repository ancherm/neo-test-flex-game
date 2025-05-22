import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
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
  List<Shop> _items = [];
  // bool _loading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadAll();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _loadAll());
  }

  @override
  Future<void> _loadAll() async {
    // получаем данные
    final fb_auth.User? fbUser = fb_auth.FirebaseAuth.instance.currentUser;
    if (fbUser == null) {
      // если вдруг разлогинились, перенаправим на экран входа
      Navigator.of(context).pushReplacementNamed('/');
      return;
    }
    final user = await widget.database.userDao.getUserById(fbUser.uid);
    final items = await widget.database.shopDao.getAllShopItems();
    if (!mounted) return;
    setState(() {
      _user  = user;
      _items = items;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _purchaseItem(Shop item) async {
    final user = _user!;
    if (user.points < item.cost) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Недостаточно очков')));
      return;
    }
    if (item.type == 'energy' && user.energy + 5 > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нельзя превысить 20 энергии')));
      return;
    }
    // обновляем сам user
    user.points -= item.cost;
    if (item.type == 'energy') user.energy += 10;
    await widget.database.userDao.updateUser(user);

    // ← вот ключевая правка: сохраняем покупку как подколлекцию в users/{userId}/purchases
    await widget.database
        .purchaseDao(user.id!)                       // передаём userId
        .insertPurchase(Purchase(
          shopItemId: item.id!,
          date: DateTime.now(),
        ));

    setState(() {}); // чтобы перерисовать счётчики
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Покупка "${item.name}" успешна!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final user = _user!;
    final items = _items!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Магазин', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF150F1E),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen(database: widget.database)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen(database: widget.database)),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF921C63), Color(0xFFE8A828)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(2,2), blurRadius: 4)],
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/neoflex-logo.png', width: 48, height: 48),
                    const SizedBox(height: 12),
                    Text('Добро пожаловать в магазин', textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMetric('Очки', user.points.toString(), Icons.star),
                        const SizedBox(width: 16),
                        _buildMetric('Энергия', user.energy.toString(), Icons.bolt),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.6,
                  crossAxisSpacing: 16, mainAxisSpacing: 16,
                ),
                itemBuilder: (ctx, i) {
                  final it = items[i];
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _purchaseItem(it),
                    child: Container(
                      height: 260,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF921C63), Color(0xFFE8A828)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(2,2), blurRadius: 4)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                              aspectRatio: 1.2,
                              child: Image.asset(it.imageUrl, fit: BoxFit.cover),
                            ),
                          ),
                          Text(it.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                               textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                          Text('${it.cost} очков', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                        ],
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

  Widget _buildMetric(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 4),
        Text('$value $label',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}
